//
//  ProfileDetailVC.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 06/09/22.
//

import UIKit

enum DetailPageFields: String, CaseIterable {
    case Name = "Name"
    case Email = "Email Id"
    case Mobile = "Mobile"
    case JobId = "Job Id"
    case Skills = "Skills"
    case Status = "Status"
    case SystemStatus = "Status given by system"
    case Resume = "Resume"
    case Score = "Resume Score"
    case LinkedInURL = "LinkedIn URL"
    case GitHubURL = "Github URL"
    case OtherURL = "Other URL"
    case AppliedOn = "Applied On"
    
    static let allFields = allValues(DetailPageFields.self)

}

class ProfileDetailVC: BaseViewController {
    
    @IBOutlet private weak  var _tableView: UITableView!
    
    var application: Application!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: StringConstants.DELETE, style: .plain, target: self, action: #selector(self.deletePressed(sender: )))
        
        // Do any additional setup after loading the view.
    }
    
    @objc func deletePressed(sender: Any) {
        AlertManager.showAlert(withTitle: StringConstants.DELETE + "?", withMessage: StringConstants.DELETE_ALERT, buttons: [AlertButton.init(style: UIAlertAction.Style.destructive, title: StringConstants.YES), AlertButton.init(style: UIAlertAction.Style.default, title: StringConstants.NO)], onViewController: self, returnBlock:  {[unowned self] clickedIndex in
            if clickedIndex == 0 {
                showLoader()

                WebRequests.deleteApplication(id: application.id) {[weak self] app, errorString in
                    
                    if let welf = self {
                        welf.hideLoader()

                        guard let _ = app else {
                            guard let errorString = errorString else {
                                AlertManager.showOKAlert(withTitle: StringConstants.ERROR, withMessage: StringConstants.UNKNOWN_ERROR, onViewController: welf)
                                return
                            }
                            AlertManager.showOKAlert(withTitle: StringConstants.ERROR, withMessage: errorString, onViewController: welf)

                            return
                        }

                        welf.navigationController?.popViewController(animated: true)
                    }
                }
            }
        })
    }

    /*
    // MARK: - Navigation
     
     Test Cases
          
     add Comments to code
     documentation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - PRIVATE FUNC
    private func _viewResumeApplication() {
        if let vc = StoryboardControllerIds.appStoryboard().instantiateViewController(withIdentifier: ViewResumeVC.identifier()) as? ViewResumeVC , let filePath = application.resumeFilePath , !filePath.isEmpty {
            vc.filePath = filePath
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            AlertManager.showOKAlert(withTitle: StringConstants.RESUME_NOT_AVAILABLE, withMessage: StringConstants.RESUME_NOT_AVAILABLE_ALERT, onViewController: self)
        }
    }
    
    private func _changeStatusApplication() {
        let applicationStatuses = ApplicationStatus.allFields
        var buttons = [AlertButton]()
        for status in applicationStatuses {
            buttons.append(AlertButton(style: .default, title: status.stringName()))
        }
        buttons.append(AlertButton(style: .destructive, title: StringConstants.CANCEL))
        AlertManager.showAlert(withTitle: "Change Status for \(application.firstName)", withMessage: StringConstants.SELECT_STATUS, buttons:buttons, onViewController: self, returnBlock:  {[unowned self] clickedIndex in
            if clickedIndex < buttons.count - 1 , String(clickedIndex + 1) != application.status {
                showLoader()

                WebRequests.changeStatus(id: application.id, status: clickedIndex + 1) {[weak self] app, errorString in
                    if let welf = self {
                        welf.hideLoader()

                        guard let app = app else {
                            guard let errorString = errorString else {
                                AlertManager.showOKAlert(withTitle: StringConstants.ERROR, withMessage: StringConstants.UNKNOWN_ERROR, onViewController: welf)
                                return
                            }
                            AlertManager.showOKAlert(withTitle: StringConstants.ERROR, withMessage: errorString, onViewController: welf)

                            return
                        }
                        
                        welf.application = app

                        DispatchQueue.main.async {
                            welf._tableView.reloadData()
                        }
                    }
                }
            }
        })

    }
}

// MARK: - TABLEVIEW DATASOURCE
extension ProfileDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailPageFields.allFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: identifier)
        }
        
        let field = DetailPageFields.allFields[indexPath.row]
        
        cell?.textLabel?.text = field.rawValue
        cell?.accessoryView = nil
        
        switch field {
        case .Name:
            cell?.detailTextLabel?.text = application.fullName()
        case .Email:
            cell?.detailTextLabel?.text = application.email
        case .Mobile:
            cell?.detailTextLabel?.text = "\(application.mobile)"
            if ASSharedClass.isLoggedUserAdmin() {
                let button: ASButton = ASButton.getOne(rect: CGRect.init(x: 0, y: 0, width: 40, height: 40), image: UIImage.init(named: "call"))
                button.facilitateTapBlock({[unowned self] button in
                    self.application.mobile.call()
                }, forEvent: .touchUpInside)
                cell?.accessoryView = button
            }
        case .JobId:
            cell?.detailTextLabel?.text = application.jobId
        case .Skills:
            cell?.detailTextLabel?.text = application.skillsConcatenated()
            cell?.detailTextLabel?.numberOfLines = 0
        case .Status:
            cell?.detailTextLabel?.text = application.statusString()
            if let resumefile = application.resumeFilePath , resumefile.count > 0 , ASSharedClass.isLoggedUserAdmin() {
                let button: ASButton = ASButton.getOne(rect: CGRect.init(x: 0, y: 0, width: 40, height: 40), image: UIImage.init(named: "status"))
                button.facilitateTapBlock({[unowned self] button in
                    self._changeStatusApplication()
                }, forEvent: .touchUpInside)
                cell?.accessoryView = button
            }
        case .SystemStatus:
            cell?.detailTextLabel?.text = application.systemStatusString()
        case .Resume:
            cell?.detailTextLabel?.text = application.resumeFileName ?? StringConstants.EMPTY_MARK
            if let resumefile = application.resumeFilePath , resumefile.count > 0 {
                let button: ASButton = ASButton.getOne(rect: CGRect.init(x: 0, y: 0, width: 40, height: 40), image: UIImage.init(named: "file"))
                button.facilitateTapBlock({[unowned self] button in
                    self._viewResumeApplication()
                }, forEvent: .touchUpInside)
                cell?.accessoryView = button
            }
        case .Score:
            cell?.detailTextLabel?.text = application.resumeScore
        case .LinkedInURL:
            cell?.detailTextLabel?.text = application.linkedInURL ?? StringConstants.EMPTY_MARK
        case .GitHubURL:
            cell?.detailTextLabel?.text = application.githubURL ?? StringConstants.EMPTY_MARK
        case .OtherURL:
            cell?.detailTextLabel?.text = application.otherURL ?? StringConstants.EMPTY_MARK
        case .AppliedOn:
            cell?.detailTextLabel?.text = application.createdDate()
        }
        
        cell?.textLabel?.textColor = UIColor.black
        cell?.detailTextLabel?.textColor = UIColor.ThemeOrangeColor()
        cell?.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        return cell!
    }
}

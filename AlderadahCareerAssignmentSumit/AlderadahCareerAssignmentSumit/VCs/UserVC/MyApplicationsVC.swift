//
//  MyApplicationsVC.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import UIKit

class MyApplicationsVC: BaseViewController {
    
    @IBOutlet private weak var _tableView: UITableView!
    
    private var applications = [Application]()
    private var totalCount = 0
    private var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Applications"
        // Do any additional setup after loading the view.
            
        _tableView.register(UINib(nibName: ApplicationTableCell.identifier(), bundle:nil), forCellReuseIdentifier: ApplicationTableCell.identifier())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applications.removeAll()
        _getApplications(page: 1)
    }
    
    private func _getApplications(page: Int, count: Int = 10) {
        var filters: [String : Any]?
        if let loginUser = ASSharedClass.loggedInUser , !ASSharedClass.isLoggedUserAdmin() {
            filters = ["userId" : loginUser.id]
        }
        
        currentPage = page
        
        WebRequests.getApplications(filter: filters, page: page, count: count, searchFilter: nil) { [weak self] list, errorString in
            if let welf = self {
                guard let list = list else {
                    guard let errorString = errorString else {
                        AlertManager.showOKAlert(withTitle: "Error", withMessage: "Unknown error occurred", onViewController: welf)
                        return
                    }
                    AlertManager.showOKAlert(withTitle: "Error", withMessage: errorString, onViewController: welf)

                    return
                }
                welf.applications.append(contentsOf: list.items)
                welf.totalCount = list.count
                
                DispatchQueue.main.async {
                    welf._tableView.reloadData()
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func _editApplication(application: Application) {
        
    }
    
    private func _deleteApplication(application: Application, index: Int) {
        AlertManager.showAlert(withTitle: "Delete?", withMessage: "Are you sure you want to delete this application?", buttons: [AlertButton.init(style: UIAlertAction.Style.destructive, title: "Yes"), AlertButton.init(style: UIAlertAction.Style.default, title: "No")], onViewController: self, returnBlock:  {clickedIndex in
            if clickedIndex == 0 {
                WebRequests.deleteApplication(id: application.id) {[weak self] app, errorString in
                    if let welf = self {
                        guard let _ = app else {
                            guard let errorString = errorString else {
                                AlertManager.showOKAlert(withTitle: "Error", withMessage: "Unknown error occurred", onViewController: welf)
                                return
                            }
                            AlertManager.showOKAlert(withTitle: "Error", withMessage: errorString, onViewController: welf)

                            return
                        }
                        welf.applications.remove(at: index)
                        welf.totalCount = welf.totalCount - 1

                        DispatchQueue.main.async {
                            welf._tableView.reloadData()
                        }
                    }
                }
            }
        })
    }
    
    private func _changeStatusApplication(application: Application, index: Int) {
        let applicationStatuses = ApplicationStatus.allFields
        var buttons = [AlertButton]()
        for status in applicationStatuses {
            buttons.append(AlertButton(style: .default, title: status.stringName()))
        }
        buttons.append(AlertButton(style: .destructive, title: "Cancel"))
        AlertManager.showAlert(withTitle: "Change Status for \(application.firstName)", withMessage: "Please select status", buttons:buttons, onViewController: self, returnBlock:  {clickedIndex in
            if clickedIndex < buttons.count - 1 , String(clickedIndex + 1) != application.status {
                WebRequests.changeStatus(id: application.id, status: clickedIndex + 1) {[weak self] app, errorString in
                    if let welf = self {
                        guard let app = app else {
                            guard let errorString = errorString else {
                                AlertManager.showOKAlert(withTitle: "Error", withMessage: "Unknown error occurred", onViewController: welf)
                                return
                            }
                            AlertManager.showOKAlert(withTitle: "Error", withMessage: errorString, onViewController: welf)

                            return
                        }
                        
                        welf.applications[index] = app

                        DispatchQueue.main.async {
                            welf._tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        }
                    }
                }
            }
        })

    }

}

extension MyApplicationsVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    private func documentInteractionControllerViewForPreview(controller: UIDocumentInteractionController!) -> UIView! {
        return self.view
    }

    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
}

extension MyApplicationsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ApplicationTableCell.identifier()) as? ApplicationTableCell
        if cell == nil {
            cell = UINib(nibName: ApplicationTableCell.identifier(), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ApplicationTableCell
        }
        
        cell?.setInformation(application: self.applications[indexPath.row])
        
        cell?.changeStatusAction = {[unowned self] rcell, senderr in
            if let ip = self._tableView.indexPath(for: rcell) , ip.row < self.applications.count {
                self._changeStatusApplication(application: self.applications[ip.row], index: ip.row)
            }
        }
        
        cell?.editAction = {[unowned self] rcell, senderr in
            if let ip = self._tableView.indexPath(for: rcell) , ip.row < self.applications.count {
                self._editApplication(application: self.applications[ip.row])
            }
        }
        
        cell?.deleteAction = {[unowned self] rcell, senderr in
            if let ip = self._tableView.indexPath(for: rcell) , ip.row < self.applications.count {
                self._deleteApplication(application: self.applications[ip.row], index: ip.row)
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == self.applications.count - 3 && self.applications.count < self.totalCount) {
            self._getApplications(page: currentPage+1)
        }
    }
}

extension MyApplicationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //open detail page
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !ASSharedClass.isLoggedUserAdmin() {
            return 364
        }
        return 400
    }
}

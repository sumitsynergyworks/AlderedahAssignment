//
//  DashboardVC.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import UIKit

class DashboardVC: BaseViewController {
    
    @IBOutlet private weak var _tableView: UITableView?
    @IBOutlet private weak var _appliedButton: UIButton!
    @IBOutlet private weak var _rejectedButton: UIButton!
    @IBOutlet private weak var _acceptedButton: UIButton!
    @IBOutlet private weak var _bestButton: UIButton!
    
    private var _appliedApplications = [Application]() {
        didSet {
            _appliedButton.titleLabel?.textAlignment = .center
            _appliedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            _appliedButton.setTitle("\(_appliedApplications.count) \n Applied", for: .normal)
        }
    }
    private var _rejectedApplications = [Application]() {
        didSet {
            _rejectedButton.titleLabel?.textAlignment = .center
            _rejectedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            _rejectedButton.setTitle("\(_rejectedApplications.count) \n Rejected", for: .normal)
        }
    }
    
    private var _selectedApplications = [Application]() {
        didSet {
            _acceptedButton.titleLabel?.textAlignment = .center
            _acceptedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            _acceptedButton.setTitle("\(_selectedApplications.count) \n Accepted", for: .normal)
        }
    }
    
    private var _bestApplications = [Application]() {
        didSet {
            _bestButton.titleLabel?.textAlignment = .center
            _bestButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            _bestButton.setTitle("\(_bestApplications.count) \n Best Resumes", for: .normal)
        }
    }
    
    private var _currentApplications = [Application]() {
        didSet {
            DispatchQueue.main.async {
                self._tableView?.reloadData()
            }
        }
    }
    
    private var _selectedStatus : ApplicationStatus? {
        didSet {
            switch _selectedStatus {
            case .Applied:
                _currentApplications = _appliedApplications
            case .Rejected:
                _currentApplications = _rejectedApplications
            case .Accepted:
                _currentApplications = _selectedApplications
            case .BestAccepted:
                _currentApplications = _bestApplications
            case .none:
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Admin Dashboard"
        
        _tableView!.register(UINib(nibName: ApplicationTableCell.identifier(), bundle:nil), forCellReuseIdentifier: ApplicationTableCell.identifier())

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _reloadAll()
    }
    
    private func _reloadAll() {
        let allstatuses = ApplicationStatus.allFields
        for st in allstatuses {
            _getApplication(type: st.rawValue)
        }
    }
    
    private func _getApplication(type: Int) {
        let filters = ["status" : type]
        
        showLoader()

        WebRequests.getApplicationsWithouPage(filter: filters) {[weak self] list, errorString in
            if let welf = self {
                welf.hideLoader()

                guard let list = list else {
                    guard let errorString = errorString else {
                        AlertManager.showOKAlert(withTitle: StringConstants.ERROR, withMessage: StringConstants.UNKNOWN_ERROR, onViewController: welf)
                        return
                    }
                    AlertManager.showOKAlert(withTitle: StringConstants.ERROR, withMessage: errorString, onViewController: welf)

                    return
                }
                let status = ApplicationStatus.init(rawValue: type)
                if status == .Applied {
                    welf._appliedApplications = list.items
                } else if status == .Rejected {
                    welf._rejectedApplications = list.items
                } else if status == .Accepted {
                    welf._selectedApplications = list.items
                } else if status == .BestAccepted {
                    welf._bestApplications = list.items
                }
                
                guard let _ = welf._selectedStatus else {
                    welf._selectedStatus = .Applied
                    return
                }
            }
        }
    }
    
    @IBAction private func _appliedPressed() {
        _selectedStatus = .Applied
    }
    
    @IBAction private func _rejectedPressed() {
        _selectedStatus = .Rejected
    }
    
    @IBAction private func _selectedPressed() {
        _selectedStatus = .Accepted
    }
    
    @IBAction private func _bestPressed() {
        _selectedStatus = .BestAccepted
    }        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DashboardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _currentApplications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ApplicationTableCell.identifier()) as? ApplicationTableCell
        if cell == nil {
            cell = UINib(nibName: ApplicationTableCell.identifier(), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ApplicationTableCell
        }
        
        cell?.setInformation(application: self._currentApplications[indexPath.row])
        
        cell?.hideButtons()
                
        return cell!
    }
}

extension DashboardVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let _selectedStatus = _selectedStatus {
            return _selectedStatus.stringName()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc = StoryboardControllerIds.appStoryboard().instantiateViewController(withIdentifier: ProfileDetailVC.identifier()) as? ProfileDetailVC {
            vc.application = self._currentApplications[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

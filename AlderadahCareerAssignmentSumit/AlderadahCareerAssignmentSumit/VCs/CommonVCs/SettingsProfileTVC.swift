//
//  SettingsProfileTVC.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 06/09/22.
//

import UIKit

class SettingsProfileTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        }
        
        cell?.textLabel?.text = ""
        cell?.detailTextLabel?.text = ""

        if let user = ASSharedClass.loggedInUser {
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = StringConstants.EMAIL
                cell?.detailTextLabel?.text = user.email
            case 1:
                cell?.textLabel?.text = StringConstants.ROLE
                if let userInt = Int(user.type) , let userType = UserType.init(rawValue: userInt) {
                    cell?.detailTextLabel?.text = userType.text()
                }
            case 2:
                cell?.textLabel?.text = StringConstants.APP_VERSION
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    cell?.detailTextLabel?.text = appVersion
                }
            case 3:
                cell?.textLabel?.text = StringConstants.LOGOUT
            default:
                cell?.textLabel?.text = ""
                cell?.detailTextLabel?.text = ""
            }
        }

        // Configure the cell...

        return cell!
    }
    
    // MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 3 {
            AlertManager.showAlert(withTitle: StringConstants.LOGOUT
                                   + "?", withMessage: StringConstants.LOGOUT_ALERT, buttons: [AlertButton.init(style: UIAlertAction.Style.destructive, title: StringConstants.YES), AlertButton.init(style: UIAlertAction.Style.default, title: StringConstants.NO)], onViewController: self, returnBlock:  { clickedIndex in
                if clickedIndex == 0 {
                    ASNotificationCenter.post(name: NotificationNames.USER_LOGGEDOUT_NOTIFICATION, object: nil)
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 3 {
            return true
        }
        return false
    }

}

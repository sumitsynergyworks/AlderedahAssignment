//
//  ApplicationTableCell.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import UIKit

typealias ClickButtonCellAction = (UITableViewCell, Any?) -> Void

class ApplicationTableCell: UITableViewCell {
    
    @IBOutlet private weak var _nameLabel: UILabel!
    @IBOutlet private weak var _jobId: UILabel!
    @IBOutlet private weak var _email: UILabel!
    @IBOutlet private weak var _mobile: UILabel!
    @IBOutlet private weak var _score: UILabel!
    @IBOutlet private weak var _status: UILabel!
    @IBOutlet private weak var _systemStatus: UILabel!
    @IBOutlet private weak var _skills: UILabel!
    
    @IBOutlet private weak var _buttonStackView: UIStackView?
    
    var deleteAction: ClickButtonCellAction?
    var editAction: ClickButtonCellAction?
    var changeStatusAction: ClickButtonCellAction?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if !ASSharedClass.isLoggedUserAdmin() {
            _buttonStackView?.removeFromSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInformation(application: Application) {
        
        _nameLabel.text = "\(application.firstName) \(application.lastName)"
        _jobId.text = "\(application.jobId)"
        _email.text = "\(application.email)"
        _mobile.text = "\(application.mobile)"
        _score.text = "\(application.resumeScore)"
        _status.text = ApplicationStatus(rawValue: Int(application.status) ?? 1)?.stringName()
        _systemStatus.text = ApplicationStatus(rawValue: Int(application.systemStatus) ?? 1)?.stringName()
        if let skil = application.skills , let skilary = skil.toJSON() as? [String], skilary.count > 0 {
            _skills.text = skilary.joined(separator: ", ")
        } else {
            _skills.text = "-"
        }        
    }
    
    @IBAction private func _changeStatusButtonPressed(sender: Any?) {
        if let changeStatusAction = changeStatusAction {
            changeStatusAction(self, sender)
        }
    }
    
    @IBAction private func _editButtonPressed(sender: Any?) {
        if let editAction = editAction {
            editAction(self, sender)
        }
    }
    
    @IBAction private func _deleteButtonPressed(sender: Any?) {
        if let deleteAction = deleteAction {
            deleteAction(self, sender)
        }
    }
}

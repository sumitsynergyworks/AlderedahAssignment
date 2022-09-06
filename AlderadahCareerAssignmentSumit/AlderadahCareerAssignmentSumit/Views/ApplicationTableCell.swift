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
    @IBOutlet private weak var _mobile: UILabel! {
        didSet {
            if ASSharedClass.isLoggedUserAdmin() {
                let touchGesture = UITapGestureRecognizer.init(target: self, action: #selector(self._callTaped(_:)))
                _mobile.addGestureRecognizer(touchGesture)
            }
        }
    }
    @IBOutlet private weak var _score: UILabel!
    @IBOutlet private weak var _status: UILabel!
    @IBOutlet private weak var _systemStatus: UILabel!
    @IBOutlet private weak var _skills: UILabel!
    
    @IBOutlet private weak var _buttonStackView: UIStackView?
    
    var deleteAction: ClickButtonCellAction?
    var editAction: ClickButtonCellAction?
    var changeStatusAction: ClickButtonCellAction?
    var callAction: ClickButtonCellAction?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if !ASSharedClass.isLoggedUserAdmin() {
            hideButtons()
        }
    }
    
    func hideButtons() {
        _buttonStackView?.removeFromSuperview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInformation(application: Application) {
        
        _nameLabel.text = application.fullName()
        _jobId.text = "\(application.jobId)"
        _email.text = "\(application.email)"
        if ASSharedClass.isLoggedUserAdmin() {
            let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.underlineStyle : NSNumber.init(value: 1), NSAttributedString.Key.underlineColor : UIColor.blue ]
            let myAttrString = NSAttributedString(string: "\(application.mobile)", attributes: myAttribute)

            // set attributed text on a UILabel
            _mobile.attributedText = myAttrString

        } else {
            _mobile.text = "\(application.mobile)"
        }
        
        _score.text = "\(application.resumeScore)"
        _status.text = application.statusString()
        _systemStatus.text = application.systemStatusString()
        
        _skills.text = application.skillsConcatenated()                
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
    
    @objc private func _callTaped(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            if let callAction = callAction {                            
                callAction(self, gesture.view)
            }
        }
    }
}

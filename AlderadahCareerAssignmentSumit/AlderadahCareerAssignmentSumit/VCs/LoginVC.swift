//
//  ViewController.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 03/09/22.
//

import UIKit

class LoginVC: BaseViewController {
    
    @IBOutlet private weak var _emailTF: UITextField!
    @IBOutlet private weak var _passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        _emailTF.text = "once@yopmail.com"
//        _passwordTF.text = "123123"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASSharedClass.myApplicationsReceived = false
    }
    
    // MARK: - BUTTON ACTION
    @IBAction private func _signInButtonPressed(sender: Any) {
        self.resignAllKeyboard()
        
        guard let email = _emailTF.text , !email.isEmpty , email.isValidEmailID() else {
            AlertManager.showOKAlert(withTitle: StringConstants.EMAIL_VALIDATION, withMessage: StringConstants.EMAIL_VALIDATION_ALERT, onViewController: self)
            return
        }
        
        guard let pswd = _passwordTF.text , !pswd.isEmpty else {
            AlertManager.showOKAlert(withTitle: StringConstants.PASSWORD_VALIDATION_ALERT, withMessage: StringConstants.PASSWORD_VALIDATION_ALERT, onViewController: self)
            return
        }
                
        ASDBManager.fetchOneResult(t: Users.self, predicator: NSPredicate(format: "email == %@", email), sort: nil) { [weak self] existinguser, error in
            if let welf = self  {
                if let existinguser = existinguser {
                    if pswd == existinguser.password {
                        welf._loginWithUserId(id: existinguser.id, dbuser: existinguser)
                    } else {
                        AlertManager.showOKAlert(withTitle: StringConstants.WRONG_PASSWORD, withMessage: StringConstants.PASSWORD_NOT_MATCHED, onViewController: self!)
                    }
                } else {
                    AlertManager.showActionSheetWithSimilarButtonsType(withTitle: StringConstants.USER_NOT_EXIST, withMessage: StringConstants.LOGIN_ANONYMOUSLY, buttonsTitles: [StringConstants.YES, StringConstants.NO], onViewController: welf) { clickedIndex in
                        if clickedIndex == 0 {
                            welf._loginWithUserId(id: "2", dbuser: nil)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func _loginWithUserId(id:String, dbuser: Users?) {
        showLoader()
        WebRequests.loginUserWith(id: id) { [weak self] user, error in
            if let welf = self {
                welf.hideLoader()
                guard let user = user else {
                    guard let errorString = error else {
                        AlertManager.showOKAlert(withTitle: StringConstants.ERROR, withMessage: StringConstants.UNKNOWN_ERROR, onViewController: welf)
                        return
                    }
                    AlertManager.showOKAlert(withTitle: StringConstants.ERROR, withMessage: errorString, onViewController: welf)

                    return
                }
                
                ASSharedClass.loggedInUser = user
                ASSharedClass.loggedInDBUser = dbuser
                
                ASNotificationCenter.post(name: NotificationNames.USER_LOGGEDIN_NOTIFICATION, object: nil)
            }
        }
    }
}

// MARK: - TEXTFIELD DELEGATE
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == _emailTF {
            _passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == _emailTF {
            if let txt = textField.text , txt.count > 0, !txt.isValidEmailID() {
                AlertManager.showOKAlert(withTitle: StringConstants.IMPROPER_ERROR, withMessage: "\(txt) is not proper email", onViewController: self)
                textField.text = nil
            }
        }
    }
}

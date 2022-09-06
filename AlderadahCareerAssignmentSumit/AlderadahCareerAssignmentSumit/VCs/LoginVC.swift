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
        _emailTF.text = "once@yopmail.com"
        _passwordTF.text = "123123"
    }
    
    @IBAction private func _signInButtonPressed(sender: Any) {
        self.resignAllKeyboard()
        
        guard let email = _emailTF.text , !email.isEmpty , email.isValidEmailID() else {
            AlertManager.showOKAlert(withTitle: "Email Validation", withMessage: "Please fill valid email id", onViewController: self)
            return
        }
        
        guard let pswd = _passwordTF.text , !pswd.isEmpty else {
            AlertManager.showOKAlert(withTitle: "Password Validation", withMessage: "Please fill password", onViewController: self)
            return
        }
                
        ASDBManager.fetchOneResult(t: Users.self, predicator: NSPredicate(format: "email == %@", email), sort: nil) { [weak self] existinguser, error in
            if let welf = self  {
                if let existinguser = existinguser {
                    if pswd == existinguser.password {
                        welf._loginWithUserId(id: existinguser.id, dbuser: existinguser)
                    } else {
                        AlertManager.showOKAlert(withTitle: "Wrong password", withMessage: "Password does not match", onViewController: self!)
                    }
                } else {
                    AlertManager.showActionSheetWithSimilarButtonsType(withTitle: "User Does not exist", withMessage: "Do you want to login with anonymous user?", buttonsTitles: ["Yes", "No"], onViewController: welf) { clickedIndex in
                        if clickedIndex == 0 {
                            welf._loginWithUserId(id: "2", dbuser: nil)
                        }
                    }
                }
            }
        }
    }
    
    private func _loginWithUserId(id:String, dbuser: Users?) {
        WebRequests.loginUserWith(id: id) { [weak self] user, error in
            if let welf = self {
                guard let user = user else {
                    guard let errorString = error else {
                        AlertManager.showOKAlert(withTitle: "Error", withMessage: "Unknown error occurred", onViewController: welf)
                        return
                    }
                    AlertManager.showOKAlert(withTitle: "Error", withMessage: errorString, onViewController: welf)

                    return
                }
                
                ASSharedClass.loggedInUser = user
                ASSharedClass.loggedInDBUser = dbuser
                
                ASNotificationCenter.post(name: NotificationNames.USER_LOGGEDIN_NOTIFICATION, object: nil)
            }
        }
    }
}

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
                AlertManager.showOKAlert(withTitle: "Improper Email", withMessage: "\(txt) is not proper email", onViewController: self)
                textField.text = nil
            }
        }
    }
}

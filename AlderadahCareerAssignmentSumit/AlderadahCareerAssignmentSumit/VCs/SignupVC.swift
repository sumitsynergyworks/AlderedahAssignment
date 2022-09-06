//
//  SignupVC.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import UIKit

class SignupVC: BaseViewController {

    @IBOutlet private weak var _emailTF: UITextField!
    @IBOutlet private weak var _passwordTF: UITextField!
    
    private var _userType = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func _signUpButtonPressed(sender: Any) {
        
        resignAllKeyboard()
        
        guard let email = _emailTF.text , !email.isEmpty , email.isValidEmailID() else {
            AlertManager.showOKAlert(withTitle: "Email Validation", withMessage: "Please fill valid email id", onViewController: self)
            return
        }
        
        guard let pswd = _passwordTF.text , !pswd.isEmpty else {
            AlertManager.showOKAlert(withTitle: "Password Validation", withMessage: "Please fill password", onViewController: self)
            return
        }
        
        guard _userType > 0 , _userType < 3 else {
            AlertManager.showOKAlert(withTitle: "User Type Validation", withMessage: "Please select which kind of user you are", onViewController: self)
            return
        }
        
        ASDBManager.fetchOneResult(t: Users.self, predicator: NSPredicate(format: "email == %@", email), sort: nil) { [weak self] existinguser, error in
            guard let welf = self , existinguser == nil else {
                AlertManager.showOKAlert(withTitle: "Already exists", withMessage: "User with given email already exists", onViewController: self!)

                return
            }
            
            WebRequests.signUpUser(email: email, password: pswd, usertype: welf._userType) { user, errorString in
                guard let _ = user else {
                    guard let errorString = errorString else {
                        AlertManager.showOKAlert(withTitle: "Error", withMessage: "Unknown error occurred", onViewController: welf)
                        return
                    }
                    AlertManager.showOKAlert(withTitle: "Error", withMessage: errorString,
                                             onViewController: welf)
                    
                    return
                }
                
                AlertManager.showOKAlert(withTitle: "Success", withMessage: "User created successfully", onViewController: welf, returnBlock:  { [weak self] clickedIndex in
                    DispatchQueue.main.async {
                        self?.dismiss(animated: true)
                    }
                })
            }
        }                
    }
    
    @IBAction private func _userTypeButtonPressed(sender: ASButton) {
        let buttons = ["Admin", "User"]
        AlertManager.showActionSheetWithSimilarButtonsType(withTitle: nil, withMessage: "You are?", buttonsTitles: buttons, onViewController: self) { [unowned self] clickedIndex in
            sender.setTitle(buttons[clickedIndex], for: .normal)
            self._userType = clickedIndex + 1
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

}

extension SignupVC: UITextFieldDelegate {
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

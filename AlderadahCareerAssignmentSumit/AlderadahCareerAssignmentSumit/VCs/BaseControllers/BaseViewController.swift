//
//  BaseViewController.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import UIKit

class BaseViewController: UIViewController {
    internal var _initialOriginY : CGFloat = CGFloat.greatestFiniteMagnitude

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ASNotificationCenter.addObserver(self, selector: #selector(BaseViewController._keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        ASNotificationCenter.addObserver(self, selector: #selector(BaseViewController._keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func _keyboardWillShow(notification: NSNotification) {
        ParseKeyboardNotification(notification: notification, callBack: {
            (animationDuration: TimeInterval, keyboardHeigh: CGFloat, animationOption: UIView.AnimationCurve) -> Void in
            
            self._keyboardIsHiding(animationDuration: animationDuration)
            
            let tf = self._findFirstResponder()
            if tf != nil {
                let tfView: UIView = tf as! UIView
                let tfBounds: CGRect = (self.view.window?.convert(tfView.bounds, from: tfView))!
                
                let lengthToKbd: CGFloat = ((self.view.window?.frame.size.height)! - keyboardHeigh) - (tfBounds.origin.y + tfBounds.size.height)
                self._initialOriginY = self.view.frame.origin.y
                
                let offsetToKbd: CGFloat = 40;
                if (lengthToKbd < offsetToKbd)
                {
                    UIView.animate(withDuration: animationDuration, animations: {
                        var r: CGRect = self.view.frame;
                        self._initialOriginY = self.view.frame.origin.y
                        r.origin.y -= offsetToKbd - lengthToKbd;
                        self.view.frame = r;
                    })
                }
            }
            
        })
    }
    
    @objc func _keyboardWillHide(notification: NSNotification) {
        ParseKeyboardNotification(notification: notification, callBack: {
            (animationDuration: TimeInterval, keyboardHeigh: CGFloat, animationOption: UIView.AnimationCurve) -> Void in
            self._keyboardIsHiding(animationDuration: animationDuration)
        })
    }
    
    private func _keyboardIsHiding(animationDuration : TimeInterval) {
        if(_initialOriginY == CGFloat.greatestFiniteMagnitude) {
            return
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            var r: CGRect = self.view.frame;
            r.origin.y = self._initialOriginY
            self._initialOriginY = CGFloat.greatestFiniteMagnitude
            self.view.frame = r;
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        resignAllKeyboard()
    }
    
    func resignAllKeyboard() {
        if let vw = self._findFirstResponder() {
            if vw is UITextField || vw is UITextView {
                if vw.canResignFirstResponder {
                    _ = vw.resignFirstResponder()
                }
            }
        }
    }

}

extension UIViewController {
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    fileprivate func _findFirstResponder() -> AnyObject! {
        return _findFirstResponderWithView(vw: view)
    }
    
    private func _findFirstResponderWithView(vw: UIView) -> UIView! {
        if vw.isFirstResponder {
            return vw
        }
        
        var res: UIView!
        for vw2: UIView in vw.subviews {
            let retVw: UIView? = _findFirstResponderWithView(vw: vw2)
            if (retVw != nil) {
                res = retVw!
                break
            }
        }
        
        return res
    }
    
}

extension UIViewController {
    static func identifier() -> String {
        let myName = String(describing: self)
        return myName
    }
}

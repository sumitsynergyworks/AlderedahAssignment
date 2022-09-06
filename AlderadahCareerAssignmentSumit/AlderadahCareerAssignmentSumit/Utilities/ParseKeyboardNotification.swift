//
//  ULParseKeyboardNotification.swift
//  Catalog-App
//
//  Created by Sumit Jain on 19/10/15.
//  Copyright © 2015 Urban Ladder. All rights reserved.
//

import UIKit

public typealias KeyboardShow = (_ animationDuration: TimeInterval, _ keyboardHeigh: CGFloat, _ animationOption: UIView.AnimationCurve) -> Void

public func ParseKeyboardNotification(notification: NSNotification, callBack:KeyboardShow?) {
    
    let userInfo = notification.userInfo
    
    let duration = (userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
    
    let option = ((userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as AnyObject).integerValue)! << 16
    
    let keyboardEndFrame = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
    
    let height = keyboardEndFrame?.size.height
    
    if (callBack != nil) {
        callBack?(duration!, height!, UIView.AnimationCurve(rawValue: option)!);
    }
}

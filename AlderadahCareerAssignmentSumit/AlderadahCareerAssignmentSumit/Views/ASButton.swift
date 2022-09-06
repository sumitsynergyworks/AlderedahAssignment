//
//  ASButton.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import UIKit

typealias ClickButtonBlock = (AnyObject?) -> Void

class ASButton: UIButton {
    
    fileprivate var _tapBlock : ClickButtonBlock?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setRoundedCornerWithRadius(radius: ASAppConstants.defaultCornerRadiusView)
    }
    
    class func getOne(rect:CGRect = CGRect.init(x: 0, y: 0, width: 20, height: 40), title: String = "", image: UIImage? = nil) -> ASButton {
        let button = ASButton.init(frame: rect)
        button.setTitle(title, for: .normal)
        if let image = image {
            button.setImage(image, for: .normal)
        }
        return button
    }
    
    func facilitateTapBlock(_ tap : @escaping ClickButtonBlock, forEvent event : UIControl.Event) {
        self.removeTarget(self, action: #selector(self.actionForSelfTarget(_:)), for: event)
        self._tapBlock = tap;
        self.addTarget(self, action: #selector(self.actionForSelfTarget(_:)), for: event)
    }
    
    @objc func actionForSelfTarget(_ sender : ASButton) {
        self._tapBlock!(sender);
    }
}

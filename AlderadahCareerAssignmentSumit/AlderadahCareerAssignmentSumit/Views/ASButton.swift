//
//  ASButton.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import UIKit

class ASButton: UIButton {

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
}

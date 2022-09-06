//
//  ASView.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import UIKit

extension UIView {
    func setRoundedCornerWithRadius(radius: Float) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true        
    }
}

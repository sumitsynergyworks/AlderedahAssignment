//
//  ColorScheme.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import Foundation

import UIKit

public func ColorInFloat(x: CGFloat) -> CGFloat{
    return x/255.0
}

public func RGB(r : CGFloat, g : CGFloat, b : CGFloat, alpha : CGFloat = 1.0) -> UIColor{
    return UIColor(red: ColorInFloat(x: r),
                   green: ColorInFloat(x: g),
                   blue: ColorInFloat(x: b),
                   alpha: alpha)
    
}

public extension UIColor {
    
    class func ThemeBlueColor() -> UIColor {
        return RGB(r: 22.0, g: 67.0, b: 133.0)
    }
    
    class func ThemeOrangeColor() -> UIColor {
        return RGB(r: 200.0, g: 103.0, b: 39.0)
    }
}

//
//  ApplicationEnums.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import Foundation
import UIKit

public func allValues<T: CaseIterable>(_:T.Type) -> Array<T> {
    return T.allCases as! Array<T>
}


enum ApplicationFields : Int, CaseIterable {
    case firstName = 0
    case lastName
    case mobileNumber
    case email
    case skills
    case resume
    case linkedInURL
    case githubURL
    case otherURL
    
    static let allFields = allValues(ApplicationFields.self)
    
    func classType() -> BaseTableViewCell.Type {
        switch self {
        case .firstName, .lastName, .mobileNumber, .email, .linkedInURL, .githubURL, .otherURL:
            return TextfieldCell.self
            
        case .skills, .resume:
            return SelectButtonCell.self
        }
    }
    
    func headerTitle() -> String {
        switch self {
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .mobileNumber:
            return "Mobile Number"
        case .email:
            return "Email"
        case .skills:
            return "Skills"
        case .resume:
            return "Select Resume"
        case .linkedInURL:
            return "linkedIN URL"
        case .githubURL:
            return "GitHub URL"
        case .otherURL:
            return "Other URL"
        }
    }
    
    func placeholderTitle() -> String {
        switch self {
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .mobileNumber:
            return "Mobile Number"
        case .email:
            return "Email"
        case .skills:
            return "Select Skill Set"
        case .resume:
            return "Select Resume"
        case .linkedInURL:
            return "linkedIN URL"
        case .githubURL:
            return "GitHub URL"
        case .otherURL:
            return "Other URL"
        }
    }
    
    func serverKeys() -> String {
        switch self {
        case .firstName:
            return "firstName"
        case .lastName:
            return "lastName"
        case .mobileNumber:
            return "mobile"
        case .email:
            return "email"
        case .skills, .resume:
            return ""
        case .linkedInURL:
            return "linkedInURL"
        case .githubURL:
            return "githubURL"
        case .otherURL:
            return "otherURL"
        }
    }
    
    func keyboardType() -> UIKeyboardType {
        switch self {
        case .firstName, .lastName, .skills, .resume:
            return .default
        case .mobileNumber:
            return .phonePad
        case .email:
            return .emailAddress
        case .linkedInURL, .githubURL, .otherURL:
            return .URL
        }
    }
}

enum Skills: String, CaseIterable {
    case iOS = "iOS"
    case Android = "Android"
    case NodeJS = "NodeJS"
    case Angular = "Angular"
    case Java = "Java"
    case Devops = "DevOps"
    case ReactNative = "ReactNative"
    case Flutter = "Flutter"
    case QA = "QA"
    case HR = "HR"
    case TechnicalManager = "Technical Manager"
    
    static let allSkills = allValues(Skills.self)
}

protocol CellSetDataMethod {
    func setDataForFieldType(fieldType: ApplicationFields, fieldData: String?)
}

//
//  StringConstants.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 03/09/22.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

@objc public class StringConstants: NSObject {
    
    public static let MAIN_STORYBOARD_NAME = "Main"
    
    public static let PLEASE_WAIT = "Please wait..."
    public static let EMAIL_VALIDATION = "Email Validation"
    public static let EMAIL_VALIDATION_ALERT = "Please fill valid email id"
    public static let PASSWORD_VALIDATION = "Password Validation"
    public static let PASSWORD_VALIDATION_ALERT = "Please fill password"
    public static let WRONG_PASSWORD = "Wrong password"
    public static let PASSWORD_NOT_MATCHED = "Password does not match"
    public static let USER_NOT_EXIST = "User Does not exist"
    public static let LOGIN_ANONYMOUSLY = "Do you want to login with anonymous user?"
    public static let YES = "YES"
    public static let NO = "NO"
    public static let CANCEL = "Cancel"
    public static let EMPTY_MARK = "-"
    public static let SELECT_STATUS = "Please select status"
    public static let ERROR = "Error"
    public static let UNKNOWN_ERROR = "Unknown error occurred"
    public static let IMPROPER_ERROR = "Improper Email"
    public static let USERTYPE_VALIDATION = "User Type Validation"
    public static let USERTYPE_VALIDATION_ALERT = "Please select your role"
    public static let ALREADY_EXISTS = "Already exists"
    public static let ALREADY_EMAIL_EXISTS = "User with given email already exists"
    public static let SUCCESS = "Success"
    public static let USER_CREATED = "User created successfully"
    public static let ADMIN = "Admin"
    public static let USER = "User"
    public static let DELETE = "Delete"
    public static let EMAIL = "Email"
    public static let ROLE = "Role"
    public static let APP_VERSION = "App Version"
    public static let LOGOUT = "Logout"
    public static let LOGOUT_ALERT = "Do you want to logout?"
    public static let APPLICATION_ADDED_SUCCESS = "Your Application added successfully"
    public static let DELETE_ALERT = "Are you sure you want to delete this application?"
    public static let RESUME_NOT_AVAILABLE = "Resume not available"
    public static let RESUME_NOT_AVAILABLE_ALERT = "Resume not available for this application"
    public static let REQUIRE_MANDATORY_FIELDS = "Require mandatory fields"
    

    // URLs
    public static let baseURL = "https://6311dfd1f5cba498da87458b.mockapi.io/api/v1/"
    public static let signupURL = "createUser"
    public static let applications = "applications"
}

extension String {
    public func isValidEmailID() -> Bool {
        let stricterFilterString : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
//        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
//        let result = phoneTest.evaluate(with: self)
//        return result
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil && self.count > 6 && self.count < 12
    }
    
    func isOnlyalpha() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    func isOnlyalphanumeric() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    func isValidURL() -> Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        }
        return false        
    }
    
    func call() {
        if let phoneCallURL = URL(string: "telprompt://\(self)") {
            if (ASSharedApplication.canOpenURL(phoneCallURL)) {
                ASSharedApplication.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func fullDateFormatToDate() -> Date? {
    
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from:self)
    }
}

extension Date {
    func toString(format: String = "dd-MM-yyyy\nHH:mm") -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
//        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)

    }
}


extension NSURL {
    public func mimeType() -> String {
        if let pathExt = self.pathExtension,
            let mimeType = UTType(filenameExtension: pathExt)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
}

extension URL {
    public func mimeType() -> String {
        if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
}

extension NSString {
    public func mimeType() -> String {
        if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
}

extension String {
    public func mimeType() -> String {
        return (self as NSString).mimeType()
    }
    
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

extension Array where Element == String {
    func json() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

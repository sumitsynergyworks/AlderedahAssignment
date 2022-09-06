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

    
    public static let baseURL = "https://6311dfd1f5cba498da87458b.mockapi.io/api/v1/"
    
    // URLs
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

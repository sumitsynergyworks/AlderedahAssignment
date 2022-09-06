//
//  ASShared.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import Foundation

class ASShared {
    static let shared = ASShared()
    
//    var dbOperationQueue = DispatchQueue(label: "DBOperations")
    
    private init() {}
    
    var loggedInUser: User?
    var loggedInDBUser: Users?
    
    var myApplicationsReceived: Bool = false
    
    func isLoggedUserAdmin() -> Bool {
        if let user = ASSharedClass.loggedInUser , let type = Int(user.type) {
            if UserType.init(rawValue: type) == .admin {
                return true
            }
        }
        
        return  false
    }
}

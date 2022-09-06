//
//  User.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import Foundation

enum UserType:Int {
    case unknown = 0
    case admin
    case user
}

struct User: Codable {
    let email: String
    let type: String
    let id: String
    let password: String
}

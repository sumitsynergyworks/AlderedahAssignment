//
//  UploadFileResponse.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import Foundation

struct UploadFile: Codable {
    let accountId: String
    let fileId: String
    let fileUniquifier: String
    let fileUrl: String
}

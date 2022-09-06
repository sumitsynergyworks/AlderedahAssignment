//
//  Application.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import Foundation

enum ApplicationStatus : Int, CaseIterable {
    case Applied = 1
    case Rejected
    case Accepted
    case BestAccepted
    
    static let allFields = allValues(ApplicationStatus.self)

    func stringName() -> String {
        switch self {
        case .Applied:
            return "Applied"
        case .Rejected:
            return "Rejected"
        case .Accepted:
            return "Accepted"
        case .BestAccepted:
            return "Best Accepted"
        }
    }
}

struct ApplicationList: Codable {
    let count: Int
    let items: [Application]
}

struct Application: Codable {
    let id: String
    let userId: String
    let email: String
    let firstName: String
    let lastName: String
    let mobile  : String
    let resumeFilePath: String?
    let resumeScore: String
    let status: String
    let linkedInURL: String?
    let githubURL: String?
    let otherURL: String?
    let jobId: String
    let fileAccountId: String?
    let fileId: String?
    let fileUniquifier: String?
    let systemStatus: String
    let skills: String?
    let resumeFileName: String?
    let createdAt: String
    
    func fullName() -> String {
        "\(firstName) \(lastName)"
    }
    
    func skillsConcatenated() -> String {
        if let skil = skills , let skilary = skil.toJSON() as? [String], skilary.count > 0 {
            return skilary.joined(separator: ", ")
        }
        return StringConstants.EMPTY_MARK
    }
    
    func statusString() -> String {
        ApplicationStatus(rawValue: Int(status) ?? 1)?.stringName() ?? StringConstants.EMPTY_MARK
    }
    
    func systemStatusString() -> String {
        ApplicationStatus(rawValue: Int(systemStatus) ?? 1)?.stringName() ?? StringConstants.EMPTY_MARK
    }
    
    func createdDate() -> String {
        if let date = createdAt.fullDateFormatToDate() {
            return date.toString()
        }
        return StringConstants.EMPTY_MARK
    }

    static func getResumeScore(dataInfo: [ApplicationFields:String], resumeInfo: UploadFile?, skills: [String]) -> (Int, Int) {
        var score = 0
        for (key, _) in dataInfo {
            switch key {
                
            case .firstName, .lastName, .mobileNumber, .email, .linkedInURL, .githubURL, .otherURL:
                score = score + 1
            case .skills, .resume:
                score = score + 0
            }
        }
        
        if let resumeInfo = resumeInfo , !resumeInfo.fileUrl.isEmpty {
            score = score + 2
        }
        
        if skills.count > 10 {
            score = score + 10
        } else if skills.count > 5 {
            score = score + 5
        } else {
            score = score + skills.count
        }
        
        var status = 1
        if score > 15 {
            status = 4
        } else if score > 10 {
            status = 3
        } else if score < 5 {
            status = 2
        }
        
        return (score, status)
    }
}

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
    
    static let BEST_PROFILE_MIN_SCORE = 16
    static let SELECTED_PROFILE_MIN_SCORE = 11
    static let SELECTED_PROFILE_MAX_SCORE = 15
    static let APPLIED_PROFILE_MAX_SCORE = 10
    static let APPLIED_PROFILE_MIN_SCORE = 5
    static let REJECTED_MAX_SCORE = 4
    
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
    
    func getDictionary() -> [ApplicationFields : String] {
        var filledData = [ApplicationFields : String]()
        filledData[.firstName] = self.firstName
        filledData[.lastName] = self.lastName
        filledData[.mobileNumber] = self.mobile
        filledData[.email] = self.email
        if let linkedInURL = linkedInURL , linkedInURL.count > 0 {
            filledData[.linkedInURL] = linkedInURL
        }
        if let githubURL = githubURL , githubURL.count > 0 {
            filledData[.githubURL] = githubURL
        }
        if let otherURL = otherURL ,otherURL.count > 0 {
            filledData[.otherURL] = otherURL
        }
        
        var skill = [String]()
        if let skills = skills , skills.count > 0 , let skillary = skills.toJSON() as? [String] , skillary.count > 0 {
            skill = skillary
        }
        
        filledData[.skills] = skill.joined(separator: ", ")
        if let resumeFilePath = resumeFileName , resumeFilePath.count > 0 {
            filledData[.resume] = resumeFilePath
        }
        
        return filledData
    }
    
    func getSkillsArray() -> [String] {
        var skill = [String]()
        if let skills = skills , skills.count > 0 , let skillary = skills.toJSON() as? [String] , skillary.count > 0 {
            skill = skillary
        }
        
        return skill
    }
    
    func getResumeInfo() -> UploadFile? {
        var resumeInfo : UploadFile?
        if let resumeFilePath = resumeFilePath , resumeFilePath.count > 0 {
            resumeInfo = UploadFile.init(accountId: self.fileAccountId ?? "", fileId: self.fileId ?? "", fileUniquifier: self.fileUniquifier ?? "", fileUrl: resumeFilePath)
        }
        
        return resumeInfo
    }
    
    func getScore() -> Int {
        let filledData = self.getDictionary()
        
        let skill = self.getSkillsArray()
        
        let resumeInfo : UploadFile? = getResumeInfo()

        return Application.getResumeScore(dataInfo: filledData, resumeInfo: resumeInfo, skills: skill).0
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
        
        let status = getStatusIntValue(score: score)
        
        return (score, status)
    }
    
    static func getStatusIntValue(score : Int) -> Int {
        var status = 1
        if score >= BEST_PROFILE_MIN_SCORE {
            status = 4
        } else if score >= SELECTED_PROFILE_MIN_SCORE {
            status = 3
        } else if score <= REJECTED_MAX_SCORE {
            status = 2
        }
        
        return status
    }
}

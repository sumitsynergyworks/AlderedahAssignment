//
//  WebRequests.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 03/09/22.
//

import Foundation
import Alamofire

class WebRequestURL {
    class func baseURL() -> String {
        return StringConstants.baseURL
    }
    
    static func signupUser() -> String {
        return baseURL() + StringConstants.signupURL
    }
    
    static func login(id:String) -> String {
        return baseURL() + StringConstants.signupURL + "/\(id)"
    }
    
    static func addApplication() -> String {
        return baseURL() + StringConstants.applications
    }
    
    static func deleteApplication(id:String) -> String {
        return baseURL() + StringConstants.applications + "/\(id)"
    }
    
    static func uploadFileURL() -> String {
        return "https://api.upload.io/v1/files/basic"
    }
}

class WebRequests {
    static func signUpUser(email: String, password: String, usertype: Int, completionHandler: @escaping (User?, String?) -> Void) {
        let request = WebRequestHelper._request(WebRequestURL.signupUser(), method: .post, parameters: RequestParams.signupParams(email: email, password: password, usertype: usertype))
        WebRequestHelper.sendRequest(request: request, type: User.self) { usert, error in
            if let usert = usert {
                let dbusere = DBManager.getBackgroundModel(t: Users.self)
                dbusere.email = usert.email
                dbusere.password = usert.password
                dbusere.type = Int16(usert.type) ?? 0
                dbusere.id = usert.id
                ASDBManager.saveObject(t: dbusere) { saved, dberror in}
            }
            completionHandler(usert, error)
        }
    }
    
    static func loginUserWith(id:String, completionHandler: @escaping (User?, String?) -> Void) {
        let request = WebRequestHelper._request(WebRequestURL.login(id: id))
        WebRequestHelper.sendRequest(request: request, type: User.self, completionHandler: completionHandler)
    }
    
    static func uploadResumeFile(fileURL: URL, fileData: Data, fileName: String, mimeType: String, completionHandler: @escaping (UploadFile?, String?) -> Void) {    
        let req = AF.upload(fileURL, to: WebRequestURL.uploadFileURL(), headers: RequestParams.headerToUploadFile(mimeType: mimeType, fileName: fileName))
        
        WebRequestHelper.sendRequest(request: req, type: UploadFile.self, completionHandler: completionHandler)
    }
    
    static func addApplication(dataInfo: [ApplicationFields:String], resumeInfo: UploadFile?, skills: [String], completionHandler: @escaping (Application?, String?) -> Void) {
        let request = WebRequestHelper._request(WebRequestURL.addApplication(), method: .post, parameters: RequestParams.addApplicationParams(dataInfo: dataInfo, resumeInfo: resumeInfo, skills: skills))
        WebRequestHelper.sendRequest(request: request, type: Application.self) { usert, error in
            if let usert = usert {
                let dbusere = DBManager.getBackgroundModel(t: JobApplications.self)
                if let resumeFilePath = usert.resumeFilePath , resumeFilePath.count > 0 {
                    dbusere.resumeFilePath = resumeFilePath
                }
                dbusere.resumeScore = Int16(usert.resumeScore) ?? 4
                dbusere.email = usert.email
                dbusere.firstName = usert.firstName
                dbusere.lastName = usert.lastName
                dbusere.mobileNumber = Int64(usert.mobile) ?? 0
                dbusere.status = Int16(usert.status) ?? 1
                if let linkedInURL = usert.linkedInURL, linkedInURL.count > 0 {
                    dbusere.linkedInURL = URL.init(string: linkedInURL )
                }
                if let githubURL = usert.githubURL , githubURL.count > 0 {
                    dbusere.githubURL = URL.init(string: githubURL)
                }
                if let otherURL = usert.otherURL , otherURL.count > 0 {
                    dbusere.otherURL = URL.init(string: otherURL)
                }
                dbusere.jobId = usert.jobId
                if let fileAccountId = usert.fileAccountId , fileAccountId.count > 0 {
                    dbusere.fileAccountId = fileAccountId
                }
                if let fileId = usert.fileId , fileId.count > 0 {
                    dbusere.fileId = fileId
                }
                if let fileUniquifier = usert.fileUniquifier , fileUniquifier.count > 0 {
                    dbusere.fileUniquifier = fileUniquifier
                }
                dbusere.systemStatus = Int16(usert.systemStatus) ?? 1
                if let skillStr = usert.skills , skillStr.count > 0 {
                    if let skillarray = skillStr.toJSON() , skillarray is [String] {
                        dbusere.skills = skillarray as? [String]
                    }
                }
                dbusere.id = usert.id
                dbusere.userId = usert.userId
                dbusere.createdAt = Date.now
                
                ASDBManager.saveObject(t: dbusere) { saved, dberror in }
            }
            completionHandler(usert, error)
        }
    }
    
    static func getApplications(filter: [String:Any]? = nil, page: Int, count: Int, searchFilter: String? = nil, completionHandler: @escaping (ApplicationList?, String?) -> Void) {
        let request = WebRequestHelper._request(WebRequestURL.addApplication(), parameters: RequestParams.getApplicationParams(filter: filter, page: page, count: count, searchFilter: searchFilter))
        WebRequestHelper.sendRequest(request: request, type: ApplicationList.self, completionHandler: completionHandler)
    }
    
    static func deleteApplication(id: String, completionHandler: @escaping (Application?, String?) -> Void) {
        let request = WebRequestHelper._request(WebRequestURL.deleteApplication(id: id), method: .delete)
        WebRequestHelper.sendRequest(request: request, type: Application.self, completionHandler: completionHandler)
    }
    
    static func changeStatus(id: String, status: Int, completionHandler: @escaping (Application?, String?) -> Void) {
        let request = WebRequestHelper._request(WebRequestURL.deleteApplication(id: id), method: .put, parameters: RequestParams.updateStatus(status: status))
        WebRequestHelper.sendRequest(request: request, type: Application.self, completionHandler: completionHandler)
    }
}



//
//  NetworkHelper.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 03/09/22.
//

import Foundation

import Foundation
import Alamofire

class WebRequestHelper {
    typealias WebRequest = DataRequest //taken this so if alamofire changes something, we do not have to do changes everytime and everywhere
    
    static func _request(_ url: String, method: HTTPMethod = .get, parameters: RequestParams.ParameterDictionary? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = RequestParams.defaultHeaders())
    -> WebRequest {
        return AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    static func sendRequest<T:Codable>(request: WebRequest, printResponse: Bool = true, type:T.Type, completionHandler: @escaping (T?, String?) -> Void) {
        if let rq = request.request , printResponse {
            if let requestData = rq.httpBody {
                print("SENDING DATA == ",String.init(data: requestData, encoding: .utf8) ?? "//No Data in request//")
            }
            
            print("URL == ",rq.url ?? "url not found")
            print("Request Method == ",rq.method ?? "method not found")

        }
        
        request.responseData { responseData in
            let error = responseData.error

            if let data = responseData.data {
                if printResponse {
                    print("URL == ",request.request?.url ?? "url not found")
                
                    print("RECEIVED RESPONSE == \n" + String(data: data, encoding: String.Encoding.utf8)!)
                }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(decodedData, error?.localizedDescription)
                } catch {
                    completionHandler(nil, error.localizedDescription)
                }
                
            } else {
                if let error = error {
                    completionHandler(nil, error.localizedDescription)
                } else {
                    completionHandler(nil, "Unknown error occurred")
                }
            }
        }
    }
}

class RequestParams {
    typealias ParameterDictionary = [String : Any] ////taken this so if alamofire changes something, we do not have to do changes everytime and everywhere
    typealias HeaderDictionary = HTTPHeaders ////taken this so if alamofire changes something, we do not have to do changes everytime and everywhere
    
    fileprivate class func _createDefaultParams() -> ParameterDictionary {
        let parameters = ParameterDictionary()
        return parameters
    }
    
    class func defaultParams() -> ParameterDictionary {
        return _createDefaultParams()
    }
    
    class func defaultHeaders() -> HeaderDictionary {
        let defaultH = ["Content-Type" : "application/x-www-form-urlencoded" ]
        let httpHeader = HTTPHeaders(defaultH)
        return httpHeader
    }
    
    static func signupParams(email: String, password: String, usertype: Int) -> ParameterDictionary {
        var params = defaultParams()
        params["email"] = email
        params["password"] = password
        params["type"] = usertype
        
        return params
    }
    
    static func addApplicationParams(dataInfo: [ApplicationFields:String], resumeInfo: UploadFile?, skills: [String]) -> ParameterDictionary {
        var params = defaultParams()
        if skills.count > 0 {
            if let skilllJson = skills.json() {
                params["skills"] = skilllJson
            }
        }
        if let resumeInfo = resumeInfo {
            params["fileUniquifier"] = resumeInfo.fileUniquifier
            params["fileId"] = resumeInfo.fileId
            params["fileAccountId"] = resumeInfo.accountId
            params["resumeFilePath"] = resumeInfo.fileUrl
        }
        
        for (key, value) in dataInfo {
            let serverKey = key.serverKeys()
            if serverKey != "" {
                params[serverKey] = value
            }
        }
        
        params["status"] = 1
        if let logu = ASSharedClass.loggedInUser {
            params["userId"] = logu.id
        }
        
        let (score, status) = Application.getResumeScore(dataInfo:dataInfo,  resumeInfo:resumeInfo, skills:skills)
        
        params["systemStatus"] = status
        params["jobId"] = "dw323"
        params["resumeScore"] = score
        
        return params
    }
        
    static func headerToUploadFile(mimeType: String, fileName: String) -> HeaderDictionary {
        var hdrs = ["Content-Type": mimeType]
        hdrs["Authorization"] = "Bearer public_FW25auRFwt8xnzm331tPp4EfFrta"
        hdrs["X-Upload-File-Name"] = fileName
        let httpHeader = HTTPHeaders(hdrs)
        return httpHeader
    }
    
    static func getApplicationParams(filter: [String: Any]? = nil, page: Int, count: Int, searchFilter: String? = nil) -> ParameterDictionary {
        var params = defaultParams()
        if let filter = filter {
            for (key, val) in filter {
                params[key] = val
            }
        }
        params["page"] = page
        params["limit"] = count
        
        if let searchFilter = searchFilter {
            params["search"] = searchFilter
        }
        
        return params
    }
    
    static func updateStatus(status: Int) -> ParameterDictionary {
        var params = defaultParams()
        params["status"] = status
        
        return params
    }
}

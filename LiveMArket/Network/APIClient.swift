//
//  APIClient.swift
//  Networking
//
//  Created by A2 MacBook Pro 2012 on 17/06/20.
//  Copyright © 2020 A2 MacBook Pro 2012. All rights reserved.
//

import Foundation
import Alamofire

protocol uploadProgressProtocol{
    func uploadProgressAction(progress:CGFloat)
}

extension Data {
    func prettyPrintedJSONString() -> NSString {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return "nil" }
        return prettyPrintedString
    }
}

class APIClient {
    
    var delegate:uploadProgressProtocol?
    class func printDetailedError(responseData: Data?, error: Error) {
        print("\n\n===========Error===========")
        print("Error Code: \(error._code)")
        print("Error Messsage: \(error.localizedDescription)")
        if let data = responseData, let str = String(data: data, encoding: String.Encoding.utf8){
            print("Server Error: " + str)
        }
        debugPrint(error as Any)
        print("===========================\n\n")
    }
    
    class func codableAPIRequest<T>(showIndicator: Bool? = true, request: APIConfiguration, completionHandler: @escaping(_ result: T?) -> Void) where T:Codable {
        
        if showIndicator == true {
            Utilities.showIndicatorView()
        }
        
        var parameters = request.parameters
        if languageBool {
            parameters["language"] = "2"
        } else {
            parameters["language"] = "1"
        }
        parameters["timezone"] = TimeZone.current.identifier
        AF.request(
            request.url ,
            method: request.method,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: request.headers
        ).validate(statusCode: 200..<500)
            .responseDecodable { (response: DataResponse<T, AFError>) in
                if showIndicator == true {
                    Utilities.hideIndicatorView()
                }
                if let responseData = response.data, let str = String(data: responseData, encoding: String.Encoding.utf8){
                    print("Response: " + str)
                }
                print(response, "-------======------------=========")
                switch response.response?.statusCode {
                case 401:
                    guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                        sessionExpiredAction(message: "Session expired. Please login again.")
                        completionHandler(nil)
                        return
                    }
                    sessionExpiredAction(message: message)
                default:
                    switch response.result {
                    case .success(let data):
                        completionHandler(data)
                    case .failure(let error):
                        completionHandler(nil)
                        handleError(error: error)
                    }
                }
            }
    }
    
    class func sessionExpiredAction(message: String) {
        Utilities.showWarningAlert(message: message) {
            SessionManager.clearLoginSession()
            NotificationCenter.default.post(name: Notification.Name("loginStatusChanged"), object: nil)
            let home = BaseViewController()
            Coordinator.updateRootVCToTab()
        }
    }
    
    class func handleError(error: AFError) {
        //  Utilities.createToast(message: error.localizedDescription)
        //        if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorNotConnectedToInternet {
        //            NotificationCenter.default.post(name: .reachabilityChanged, object: nil)
        //        }  else if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorNetworkConnectionLost {
        ////                        Utilities.showWarningAlert(message: "Internet connection lost")
        //            NotificationCenter.default.post(name: .reachabilityChanged, object: nil)
        //        } else if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorDataNotAllowed {
        ////                        Utilities.showWarningAlert(message: "No Internet connection available")
        //            NotificationCenter.default.post(name: .reachabilityChanged, object: nil)
        //        } else if let underError = error.underlyingError as NSError?, underError.code == NSURLErrorTimedOut {
        ////                        Utilities.createToast(message: "Request Timed Out")
        //        }
    }
    
    class func apiRequest(request: APIConfiguration, completionHandler : @escaping(_ result: NSDictionary?) -> Void) {
        
        Utilities.showIndicatorView()
        
        var parameters = request.parameters
        if languageBool {
            parameters["language"] = "2"//"ar"
        } else {
            parameters["language"] = "1"//"en"
        }
        parameters["timezone"] = TimeZone.current.identifier
        
        AF.request(request.url, method: request.method, parameters: parameters, encoding: URLEncoding.default, headers: request.headers).validate(statusCode: 200..<500).responseJSON { response in
            
            Utilities.hideIndicatorView()
            print("Request: \(String(describing: response.request))")  // original URL request
            print("---------------------------")
            print("HTTP URL response: \(String(describing: response.response))") // HTTP URL response
            print("---------------------------")
            print("Data: \(String(describing: response.data))")     // server data
            print("---------------------------")
            print("Result of Reponse Serialization \(request.url) \(response.result)")   // result of response serialization
            print("---------------------------")
            print("Error \(String(describing: response.error))")   // result of response serialization
            print("---------------------------")
            print("Access Token \(SessionManager.getAccessToken() ?? "No Access Token")")   // Acccess Token
            print("---------------------------")
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                    sessionExpiredAction(message: "Session expired. Please login again.")
                    completionHandler(nil)
                    return
                }
                sessionExpiredAction(message: message)
            default:
                switch response.result {
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(reponseDict)
                case .failure(let error):
                    handleError(error: error)
                }
            }
        }
    }
    
    class func apiRequestV2(request: APIConfiguration, completionHandler : @escaping(_ result: NSDictionary?) -> Void) {
        
        Utilities.showIndicatorView()
        
        var parameters = request.parameters
        if languageBool {
            parameters["language"] = "2"//"ar"
        } else {
            parameters["language"] = "1"//"en"
        }
        parameters["timezone"] = TimeZone.current.identifier
        
        AF.request(request.urlv2, method: request.method, parameters: parameters, encoding: URLEncoding.default, headers: request.headers).validate(statusCode: 200..<500).responseJSON { response in
            
            Utilities.hideIndicatorView()
            print("Request: \(String(describing: response.request))")  // original URL request
            print("---------------------------")
            print("HTTP URL response: \(String(describing: response.response))") // HTTP URL response
            print("---------------------------")
            print("Data: \(String(describing: response.data))")     // server data
            print("---------------------------")
            print("Result of Reponse Serialization \(response.result)")   // result of response serialization
            print("---------------------------")
            print("Error \(String(describing: response.error))")   // result of response serialization
            print("---------------------------")
            print("Access Token \(SessionManager.getAccessToken() ?? "No Access Token")")   // Acccess Token
            print("---------------------------")
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                    sessionExpiredAction(message: "Session expired. Please login again.")
                    completionHandler(nil)
                    return
                }
                sessionExpiredAction(message: message)
            default:
                switch response.result {
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(reponseDict)
                case .failure(let error):
                    handleError(error: error)
                }
            }
        }
    }
    
    
    class func multiPartRequest(request: UploadAPIConfiguration, completionHandler : @escaping(_ result: NSDictionary?) -> Void) {
        
        Utilities.showIndicatorView()
        
        var parameters = request.parameters
        if languageBool {
            parameters["language"] = "ar"
        } else {
            parameters["language"] = "en"
        }
        parameters["timezone"] = TimeZone.current.identifier
        
        AF.upload(multipartFormData: { multipartFormData in
            for (imageKey, images) in request.images {
                for image in images {
                    if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                        let type = imageData.mimeType
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(imageData, withName: imageKey, fileName: "image\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            for (documentKey, documents) in request.documents {
                for document in documents {
                    if let document = document, let type = document.mimeType, let data = document.data {
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(data, withName: documentKey, fileName: "document\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (key, value) in parameters {
                multipartFormData.append(value .data(using: .utf8)!, withName: key)
            }
        },
                  to: request.url,
                  method: request.method,
                  headers: request.headers).uploadProgress(closure: { progress in
            print(progress.fractionCompleted)
        }).responseJSON { response in
            Utilities.hideIndicatorView()
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                    sessionExpiredAction(message: "Session expired. Please login again.")
                    completionHandler(nil)
                    return
                }
                sessionExpiredAction(message: message)
            default:
                switch response.result {
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(reponseDict)
                case .failure(let error):
                    handleError(error: error)
                }
            }
        }
    }
    
    class func multiPartRequestV2(request: UploadAPIConfiguration, completionHandler : @escaping(_ result: NSDictionary?) -> Void) {
        
        Utilities.showIndicatorView()
        
        var parameters = request.parameters
        if languageBool {
            parameters["language"] = "ar"
        } else {
            parameters["language"] = "en"
        }
        parameters["timezone"] = TimeZone.current.identifier
        
        AF.upload(multipartFormData: { multipartFormData in
            for (imageKey, images) in request.images {
                for image in images {
                    if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                        let type = imageData.mimeType
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(imageData, withName: imageKey, fileName: "image\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            for (documentKey, documents) in request.documents {
                for document in documents {
                    if let document = document, let type = document.mimeType, let data = document.data {
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(data, withName: documentKey, fileName: "document\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (key, value) in parameters {
                multipartFormData.append(value .data(using: .utf8)!, withName: key)
            }
        },
                  to: request.urlv2,
                  method: request.method,
                  headers: request.headers).uploadProgress(closure: { progress in
            print(progress.fractionCompleted)
        }).responseJSON { response in
            Utilities.hideIndicatorView()
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                    sessionExpiredAction(message: "Session expired. Please login again.")
                    completionHandler(nil)
                    return
                }
                sessionExpiredAction(message: message)
            default:
                switch response.result {
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(reponseDict)
                case .failure(let error):
                    handleError(error: error)
                }
            }
        }
    }
    
    class func multiPartAddPostRequest(request: AddPostUploadAPIConfiguration, completionHandler : @escaping(_ result: NSDictionary?) -> Void) {
        
        Utilities.showIndicatorView()
        
        var parameters = request.parameters
        if languageBool {
            parameters["language"] = "ar"
        } else {
            parameters["language"] = "en"
        }
        parameters["timezone"] = TimeZone.current.identifier
        
        AF.upload(multipartFormData: { multipartFormData in
            for (imageKey, images) in request.images {
                for image in images {
                    if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                        let type = imageData.mimeType
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(imageData, withName: imageKey, fileName: "image\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (imageKey, images) in request.firstImages {
                for image in images {
                    if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                        let type = imageData.mimeType
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(imageData, withName: imageKey, fileName: "image\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (documentKey, documents) in request.documents {
                for document in documents {
                    if let document = document, let type = document.mimeType, let data = document.data {
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(data, withName: documentKey, fileName: "document\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (key, value) in parameters {
                multipartFormData.append(value .data(using: .utf8)!, withName: key)
            }
        },
                  to: request.url,
                  method: request.method,
                  headers: request.headers).uploadProgress(closure: { progress in
            print(progress.fractionCompleted)
        }).responseJSON { response in
            Utilities.hideIndicatorView()
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                    sessionExpiredAction(message: "Session expired. Please login again.")
                    completionHandler(nil)
                    return
                }
                sessionExpiredAction(message: message)
            default:
                switch response.result {
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(reponseDict)
                case .failure(let error):
                    handleError(error: error)
                }
            }
        }
    }
    
    class func multiPartAddVideoPostRequest(request: AddPostVideoUploadAPIConfiguration, completionHandler : @escaping(_ result: NSDictionary?,_ progress:CGFloat?) -> Void) {
        
        //Utilities.showIndicatorView()
        
        var parameters = request.parameters
        if languageBool {
            parameters["language"] = "ar"
        } else {
            parameters["language"] = "en"
        }
        parameters["timezone"] = TimeZone.current.identifier
        
        AF.upload(multipartFormData: { multipartFormData in
            
            
            for (imageKey, images) in request.images {
                for image in images {
                    if let data = try? Data(contentsOf: image!) {
                        // Create Image and Update Image View
                        let type = data.mimeType
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(data, withName: imageKey, fileName: "Video\(randomNumber)\(Utilities.getTheExtension(mimeType: "video/mp4"))", mimeType: "video/mp4")
                    }
                }
            }
            
            for (imageKey, images) in request.firstImages {
                for image in images {
                    
                    if let data = try? Data(contentsOf: image!) {
                        // Create Image and Update Image View
                        //let type = data.mimeType
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(data, withName: imageKey, fileName: "Video\(randomNumber)" + ".mp4", mimeType:"video/mp4")
                    }
                }
            }
            
            for (documentKey, documents) in request.documents {
                for document in documents {
                    if let document = document, let type = document.mimeType, let data = document.data {
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(data, withName: documentKey, fileName: "document\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (key, value) in parameters {
                multipartFormData.append(value .data(using: .utf8)!, withName: key)
            }
        },
                  to: request.url,
                  method: request.method,
                  headers: request.headers).uploadProgress(closure: { progress in
            print(progress.fractionCompleted)
            //completionHandler(nil,progress.fractionCompleted)
            NotificationCenter.default.post(name: Notification.Name("UploadProgress"), object: progress.fractionCompleted)
            
        }).responseJSON { response in
           // Utilities.hideIndicatorView()
            print(response.result)
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                    sessionExpiredAction(message: "Session expired. Please login again.")
                    completionHandler(nil, 0.0)
                    return
                }
                sessionExpiredAction(message: message)
            default:
                
                
                switch response.result {
                    
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil,0.0)
                        return
                    }
                    completionHandler(reponseDict,1.0)
                case .failure(let error):
                    handleError(error: error)
                    print(error)
                }
            }
        }
    }
    
    
    
    class func multiPartRequestForDocs(request: UploadDocsAPIConfiguration, completionHandler : @escaping(_ result: NSDictionary?) -> Void) {
        
        Utilities.showIndicatorView()
        
        var parameters = request.parameters
        if languageBool {
            parameters["language"] = "ar"
        } else {
            parameters["language"] = "en"
        }
        parameters["timezone"] = TimeZone.current.identifier
        
        AF.upload(multipartFormData: { multipartFormData in
            for (imageKey, images) in request.images {
                for image in images {
                    if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                        let type = imageData.mimeType
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(imageData, withName: imageKey, fileName: "image\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (documentKey, documents) in request.documents {
                for document in documents {
                    if let document = document {
                        let type = document.mimeType
                        let data = document
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(data, withName: documentKey, fileName: "document\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (key, value) in parameters {
                multipartFormData.append(value .data(using: .utf8)!, withName: key)
            }
        },
                  to: request.url,
                  method: request.method,
                  headers: request.headers).uploadProgress(closure: { progress in
            print(progress.fractionCompleted)
        }).responseJSON { response in
            Utilities.hideIndicatorView()
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                    sessionExpiredAction(message: "Session expired. Please login again.")
                    completionHandler(nil)
                    return
                }
                sessionExpiredAction(message: message)
            default:
                switch response.result {
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(reponseDict)
                case .failure(let error):
                    handleError(error: error)
                }
            }
        }
    }
    
    class func multiPartRequestForDocsV2(request: UploadDocsAPIConfiguration, completionHandler : @escaping(_ result: NSDictionary?) -> Void) {
        
        Utilities.showIndicatorView()
        
        var parameters = request.parameters
        if languageBool {
            parameters["language"] = "ar"
        } else {
            parameters["language"] = "en"
        }
        parameters["timezone"] = TimeZone.current.identifier
        
        AF.upload(multipartFormData: { multipartFormData in
            for (imageKey, images) in request.images {
                for image in images {
                    if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                        let type = imageData.mimeType
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(imageData, withName: imageKey, fileName: "image\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (documentKey, documents) in request.documents {
                for document in documents {
                    if let document = document {
                        let type = document.mimeType
                        let data = document
                        let randomNumber = Utilities.randomInt(min: 0, max: 1000)
                        multipartFormData.append(data, withName: documentKey, fileName: "document\(randomNumber)\(Utilities.getTheExtension(mimeType: type))", mimeType: type)
                    }
                }
            }
            
            for (key, value) in parameters {
                multipartFormData.append(value .data(using: .utf8)!, withName: key)
            }
        },
                  to: request.urlv2,
                  method: request.method,
                  headers: request.headers).uploadProgress(closure: { progress in
            print(progress.fractionCompleted)
        }).responseJSON { response in
            Utilities.hideIndicatorView()
            
            switch response.response?.statusCode {
            case 401:
                guard let reponseDict = response.value as? NSDictionary, let message = reponseDict["message"] as? String else {
                    sessionExpiredAction(message: "Session expired. Please login again.")
                    completionHandler(nil)
                    return
                }
                sessionExpiredAction(message: message)
            default:
                switch response.result {
                case .success:
                    guard let reponseDict = response.value as? NSDictionary else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(reponseDict)
                case .failure(let error):
                    handleError(error: error)
                }
            }
        }
    }
}

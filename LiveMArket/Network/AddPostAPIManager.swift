//
//  AddPostAPIManager.swift
//  LiveMArket
//
//  Created by Greeniitc on 19/05/23.
//

import Foundation
import Alamofire

class AddPostAPIManager {
    
    /// Create service
    struct addPostConfig: AddPostUploadAPIConfiguration {
        var uploadImages: [BBMedia]
        var documents: [String : [UploadMedia?]]
        var images: [String : [UIImage?]]
        var firstImages: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add_post"
    }
    class func addPostImageApi(image: [UIImage],firstImage:[UIImage], parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse) -> Void) {
        var config = addPostConfig(
            uploadImages: [], documents: [:], images: ["extra_files[]": image], firstImages: ["file" : firstImage]
        )
        config.parameters = parameters
        APIClient.multiPartAddPostRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Create service
    struct addPostVideoConfig: AddPostVideoUploadAPIConfiguration {
        var uploadImages: [BBMedia]
        var documents: [String : [UploadMedia?]]
        var images: [String : [URL?]]
        var firstImages: [String : [URL?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add_post"
    }
    
    class func addPostVideoApi(video: [URL],firstVideo:[URL], parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse) -> Void) {
        var config = addPostVideoConfig(
            uploadImages: [], documents: [:], images: ["extra_files[]": video], firstImages: ["file" : firstVideo]
        )
        config.parameters = parameters
        APIClient.multiPartAddVideoPostRequest(request: config) { result,progress   in
            
            print("&&&&&&&&&&&\(progress ?? 0.0)")
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
   
    
    /// Rate Store
    struct addPostLiveVideoConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add_post"
    }
    
    public class func addPostLiveVideoApi(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = addPostLiveVideoConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    struct reportPostConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/report_post"
    }
    
    public class func reportPostAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = reportPostConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    /// Rate Store
    struct hashTagConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/check_hash_tag"
    }
    
    public class func checkHashTagApi(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = hashTagConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
}

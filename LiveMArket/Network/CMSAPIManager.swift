//
//  CMSAPIManager.swift
//  LiveMArket
//
//  Created by Albin Jose on 13/07/23.
//

import Foundation
import Alamofire

class CMSAPIManager {
   //// cms pages
    //// Follow and un follow
    struct CMSConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_page"
    }
    
    public class func getCMSPageAPI(parameters: [String: String], completionHandler : @escaping(_ result: CMS_Base) -> Void) {
        var config = CMSConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(CMS_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// cms pages
     //// Follow and un follow
     struct CheckUserProductConfig: APIConfiguration {
         var parameters: [String : String] = [:]
         var method: HTTPMethod = .post
         var path = "/check_user_product_exist"
     }
     
     public class func checkUserProductExistAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
         var config = CheckUserProductConfig()
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
    
    struct HelpCenterConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/submit-contact-query"
    }
    
    public class func helpCenterAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = HelpCenterConfig()
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

//
//  AuthenticationAPIManager.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation
import Alamofire

class ServiceAPIManager {
    
    /// Create service
    struct addServiceConfig: UploadAPIConfiguration {
        var uploadImages: [BBMedia]
        var documents: [String : [UploadMedia?]]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "place_service_request"
        var path = "place_service_request_o_tab"
    }
    class func addServiceApi(image: [UIImage], audioData: Data?, parameters: [String: String], completionHandler: @escaping(_ result: Services_Base) -> Void) {
        
        var config = addServiceConfig(
            uploadImages: [], documents: [:], images: ["image[]": image]
        )

        if audioData != nil {
            let uploadMedia = UploadMedia(data: audioData, mimeType: "audio/aac")
            config.documents = ["voice_message":[uploadMedia]]
        }
        
        config.parameters = parameters
        APIClient.multiPartRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Services_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    //// Request  Service
    struct requestServiceConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "my_service_details"
    }
    
    public class func requestServiceAPI(parameters: [String: String], completionHandler : @escaping(_ result: Services_Base) -> Void) {
        var config = requestServiceConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Services_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// accept_quote
    struct accept_quoteConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "accept_quote"
    }
    
    public class func accept_quoteAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = accept_quoteConfig()
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
    
    //// reject_quote
    struct reject_quoteConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reject_quote"
    }
    
    public class func reject_quoteAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = reject_quoteConfig()
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
    
    //// work_completed
    struct work_completedConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "work_completed"
    }
    
    public class func work_completedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = work_completedConfig()
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
    
    //// work_finished
    struct work_finishedConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "work_finished"
    }
    
    public class func work_finishedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = work_finishedConfig()
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
    
    //// payment Init
    struct  payment_initConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "init_service_strip_payment"
        var path = "payment_init_service_request_o_tab"
    }
    
    public class func payment_initAPI(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = payment_initConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(TappPeymentRespoSE.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    //// complete payment
    struct  completeConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "complete_service_payment"
    }
    
    public class func completeAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = completeConfig()
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
    
    
    ////my_service
    struct  my_serviceConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "my_service_requests"
    }
    
    public class func my_ServiceAPI(parameters: [String: String], completionHandler : @escaping(_ result: MyServicesOrders_Base) -> Void) {
        var config = my_serviceConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyServicesOrders_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ////provider_service
    struct  provider_serviceConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "provider_service_requests"
    }
    
    public class func provider_serviceAPI(parameters: [String: String], completionHandler : @escaping(_ result: MyServicesOrders_Base) -> Void) {
        var config = provider_serviceConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyServicesOrders_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// reject_Provider side
    struct reject_ProvidorConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reject_service_request"
    }
    
    public class func reject_ProviderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = reject_ProvidorConfig()
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
    
    //// Accept_Provider side
    struct Accept_ProvidorConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "accept_service_request"
    }
    
    public class func Accept_ProviderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = Accept_ProvidorConfig()
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
    
    //// Request  Service
    struct providerServiceConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "provider_service_details"
    }
    
    public class func providerServiceAPI(parameters: [String: String], completionHandler : @escaping(_ result: Services_Base) -> Void) {
        var config = providerServiceConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Services_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// ontheWay_Provider side
    struct ontheWay_ProvidorConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "on_the_way_to_site"
    }
    
    public class func onTheWay_ProviderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = ontheWay_ProvidorConfig()
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
    
    //// Reached_Provider side
    struct reached_ProvidorConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "work_started"
    }
    
    public class func reached_ProviderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = reached_ProvidorConfig()
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
    //// completed_Provider side
    struct  completed_ProvidorConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "work_completed"
    }
    
    public class func completed_ProviderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = completed_ProvidorConfig()
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

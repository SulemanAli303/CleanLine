//
//  LivePostAPIManager.swift
//  LiveMArket
//
//  Created by Ramamoorthy on 09/06/23.
//

import Foundation
import Alamofire

class DelegateServiceAPIManager {
    
    //// Get services list
    struct GetServicesListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "get_deligate_services"
    }
    
    public class func getServicesListAPI(parameters: [String: String], completionHandler : @escaping(_ result: DelegateServices_base) -> Void) {
        var config = GetServicesListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(DelegateServices_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Get vehicle list
    struct GetServicesVehicleConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "get_vehicle_type"
    }
    
    public class func getServicesVehicleAPI(parameters: [String: String], completionHandler : @escaping(_ result: Vehicle_base) -> Void) {
        var config = GetServicesVehicleConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Vehicle_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Create delegate request
    struct addDelegateConfig: UploadAPIConfiguration {
        var uploadImages: [BBMedia]
        var documents: [String : [UploadMedia?]]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "place_deligate_service_request"
    }
    class func addDelegateApi(image: [UIImage], parameters: [String: String], completionHandler: @escaping(_ result: Services_Base) -> Void) {
        var config = addDelegateConfig(
            uploadImages: [], documents: [:], images: ["files[]": image]
        )
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
     /// Create delegate request
    struct addDelegateTabPayConfig: UploadAPIConfiguration {
        var uploadImages: [BBMedia]
        var documents: [String : [UploadMedia?]]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "deligate_payment_init"
    }
    class func addDelegateTabPayApi(image: [UIImage], parameters: [String: String], completionHandler: @escaping(_ result: Services_Base) -> Void) {
        var config = addDelegateConfig(
            uploadImages: [], documents: [:], images: ["files[]": image]
        )
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
    
    //// Get my request details
    struct GetMyReqDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "get_user_deligate_service_request_details"
    }
    
    public class func getMyRequestDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: DelegateDetailsServices_Base) -> Void) {
        var config = GetMyReqDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(DelegateDetailsServices_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// complete payment services
    struct  completeServicesDelegateConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "deligate_service_complete_payment"
    }
    
    public class func completeServicesPaymentAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = completeServicesDelegateConfig()
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
    
    //// payment Init services delegate
    struct  payment_initServicesConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "deligate_service_init_strip_payment"
    }
    
    public class func payment_initServicesAPI(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = payment_initServicesConfig()
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
    
    /// Rate Services
    struct rateDelegateConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "rate_deligate_order"
    }
    
    public class func rateDelegateAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = rateDelegateConfig()
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
    
    //// Get user Request List
    struct userRequestListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "get_user_deligate_service_requests"
    }
    
    public class func getUserRequestListAPI(parameters: [String: String], completionHandler : @escaping(_ result: UserRequestDelegates_basic) -> Void) {
        var config = userRequestListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(UserRequestDelegates_basic.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Get user Request List
    struct DriverAcceptDelegateConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "driver_accept_deligate_service_request"
    }
    
    public class func driverAcceptServiceAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = DriverAcceptDelegateConfig()
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
    
    //// Get Driver Request Details
    struct GetDriverReqDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "get_driver_deligate_service_request_details"
    }
    
    public class func getDriverRequestDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: DelegateDetailsServices_Base) -> Void) {
        var config = GetDriverReqDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(DelegateDetailsServices_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    //// Accept_Provider side
    struct AddBillConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "driver_add_bill_details"
    }
    
    public class func addBillAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = AddBillConfig()
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
    struct onTheWayConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "deligate_driver_ontheway"
    }
    
    public class func onTheWayAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = onTheWayConfig()
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
    
    //// Driver otp
    struct DriverOTPConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "driver_deliver_the_request"
    }
    
    public class func DriverOTPAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = DriverOTPConfig()
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

//
//  GymAPIManager.swift
//  LiveMArket
//
//  Created by Greeniitc on 15/05/23.
//

import Foundation
import Alamofire

class GymAPIManager {
    
    /// Gym package Details
    struct GymPackagesConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_gym_packages"
    }
    
    public class func gymPackagesAPI(parameters: [String: String], completionHandler : @escaping(_ result: GymPackage_Base) -> Void) {
        var config = GymPackagesConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GymPackage_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Paymennt init
    struct PaymentInitConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "/init_gym_strip_payment"
        var path = "/init_gym_strip_payment_o_tab"
    }
    
    public class func paymentInitAPI(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = PaymentInitConfig()
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
    
    /// place gym subscription
    struct PlaceSubscriptionConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/place_gym_subscription"
    }
    
    public class func placegySubscriptionAPI(parameters: [String: String], completionHandler : @escaping(_ result: PlaceGymSubscription_Base) -> Void) {
        var config = PlaceSubscriptionConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(PlaceGymSubscription_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// My subscription
    struct MySubscriptionConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_subscriptions"
    }
    
    public class func mySubscriptionAPI(parameters: [String: String], completionHandler : @escaping(_ result: Subscription_Base) -> Void) {
        var config = MySubscriptionConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Subscription_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// My Received subscription
    struct MyReceivedSubscriptionConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_received_subscriptions"
    }
    
    public class func myReceivedSubscriptionAPI(parameters: [String: String], completionHandler : @escaping(_ result: Subscription_Base) -> Void) {
        var config = MyReceivedSubscriptionConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Subscription_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// My subscription details
    struct MySubscriptionDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_subscription_details"
    }
    
    public class func mySubscriptionDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: SubscriptionDetails_Base) -> Void) {
        var config = MySubscriptionDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SubscriptionDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// My subscription details
    struct MyReceivedSubscriptionDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_received_subscription_details"
    }
    
    public class func myReceivedSubscriptionDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: SubscriptionDetails_Base) -> Void) {
        var config = MyReceivedSubscriptionDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(SubscriptionDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// My subscription details
    struct AcceptGymSubscriptionConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/accept_gym_subscription"
    }
    
    public class func acceptSubscriptionAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = AcceptGymSubscriptionConfig()
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
    
    /// My subscription details
    struct rejectGymSubscriptionConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/reject_subscription_request"
    }
    
    public class func rejectGymSubscriptionAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = rejectGymSubscriptionConfig()
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
    
    /// Gym details
    struct gymDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/gym_details"
    }
    
    public class func gymDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: GymDetails_Base) -> Void) {
        var config = gymDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GymDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    struct GymPackageDetailConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_gym_package_details"
    }
    
    public class func gymPackageDetailAPI(parameters: [String: String], completionHandler : @escaping(_ result: GymPackageDetailBase) -> Void) {
        var config = GymPackageDetailConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GymPackageDetailBase.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
}

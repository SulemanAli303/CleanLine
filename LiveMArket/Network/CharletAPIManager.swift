//
//  AuthenticationAPIManager.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation
import Alamofire

class CharletAPIManager {
    //// Get Charlet List
    struct CharletListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/products/chalets"
    }
    
    public class func getCharletListAPI(parameters: [String: String], completionHandler : @escaping(_ result: ProductChalets_Base) -> Void) {
        var config = CharletListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ProductChalets_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    //// Get Charlet List Product Details
    struct CharletListProductConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/products/chalets/show"
    }
    
    public class func getCharletListProductAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsDetail_Base) -> Void) {
        var config = CharletListProductConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsDetail_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    //// set Like/Unlike Charlet list product
    struct CharletListProductLikeConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/product_like_dislike"
    }
    
    public class func charletListProductLikeAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = CharletListProductLikeConfig()
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
    
    //// add Promo
    struct CharletPromoConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/bookings/chalets/promo_code"
    }
    
    public class func charletPromoAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsPromo_Base) -> Void) {
        var config = CharletPromoConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsPromo_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Charlet CheckOut
    struct CharletCheckOUtConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/bookings/chalets/checkout"
    }
    
    public class func charletCheckoutAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsCheckOUt_Base) -> Void) {
        var config = CharletCheckOUtConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsCheckOUt_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Charlet Create Bookin
    struct CharletCreateBookingConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "reservation/bookings/chalets/store"
        var path = "reservation/bookings/chalets/chalets_store_o_tab"
    }
    
    public class func charletCreateBookingAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsCreateBooking_Base) -> Void) {
        var config = CharletCreateBookingConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsCreateBooking_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Charlet Booking List
    struct CharletBookingListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/chalets/bookings"
    }
    
    public class func charletBookingListAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsBookingList_Base) -> Void) {
        var config = CharletBookingListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsBookingList_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Charlet Booking details
    struct CharletBookingDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/bookings/chalets/show"
    }
    
    public class func charletuserBookingDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsBookingDetails_Base) -> Void) {
        var config = CharletBookingDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsBookingDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Charlet Booking Pay
    struct CharletBookingPayConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/booking/chalets/payment"
    }
    
    public class func charletBookingPayAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletPayment_Base) -> Void) {
        var config = CharletBookingPayConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletPayment_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Charlet setOTP
    struct CharletBookingSetOTPConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/bookings/chalets/verification_code"
    }
    
    public class func charletBookingPaySetOTPAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = CharletBookingSetOTPConfig()
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
    
    //// Charlet setOTP
    struct CharletBookingCompllete: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/booking/complete_chalet_payment"
    }
    
    public class func charletBookingCompleteAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = CharletBookingCompllete()
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
    
    
    //// Charlet managment Booking List
    struct CharletManagmentBookingListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/management/chalets/bookings"
    }
    
    public class func charletManagmentBookingListAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsBookingList_Base) -> Void) {
        var config = CharletManagmentBookingListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsBookingList_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Charlet managment accept/Reject
    struct CharletManagmentBookingYesNOConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/management/chalets/booking_response"
    }
    
    public class func charletManagmentBookingYesNOAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = CharletManagmentBookingYesNOConfig()
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
    
    //// Charlet managment Booking details
    struct CharletManagementBookingDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/management/chalets/booking_show"
    }
    
    public class func charletManagementBookingDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsBookingDetails_Base) -> Void) {
        var config = CharletManagementBookingDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsBookingDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Charlet managment setOTP
    struct CharletManagmentBookingSetOTPConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/management/chalets/verification_code"
    }
    
    public class func charletManagementBookingPaySetOTPAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = CharletManagmentBookingSetOTPConfig()
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
    
    //// Get Charlet managment Products
    struct CharletManagmentListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/management/chalets"
    }
    
    public class func getCharletManagementListAPI(parameters: [String: String], completionHandler : @escaping(_ result: ProductChalets_Base) -> Void) {
        var config = CharletManagmentListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ProductChalets_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Get Charlet managment Products details
    struct CharletManagmentListProductConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/management/chalets/show"
    }
    
    public class func getCharletManagementListProductAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsManagmentProductDetails) -> Void) {
        var config = CharletManagmentListProductConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsManagmentProductDetails.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Chalet Avaliblity
    struct CharletAvaliablitlyConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/chalets/checkAvailability"
    }
    
    public class func getCharletAvaliabliltyAPI(parameters: [String: String], completionHandler : @escaping(_ result: ChaletsAvaliablity_basic) -> Void) {
        var config = CharletAvaliablitlyConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ChaletsAvaliablity_basic.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    //// Chalet Review
    struct CharletReviewConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "reservation/booking/chalets/add_reviews"
    }
    
    public class func setChaletReviewAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = CharletReviewConfig()
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

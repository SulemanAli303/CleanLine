//
//  AuthenticationAPIManager.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation
import Alamofire

class StoreAPIManager {
    
    //// Follow and un follow
    struct followAndUnfollowConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/follow_unfollow_user"
    }
    
    public class func followAndUnfollowAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = followAndUnfollowConfig()
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
    
    /// Mute all driver orders
    struct MuteAllOrdersConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/driver_mute_all_order"
    }
    
    public class func driverAllOrdersMuteAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = MuteAllOrdersConfig()
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
    
    /// Driver Profile
    struct UserProfileConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_profile"
    }
    
    public class func userProfileAPI(parameters: [String: String], completionHandler : @escaping(_ result: Profile_Base) -> Void) {
        var config = UserProfileConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Profile_Base.self, from: json)
                switch response.status {
                case "1":
                    guard var dict = result?["oData"] as? [String:Any] else { return }
                    guard var dict2 = dict["data"] as? [String:Any] else { return }
                    dict2["access_token"] = SessionManager.getAccessToken() ?? ""
                    SessionManager.setUserData(dictionary: dict2)
                    UserDefaults.standard.set(nil, forKey: "googleImage")
                default:
                    break
                }
                
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Hide and UnHide
    struct profileHideUnhideConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hide_un_hide_profile"
    }
    
    public class func profileHideAndUnhideAPI(parameters: [String: String], completionHandler : @escaping(_ result: Profile_Base) -> Void) {
        var config = profileHideUnhideConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Profile_Base.self, from: json)
                switch response.status {
                case "1":
                    guard var dict = result?["oData"] as? [String:Any] else { return }
                    guard var dict2 = dict["data"] as? [String:Any] else { return }
                    dict2["access_token"] = SessionManager.getAccessToken() ?? ""
                    SessionManager.setUserData(dictionary: dict2)
                    UserDefaults.standard.set(nil, forKey: "googleImage")
                default:
                    break
                }
                
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// My Reviews
    struct MyReviewConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_reviews"
    }
    
    public class func myReviewAPI(parameters: [String: String], completionHandler : @escaping(_ result: DriverReview_Base) -> Void) {
        var config = MyReviewConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(DriverReview_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    struct CommonReviewConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/all_reviews_list"
    }
    
    public class func commonReviewAPI(parameters: [String: String], completionHandler : @escaping(_ result: AllReviewModel) -> Void) {
        var config = CommonReviewConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(AllReviewModel.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Driver Profile
    struct DriverProfileConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/driver_profile"
    }
    
    public class func driverProfileAPI(parameters: [String: String], completionHandler : @escaping(_ result: Profile_Base) -> Void) {
        var config = DriverProfileConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Profile_Base.self, from: json)
                switch response.status {
                case "1":
                    guard var dict = result?["oData"] as? [String:Any] else { return }
                    guard var dict2 = dict["data"] as? [String:Any] else { return }
                    dict2["access_token"] = SessionManager.getAccessToken() ?? ""
                    SessionManager.setUserData(dictionary: dict2)
                    UserDefaults.standard.set(nil, forKey: "googleImage")
                default:
                    break
                }
                
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Driver Profile
    struct SwitchDriverProfileConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/switch_user"
    }
    
    public class func driverSwitchProfileAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = SwitchDriverProfileConfig()
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
    
    /// paymentWithCompleteAPI
    struct paymentWithCompleteConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/init_strip_payment"
    }
    
    public class func paymentWithCompleteAPI(parameters: [String: String], completionHandler : @escaping(_ result: Payment_Base) -> Void) {
        var config = paymentWithCompleteConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Payment_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Ground paymentWithCompleteAPI
    struct groundPaymentWithInitConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/init_payment"
    }
    
    public class func groundPaymentWithInitAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundPaymentInit_base) -> Void) {
        var config = groundPaymentWithInitConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundPaymentInit_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    /// Ground paymentWithCompleteAPI
    struct groundPaymentWithCompleteConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/booking_complete_payment"
    }
    
    public class func groundPaymentWithCompleteAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundPaymentComplete_base) -> Void) {
        var config = groundPaymentWithCompleteConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundPaymentComplete_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    ///Payment Completed
    struct paymentConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/complete_payment"
    }
    
    public class func paymentCompletedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = paymentConfig()
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
    
    ///Payment Completed
    struct paymentFoodConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/payment_response"
    }
    
    public class func foodPaymentCompletedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = paymentFoodConfig()
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
    
    ///Driver Order Accepted
    struct driverAcceptedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/driver_accept_order"
    }
    
    public class func driverAcceptedOrderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = driverAcceptedOrderConfig()
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
    
    ///Driver Order Collected
    struct driverCollectedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/driver_collect_order"
    }
    
    public class func driverCollectedOrderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = driverCollectedOrderConfig()
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
    
    ///Driver Order Delivered
    struct driverDeliveredOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/driver_deliver_order"
    }
    
    public class func driverDeliveredOrderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = driverDeliveredOrderConfig()
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
    
    ///Order Accepted
    struct acceptedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/accept_order"
    }
    
    public class func ordersAcceptedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = acceptedOrderConfig()
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
    
    ///readyForDelivery
    struct readyForDeliveryOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ready_for_delivery"
    }
    
    public class func ordersDreadyForDeliveryAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = readyForDeliveryOrderConfig()
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
    
    ///Seller deliverd order
    struct storeDeliveryOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/store_deliver_order"
    }
    
    public class func storeOrderDeliveryAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = storeDeliveryOrderConfig()
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
    
    
    
    ///Order Rejected
    struct rejectedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/reject_order"
    }
    
    public class func ordersRejectedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = rejectedOrderConfig()
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
    
    ///Order Cancel
    struct canceledOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/cancel_order"
    }
    
    public class func ordersCanceledAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = canceledOrderConfig()
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
    
    ///my_received_orders
    struct myReceivedOrdersConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_received_orders"
    }
    
    public class func myReceivedOrdersAPI(parameters: [String: String], completionHandler : @escaping(_ result: MyReceiveOrders_Base) -> Void) {
        var config = myReceivedOrdersConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyReceiveOrders_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Driver_received_orders
    struct driverReceivedOrdersConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/driver_orders_v2"
    }
    
    public class func driverReceivedOrdersAPI(parameters: [String: String], completionHandler : @escaping(_ result: MyOrders_Base) -> Void) {
        var config = driverReceivedOrdersConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyOrders_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Driver_delegate_service_requests
    struct driverDelegateServiceRequestsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_driver_deligate_service_requests"
    }
    
    public class func driverDelegateServiceRequests(parameters: [String: String], completionHandler : @escaping(_ result: DriverDelegateServiceRequest_Base) -> Void) {
        var config = driverDelegateServiceRequestsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(DriverDelegateServiceRequest_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Cancel Orders
    struct cancelOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/Cancel_Order"
    }
    
    public class func cancelOrderAPI(parameters: [String: String], completionHandler : @escaping(_ result: CancelOrder_Base) -> Void) {
        var config = cancelOrderConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(CancelOrder_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
        ///My Orders Details List
        struct myOrdersDetailsConfig: APIConfiguration {
            var parameters: [String : String] = [:]
            var method: HTTPMethod = .post
            var path = "/my_order_details"
        }
        
        public class func myOrdersDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: MyOrderDetails_Base) -> Void) {
            var config = myOrdersDetailsConfig()
            config.parameters = parameters
            APIClient.apiRequest(request: config) { (result) in
                do {
                    let json = try JSONSerialization.data(withJSONObject: result as Any)
                    let response = try JSONDecoder().decode(MyOrderDetails_Base.self, from: json)
                    completionHandler(response)
                } catch let err {
                    print(err)
                }
            }
        }
    
    ///My Booking Details List
    struct myBookingDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/booking_detail"
    }
    
    public class func myBookingDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundBookingDetails_Base) -> Void) {
        var config = myBookingDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundBookingDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///My Receive Booking Details List
    struct myReceiveBookingDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/seller/booking_detail"
    }
    
    public class func myReceiveBookingDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundBookingDetails_Base) -> Void) {
        var config = myReceiveBookingDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundBookingDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }

    
    ///My Received Orders Details List
    struct receivedOrdersDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/received_order_details"
    }
    
    public class func receivedOrdersDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: MyOrderDetails_Base) -> Void) {
        var config = receivedOrdersDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyOrderDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Driver Orders Details List
    struct driverOrdersDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/driver_order_details"
    }
    
    public class func driverOrdersDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: DriverOrderDetails_Base) -> Void) {
        var config = driverOrdersDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(DriverOrderDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    ///Driver FoodvOrders Details List
    struct driverFoodOrdersDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/driver_order_details"
    }
    
    public class func driverFoodOrdersDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: DriverOrderDetails_Base) -> Void) {
        var config = driverFoodOrdersDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(DriverOrderDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Nerw Orders List
    struct myOrdersConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_orders"
    }
    
    public class func myOrdersListAPI(parameters: [String: String], completionHandler : @escaping(_ result: MyOrders_Base) -> Void) {
        var config = myOrdersConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyOrders_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Nerw Orders List
    struct myPGBookingsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/bookings"
    }
    
    public class func myPGBookingListAPI(parameters: [String: String], completionHandler : @escaping(_ result: PGBooking_Base) -> Void) {
        var config = myPGBookingsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(PGBooking_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Accept Booking
    struct myPGBookingsAcceptConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/accept_booking"
    }
    
    public class func myPGBookingAcceptAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = myPGBookingsAcceptConfig()
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
    
    ///Reject Booking
    struct myPGBookingsRejectConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/reject_booking"
    }
    
    public class func myPGBookingRejectAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = myPGBookingsRejectConfig()
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
    
    ///Cancel Booking
    struct myPGBookingsCancelConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/cancel_booking"
    }
    
    public class func myPGBookingCancelAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = myPGBookingsCancelConfig()
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
    
    ///Verification code submit Booking
    struct myPGBookingsVerificationCodeSumbitConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/booking_verification_code"
    }
    
    public class func myPGBookingVerificationCodeSubmitAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = myPGBookingsVerificationCodeSumbitConfig()
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
    
    
    ///Nerw Orders List
    struct myPGSellerBookingsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/seller/bookings"
    }
    
    public class func myPGSellerBookingListAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundReceivedBooking_Base) -> Void) {
        var config = myPGSellerBookingsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundReceivedBooking_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Products details
    struct productDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/product_details"
    }
    
    public class func shopProductDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: ProductDetails_Base) -> Void) {
        var config = productDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ProductDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// add Address
    struct storeDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/store_details"
    }
    
    public class func storeDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: Store_Base) -> Void) {
        var config = storeDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Store_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    struct storeDetailsBillingConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_service_payment_data"
    }
    
    public class func storeDetailsBillingAPI(parameters: [String: String], completionHandler : @escaping(_ result: Store_Base_Payment) -> Void) {
        var config = storeDetailsBillingConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Store_Base_Payment.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// add Address
    struct playGroundListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/get_ground_list"
    }
    
    public class func playGroundListAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundListModel) -> Void) {
        var config = playGroundListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundListModel.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// add Address
    struct playGroundDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/get_ground_details"
    }
    
    public class func playGroundDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundDetails_Base) -> Void) {
        var config = playGroundDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// add Address
    struct playGroundCheckOutConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/checkout"
    }
    
    public class func playGroundCheckOutAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundCheckOut_Base) -> Void) {
        var config = playGroundCheckOutConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundCheckOut_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Place Order
    struct playGroundPlaceOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "/ground/place_order"
        var path = "/ground/place_order_o_tab"
    }
    
    public class func playGroundPlaceOrderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundPlaceOrder_Base) -> Void) {
        var config = playGroundPlaceOrderConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundPlaceOrder_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    //// add Address
    struct playGroundSaveBookingConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/save_booking_dates"
    }
    
    public class func playGroundSaveBookingAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = playGroundSaveBookingConfig()
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
    
    
    //// add Address
    struct bookindDatesDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/get_booking_dates"
    }
    
    public class func bookindDatesDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundBookingDate_Base) -> Void) {
        var config = bookindDatesDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundBookingDate_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    //// Remove post
    struct removePostConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/remove_post"
    }
    
    public class func removePostAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = removePostConfig()
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
    
    //// Set default post
    struct setDefaultPostConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/make_default_post"
    }
    
    public class func setDefaultPostAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = setDefaultPostConfig()
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
    
    //// Product List
    struct ProductListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/products"
    }
    
    public class func productListAPI(parameters: [String: String], completionHandler : @escaping(_ result: Product_Base) -> Void) {
        var config = ProductListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Product_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Product Details
    struct ProductDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/products"
    }
    
    public class func productDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: Product_Base) -> Void) {
        var config = ProductDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Product_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Add TO Cart
    struct addTOCartConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add_to_cart"
    }
    
    public class func addTOCartAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = addTOCartConfig()
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
    
    //// Get Cart
    struct getCartConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_cart"
    }
    
    public class func getCartAPI(parameters: [String: String], completionHandler : @escaping(_ result: Cart_Base) -> Void) {
        var config = getCartConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Cart_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Clear Cart
    struct clearCartConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/clear_cart"
    }
    
    public class func clearCartAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = clearCartConfig()
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
    
    //// Clear Cart
    struct clearCartFoodConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/empty_cart"
    }
    
    public class func clearCartFoodAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = clearCartFoodConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                UserDefaults.standard.removeObject(forKey: "add_ons")
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Reduce Cart
    struct reduceCartConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/reduce_cart"
    }
    
    public class func reduceCartAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = reduceCartConfig()
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
    //// Check Out
    struct checkOutConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/checkout"
    }
    
    public class func checkOutAPI(parameters: [String: String], completionHandler : @escaping(_ result: CheckOut_Base) -> Void) {
        var config = checkOutConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(CheckOut_Base.self, from: json)
                print("JSON RESPONSE FOR CART ITEM \(json)")
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// get_deligates
    struct deligatesConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_deligates"
    }
    
    public class func deligatesAPI(parameters: [String: String], completionHandler : @escaping(_ result: Delegate_Base) -> Void) {
        var config = deligatesConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Delegate_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// payment init
    struct paymentInitConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/payment_init"
    } 
    
    public class func paymentInitAPI(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = paymentInitConfig()
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
    
    struct paymentInitConfigForService: UploadAPIConfiguration {
        var uploadImages: [BBMedia]
        var documents: [String : [UploadMedia?]]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "/service_request_payment_init"
        var path = "/payment_init_service_request_o_tab"
    }
    
    public class func paymentInitAPIForServiceBooking(image: [UIImage], audioData: Data?,parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = paymentInitConfigForService(
            uploadImages: [], documents: [:], images: ["image[]": image]
        )

        if audioData != nil {
            let uploadMedia = UploadMedia(data: audioData, mimeType: "audio/aac")
            config.documents = ["voice_message":[uploadMedia]]
        }
        
        config.parameters = parameters
        APIClient.multiPartRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(TappPeymentRespoSE.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    
    
    struct paymentInitConfigHotel: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "/room/payment_init_hotel"
        var path = "/room/payment_init_hotel_o_tab"
    }
    
    public class func paymentInitAPIForRooms(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = paymentInitConfigHotel()
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
    
    struct paymentInitConfigChalets: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "reservation/bookings/chalets/chalets_payment_init"
        var path = "reservation/bookings/chalets/chalets_payment_init_o_tab"
    }
    
    public class func paymentInitAPIForChalets(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = paymentInitConfigChalets()
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
    
    
    
    struct paymentInitConfigPlayGround: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "/ground/payment_init_ground"
        var path = "/ground/payment_init_ground_o_tab"
    }
    
    public class func paymentInitAPIForPlayground(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = paymentInitConfigPlayGround()
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
    
    //// Place order
    struct PlaceOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/place_order"
    }
    
    public class func placeOrderAPI(parameters: [String: String], completionHandler : @escaping(_ result: PlaceOrder_Base) -> Void) {
        var config = PlaceOrderConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(PlaceOrder_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Product Fav
    struct ProductFavConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/product_like"
    }
    
    public class func productFavAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = ProductFavConfig()
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
    
    //// Store Fav
    struct StoreFavConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/store_like"
    }
    
    public class func storeFavAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = StoreFavConfig()
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
    struct rateStoreConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/rate_store"
    }
    
    public class func rateStoreAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = rateStoreConfig()
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
    
    /// Rate Ground Booking Store
    struct rateGroundStoreConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/ground/add_reviews"
    }
    
    public class func rateGroundStoreAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = rateGroundStoreConfig()
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
    
    /// Rate Driver
    struct rateDriverConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/rate_driver"
    }
    
    public class func rateDriverAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = rateDriverConfig()
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
    
    struct rateGymConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/rate_subscription"
    }
    
    public class func rateGymAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = rateGymConfig()
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
    
    /// Rate Services
    struct rateServicesConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/rate_service"
    }
    
    public class func rateServicesAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = rateServicesConfig()
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
    
    //// Product List
    struct FavProductListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/fav_products"
    }
    
    public class func productFavListAPI(parameters: [String: String], completionHandler : @escaping(_ result: Product_Base) -> Void) {
        var config = FavProductListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Product_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Store Fave List
    struct FavStoreListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/fav_stores"
    }
    
    public class func storeFavListAPI(parameters: [String: String], completionHandler : @escaping(_ result: favouriteStore_base) -> Void) {
        var config = FavStoreListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(favouriteStore_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Follower lists
    struct FollowersConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/others_followers_list"
    }
    
    public class func followersListAPI(parameters: [String: String], completionHandler : @escaping(_ result: FollowModel) -> Void) {
        var config = FollowersConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(FollowModel.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Following lists
    struct FollowingConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/others_following_list"
    }
    
    public class func followingListAPI(parameters: [String: String], completionHandler : @escaping(_ result: FollowModel) -> Void) {
        var config = FollowingConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(FollowModel.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    
    //// Remove Follower
    struct RemoveFollowersConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/remove_follower"
    }
    
    public class func removefollowersListAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = RemoveFollowersConfig()
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
    
    //// Follower lists
    struct AddFollowersConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/follow_unfollow_user"
    }
    
    public class func AddfollowersListAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = AddFollowersConfig()
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
    
    ///Hotel Booking
    ///
    //// Follower lists
    struct RoomListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_room_list"
    }
    
    public class func hotelRoomListAPI(parameters: [String: String], completionHandler : @escaping(_ result: RoomList_Base) -> Void) {
        var config = RoomListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(RoomList_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Follower lists
    struct RoomDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_room_details"
    }
    
    public class func hotelRoomDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: RoomDetails_Base) -> Void) {
        var config = RoomDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(RoomDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Get booking date
    struct bookingDateConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_room_booking_dates"
    }
    
    public class func hotelBookingDateAPI(parameters: [String: String], completionHandler : @escaping(_ result: RoomBookingDates_Base) -> Void) {
        var config = bookingDateConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(RoomBookingDates_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Save booking date
    struct SaveBookingDateConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/save_booking_dates"
    }
    
    public class func saveBookingDateAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = SaveBookingDateConfig()
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
    
    //// Checkout API
    struct CheckOutConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/room/checkout"
    }
    
    public class func roomCheckOutAPI(parameters: [String: String], completionHandler : @escaping(_ result: HotelCheckOut_Base) -> Void) {
        var config = CheckOutConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(HotelCheckOut_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Place order API
    struct RoomPlaceOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "/room/place_order"
        var path = "/room/place_order_o_tab"
    }
    
    public class func roomPlaceOrderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundPlaceOrder_Base) -> Void) {
        var config = RoomPlaceOrderConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundPlaceOrder_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// User booking details API
    struct UserBookingConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/booking_detail"
    }
    
    public class func userBookingDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: HotelBookingDetails_Base) -> Void) {
        var config = UserBookingConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(HotelBookingDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Hotel booking details API
    struct sellerBookingConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/seller/booking_detail"
    }
    
    public class func sellerBookingDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: HotelBookingDetails_Base) -> Void) {
        var config = sellerBookingConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(HotelBookingDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Hotel booking details API
    struct userBookingListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/bookings"
    }
    
    public class func userBookingListAPI(parameters: [String: String], completionHandler : @escaping(_ result: HotelBookingList_Base) -> Void) {
        var config = userBookingListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(HotelBookingList_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Hotel booking details API
    struct sellerBookingListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/seller/bookings"
    }
    
    public class func sellerBookingListAPI(parameters: [String: String], completionHandler : @escaping(_ result: HotelBookingList_Base) -> Void) {
        var config = sellerBookingListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(HotelBookingList_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Hotel booking Accepted API
    struct sellerBookingAcceptConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/accept_booking"
    }
    
    public class func sellerBookingAcceptedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = sellerBookingAcceptConfig()
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
    
    //// Hotel booking Accepted API
    struct sellerBookingRejectConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/reject_booking"
    }
    
    public class func sellerBookingRejectAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = sellerBookingRejectConfig()
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
    
    //// Hotel booking Accepted API
    struct userBookingCancelConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/cancel_booking"
    }
    
    public class func userBookingCancelAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = userBookingCancelConfig()
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
    
    /// Ground paymentWithCompleteAPI
    struct HotelPaymentWithInitConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/init_payment"
    }
    
    public class func hotelPaymentWithInitAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundPaymentInit_base) -> Void) {
        var config = HotelPaymentWithInitConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundPaymentInit_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Ground paymentWithCompleteAPI
    struct HoltelPaymentWithCompleteConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/booking_make_payment"
    }
    
    public class func hotelPaymentWithCompleteAPI(parameters: [String: String], completionHandler : @escaping(_ result: GroundPaymentComplete_base) -> Void) {
        var config = HoltelPaymentWithCompleteConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GroundPaymentComplete_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Verification code submit Booking
    struct hotelVerificationCodeSumbitConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/booking_verification_code"
    }
    
    public class func hotelVerificationCodeSubmitAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = hotelVerificationCodeSumbitConfig()
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
    
    ///Rate Hotel store
    struct hotelRateConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/hotel/add_reviews"
    }
    
    public class func hotelRateAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = hotelRateConfig()
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
    
    /// Account Type
    struct AccountTypeDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/account-types"
    }
    
    public class func accountTypeAPI(parameters: [String: String],id:String, completionHandler : @escaping(_ result: AccountType_Model) -> Void) {
        var config = AccountTypeDetailsConfig()
        config.parameters = parameters
        config.path = "\(config.path)/\(id)"
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(AccountType_Model.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    struct ActivityTypeDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/activity-types"
    }
    
    public class func activityTypeAPI(parameters: [String: String],id:String,individual_id:String, completionHandler : @escaping(_ result: ActivityType_Base) -> Void) {
        var config = ActivityTypeDetailsConfig()
        config.parameters = parameters
        config.path = "\(config.path)/\(id)/\(individual_id)"
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ActivityType_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    struct getFileterDataConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/filter_data"
    }
    
    public class func getFilterDataAPI(parameters: [String: String], completionHandler : @escaping(_ result: FilterData_Base) -> Void) {
        var config = getFileterDataConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(FilterData_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    struct getCityConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_city_list"
    }
    
    public class func getCityDataAPI(parameters: [String: String], completionHandler : @escaping(_ result: City_Base) -> Void) {
        var config = getCityConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(City_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Product List
    struct FavChaletListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/reservation/liked_product"
    }
    
    public class func chaletFavListAPI(parameters: [String: String], completionHandler : @escaping(_ result: FavChaletsBase) -> Void) {
        var config = FavChaletListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(FavChaletsBase.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    //// Product List
    struct GetTimeSlotConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_slots"
    }
    
    public class func getTimeSlotAPI(parameters: [String: String], completionHandler : @escaping(_ result: GetTimeSlot_Base) -> Void) {
        var config = GetTimeSlotConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GetTimeSlot_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Table Booking Details
    struct TableBookingDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_booking_details"
    }
    
    public class func tabelBookingdetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: TableBookDetails_Base) -> Void) {
        var config = TableBookingDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(TableBookDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Table Booking Details
    struct ReceivedTableBookingDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_received_booking_details"
    }
    
    public class func receivedTabelBookingdetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: TableBookDetails_Base) -> Void) {
        var config = ReceivedTableBookingDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(TableBookDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Table Place request
    struct TableBookingPlaceConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/place_booking"
    }
    
    public class func tabelBookingPlaceAPI(parameters: [String: String], completionHandler : @escaping(_ result: TableBookingPlace_Base) -> Void) {
        var config = TableBookingPlaceConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(TableBookingPlace_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///my table Booking List
    struct myBookingConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_bookings"
    }
    
    public class func myTableBookingListAPI(parameters: [String: String], completionHandler : @escaping(_ result: MyTableBookingList_Base) -> Void) {
        var config = myBookingConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyTableBookingList_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///my receved table Booking List
    struct myReceivedBookingConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/my_received_bookings"
    }
    
    public class func myRecevedTableBookingListAPI(parameters: [String: String], completionHandler : @escaping(_ result: MyTableBookingList_Base) -> Void) {
        var config = myReceivedBookingConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(MyTableBookingList_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Table Booking enble and disable
    struct EnableDisableBookingConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/toggle_table_booking_enable"
    }
    
    public class func tableBookingEnableDisbleAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = EnableDisableBookingConfig()
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
    
    ///Order Accepted
    struct TableBookingAcceptedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/accept_table_booking"
    }
    
    public class func tableBookingAcceptedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = TableBookingAcceptedOrderConfig()
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
    ///Order Rejected
    struct TableBookingRejectedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/reject_table_booking"
    }
    
    public class func tableBookingRejectedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = TableBookingRejectedOrderConfig()
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
    
    ///Booking Verified Rejected
    struct TableBookingCompletedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/complete_table_booking"
    }
    
    public class func tableBookingCompletedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = TableBookingCompletedOrderConfig()
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
    
    /// My Reviews
    struct GetPostiongConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_table_positions"
    }
    
    public class func getTblPostionAPI(parameters: [String: String], completionHandler : @escaping(_ result: TablePositionBase) -> Void) {
        var config = GetPostiongConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(TablePositionBase.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Rate Store
    struct ratetableConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add_table_review"
    }
    
    public class func rateTabelBookingAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = ratetableConfig()
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
    
    /// Wallet Earnings
    struct walletEarningConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/wallet_details"
    }
    
    public class func walletEarningAPI(parameters: [String: String], completionHandler : @escaping(_ result: WalletEarnings_Base) -> Void) {
        var config = walletEarningConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(WalletEarnings_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Wallet Withdraw
    struct walletWithdrawConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/withdraw_ernings"
    }
    
    public class func walletWithdrawAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = walletWithdrawConfig()
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


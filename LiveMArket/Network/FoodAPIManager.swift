//
//  FoodAPIManager.swift
//  LiveMArket
//
//  Created by Greeniitc on 05/05/23.
//

import Foundation
import Alamofire

class FoodAPIManager {
    
    /// Food Store Details
    struct StoreDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/get_store_details"
    }
    
    public class func storeDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: Resturant_Base) -> Void) {
        var config = StoreDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Resturant_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Food Store Details
    struct productListConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/get_menus_by_category"
    }
    
    public class func productListAPI(parameters: [String: String], completionHandler : @escaping(_ result: ResturanrProduct_Base) -> Void) {
        var config = productListConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(ResturanrProduct_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Add TO Cart
    struct addToCartConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add_food_to_cart"
    }
    
    public class func addToCartAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = addToCartConfig()
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
    
    //// List cart Items
    struct listCartItemsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/list_food_cart"
    }
    
    public class func listCartItemsAPI(parameters: [String: String], completionHandler : @escaping(_ result: FoodCart_Base) -> Void) {
        var config = listCartItemsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(FoodCart_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Apply coupon
    struct applyCouponConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/apply_food_coupon"
    }
    
    public class func applyCouponItemsAPI(parameters: [String: String], completionHandler : @escaping(_ result: FoodCart_Base) -> Void) {
        var config = applyCouponConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(FoodCart_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// List cart Items
    struct listCartNewItemsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/list_food_cart_device"
    }
    
    public class func listCartNewItemsAPI(parameters: [String: String], completionHandler : @escaping(_ result: FoodCart_Base) -> Void) {
        var config = listCartNewItemsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(FoodCart_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Product Fav
    struct FoodProductConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/product_like_dislike"
    }
    
    public class func productFavouriteAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = FoodProductConfig()
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
    
    //// payment init
    struct OrderRequestConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/order_request"
    }
    
    public class func orderRequestAPI(parameters: [String: String], completionHandler : @escaping(_ result: PaymentInit_Base) -> Void) {
        var config = OrderRequestConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(PaymentInit_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    struct OrderFoodPaymentInitConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/payment_init"
    }
    
    public class func orderFoodPayInit(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = OrderFoodPaymentInitConfig()
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
    
    
    struct OrderTableBookingInitConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
//        var path = "/table_booking_payment_init"
        var path = "/table_booking_payment_init_o_tab"
    }
    
    public class func orderTableBookingPayInit(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = OrderTableBookingInitConfig()
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
    
    //// Reduce Cart
    struct reduceCartConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/reduce_cart"
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
    
    ///Nerw Orders List
    struct myOrdersConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/my_orders"
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
    
    ///my_received_orders
    struct myReceivedOrdersConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/my_orders/seller"
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
    
    ///My Orders Details List
    struct myOrdersDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/order_details"
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
    
    ///My Received Orders Details List
    struct receivedOrdersDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/received_order_details"
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
    
    ///Order Accepted
    struct acceptedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/accept_order"
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
    
    ///Order Rejected
    struct rejectedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/reject_order"
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
        var path = "/food/cancel_order"
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
    ///Order Cancel
    struct prepareOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/preparing_order"
    }
    
    public class func ordersPreparedAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = prepareOrderConfig()
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
        var path = "/food/driver_accept_order"
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
    
    ///Driver Order Delivered
    struct driverDeliveredOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/driver_deliver_order"
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
    
    ///Driver Order Collected
    struct driverCollectedOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/driver_collect_order"
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
    
    ///Driver clear order
    struct driverClearOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/driver_complete_order_request"
    }
    
    public class func driverClearOrderAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = driverClearOrderConfig()
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
    struct foodStoreDeliveryOrderConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/store_deliver_order"
    }
    
    public class func foodStoreOrderDeliveryAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = foodStoreDeliveryOrderConfig()
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
        var path = "/food/rate_store"
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
    
    /// Rate Driver
    struct rateDriverConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/rate_driver"
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
    
    
    /// Food Details
    struct foodDetailsConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/food/get_product_details"
    }
    
    public class func foodDetailsAPI(parameters: [String: String], completionHandler : @escaping(_ result: FoodDetails_Base) -> Void) {
        var config = foodDetailsConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(FoodDetails_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    /// Food Details
    struct foodFavoriteConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "food/fav_list"
    }
    
    public class func foodFavoriteAPI(parameters: [String: String], completionHandler : @escaping(_ result: FoodFav_Base) -> Void) {
        var config = foodFavoriteConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(FoodFav_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
}

//
//  Authentication.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation

struct Store_Base : Codable {
    let status : String?
    let message : String?
    let oData : StoreData?
    
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(StoreData.self, forKey: .oData)
        
    }
}

struct StoreData : Codable {
    let sellerData: SellerData
    let categories: [Category]
    let chat_open: String?
    let chat_message: String?
    
    enum CodingKeys: String, CodingKey {
        case sellerData = "seller_data"
        case categories
        case chat_open = "chat_open"
        case chat_message = "chat_message"
    }
}


struct Store_Base_Payment : Codable {
    let status : String?
    let message : String?
    let oData : StorePaymentData?
    
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(StorePaymentData.self, forKey: .oData)
        
    }
}

struct StorePaymentData : Codable {
    let amount: String?
    let cuurency_code: String?
    let grand_total: String?
    let tax: String?
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case cuurency_code = "cuurency_code"
        case grand_total = "grand_total"
        case tax = "tax"
    }
}


// MARK: - Category
struct Category: Codable {
    let id, name: String
    let image, bannerImage: String
    let active : String
    let parentID: String
    let product_count:String
    
    enum CodingKeys: String, CodingKey {
        case id, name, image
        case bannerImage = "banner_image"
        case parentID = "parent_id"
        case active
        case product_count = "product_count"
        
    }
}

// MARK: - SellerData
struct SellerData: Codable {
    let id : String?
    let user_image : String?
    let name : String?
    let email : String?
    let phone : String?
    let dial_code : String?
    let about_me : String?
    let rating : String?
    let rated_users : String?
    let banner_image : String?
    let user_type_id : String?
    let activity_type_id : String?
    let firebase_user_key : String?
    let user_device_token : String?
    let profile_url : String?
    let user_location : User_location?
    let location_data : Location_data?
    let activity_type : Activity_type?
    let is_liked : String?
    let followers_count : String?
    let following_count : String?
    let post_count : String?
    let isLive : String?
    let is_table_booking_available : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_image = "user_image"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case dial_code = "dial_code"
        case about_me = "about_me"
        case rating = "rating"
        case rated_users = "rated_users"
        case banner_image = "banner_image"
        case user_type_id = "user_type_id"
        case activity_type_id = "activity_type_id"
        case firebase_user_key = "firebase_user_key"
        case user_device_token = "user_device_token"
        case profile_url = "profile_url"
        case user_location = "user_location"
        case location_data = "location_data"
        case activity_type = "activity_type"
        case is_liked = "is_liked"
        case followers_count = "followers_count"
        case following_count = "following_count"
        case post_count = "post_count"
        case isLive = "isLive"
        case is_table_booking_available = "is_table_booking_available"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        about_me = try values.decodeIfPresent(String.self, forKey: .about_me)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        rated_users = try values.decodeIfPresent(String.self, forKey: .rated_users)
        banner_image = try values.decodeIfPresent(String.self, forKey: .banner_image)
        user_type_id = try values.decodeIfPresent(String.self, forKey: .user_type_id)
        activity_type_id = try values.decodeIfPresent(String.self, forKey: .activity_type_id)
        firebase_user_key = try values.decodeIfPresent(String.self, forKey: .firebase_user_key)
        user_device_token = try values.decodeIfPresent(String.self, forKey: .user_device_token)
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
        user_location = try values.decodeIfPresent(User_location.self, forKey: .user_location)
        location_data = try values.decodeIfPresent(Location_data.self, forKey: .location_data)
        activity_type = try values.decodeIfPresent(Activity_type.self, forKey: .activity_type)
        is_liked = try values.decodeIfPresent(String.self, forKey: .is_liked)
        followers_count = try values.decodeIfPresent(String.self, forKey: .followers_count)
        following_count = try values.decodeIfPresent(String.self, forKey: .following_count)
        post_count = try values.decodeIfPresent(String.self, forKey: .post_count)
        isLive = try values.decodeIfPresent(String.self, forKey: .isLive)
        is_table_booking_available = try values.decodeIfPresent(String.self, forKey: .is_table_booking_available)
    }

}

struct activityData : Codable {
    let id : String?
    let name : String?
  
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
      
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
       
    }
}


struct Cart_Base : Codable {
    let status : String?
    let message : String?
    let oData : CartData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(CartData.self, forKey: .oData)
    }
}
// MARK: - Cart Data
struct CartData: Codable {
    let cartItems: [CartItem]
        let cartTotal, cartCount, deliveryCharge, grandTotal: String
        let currencyCode: String

        enum CodingKeys: String, CodingKey {
            case cartItems = "cart_items"
            case cartTotal = "cart_total"
            case cartCount = "cart_count"
            case deliveryCharge = "delivery_charge"
            case grandTotal = "grand_total"
            case currencyCode = "currency_code"
        }
}
// MARK: - CartItem
struct CartItem: Codable {
    let id, productID, productAttributeID, quantity: String
    let userID, storeID, deviceCartID, createdAt: String
    let updatedAt: String
    let name: String
    let manageStock: String
    let stockQuantity: String
    let allowBackOrder, stockStatus, soldIndividually: String
    let shippingClass: String
    let salePrice, regularPrice: String
    let taxable: String
    let image: String
    let shippingNote, title, rating: String?
    let ratedUsers: String
    let imageTemp, barcode, imageAction: String?
    let prCode: String
    let productDesc: String?
    let productFullDescr: String
    let sizeChart: String?
    let productName, productType, categorySelected: String
    let imageList: [String]
    let defaultImage: String
    let subTotal, discountedSubTotal: String
    //let couponDiscountedAmount: Int
    let product_variations : [ProductVariations]?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case productAttributeID = "product_attribute_id"
        case quantity
        case userID = "user_id"
        case storeID = "store_id"
        case deviceCartID = "device_cart_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
       
        case name
        case manageStock = "manage_stock"
        case stockQuantity = "stock_quantity"
        case allowBackOrder = "allow_back_order"
        case stockStatus = "stock_status"
        case soldIndividually = "sold_individually"
        
        case shippingClass = "shipping_class"
        case salePrice = "sale_price"
        case regularPrice = "regular_price"
        case taxable, image
        case shippingNote = "shipping_note"
        case title, rating
        case ratedUsers = "rated_users"
        case imageTemp = "image_temp"
        case barcode
        case imageAction = "image_action"
        case prCode = "pr_code"
        case productDesc = "product_desc"
        case productFullDescr = "product_full_descr"
        case sizeChart = "size_chart"
        case productName = "product_name"
        case productType = "product_type"
        case categorySelected = "category_selected"
        case imageList = "image_list"
        case defaultImage = "default_image"
        case subTotal = "sub_total"
        case discountedSubTotal = "discounted_sub_total"
      //  case couponDiscountedAmount = "coupon_discounted_amount"
        case product_variations = "product_variations"
    }
}

struct CheckOut_Base : Codable {
    let status : String?
    let message : String?
    let oData : checkOutData?
    let errors : Errors?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
        case errors = "errors"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(checkOutData.self, forKey: .oData)
        errors = try values.decodeIfPresent(Errors.self, forKey: .errors)
    }
}
// MARK: - OData
struct checkOutData: Codable {
    var items: [CartItem]
    let cartTotal, deliveryCharge, tax, taxPercentage: String
    let grandTotal, couponAppliedStatus, totalCouponDiscount, appliedCouponID: String
    let cartCount: String
   
    enum CodingKeys: String, CodingKey {
        case items
        case cartTotal = "cart_total"
        case deliveryCharge = "delivery_charge"
        case tax
        case taxPercentage = "tax_percentage"
        case grandTotal = "grand_total"
        case couponAppliedStatus = "coupon_applied_status"
        case totalCouponDiscount = "total_coupon_discount"
        case appliedCouponID = "applied_coupon_id"
        case cartCount = "cart_count"
    }
}

struct Delegate_Base : Codable {
    let status : String?
    let message : String?
    let oData : DelegateData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(DelegateData.self, forKey: .oData)
    }
}
// MARK: - OData
struct DelegateData: Codable {
    let list: [DelegateList]
}

// MARK: - List
struct DelegateList: Codable {
    var id, deligateName: String
    let deligateIcon: String
    let deligateStatus, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case deligateName = "deligate_name"
        case deligateIcon = "deligate_icon"
        case deligateStatus = "deligate_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct PaymentInit_Base : Codable {
    let status : String?
    let message : String?
    let oData : PaymentData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(PaymentData.self, forKey: .oData)
    }
}
// MARK: - Payment Data
struct PaymentData: Codable {
    let invoiceID, paymentRef: String

    enum CodingKeys: String, CodingKey {
        case invoiceID = "invoice_id"
        case paymentRef = "payment_ref"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        paymentRef = try values.decodeIfPresent(String.self, forKey: .paymentRef) ?? ""
        invoiceID = try values.decodeIfPresent(String.self, forKey: .invoiceID) ?? ""
    }
}
struct Errors : Codable {
    let coupon_code : [String]?

    enum CodingKeys: String, CodingKey {

        case coupon_code = "coupon_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coupon_code = try values.decodeIfPresent([String].self, forKey: .coupon_code)
    }

}

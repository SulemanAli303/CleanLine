//
//  Authentication.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation

struct Product_Base : Codable {
    let status : String?
    let message : String?
    let oData : ProductData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ProductData.self, forKey: .oData)
    }
}

struct ProductData : Codable {
    let list : [ProductList]?

    enum CodingKeys: String, CodingKey {

        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([ProductList].self, forKey: .list)
    }

}

// MARK: - ProductList
struct ProductList: Codable {
    let id, productName, productType, defaultAttributeID: String
    let isLiked: String
    var storeID:String?
    let inventory: Inventory
    
    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case productType = "product_type"
        case defaultAttributeID = "default_attribute_id"
        case storeID = "store_id"
        case isLiked = "is_liked"
        case inventory
    }
}

// MARK: - Inventory
struct Inventory: Codable {
    let productAttributeID, stockQuantity, salePrice, regularPrice: String
    let image: [String]
    let sizeChart: String
    
    enum CodingKeys: String, CodingKey {
        case productAttributeID = "product_attribute_id"
        case stockQuantity = "stock_quantity"
        case salePrice = "sale_price"
        case regularPrice = "regular_price"
        case image
        case sizeChart = "size_chart"
    }
}


// MARK: - ProductDetails
struct ProductDetails: Codable {
    let productID, productVariantID, productName, productDescShort: String
    let productDesc: String
    let stockQuantity: Int
    let productSellerID, allowBackOrder, categoryID, productBrandID: String
    let brandName, productType: String
    let productImage: String
    let productImages: [String]
    let ratedUsers, rating, salePrice, regularPrice: String
    let productVendorID, modaSubCategory, modaMainCategory: Int
    let sizeChart: String
    let storeID, offerEnabled, offerPercentage: Int
    let vendorRating: String
    let isLiked: Int
    let shareLink: String
    let storeDetails: StoreDetails
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productVariantID = "product_variant_id"
        case productName = "product_name"
        case productDescShort = "product_desc_short"
        case productDesc = "product_desc"
        case stockQuantity = "stock_quantity"
        case productSellerID = "product_seller_id"
        case allowBackOrder = "allow_back_order"
        case categoryID = "category_id"
        case productBrandID = "product_brand_id"
        case brandName = "brand_name"
        case productType = "product_type"
        case productImage = "product_image"
        case productImages = "product_images"
        case ratedUsers = "rated_users"
        case rating
        case salePrice = "sale_price"
        case regularPrice = "regular_price"
        case productVendorID = "product_vendor_id"
        case modaSubCategory = "moda_sub_category"
        case modaMainCategory = "moda_main_category"
        case sizeChart = "size_chart"
        case storeID = "store_id"
        case offerEnabled = "offer_enabled"
        case offerPercentage = "offer_percentage"
        case vendorRating = "vendor_rating"
        case isLiked = "is_liked"
        case shareLink = "share_link"
        case storeDetails = "store_details"
       
    }
}

// MARK: - StoreDetails
struct StoreDetails: Codable {
    let id: Int
    let userImage: String
    let name, email, phone, dialCode: String
    let aboutMe: String?
    let rating: String
    let ratedUsers: String
    let userLocation: UserLocation

    enum CodingKeys: String, CodingKey {
        case id
        case userImage = "user_image"
        case name, email, phone
        case dialCode = "dial_code"
        case aboutMe = "about_me"
        case rating
        case ratedUsers = "rated_users"
        case userLocation = "user_location"
    }
}

// MARK: - UserLocation
struct UserLocation: Codable {
   // let id, userID: Int
    let lattitude, longitude, createdAt, updatedAt: String
    let locationName: String

    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
        case lattitude, longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case locationName = "location_name"
    }
}


struct Payment_Base : Codable {
    let status : String?
    let message : String?
    let oData : StripePayment?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(StripePayment.self, forKey: .oData)
    }
}
// MARK: - UserLocation
struct StripePayment: Codable,CodableInit {
   
    var invoice_id, ref_id: String
    
}

struct PaymentServices_Base : Codable {
    let status : String?
    let message : String?
    let oData : StripeServicesPayment?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(StripeServicesPayment.self, forKey: .oData)
    }
}
// MARK: - UserLocation
struct StripeServicesPayment: Codable,CodableInit {
   
    var ref_id: String
    
}

class TappPeymentRespoSE: Codable {
    var status: String?
    var message: String?
    var oData: PaymentResponse?


    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(status: String?, message: String?, oData: PaymentResponse?) {
        self.status = status
        self.message = message
        self.oData = oData
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        oData = try? values.decode(PaymentResponse.self, forKey: .oData)
        message = try? values.decode(String.self, forKey: .message)
        if let userReactionString = try? values.decode(String.self, forKey: .status), !userReactionString.isEmpty {
            status = userReactionString
        } else if let userBoolean = try? values.decode(Bool.self, forKey: .status) {
            status = "\(userBoolean ? 1 : 0)"
        } else {
             let statusInt =  try? values.decodeIfPresent(Int.self, forKey: .status) ?? 0
            status = "\(statusInt ?? 0)"
        }
    }
}

    // MARK: - OData
class PaymentResponse: Codable {
    var oTabTransaction: OTabTransaction?
    var payment_ref: String?
    var invoice_id: String?
    var temp_order_id: String?

    enum CodingKeys: String, CodingKey {
        case oTabTransaction = "o_tab_transaction"
        case payment_ref = "payment_ref"
        case invoice_id = "invoice_id"
        case temp_order_id = "temp_order_id"

    }

    init(oTabTransaction: OTabTransaction?,payment_ref: String?,invoice_id: String?,temp_order_id: String?) {
        self.oTabTransaction = oTabTransaction
        self.payment_ref = payment_ref
        self.invoice_id = invoice_id
        self.temp_order_id = temp_order_id
    }
}

    // MARK: - OTabTransaction
class OTabTransaction: Codable {
    var id: String?
    var object: String?
    var apiVersion: String?
    var method: String?
    var status: String?
    var currency: String?
    var product: String?
    var transaction: TabTransaction?
    var redirect: OTabTransactionPost?
    var post: OTabTransactionPost?
    var description: String?


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case object = "object"
        case apiVersion = "api_version"
        case method = "method"
        case status = "status"
        case currency = "currency"
        case product = "product"
        case transaction = "transaction"
        case redirect = "redirect"
        case post = "post"
        case description = "description"
    }

    init(id: String?, object: String?,  apiVersion: String?, method: String?, status: String?, currency: String?, product: String?, transaction: TabTransaction?, redirect: OTabTransactionPost?, post: OTabTransactionPost?, description: String?) {
        self.id = id
        self.object = object
        self.apiVersion = apiVersion
        self.method = method
        self.status = status
        self.currency = currency
        self.product = product
        self.transaction = transaction
        self.redirect = redirect
        self.post = post
        self.description = description
    }
}



    // MARK: - OTabTransactionPost
class OTabTransactionPost: Codable {
    var status: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case url = "url"
    }

    init(status: String?, url: String?) {
        self.status = status
        self.url = url
    }
}



    // MARK: - Reference
class Reference: Codable {
    var transaction: String?
    var order: String?

    enum CodingKeys: String, CodingKey {
        case transaction = "transaction"
        case order = "order"
    }

    init(transaction: String?, order: String?) {
        self.transaction = transaction
        self.order = order
    }
}

    // MARK: - Response
class Response: Codable {
    var code: String?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }

    init(code: String?, message: String?) {
        self.code = code
        self.message = message
    }
}



    // MARK: - Transaction
class TabTransaction: Codable {
    var timezone: String?
    var created: String?
    var url: String?
    var currency: String?

    enum CodingKeys: String, CodingKey {
        case timezone = "timezone"
        case created = "created"
        case url = "url"
        case currency = "currency"
    }

    init(timezone: String?, created: String?, url: String?,  currency: String?) {
        self.timezone = timezone
        self.created = created
        self.url = url
        self.currency = currency
    }
}

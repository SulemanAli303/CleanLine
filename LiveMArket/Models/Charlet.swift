//
//  Authentication.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation

struct ProductChalets_Base : Codable {
    let status : String?
    let message : String?
    let oData : ProductChaletsBase?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ProductChaletsBase.self, forKey: .oData)
    }
}
struct ProductChaletsBase : Codable,CodableInit {
    var list :  [ChaletsList]?
    var currency_code :  String?
}

// MARK: - List
struct ChaletsList: Codable,CodableInit {
    var id, name: String?
    var primary_image: String?
    var description, price_type, price: String?
    var facilities: [Facility]?
}

// MARK: - Facility
struct Facility: Codable,CodableInit {
    var id, name: String?
    var icon: String?
}


struct ChaletsDetail_Base : Codable {
    let status : String?
    let message : String?
    let oData : ChaletsDetailData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ChaletsDetailData.self, forKey: .oData)
    }
}


// MARK: - OData
struct ChaletsDetailData : Codable,CodableInit {
    var product: CharletProductDetail?
    var bookings : [String]?

}

// MARK: - Product
struct CharletProductDetail: Codable {
    let id, name, description: String?
    let primary_image, cover_image: String?
    let address: String?
    let facilities: [Facility]?
    let currency_code: String?
    let gallery: [Gallery]?
    let vendor: Vendor?
    let ratings, price_type, price, service_charges: String?
    let tax_charges, isLiked: String?
}
// MARK: - Gallery
struct Gallery: Codable,CodableInit {
    var type: String
    var content: String
}

// MARK: - Vendor
struct Vendor: Codable,CodableInit {
    var id, name: String
}


struct ChaletsCheckOUt_Base : Codable {
    let status : String?
    let message : String?
    let oData : ChaletsCheckOutData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ChaletsCheckOutData.self, forKey: .oData)
    }
}

// MARK: - check OUt
struct ChaletsCheckOutData: Codable,CodableInit {
    var device_cart_id, schedule, product_name, product_price: String?
    var facilities: [Facility]?
    var currency_code, subtotal, service_charges, tax_charges: String?
    var total_amount: String?
    var coupon_applied : String?
}


struct ChaletsCreateBooking_Base : Codable {
    let status : String?
    let message : String?
    let oData : ChaletsCreateBookingData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ChaletsCreateBookingData.self, forKey: .oData)
    }
}
// MARK: - ChaletsCreateBooking data
struct ChaletsCreateBookingData: Codable, CodableInit {
    var booking_id, invoice_number, message_title, message: String?
}



struct ChaletsBookingList_Base : Codable {
    let status : String?
    let message : String?
    let oData : CharletBookingListData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(CharletBookingListData.self, forKey: .oData)
    }
}

// MARK: - Booking List
struct CharletBookingListData: Codable,CodableInit {
    let list : [CharletBookingList]?
    let currency_code : String?
}
// MARK: - Booking List
struct CharletBookingList: Codable,CodableInit {
    var id, booking_id, start_date_time, total_amount: String?
    var booking_status, created_at,created_at_format, is_paid, product_name,booking_status_number: String?
    var product_image,user_name: String?
    var activity_type,user_image: String?

}


struct ChaletsBookingDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : ChaletsBookingDetailsData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ChaletsBookingDetailsData.self, forKey: .oData)
    }
}

// MARK: - booking details data
struct ChaletsBookingDetailsData: Codable,CodableInit {
    var booking: BookingDetails?
    var show_pay_button: String?
    var remaining: Remaining?
    var product: CharletBookingProduct?
    var is_rated : String?
    var review_data : ChaletReviewData?

}

// MARK: - booking details product
struct CharletBookingProduct: Codable,CodableInit {
    var product_id, product_name: String?
    var primary_image: String
    var product_price, address, latitude, longitude: String?
    let facilities: [Facility]
    var currency_code, ratings,vendor_contact: String?

}

// MARK: - Booking
struct BookingDetails: Codable {
    let id, bookingID, startDateTime, bookingPrice: String
    let taxCharges, serviceCharges, totalAmount, discountAmount: String
    let bookingStatus, endDateTime, isPaid, reservationProductID: String
    let activityType, bookingStatusNumber,created_at,schedule,payment_mode_text,completed_on: String
    var user_image : String?
    var user_name : String?
    var phone : String?
    var user_code : String?
    enum CodingKeys: String, CodingKey {
        case id
        case bookingID = "booking_id"
        case startDateTime = "start_date_time"
        case bookingPrice = "booking_price"
        case taxCharges = "tax_charges"
        case serviceCharges = "service_charges"
        case totalAmount = "total_amount"
        case discountAmount = "discount_amount"
        case bookingStatus = "booking_status"
        case endDateTime = "end_date_time"
        case isPaid = "is_paid"
        case reservationProductID = "reservation_product_id"
        case activityType = "activity_type"
        case bookingStatusNumber = "booking_status_number"
        case schedule
        case created_at
        case payment_mode_text
        case user_image
        case user_name
        case phone
        case user_code
        case completed_on
    }
}
// MARK: - Remaining
struct Remaining: Codable,CodableInit {
    var d, h, m, s: String?
}


struct ChaletsPromo_Base : Codable {
    let status : String?
    let message : String?
    let oData : ChaletsPromoData?
    let errors : ChaletsPromoErrors?
    
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
        oData = try values.decodeIfPresent(ChaletsPromoData.self, forKey: .oData)
        errors = try values.decodeIfPresent(ChaletsPromoErrors.self, forKey: .errors)
    }
}

struct ChaletsPromoErrors : Codable {
    let couponCode: [String]?
    
    enum CodingKeys: String, CodingKey {
        case couponCode = "coupon_code"
    }
}

// MARK: - ChaletsPromodata
struct ChaletsPromoData: Codable,CodableInit {
    var coupon_applied, coupon_discount, grand_total, service_charges,subtotal,tax_amount: String?
}


struct ChaletPayment_Base : Codable {
    let status : String?
    let message : String?
    let oData : ChaletPaymentData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ChaletPaymentData.self, forKey: .oData)
    }
}
// MARK: - ChaletsPayment
struct ChaletPaymentData: Codable,CodableInit {
   
    var payment_ref: ChaletPayment?
    
}
// MARK: - ChaletsPayment
struct ChaletPayment: Codable,CodableInit {
   
    var payment_ref: String
    
}


struct ChaletsManagmentProductDetails : Codable {
    let status : String?
    let message : String?
    let oData : ChaletsManagmentProductDetailsData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ChaletsManagmentProductDetailsData.self, forKey: .oData)
    }
}

struct ChaletsManagmentProductDetailsData : Codable {
    let product : ChaletsManagmentProduct?
}
// MARK: - ProductList
struct ChaletsManagmentProduct: Codable {
    let id, name, description: String
    let primaryImage, coverImage: String
    let address: String
    let currencyCode: String
    let ratings, priceType, price, serviceCharges: String
    let taxCharges: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case primaryImage = "primary_image"
        case coverImage = "cover_image"
        case address
        case currencyCode = "currency_code"
        case ratings
        case priceType = "price_type"
        case price
        case serviceCharges = "service_charges"
        case taxCharges = "tax_charges"
    }
}


struct ChaletsAvaliablity_basic : Codable {
    let status : String?
    let message : String?
    let oData : ChaletsAvaliablityData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ChaletsAvaliablityData.self, forKey: .oData)
    }
}
struct ChaletsAvaliablityData : Codable {
    var list : [String]?
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
      
    }
}



struct favouriteStore_base : Codable {
    let status : String?
    let message : String?
    let oData : favouriteStoreData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(favouriteStoreData.self, forKey: .oData)
    }
}

// MARK: - OData
struct favouriteStoreData: Codable {
    let list: [StoreFavList]
}

// MARK: - List
struct StoreFavList: Codable {
    let id, name, email: String
    let userImage: String
    let userTypeID, activityTypeID: String
    let bannerImage: String
    let aboutMe, locationName, lattitude, longitude: String
    let isLiked: String

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case userImage = "user_image"
        case userTypeID = "user_type_id"
        case activityTypeID = "activity_type_id"
        case bannerImage = "banner_image"
        case aboutMe = "about_me"
        case locationName = "location_name"
        case lattitude, longitude
        case isLiked = "is_liked"
    }
}

struct ChaletReviewData: Codable {
    let id: String?
    let reservationProductID: String?
    let ratings: String?
    let review: String?
    let userID: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case reservationProductID = "reservation_product_id"
        case ratings = "ratings"
        case review = "review"
        case userID = "user_id"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

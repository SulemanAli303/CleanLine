//
//  GroundBookingDetails_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/08/23.
//

import Foundation
struct GroundBookingDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : GroundBookingDetailsData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(GroundBookingDetailsData.self, forKey: .oData)
    }

}
struct GroundBookingDetailsData : Codable {
    let booking : GroundBookingDetailsBooking?
    let show_pay_button : String?
    let remaining : GroundBookingDetailsRemaining?
    let subtotal : String?
    let tax_charges : String?
    let service_charges : String?
    let total_amount : String?
    let ground : GroundBookingDetailsGround?
    let isRated : String?
    let review_data : PGReviewDetailObj?
    let slots_list : [Slot]?

    enum CodingKeys: String, CodingKey {

        case booking = "booking"
        case show_pay_button = "show_pay_button"
        case remaining = "remaining"
        case subtotal = "subtotal"
        case tax_charges = "tax_charges"
        case service_charges = "service_charges"
        case total_amount = "total_amount"
        case ground = "ground"
        case isRated = "isRated"
        case review_data = "review_data"
        case slots_list = "slots_list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        booking = try values.decodeIfPresent(GroundBookingDetailsBooking.self, forKey: .booking)
        show_pay_button = try values.decodeIfPresent(String.self, forKey: .show_pay_button)
        remaining = try values.decodeIfPresent(GroundBookingDetailsRemaining.self, forKey: .remaining)
        subtotal = try values.decodeIfPresent(String.self, forKey: .subtotal)
        tax_charges = try values.decodeIfPresent(String.self, forKey: .tax_charges)
        service_charges = try values.decodeIfPresent(String.self, forKey: .service_charges)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        ground = try values.decodeIfPresent(GroundBookingDetailsGround.self, forKey: .ground)
        isRated = try values.decodeIfPresent(String.self, forKey: .isRated)
        review_data = try values.decodeIfPresent(PGReviewDetailObj.self, forKey: .review_data)
        slots_list = try values.decodeIfPresent([Slot].self, forKey: .slots_list)
    }

}

struct PGBookingDetailTimeSlot : Codable {
    let id : String?
    let reservation_product_id : String?
    let start_time : String?
    let end_time : String?
    let type : String?
    let vendor_id : String?
    let created_at : String?
    let updated_at : String?
    //let unavailable_dates : String?
    let slot_value_text : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case reservation_product_id = "reservation_product_id"
        case start_time = "start_time"
        case end_time = "end_time"
        case type = "type"
        case vendor_id = "vendor_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        //case unavailable_dates = "unavailable_dates"
        case slot_value_text = "slot_value_text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        reservation_product_id = try values.decodeIfPresent(String.self, forKey: .reservation_product_id)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        vendor_id = try values.decodeIfPresent(String.self, forKey: .vendor_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        //unavailable_dates = try values.decodeIfPresent(String.self, forKey: .unavailable_dates)
        slot_value_text = try values.decodeIfPresent(String.self, forKey: .slot_value_text)
    }

}

struct GroundBookingDetailsGround : Codable {
    let ground_id : String?
    let ground_name : String?
    let primary_image : String?
    let ground_price : String?
    let area : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let ratings : String?
    let currency_code : String?
    


    enum CodingKeys: String, CodingKey {

        case ground_id = "ground_id"
        case ground_name = "ground_name"
        case primary_image = "primary_image"
        case ground_price = "ground_price"
        case area = "area"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case ratings = "ratings"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ground_id = try values.decodeIfPresent(String.self, forKey: .ground_id)
        ground_name = try values.decodeIfPresent(String.self, forKey: .ground_name)
        primary_image = try values.decodeIfPresent(String.self, forKey: .primary_image)
        ground_price = try values.decodeIfPresent(String.self, forKey: .ground_price)
        area = try values.decodeIfPresent(String.self, forKey: .area)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        ratings = try values.decodeIfPresent(String.self, forKey: .ratings)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct GroundBookingDetailsBooking : Codable {
    let booking_id : String?
    let invoice_id : String?
    let booking_price : String?
    let tax_charges : String?
    let service_charges : String?
    let total_amount : String?
    let booking_status : String?
    let is_paid : String?
    let reservation_product_id : String?
    let created_at : String?
    let vendor_id : String?
    let payment_mode : String?
    let start_date_time : String?
    let end_date_time : String?
    let user_id : String?
    let date : String?
    let activity_type : String?
    let vendor : GroundBookingDetailsVendor?
    let user : GroundReceivedUser?
    let booking_status_text : String?
    let payment_mode_text : String?
    let slot_value : String?
    let user_code : String?
    
    enum CodingKeys: String, CodingKey {

        case booking_id = "booking_id"
        case invoice_id = "invoice_id"
        case booking_price = "booking_price"
        case tax_charges = "tax_charges"
        case service_charges = "service_charges"
        case total_amount = "total_amount"
        case booking_status = "booking_status"
        case is_paid = "is_paid"
        case reservation_product_id = "reservation_product_id"
        case created_at = "created_at"
        case vendor_id = "vendor_id"
        case payment_mode = "payment_mode"
        case start_date_time = "start_date_time"
        case end_date_time = "end_date_time"
        case user_id = "user_id"
        case date = "date"
        case activity_type = "activity_type"
        case vendor = "vendor"
        case user = "user"
        case booking_status_text = "booking_status_text"
        case payment_mode_text = "payment_mode_text"
        case slot_value = "slot_value"
        case user_code = "user_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        booking_id = try values.decodeIfPresent(String.self, forKey: .booking_id)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
        booking_price = try values.decodeIfPresent(String.self, forKey: .booking_price)
        tax_charges = try values.decodeIfPresent(String.self, forKey: .tax_charges)
        service_charges = try values.decodeIfPresent(String.self, forKey: .service_charges)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        booking_status = try values.decodeIfPresent(String.self, forKey: .booking_status)
        is_paid = try values.decodeIfPresent(String.self, forKey: .is_paid)
        reservation_product_id = try values.decodeIfPresent(String.self, forKey: .reservation_product_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        vendor_id = try values.decodeIfPresent(String.self, forKey: .vendor_id)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        start_date_time = try values.decodeIfPresent(String.self, forKey: .start_date_time)
        end_date_time = try values.decodeIfPresent(String.self, forKey: .end_date_time)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        activity_type = try values.decodeIfPresent(String.self, forKey: .activity_type)
        vendor = try values.decodeIfPresent(GroundBookingDetailsVendor.self, forKey: .vendor)
        user = try values.decodeIfPresent(GroundReceivedUser.self, forKey: .user)
        booking_status_text = try values.decodeIfPresent(String.self, forKey: .booking_status_text)
        payment_mode_text = try values.decodeIfPresent(String.self, forKey: .payment_mode_text)
        slot_value = try values.decodeIfPresent(String.self, forKey: .slot_value)
        user_code = try values.decodeIfPresent(String.self, forKey: .user_code)
    }

}
struct GroundBookingDetailsRemaining : Codable {
    let d : String?
    let h : String?
    let m : String?
    let s : String?

    enum CodingKeys: String, CodingKey {

        case d = "d"
        case h = "h"
        case m = "m"
        case s = "s"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        d = try values.decodeIfPresent(String.self, forKey: .d)
        h = try values.decodeIfPresent(String.self, forKey: .h)
        m = try values.decodeIfPresent(String.self, forKey: .m)
        s = try values.decodeIfPresent(String.self, forKey: .s)
    }

}
struct GroundBookingDetailsVendor : Codable {
    let id : String?
    let name : String?
    let user_image : String?
    let dial_code : String?
    let phone : String?
    let profile_url : String?
    let user_location : User_location?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case user_image = "user_image"
        case dial_code = "dial_code"
        case phone = "phone"
        case profile_url = "profile_url"
        case user_location = "user_location"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
        user_location = try values.decodeIfPresent(User_location.self, forKey: .user_location)
        
    }

}

struct PGReviewDetailObj: Codable {
    let id: String?
    let reservationProductID: String?
    let vendorID: String?
    let ratings: String?
    let review: String?
    let userID: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    let reservationBookingID: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case reservationProductID = "reservation_product_id"
        case vendorID = "vendor_id"
        case ratings = "ratings"
        case review = "review"
        case userID = "user_id"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case reservationBookingID = "reservation_booking_id"
    }
}

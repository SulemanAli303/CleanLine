//
//  HotelBookingDetails_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 09/08/23.
//

import Foundation
struct HotelBookingDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : HotelBookingDetailsData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(HotelBookingDetailsData.self, forKey: .oData)
    }

}
struct HotelBookingDetailsData : Codable {
    let booking : HotelDetaislBooking?
    let show_pay_button : String?
    let remaining : Remaining?
    let subtotal : String?
    let tax_charges : String?
    let service_charges : String?
    let coupon_code : String?
    let coupon_applied : String?
    let discount : String?
    let total_amount : String?
    let room : HotelDetailsRoom?
    let isRated: String?
    let review_data: HotelReviewData?

    enum CodingKeys: String, CodingKey {

        case booking = "booking"
        case show_pay_button = "show_pay_button"
        case remaining = "remaining"
        case subtotal = "subtotal"
        case tax_charges = "tax_charges"
        case service_charges = "service_charges"
        case coupon_code = "coupon_code"
        case coupon_applied = "coupon_applied"
        case discount = "discount"
        case total_amount = "total_amount"
        case room = "room"
        case isRated = "isRated"
        case review_data = "review_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        booking = try values.decodeIfPresent(HotelDetaislBooking.self, forKey: .booking)
        show_pay_button = try values.decodeIfPresent(String.self, forKey: .show_pay_button)
        remaining = try values.decodeIfPresent(Remaining.self, forKey: .remaining)
        subtotal = try values.decodeIfPresent(String.self, forKey: .subtotal)
        tax_charges = try values.decodeIfPresent(String.self, forKey: .tax_charges)
        service_charges = try values.decodeIfPresent(String.self, forKey: .service_charges)
        coupon_code = try values.decodeIfPresent(String.self, forKey: .coupon_code)
        coupon_applied = try values.decodeIfPresent(String.self, forKey: .coupon_applied)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        room = try values.decodeIfPresent(HotelDetailsRoom.self, forKey: .room)
        review_data = try values.decodeIfPresent(HotelReviewData.self, forKey: .review_data)
        isRated = try values.decodeIfPresent(String.self, forKey: .isRated)
        
    }

}
struct HotelDetaislBooking : Codable {
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
    let user_code : String?
    let start_date : String?
    let end_date : String?
    let activity_type : String?
    let vendor : GroundVendor?
    let user : GroundReceivedUser?
    let booking_status_text : String?
    let payment_mode_text : String?
    let completed_on: String?
    
    

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
        case user_code = "user_code"
        case start_date = "start_date"
        case end_date = "end_date"
        case activity_type = "activity_type"
        case vendor = "vendor"
        case user = "user"
        case booking_status_text = "booking_status_text"
        case payment_mode_text = "payment_mode_text"
        case completed_on = "completed_on"
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
        user_code = try values.decodeIfPresent(String.self, forKey: .user_code)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        activity_type = try values.decodeIfPresent(String.self, forKey: .activity_type)
        vendor = try values.decodeIfPresent(GroundVendor.self, forKey: .vendor)
        user = try values.decodeIfPresent(GroundReceivedUser.self, forKey: .user)
        booking_status_text = try values.decodeIfPresent(String.self, forKey: .booking_status_text)
        payment_mode_text = try values.decodeIfPresent(String.self, forKey: .payment_mode_text)
        completed_on = try values.decodeIfPresent(String.self, forKey: .completed_on)
    }

}
struct HotelDetailsRoom : Codable {
    let room_id : String?
    let room_name : String?
    let primary_image : String?
    let room_price : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let facilities : [Facilities]?
    let adults : String?
    let children_above_two : String?
    let children_below_two : String?
    let room_count : String?
    let ratings : String?
    let currency_code : String?
    


    enum CodingKeys: String, CodingKey {

        case room_id = "room_id"
        case room_name = "room_name"
        case primary_image = "primary_image"
        case room_price = "room_price"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case facilities = "facilities"
        case adults = "adults"
        case children_above_two = "children_above_two"
        case children_below_two = "children_below_two"
        case room_count = "room_count"
        case ratings = "ratings"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        room_id = try values.decodeIfPresent(String.self, forKey: .room_id)
        room_name = try values.decodeIfPresent(String.self, forKey: .room_name)
        primary_image = try values.decodeIfPresent(String.self, forKey: .primary_image)
        room_price = try values.decodeIfPresent(String.self, forKey: .room_price)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        facilities = try values.decodeIfPresent([Facilities].self, forKey: .facilities)
        adults = try values.decodeIfPresent(String.self, forKey: .adults)
        children_above_two = try values.decodeIfPresent(String.self, forKey: .children_above_two)
        children_below_two = try values.decodeIfPresent(String.self, forKey: .children_below_two)
        room_count = try values.decodeIfPresent(String.self, forKey: .room_count)
        ratings = try values.decodeIfPresent(String.self, forKey: .ratings)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}


struct HotelReviewData: Codable {
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

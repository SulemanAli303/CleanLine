//
//  GroundReceivedBooking_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/08/23.
//

import Foundation

struct GroundReceivedBooking_Base : Codable {
    let status : String?
    let message : String?
    let oData : GroundReceivedBookingData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(GroundReceivedBookingData.self, forKey: .oData)
    }

}
struct GroundReceivedBookingData : Codable {
    let list : [GroundReceivedBookingList]?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case list = "list"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([GroundReceivedBookingList].self, forKey: .list)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct GroundReceivedUser : Codable {
    let id : String?
    let name : String?
    let user_image : String?
    let dial_code : String?
    let phone : String?
    let profile_url : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case user_image = "user_image"
        case dial_code = "dial_code"
        case phone = "phone"
        case profile_url = "profile_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
    }

}
struct GroundReceivedBookingList : Codable {
    let booking_id : String?
    let invoice_id : String?
    let total_amount : String?
    let booking_status : String?
    let is_paid : String?
    let created_at : String?
    let start_date_time : String?
    let end_date_time : String?
    let user_id : String?
    let payment_mode : String?
    let date : String?
    let product_name : String?
    let area : String?
    let product_image : String?
    let activity_type : String?
    let user : GroundReceivedUser?
    let booking_status_text : String?
    let payment_mode_text : String?
    let show_accept_btn : String?
    let show_reject_btn : String?

    enum CodingKeys: String, CodingKey {

        case booking_id = "booking_id"
        case invoice_id = "invoice_id"
        case total_amount = "total_amount"
        case booking_status = "booking_status"
        case is_paid = "is_paid"
        case created_at = "created_at"
        case start_date_time = "start_date_time"
        case end_date_time = "end_date_time"
        case user_id = "user_id"
        case payment_mode = "payment_mode"
        case date = "date"
        case product_name = "product_name"
        case area = "area"
        case product_image = "product_image"
        case activity_type = "activity_type"
        case user = "user"
        case booking_status_text = "booking_status_text"
        case payment_mode_text = "payment_mode_text"
        case show_accept_btn = "show_accept_btn"
        case show_reject_btn = "show_reject_btn"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        booking_id = try values.decodeIfPresent(String.self, forKey: .booking_id)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        booking_status = try values.decodeIfPresent(String.self, forKey: .booking_status)
        is_paid = try values.decodeIfPresent(String.self, forKey: .is_paid)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        start_date_time = try values.decodeIfPresent(String.self, forKey: .start_date_time)
        end_date_time = try values.decodeIfPresent(String.self, forKey: .end_date_time)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
        area = try values.decodeIfPresent(String.self, forKey: .area)
        product_image = try values.decodeIfPresent(String.self, forKey: .product_image)
        activity_type = try values.decodeIfPresent(String.self, forKey: .activity_type)
        user = try values.decodeIfPresent(GroundReceivedUser.self, forKey: .user)
        booking_status_text = try values.decodeIfPresent(String.self, forKey: .booking_status_text)
        payment_mode_text = try values.decodeIfPresent(String.self, forKey: .payment_mode_text)
        show_accept_btn = try values.decodeIfPresent(String.self, forKey: .show_accept_btn)
        show_reject_btn = try values.decodeIfPresent(String.self, forKey: .show_reject_btn)
    }

}

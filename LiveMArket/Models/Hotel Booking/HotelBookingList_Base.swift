//
//  HotelBookingList_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 09/08/23.
//

import Foundation
struct HotelBookingList_Base : Codable {
    let status : String?
    let message : String?
    let oData : HotelBookingListData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(HotelBookingListData.self, forKey: .oData)
    }

}
struct HotelBookingListData : Codable {
    let list : [HotelBookingList]?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case list = "list"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([HotelBookingList].self, forKey: .list)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct HotelBookingList : Codable {
    let booking_id : String?
    let invoice_id : String?
    let total_amount : String?
    let booking_status : String?
    let is_paid : String?
    let created_at : String?
    let user_id : String?
    let payment_mode : String?
    let start_date : String?
    let end_date : String?
    let product_name : String?
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
        case user_id = "user_id"
        case payment_mode = "payment_mode"
        case start_date = "start_date"
        case end_date = "end_date"
        case product_name = "product_name"
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
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
        product_image = try values.decodeIfPresent(String.self, forKey: .product_image)
        activity_type = try values.decodeIfPresent(String.self, forKey: .activity_type)
        user = try values.decodeIfPresent(GroundReceivedUser.self, forKey: .user)
        booking_status_text = try values.decodeIfPresent(String.self, forKey: .booking_status_text)
        payment_mode_text = try values.decodeIfPresent(String.self, forKey: .payment_mode_text)
        show_accept_btn = try values.decodeIfPresent(String.self, forKey: .show_accept_btn)
        show_reject_btn = try values.decodeIfPresent(String.self, forKey: .show_reject_btn)
    }

}

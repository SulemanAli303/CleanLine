//
//  PGBooking_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/08/23.
//

import Foundation

struct PGBooking_Base : Codable {
    let status : String?
    let message : String?
    let oData : PGBookingData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(PGBookingData.self, forKey: .oData)
    }

}
struct PGBookingData : Codable {
    let list : [PGBookingList]?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case list = "list"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([PGBookingList].self, forKey: .list)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct PGBookingList : Codable {
    let booking_id : String?
    let invoice_id : String?
    let total_amount : String?
    let booking_status : String?
    let is_paid : String?
    let created_at : String?
    let start_date_time : String?
    let end_date_time : String?
    let payment_mode : String?
    let date : String?
    let product_name : String?
    let area : String?
    let product_image : String?
    let activity_type : String?
    let booking_status_text : String?
    let payment_mode_text : String?

    enum CodingKeys: String, CodingKey {

        case booking_id = "booking_id"
        case invoice_id = "invoice_id"
        case total_amount = "total_amount"
        case booking_status = "booking_status"
        case is_paid = "is_paid"
        case created_at = "created_at"
        case start_date_time = "start_date_time"
        case end_date_time = "end_date_time"
        case payment_mode = "payment_mode"
        case date = "date"
        case product_name = "product_name"
        case area = "area"
        case product_image = "product_image"
        case activity_type = "activity_type"
        case booking_status_text = "booking_status_text"
        case payment_mode_text = "payment_mode_text"
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
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
        area = try values.decodeIfPresent(String.self, forKey: .area)
        product_image = try values.decodeIfPresent(String.self, forKey: .product_image)
        activity_type = try values.decodeIfPresent(String.self, forKey: .activity_type)
        booking_status_text = try values.decodeIfPresent(String.self, forKey: .booking_status_text)
        payment_mode_text = try values.decodeIfPresent(String.self, forKey: .payment_mode_text)
    }

}

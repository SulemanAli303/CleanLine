//
//  GroundCheckOut_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/08/23.
//

import Foundation

struct GroundCheckOut_Base : Codable {
    let status : String?
    let message : String?
    let oData : GroundCheckOutData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(GroundCheckOutData.self, forKey: .oData)
    }

}
struct GroundCheckOutData : Codable {
    let booking : Booking?
    let currency_code : String?
    let grand_total : String?
    let service_charges : String?
    let subtotal : String?
    let tax_amount : String?
    let wallet_balance : String?
    

    enum CodingKeys: String, CodingKey {

        case booking = "booking"
        case currency_code = "currency_code"
        case subtotal = "subtotal"
        case service_charges = "service_charges"
        case tax_amount = "tax_amount"
        case grand_total = "grand_total"
        case wallet_balance = "wallet_balance"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        booking = try values.decodeIfPresent(Booking.self, forKey: .booking)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        subtotal = try values.decodeIfPresent(String.self, forKey: .subtotal)
        service_charges = try values.decodeIfPresent(String.self, forKey: .service_charges)
        tax_amount = try values.decodeIfPresent(String.self, forKey: .tax_amount)
        grand_total = try values.decodeIfPresent(String.self, forKey: .grand_total)
        wallet_balance = try values.decodeIfPresent(String.self, forKey: .wallet_balance)
    }

}
struct Ground : Codable {
    let id : String?
    let name : String?
    let primary_image : String?
    let description : String?
    let price_type : String?
    let price : String?
    let tax_charges : String?
    let service_charges : String?
    let isLiked : String?
    let content : [GroundGalleryContent]?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case primary_image = "primary_image"
        case description = "description"
        case price_type = "price_type"
        case price = "price"
        case tax_charges = "tax_charges"
        case service_charges = "service_charges"
        case isLiked = "isLiked"
        case content = "content"
    }

}
struct Slot : Codable {
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
struct Booking : Codable {
    let created_at : String?
    let date : String?
    let device_cart_id : String?
    let ground : Ground?
    let ground_id : String?
    let hours : String?
    let id : String?
    let slot : Slot?
    let slot_id : String?
    let slot_id_list : String?
    let slot_lists : [Slot]?
    let slot_value : String?
    let updated_at : String?
    let user_id : String?
    let vendor_id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case device_cart_id = "device_cart_id"
        case user_id = "user_id"
        case vendor_id = "vendor_id"
        case ground_id = "ground_id"
        case slot_id = "slot_id"
        case date = "date"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case hours = "hours"
        case slot_value = "slot_value"
        case ground = "ground"
        case slot = "slot"
        case slot_id_list = "slot_id_list"
        case slot_lists = "slot_lists"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        device_cart_id = try values.decodeIfPresent(String.self, forKey: .device_cart_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        vendor_id = try values.decodeIfPresent(String.self, forKey: .vendor_id)
        ground_id = try values.decodeIfPresent(String.self, forKey: .ground_id)
        slot_id = try values.decodeIfPresent(String.self, forKey: .slot_id)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        hours = try values.decodeIfPresent(String.self, forKey: .hours)
        slot_value = try values.decodeIfPresent(String.self, forKey: .slot_value)
        ground = try values.decodeIfPresent(Ground.self, forKey: .ground)
        slot = try values.decodeIfPresent(Slot.self, forKey: .slot)
        slot_id_list = try values.decodeIfPresent(String.self, forKey: .slot_id_list)
        slot_lists = try values.decodeIfPresent([Slot].self, forKey: .slot_lists)
    }

}

// MARK: - Content
struct GroundGalleryContent: Codable {
    let id: String?
    let reservationProductID: String?
    let contentType: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case reservationProductID = "reservation_product_id"
        case contentType = "content_type"
        case content = "content"
    }
}

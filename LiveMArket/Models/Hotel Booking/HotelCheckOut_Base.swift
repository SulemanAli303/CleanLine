//
//  HotelCheckOut_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 08/08/23.
//

import Foundation

struct HotelCheckOut_Base : Codable {
    let status : String?
    let message : String?
    let errors : Errors?
    let oData : HotelCheckOutData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case errors = "errors"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        errors = try values.decodeIfPresent(Errors.self, forKey: .errors)
        oData = try values.decodeIfPresent(HotelCheckOutData.self, forKey: .oData)
    }

}
struct HotelCheckOutData : Codable {
    let booking : CheckOutBooking?
    let currency_code : String?
    let subtotal : String?
    let service_charges : String?
    let tax_amount : String?
    let grand_total : String?
    let coupon_applied : String?
    let coupon_discount : String?

    enum CodingKeys: String, CodingKey {

        case booking = "booking"
        case currency_code = "currency_code"
        case subtotal = "subtotal"
        case service_charges = "service_charges"
        case tax_amount = "tax_amount"
        case grand_total = "grand_total"
        case coupon_applied = "coupon_applied"
        case coupon_discount = "coupon_discount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        booking = try values.decodeIfPresent(CheckOutBooking.self, forKey: .booking)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        subtotal = try values.decodeIfPresent(String.self, forKey: .subtotal)
        service_charges = try values.decodeIfPresent(String.self, forKey: .service_charges)
        tax_amount = try values.decodeIfPresent(String.self, forKey: .tax_amount)
        grand_total = try values.decodeIfPresent(String.self, forKey: .grand_total)
        coupon_applied = try values.decodeIfPresent(String.self, forKey: .coupon_applied)
        coupon_discount = try values.decodeIfPresent(String.self, forKey: .coupon_discount)
    }

}
struct CheckOutBooking : Codable {
    let id : String?
    let device_cart_id : String?
    let user_id : String?
    let hotel_id : String?
    let room_id : String?
    let start_date : String?
    let end_date : String?
    let adults : String?
    let children_above_two : String?
    let children_below_two : String?
    let created_at : String?
    let updated_at : String?
    let room_count : String?
    let days : String?
    let room : Room?
   

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case device_cart_id = "device_cart_id"
        case user_id = "user_id"
        case hotel_id = "hotel_id"
        case room_id = "room_id"
        case start_date = "start_date"
        case end_date = "end_date"
        case adults = "adults"
        case children_above_two = "children_above_two"
        case children_below_two = "children_below_two"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case room_count = "room_count"
        case days = "days"
        case room = "room"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        device_cart_id = try values.decodeIfPresent(String.self, forKey: .device_cart_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        hotel_id = try values.decodeIfPresent(String.self, forKey: .hotel_id)
        room_id = try values.decodeIfPresent(String.self, forKey: .room_id)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        adults = try values.decodeIfPresent(String.self, forKey: .adults)
        children_above_two = try values.decodeIfPresent(String.self, forKey: .children_above_two)
        children_below_two = try values.decodeIfPresent(String.self, forKey: .children_below_two)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        room_count = try values.decodeIfPresent(String.self, forKey: .room_count)
        days = try values.decodeIfPresent(String.self, forKey: .days)
        room = try values.decodeIfPresent(Room.self, forKey: .room)
    }

}
struct Room : Codable {
    let id : String?
    let name : String?
    let primary_image : String?
    let description : String?
    let price_type : String?
    let price : String?
    let tax_charges : String?
    let service_charges : String?
    let facilities : [Facilities]?
    let isLiked : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case primary_image = "primary_image"
        case description = "description"
        case price_type = "price_type"
        case price = "price"
        case tax_charges = "tax_charges"
        case service_charges = "service_charges"
        case facilities = "facilities"
        case isLiked = "isLiked"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        primary_image = try values.decodeIfPresent(String.self, forKey: .primary_image)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        price_type = try values.decodeIfPresent(String.self, forKey: .price_type)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        tax_charges = try values.decodeIfPresent(String.self, forKey: .tax_charges)
        service_charges = try values.decodeIfPresent(String.self, forKey: .service_charges)
        facilities = try values.decodeIfPresent([Facilities].self, forKey: .facilities)
        isLiked = try values.decodeIfPresent(String.self, forKey: .isLiked)
    }

}

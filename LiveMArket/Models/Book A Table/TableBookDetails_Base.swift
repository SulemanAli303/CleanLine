//
//  TableBookDetails_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 27/09/23.
//

import Foundation
struct TableBookDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : TableBookDetailsData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(TableBookDetailsData.self, forKey: .oData)
    }

}
struct TableBookDetailsData : Codable {
    let id : String?
    let invoice_id : String?
    let user_id : String?
    let store_id : String?
    let no_of_persons : String?
    let booking_date : String?
    let booking_from : String?
    let booking_to : String?
    let booking_status : String?
    let item_total : String?
    let service_charge : String?
    let tax : String?
    let grand_total : String?
    let address_id : String?
    let payment_method : String?
    let booking_otp : String?
    let completed_on : String?
    let rating : String?
    let review : String?
    let is_rated : String?
    let created_at : String?
    let updated_at : String?
    let is_review_verified : String?
    let store : Store?
    let user : GroundReceivedUser?
    let address : Address?
    let booking_status_text : String?
    var description : String?
    var table_possition : Postionlist?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case invoice_id = "invoice_id"
        case user_id = "user_id"
        case store_id = "store_id"
        case no_of_persons = "no_of_persons"
        case booking_date = "booking_date"
        case booking_from = "booking_from"
        case booking_to = "booking_to"
        case booking_status = "booking_status"
        case item_total = "item_total"
        case service_charge = "service_charge"
        case tax = "tax"
        case grand_total = "grand_total"
        case address_id = "address_id"
        case payment_method = "payment_method"
        case booking_otp = "booking_otp"
        case completed_on = "completed_on"
        case rating = "rating"
        case review = "review"
        case is_rated = "is_rated"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case is_review_verified = "is_review_verified"
        case store = "store"
        case user = "user"
        case address = "address"
        case booking_status_text = "booking_status_text"
        case description,table_possition
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
        no_of_persons = try values.decodeIfPresent(String.self, forKey: .no_of_persons)
        booking_date = try values.decodeIfPresent(String.self, forKey: .booking_date)
        booking_from = try values.decodeIfPresent(String.self, forKey: .booking_from)
        booking_to = try values.decodeIfPresent(String.self, forKey: .booking_to)
        booking_status = try values.decodeIfPresent(String.self, forKey: .booking_status)
        item_total = try values.decodeIfPresent(String.self, forKey: .item_total)
        service_charge = try values.decodeIfPresent(String.self, forKey: .service_charge)
        tax = try values.decodeIfPresent(String.self, forKey: .tax)
        grand_total = try values.decodeIfPresent(String.self, forKey: .grand_total)
        address_id = try values.decodeIfPresent(String.self, forKey: .address_id)
        payment_method = try values.decodeIfPresent(String.self, forKey: .payment_method)
        booking_otp = try values.decodeIfPresent(String.self, forKey: .booking_otp)
        completed_on = try values.decodeIfPresent(String.self, forKey: .completed_on)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        review = try values.decodeIfPresent(String.self, forKey: .review)
        is_rated = try values.decodeIfPresent(String.self, forKey: .is_rated)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        is_review_verified = try values.decodeIfPresent(String.self, forKey: .is_review_verified)
        store = try values.decodeIfPresent(Store.self, forKey: .store)
        user = try values.decodeIfPresent(GroundReceivedUser.self, forKey: .user)
        address = try values.decodeIfPresent(Address.self, forKey: .address)
        booking_status_text = try values.decodeIfPresent(String.self, forKey: .booking_status_text)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        table_possition = try values.decodeIfPresent(Postionlist.self, forKey: .table_possition)
    }

}



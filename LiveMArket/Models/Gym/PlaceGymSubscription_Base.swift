//
//  PlaceGymSubscription_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 16/05/23.
//

import Foundation

struct PlaceGymSubscription_Base : Codable {
    let status : String?
    let message : String?
    let oData : PlaceSubscriptionData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(PlaceSubscriptionData.self, forKey: .oData)
    }

}
struct PlaceSubscriptionData : Codable {
    let id : String?
    let user_id : String?
    let store_id : String?
    let package_id : String?
    let subscription_title : String?
    let subscription_no_of_days : String?
    let subscription_end_date : String?
    let subscription_status : String?
    let full_name : String?
    let dial_code : String?
    let phone : String?
    let age : String?
    let gender : String?
    let email : String?
    let sub_total : String?
    let tax : String?
    let service_charge : String?
    let grand_total : String?
    let subscription_invoice_id : String?
    let subscription_number : String?
    let note : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case store_id = "store_id"
        case package_id = "package_id"
        case subscription_title = "subscription_title"
        case subscription_no_of_days = "subscription_no_of_days"
        case subscription_end_date = "subscription_end_date"
        case subscription_status = "subscription_status"
        case full_name = "full_name"
        case dial_code = "dial_code"
        case phone = "phone"
        case age = "age"
        case gender = "gender"
        case email = "email"
        case sub_total = "sub_total"
        case tax = "tax"
        case service_charge = "service_charge"
        case grand_total = "grand_total"
        case subscription_invoice_id = "subscription_invoice_id"
        case subscription_number = "subscription_number"
        case note = "note"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
        package_id = try values.decodeIfPresent(String.self, forKey: .package_id)
        subscription_title = try values.decodeIfPresent(String.self, forKey: .subscription_title)
        subscription_no_of_days = try values.decodeIfPresent(String.self, forKey: .subscription_no_of_days)
        subscription_end_date = try values.decodeIfPresent(String.self, forKey: .subscription_end_date)
        subscription_status = try values.decodeIfPresent(String.self, forKey: .subscription_status)
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        age = try values.decodeIfPresent(String.self, forKey: .age)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        sub_total = try values.decodeIfPresent(String.self, forKey: .sub_total)
        tax = try values.decodeIfPresent(String.self, forKey: .tax)
        service_charge = try values.decodeIfPresent(String.self, forKey: .service_charge)
        grand_total = try values.decodeIfPresent(String.self, forKey: .grand_total)
        subscription_invoice_id = try values.decodeIfPresent(String.self, forKey: .subscription_invoice_id)
        subscription_number = try values.decodeIfPresent(String.self, forKey: .subscription_number)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}

//
//  Authentication.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation

struct Services_Base : Codable {
    let status : String?
    let message : String?
    let oData : ServiceData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ServiceData.self, forKey: .oData)
    }
}


struct normalResponse:Codable, CodableInit {
    let result: Int?
    let message: String?
}

// MARK: - OData
struct ServiceData: Codable,CodableInit {
    var id, user_id, store_id, description: String?
    var status, is_completed, accept_note, amount,booking_date,status_text,currency_code,is_rated: String?
    var service_charges, tax, total_amount, address: String?
    var latitude, longitude, otp ,payment_method, payment_status: String?
    var created_at, updated_at, service_date, service_time: String?
    var location_name, service_invoice_id, complete_note, completed_on: String?
    var rating, review,payment_text, payment_note: String?
    var service_request_images: [ServiceRequestImage]?
    var store :  ServiceStore?
    var user: Customer?
    var distance: TotalDistance?
    var voice_message_url: String?


}

// MARK: - ServiceRequestImage
struct ServiceRequestImage: Codable {
    let id, serviceRequestID: String
    let image: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case serviceRequestID = "service_request_id"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ServiceStore
struct ServiceStore: Codable {
    let id, name: String
    let user_image: String
    let dial_code, phone,profile_url,firebase_user_key: String

    enum CodingKeys: String, CodingKey {
        case id,user_image
        case name = "name"
        case dial_code
        case phone = "phone"
        case profile_url = "profile_url"
        case firebase_user_key = "firebase_user_key"
    }
}

struct MyServicesOrders_Base : Codable {
    let status : String?
    let message : String?
    let oData : MyServicesData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(MyServicesData.self, forKey: .oData)
    }

}
struct MyServicesData : Codable {
    let list : [ServiceData]?
    let currency_code : String?
    let pagination : Pagination?

    enum CodingKeys: String, CodingKey {

        case list = "list"
        case currency_code = "currency_code"
        case pagination = "pagination"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([ServiceData].self, forKey: .list)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)
    }

}


struct TopOptions {
    var name: String?
    var selectedImg : String?
    var unselectedImg : String?
}
struct amenitiesOption {
    var name: String?
    var img : String?
}

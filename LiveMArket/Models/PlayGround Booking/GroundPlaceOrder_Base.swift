//
//  GroundPlaceOrder_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/08/23.
//

import Foundation
struct GroundPlaceOrder_Base : Codable {
    let status : String?
    let message : String?
    let oData : GroundPlaceOrderData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(GroundPlaceOrderData.self, forKey: .oData)
    }

}
struct GroundPlaceOrderData : Codable {
    let booking_id : String?
    let invoice_id : String?

    enum CodingKeys: String, CodingKey {

        case booking_id = "booking_id"
        case invoice_id = "invoice_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        booking_id = try values.decodeIfPresent(String.self, forKey: .booking_id)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
    }

}

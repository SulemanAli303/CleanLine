//
//  PlaceOrder_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 16/06/23.
//

import Foundation
struct PlaceOrder_Base : Codable {
    let status : String?
    let message : String?
    let oData : PlaceOrderData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(PlaceOrderData.self, forKey: .oData)
    }
}

struct PlaceOrderData : Codable {
    let order_id : String?
    let invoice_id : String?

    enum CodingKeys: String, CodingKey {

        case order_id = "order_id"
        case invoice_id = "invoice_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
    }

}

//
//  GroundPaymentComplete_base.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/08/23.
//

import Foundation
struct GroundPaymentComplete_base : Codable {
    let status : Int?
    let message : String?
    let oData : GroundPaymentInitData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(GroundPaymentInitData.self, forKey: .oData)
    }

}




//
//  GroundDetails_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 04/09/23.
//

import Foundation
struct GroundDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : GroundDetailsData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(GroundDetailsData.self, forKey: .oData)
    }

}
struct GroundDetailsData : Codable {
    let ground : Ground?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case ground = "ground"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ground = try values.decodeIfPresent(Ground.self, forKey: .ground)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}

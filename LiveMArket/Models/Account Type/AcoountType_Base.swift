//
//  AcoountType_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 23/08/23.
//

import Foundation

struct AccountType_Model : Codable {
    let status : String?
    let code : String?
    let message : String?
    let oData : [AccountData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case code = "code"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent([AccountData].self, forKey: .oData)
    }

}
struct AccountData : Codable {
    var id : Int?
    var name : String?
    var image : String?
    var capitalized_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case image = "image"
        case capitalized_name = "capitalized_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        capitalized_name = try values.decodeIfPresent(String.self, forKey: .capitalized_name)
    }

}

//
//  FilterData_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 23/08/23.
//

import Foundation

struct FilterData_Base : Codable {
    let status : String?
    let message : String?
    let oData : FilterData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(FilterData.self, forKey: .oData)
    }

}
struct FilterData : Codable {
    let aminity_list : [Aminity_list]?
    let price : Price?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case aminity_list = "aminity_list"
        case price = "price"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aminity_list = try values.decodeIfPresent([Aminity_list].self, forKey: .aminity_list)
        price = try values.decodeIfPresent(Price.self, forKey: .price)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct Aminity_list : Codable {
    let id : String?
    let name : String?
    let icon : String?
    let status : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case icon = "icon"
        case status = "status"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
struct Price : Codable {
    let from : String?
    let to : String?

    enum CodingKeys: String, CodingKey {

        case from = "from"
        case to = "to"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        from = try values.decodeIfPresent(String.self, forKey: .from)
        to = try values.decodeIfPresent(String.self, forKey: .to)
    }

}

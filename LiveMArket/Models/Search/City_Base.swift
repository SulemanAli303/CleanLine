//
//  City_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 24/08/23.
//

import Foundation

struct City_Base : Codable {
    let status : String?
    let message : String?
    let oData : CityData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(CityData.self, forKey: .oData)
    }

}
struct CityData : Codable {
    let list : [CityList]?

    enum CodingKeys: String, CodingKey {

        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([CityList].self, forKey: .list)
    }

}
struct CityList : Codable {
    let id : String?
    let name : String?
    let active : String?
    let country_id : String?
    let state_id : String?
    let created_uid : String?
    let updated_uid : String?
    let deleted : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case active = "active"
        case country_id = "country_id"
        case state_id = "state_id"
        case created_uid = "created_uid"
        case updated_uid = "updated_uid"
        case deleted = "deleted"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        active = try values.decodeIfPresent(String.self, forKey: .active)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        state_id = try values.decodeIfPresent(String.self, forKey: .state_id)
        created_uid = try values.decodeIfPresent(String.self, forKey: .created_uid)
        updated_uid = try values.decodeIfPresent(String.self, forKey: .updated_uid)
        deleted = try values.decodeIfPresent(String.self, forKey: .deleted)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}

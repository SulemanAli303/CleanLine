//
//  ActivityType_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 23/08/23.
//

import Foundation

struct ActivityType_Base : Codable {
    let status : String?
    let code : String?
    let message : String?
    let oData : [ActicityData]?

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
        oData = try values.decodeIfPresent([ActicityData].self, forKey: .oData)
    }

}
struct ActicityData : Codable {
    let id : Int?
    let name : String?
    let logo : String?
    let activity_type_image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case logo = "logo"
        case activity_type_image = "activity_type_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        activity_type_image = try values.decodeIfPresent(String.self, forKey: .activity_type_image)
    }

}

struct ActicityData_new : Codable {
    let id : String?
    let name : String?
    let logo : String?
    let activity_type_image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case logo = "logo"
        case activity_type_image = "activity_type_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        activity_type_image = try values.decodeIfPresent(String.self, forKey: .activity_type_image)
    }

}

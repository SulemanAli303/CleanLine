//
//  FollowModel.swift
//  LiveMArket
//
//  Created by Rupesh E on 04/07/23.
//

import Foundation
struct FollowModel : Codable {
    let status : String?
    let message : String?
    let oData : FollowData?
    let extra_data : Extra_data?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
        case extra_data = "extra_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(FollowData.self, forKey: .oData)
        extra_data = try values.decodeIfPresent(Extra_data.self, forKey: .extra_data)
    }

}
struct FollowData : Codable {
    let list : [FollowList]?

    enum CodingKeys: String, CodingKey {

        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([FollowList].self, forKey: .list)
    }

}
struct FollowList : Codable {
    let name : String?
    let user_image : String?
    let user_id : String?
    let firebase_user_key : String?
    let user_name : String?
    let follow_id : String?
    let is_folowed_by_me : String?
    let followed_from : String?
    let location_name: String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case user_image = "user_image"
        case user_id = "user_id"
        case firebase_user_key = "firebase_user_key"
        case user_name = "user_name"
        case follow_id = "follow_id"
        case is_folowed_by_me = "is_folowed_by_me"
        case followed_from = "followed_from"
        case location_name = "location_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        firebase_user_key = try values.decodeIfPresent(String.self, forKey: .firebase_user_key)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        follow_id = try values.decodeIfPresent(String.self, forKey: .follow_id)
        is_folowed_by_me = try values.decodeIfPresent(String.self, forKey: .is_folowed_by_me)
        followed_from = try values.decodeIfPresent(String.self, forKey: .followed_from)
        location_name = try values.decodeIfPresent(String.self, forKey: .location_name)
    }

}
struct Extra_data : Codable {
    let current_page : String?
    let total_count : String?
    let per_page : String?

    enum CodingKeys: String, CodingKey {

        case current_page = "current_page"
        case total_count = "total_count"
        case per_page = "per_page"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current_page = try values.decodeIfPresent(String.self, forKey: .current_page)
        total_count = try values.decodeIfPresent(String.self, forKey: .total_count)
        per_page = try values.decodeIfPresent(String.self, forKey: .per_page)
    }

}

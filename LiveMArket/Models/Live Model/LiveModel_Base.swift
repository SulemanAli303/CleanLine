//
//  LiveModel.swift
//  LiveMArket
//
//  Created by Rupesh E on 14/07/23.
//

import Foundation
struct LiveModel_Base : Codable {
    let status : String?
    let message : String?
    let oData : LiveData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(LiveData.self, forKey: .oData)
    }

}
struct LiveData : Codable {
    let id : Int?
    let user_id : String?
    let caption : String?
    let path : String?
    let status : String?
    let is_blocked : String?
    let created_at : String?
    let updated_at : String?
    let is_live : String?
    let live_url : String?
    let channel_id : String?
    let zoom : String?
    let width : String?
    let height : String?
    let channel_key : String?
    let views_count : String?
    let like_count : String?
    let comment_count : String?
    let story_url : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case caption = "caption"
        case path = "path"
        case status = "status"
        case is_blocked = "is_blocked"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case is_live = "is_live"
        case live_url = "live_url"
        case channel_id = "channel_id"
        case zoom = "zoom"
        case width = "width"
        case height = "height"
        case channel_key = "channel_key"
        case views_count = "views_count"
        case like_count = "like_count"
        case comment_count = "comment_count"
        case story_url = "story_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        is_blocked = try values.decodeIfPresent(String.self, forKey: .is_blocked)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        is_live = try values.decodeIfPresent(String.self, forKey: .is_live)
        live_url = try values.decodeIfPresent(String.self, forKey: .live_url)
        channel_id = try values.decodeIfPresent(String.self, forKey: .channel_id)
        zoom = try values.decodeIfPresent(String.self, forKey: .zoom)
        width = try values.decodeIfPresent(String.self, forKey: .width)
        height = try values.decodeIfPresent(String.self, forKey: .height)
        channel_key = try values.decodeIfPresent(String.self, forKey: .channel_key)
        views_count = try values.decodeIfPresent(String.self, forKey: .views_count)
        like_count = try values.decodeIfPresent(String.self, forKey: .like_count)
        comment_count = try values.decodeIfPresent(String.self, forKey: .comment_count)
        story_url = try values.decodeIfPresent(String.self, forKey: .story_url)
    }

}

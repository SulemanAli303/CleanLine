//
//  RoomList_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 07/08/23.
//

import Foundation
struct RoomList_Base : Codable {
    let status : String?
    let message : String?
    let oData : RoomListData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(RoomListData.self, forKey: .oData)
    }

}
struct RoomListData : Codable {
    let rooms : [Rooms]?
    let hotel : Hotel?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case rooms = "rooms"
        case hotel = "hotel"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rooms = try values.decodeIfPresent([Rooms].self, forKey: .rooms)
        hotel = try values.decodeIfPresent(Hotel.self, forKey: .hotel)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct Rooms : Codable {
    let id : String?
    let name : String?
    let primary_image : String?
    let description : String?
    let price_type : String?
    let price : String?
    let facilities : [Facilities]?
    let isLiked : String?
    let content : [RoomGalleryContent]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case primary_image = "primary_image"
        case description = "description"
        case price_type = "price_type"
        case price = "price"
        case facilities = "facilities"
        case isLiked = "isLiked"
        case content = "content"
    }


}
struct Hotel : Codable {
    let id : String?
    let user_image : String?
    let name : String?
    let email : String?
    let phone : String?
    let dial_code : String?
    let about_me : String?
    let rating : String?
    let rated_users : String?
    let banner_image : String?
    let profile_url : String?
    let user_location : User_location?
    let is_liked : String?
    let hide_profile : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_image = "user_image"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case dial_code = "dial_code"
        case about_me = "about_me"
        case rating = "rating"
        case rated_users = "rated_users"
        case banner_image = "banner_image"
        case profile_url = "profile_url"
        case user_location = "user_location"
        case is_liked = "is_liked"
        case hide_profile = "hide_profile"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        about_me = try values.decodeIfPresent(String.self, forKey: .about_me)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        rated_users = try values.decodeIfPresent(String.self, forKey: .rated_users)
        banner_image = try values.decodeIfPresent(String.self, forKey: .banner_image)
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
        user_location = try values.decodeIfPresent(User_location.self, forKey: .user_location)
        is_liked = try values.decodeIfPresent(String.self, forKey: .is_liked)
        hide_profile = try values.decodeIfPresent(String.self, forKey: .hide_profile)

    }

}
struct Facilities : Codable {
    let id : String?
    let name : String?
    let icon : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case icon = "icon"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
    }

}


// MARK: - Content
struct RoomGalleryContent: Codable {
    let id: String?
    let reservationProductID: String?
    let contentType: String?
    let content: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case reservationProductID = "reservation_product_id"
        case contentType = "content_type"
        case content = "content"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

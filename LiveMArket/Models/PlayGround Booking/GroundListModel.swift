//
//  GroundListModel.swift
//  LiveMArket
//
//  Created by Rupesh E on 01/08/23.
//

import Foundation

struct GroundListModel : Codable {
    let status : String?
    let message : String?
    let errors : Errors?
    let oData : GroundListData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case errors = "errors"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        errors = try values.decodeIfPresent(Errors.self, forKey: .errors)
        oData = try values.decodeIfPresent(GroundListData.self, forKey: .oData)
    }

}
struct GroundListData : Codable {
    let vendor : GroundVendor?
    let grounds : [Grounds]?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case vendor = "vendor"
        case grounds = "grounds"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        vendor = try values.decodeIfPresent(GroundVendor.self, forKey: .vendor)
        grounds = try values.decodeIfPresent([Grounds].self, forKey: .grounds)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct GroundVendor : Codable {
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
    let isFav : String?
    

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
        case isFav = "isFav"
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
        isFav = try values.decodeIfPresent(String.self, forKey: .isFav)
    }

}
struct Grounds : Codable {
    let id : String?
    let name : String?
    let primary_image : String?
    let description : String?
    let price_type : String?
    let price : String?
    let area : String?
    let isLiked : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case primary_image = "primary_image"
        case description = "description"
        case price_type = "price_type"
        case price = "price"
        case area = "area"
        case isLiked = "isLiked"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        primary_image = try values.decodeIfPresent(String.self, forKey: .primary_image)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        price_type = try values.decodeIfPresent(String.self, forKey: .price_type)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        area = try values.decodeIfPresent(String.self, forKey: .area)
        isLiked = try values.decodeIfPresent(String.self, forKey: .isLiked)
    }

}


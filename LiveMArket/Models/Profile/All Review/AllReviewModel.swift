//
//  AllReviewModel.swift
//  LiveMArket
//
//  Created by Rupesh E on 21/08/23.
//

import Foundation

struct AllReviewModel : Codable {
    let status : String?
    let message : String?
    let oData : ReviewOData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ReviewOData.self, forKey: .oData)
    }

}
struct ReviewOData : Codable {
    let data : ReviewData?

    enum CodingKeys: String, CodingKey {

        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ReviewData.self, forKey: .data)
    }

}
struct ReviewList : Codable {
    let id : String?
    let rating : String?
    let review : String?
    let review_date : String?
    let user_id : String?
    let customer : Customer?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case rating = "rating"
        case review = "review"
        case review_date = "review_date"
        case user_id = "user_id"
        case customer = "customer"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        review = try values.decodeIfPresent(String.self, forKey: .review)
        review_date = try values.decodeIfPresent(String.self, forKey: .review_date)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        customer = try values.decodeIfPresent(Customer.self, forKey: .customer)
    }

}

struct ReviewData : Codable {
    let id : String?
    let name : String?
    let email : String?
    let dial_code : String?
    let phone : String?
    let user_image : String?
    let rating : String?
    let rated_users : String?
    let user_type_id : String?
    let activity_type_id : String?
    let profile_url : String?
    let list : [ReviewList]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case email = "email"
        case dial_code = "dial_code"
        case phone = "phone"
        case user_image = "user_image"
        case rating = "rating"
        case rated_users = "rated_users"
        case user_type_id = "user_type_id"
        case activity_type_id = "activity_type_id"
        case profile_url = "profile_url"
        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        rated_users = try values.decodeIfPresent(String.self, forKey: .rated_users)
        user_type_id = try values.decodeIfPresent(String.self, forKey: .user_type_id)
        activity_type_id = try values.decodeIfPresent(String.self, forKey: .activity_type_id)
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
        list = try values.decodeIfPresent([ReviewList].self, forKey: .list)
    }

}

//
//  DriverReview_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 02/05/23.
//

import Foundation
struct DriverReview_Base : Codable {
    let status : String?
    let message : String?
    let oData : DriverBaseData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(DriverBaseData.self, forKey: .oData)
    }

}
struct DriverBaseData : Codable {
    let data : DriverReviewData?
    let pagination : Pagination?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case pagination = "pagination"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(DriverReviewData.self, forKey: .data)
        pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)
    }

}
struct Pagination : Codable {
    let limit : String?
    let page : String?

    enum CodingKeys: String, CodingKey {

        case limit = "limit"
        case page = "page"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        limit = try values.decodeIfPresent(String.self, forKey: .limit)
        page = try values.decodeIfPresent(String.self, forKey: .page)
    }

}
struct DriverReviewData : Codable {
    let id : String?
    let name : String?
    let email : String?
    let dial_code : String?
    let phone : String?
    let user_image : String?
    let rating : String?
    let rated_users : String?
    let profile_url : String?
    let list : [DriverReviewList]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case email = "email"
        case dial_code = "dial_code"
        case phone = "phone"
        case user_image = "user_image"
        case rating = "rating"
        case rated_users = "rated_users"
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
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
        list = try values.decodeIfPresent([DriverReviewList].self, forKey: .list)
    }

}
struct DriverReviewList : Codable {
    let order_id : String?
    let driver_rating : String?
    let driver_review : String?
    let review_date : String?
    let user_id : String?
    let customer : Customer?

    enum CodingKeys: String, CodingKey {

        case order_id = "order_id"
        case driver_rating = "rating"
        case driver_review = "review"
        case review_date = "review_date"
        case user_id = "user_id"
        case customer = "customer"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        driver_rating = try values.decodeIfPresent(String.self, forKey: .driver_rating)
        driver_review = try values.decodeIfPresent(String.self, forKey: .driver_review)
        review_date = try values.decodeIfPresent(String.self, forKey: .review_date)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        customer = try values.decodeIfPresent(Customer.self, forKey: .customer)
    }

}

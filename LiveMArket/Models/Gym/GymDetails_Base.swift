//
//  GymDetails_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 18/05/23.
//

import Foundation

struct GymDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : GymDetailsOData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(GymDetailsOData.self, forKey: .oData)
    }

}
struct GymDetailsOData : Codable {
    let seller_data : Seller_data?
    let packages_list : [Packages_list]?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case seller_data = "seller_data"
        case packages_list = "packages_list"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        seller_data = try values.decodeIfPresent(Seller_data.self, forKey: .seller_data)
        packages_list = try values.decodeIfPresent([Packages_list].self, forKey: .packages_list)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct Packages_list : Codable {
    let id : String?
    let package_name : String?
    let no_of_days : String?
    let price : String?
    let package_description : String?
    let store_id : String?
    let service_charge : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case package_name = "package_name"
        case no_of_days = "no_of_days"
        case price = "price"
        case package_description = "package_description"
        case store_id = "store_id"
        case service_charge = "service_charge"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        package_name = try values.decodeIfPresent(String.self, forKey: .package_name)
        no_of_days = try values.decodeIfPresent(String.self, forKey: .no_of_days)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        package_description = try values.decodeIfPresent(String.self, forKey: .package_description)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
        service_charge = try values.decodeIfPresent(String.self, forKey: .service_charge)
    }

}
struct Seller_data : Codable {
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
    let user_type_id : String?
    let activity_type_id : String?
    let user_location : User_location?
    let activity_type : Activity_type?

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
        case user_type_id = "user_type_id"
        case activity_type_id = "activity_type_id"
        case user_location = "user_location"
        case activity_type = "activity_type"
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
        user_type_id = try values.decodeIfPresent(String.self, forKey: .user_type_id)
        activity_type_id = try values.decodeIfPresent(String.self, forKey: .activity_type_id)
        user_location = try values.decodeIfPresent(User_location.self, forKey: .user_location)
        activity_type = try values.decodeIfPresent(Activity_type.self, forKey: .activity_type)
    }

}

struct Activity_type : Codable {
    let id : String?
    let name : String?
    let activity_type_image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case activity_type_image = "activity_type_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        activity_type_image = try values.decodeIfPresent(String.self, forKey: .activity_type_image)
    }

}

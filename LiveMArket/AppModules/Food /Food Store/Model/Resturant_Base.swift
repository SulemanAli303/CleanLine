//
//  Resturant_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 05/05/23.
//

import Foundation
struct Resturant_Base : Codable {
    let status : String?
    let message : String?
    let oData : ResturantData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ResturantData.self, forKey: .oData)
    }

}
struct ResturantData : Codable {
    let store_details : Store_details?
    let categories : [FoodCategories]?

    enum CodingKeys: String, CodingKey {

        case store_details = "store_details"
        case categories = "categories"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        store_details = try values.decodeIfPresent(Store_details.self, forKey: .store_details)
        categories = try values.decodeIfPresent([FoodCategories].self, forKey: .categories)
    }

}

struct FoodCategories : Codable {
    let id : String?
    let name : String?
    let image : String?
    let banner_image : String?
    let product_count : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case image = "image"
        case banner_image = "banner_image"
        case product_count = "product_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        banner_image = try values.decodeIfPresent(String.self, forKey: .banner_image)
        product_count = try values.decodeIfPresent(String.self, forKey: .product_count)
    }

}


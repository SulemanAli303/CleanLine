//
//  FoodFav_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 08/09/23.
//

import Foundation

struct FoodFav_Base : Codable {
    let status : String?
    let message : String?
    let oData : FavData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(FavData.self, forKey: .oData)
    }

}
struct FavData : Codable {
    let list : [FavList]?

    enum CodingKeys: String, CodingKey {

        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([FavList].self, forKey: .list)
    }

}
struct FavList : Codable {
    let id : String?
    let product_id : String?
    let user_id : String?
    let created_at : String?
    let updated_at : String?
    let product : [FavProduct]?
    let is_liked : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case product_id = "product_id"
        case user_id = "user_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case product = "product"
        case is_liked = "is_liked"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        product_id = try values.decodeIfPresent(String.self, forKey: .product_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        product = try values.decodeIfPresent([FavProduct].self, forKey: .product)
        is_liked = try values.decodeIfPresent(String.self, forKey: .is_liked)
    }

}
struct FavProduct : Codable {
    let id : String?
    let vendor_id : String?
    let shared_product : String?
    let store_id : String?
    let is_editable_by_outlets : String?
    let product_name : String?
    let regular_price : String?
    let sale_price : String?
    let is_veg : String?
    let promotion : String?
    let product_images : [String]?
    let description : String?
    let deleted : String?
    let product_status : String?
    let created_at : String?
    let updated_at : String?
    let pieces : String?
    let processed_product_images : [String]?
    let processed_default_image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case vendor_id = "vendor_id"
        case shared_product = "shared_product"
        case store_id = "store_id"
        case is_editable_by_outlets = "is_editable_by_outlets"
        case product_name = "product_name"
        case regular_price = "regular_price"
        case sale_price = "sale_price"
        case is_veg = "is_veg"
        case promotion = "promotion"
        case product_images = "product_images"
        case description = "description"
        case deleted = "deleted"
        case product_status = "product_status"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case pieces = "pieces"
        case processed_product_images = "processed_product_images"
        case processed_default_image = "processed_default_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        vendor_id = try values.decodeIfPresent(String.self, forKey: .vendor_id)
        shared_product = try values.decodeIfPresent(String.self, forKey: .shared_product)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
        is_editable_by_outlets = try values.decodeIfPresent(String.self, forKey: .is_editable_by_outlets)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
        regular_price = try values.decodeIfPresent(String.self, forKey: .regular_price)
        sale_price = try values.decodeIfPresent(String.self, forKey: .sale_price)
        is_veg = try values.decodeIfPresent(String.self, forKey: .is_veg)
        promotion = try values.decodeIfPresent(String.self, forKey: .promotion)
        product_images = try values.decodeIfPresent([String].self, forKey: .product_images)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        deleted = try values.decodeIfPresent(String.self, forKey: .deleted)
        product_status = try values.decodeIfPresent(String.self, forKey: .product_status)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        pieces = try values.decodeIfPresent(String.self, forKey: .pieces)
        processed_product_images = try values.decodeIfPresent([String].self, forKey: .processed_product_images)
        processed_default_image = try values.decodeIfPresent(String.self, forKey: .processed_default_image)
    }

}

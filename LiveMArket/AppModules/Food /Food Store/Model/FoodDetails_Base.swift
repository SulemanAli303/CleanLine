//
//  FoodDetails_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 21/08/23.
//

import Foundation
struct FoodDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : FoodProductData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(FoodProductData.self, forKey: .oData)
    }

}
struct FoodProductData : Codable {
    let product_details : Product_details?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case product_details = "product_details"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        product_details = try values.decodeIfPresent(Product_details.self, forKey: .product_details)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct Product_details : Codable {
    let id : String?
    let store_id : String?
    let product_name : String?
    let regular_price : String?
    let sale_price : String?
    let is_veg : String?
    let promotion : String?
    let product_images : [String]?
    let pieces : String?
    let default_image : String?
    var isLiked : String?
    var description : String?
    let product_combo:[FoodProductComboElement]

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case store_id = "store_id"
        case product_name = "product_name"
        case regular_price = "regular_price"
        case sale_price = "sale_price"
        case is_veg = "is_veg"
        case promotion = "promotion"
        case product_images = "product_images"
        case pieces = "pieces"
        case default_image = "default_image"
        case isLiked = "isLiked"
        case description
        case product_combo = "food_product_combo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
        regular_price = try values.decodeIfPresent(String.self, forKey: .regular_price)
        sale_price = try values.decodeIfPresent(String.self, forKey: .sale_price)
        is_veg = try values.decodeIfPresent(String.self, forKey: .is_veg)
        promotion = try values.decodeIfPresent(String.self, forKey: .promotion)
        product_images = try values.decodeIfPresent([String].self, forKey: .product_images)
        pieces = try values.decodeIfPresent(String.self, forKey: .pieces)
        default_image = try values.decodeIfPresent(String.self, forKey: .default_image)
        isLiked = try values.decodeIfPresent(String.self, forKey: .isLiked)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        product_combo = try values.decodeIfPresent([FoodProductComboElement].self, forKey: .product_combo) ?? []
    }

}

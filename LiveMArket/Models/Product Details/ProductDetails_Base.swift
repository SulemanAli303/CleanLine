//
//  ProductDetails_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 19/04/23.
//

import Foundation

struct ProductDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : ProductDetailsData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ProductDetailsData.self, forKey: .oData)
    }

}

struct ProductDetailsData : Codable {
    let product_id : String?
    let product_variant_id : String?
    let product_name : String?
    let product_desc_short : String?
    let product_desc : String?
    let stock_quantity : String?
    let product_seller_id : String?
    let allow_back_order : String?
    let category_id : String?
    let product_brand_id : String?
    let brand_name : String?
    let product_type : String?
    let product_image : String?
    let product_images : [String]?
    let rated_users : String?
    let rating : String?
    let sale_price : String?
    let regular_price : String?
    let product_vendor_id : String?
    let moda_sub_category : String?
    let moda_main_category : String?
    let size_chart : String?
    let store_id : String?
    let offer_enabled : String?
    let offer_percentage : String?
    let vendor_rating : String?
    let is_liked : String?
    let share_link : String?
    let store_details : Store_details?
    let specifications : [String]?
    let product_variations : [Product_variations]?
    let shop_products : [Shop_products]?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case product_id = "product_id"
        case product_variant_id = "product_variant_id"
        case product_name = "product_name"
        case product_desc_short = "product_desc_short"
        case product_desc = "product_desc"
        case stock_quantity = "stock_quantity"
        case product_seller_id = "product_seller_id"
        case allow_back_order = "allow_back_order"
        case category_id = "category_id"
        case product_brand_id = "product_brand_id"
        case brand_name = "brand_name"
        case product_type = "product_type"
        case product_image = "product_image"
        case product_images = "product_images"
        case rated_users = "rated_users"
        case rating = "rating"
        case sale_price = "sale_price"
        case regular_price = "regular_price"
        case product_vendor_id = "product_vendor_id"
        case moda_sub_category = "moda_sub_category"
        case moda_main_category = "moda_main_category"
        case size_chart = "size_chart"
        case store_id = "store_id"
        case offer_enabled = "offer_enabled"
        case offer_percentage = "offer_percentage"
        case vendor_rating = "vendor_rating"
        case is_liked = "is_liked"
        case share_link = "share_link"
        case store_details = "store_details"
        case specifications = "specifications"
        case product_variations = "product_variations"
        case shop_products = "shop_products"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        product_id = try values.decodeIfPresent(String.self, forKey: .product_id)
        product_variant_id = try values.decodeIfPresent(String.self, forKey: .product_variant_id)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
        product_desc_short = try values.decodeIfPresent(String.self, forKey: .product_desc_short)
        product_desc = try values.decodeIfPresent(String.self, forKey: .product_desc)
        stock_quantity = try values.decodeIfPresent(String.self, forKey: .stock_quantity)
        product_seller_id = try values.decodeIfPresent(String.self, forKey: .product_seller_id)
        allow_back_order = try values.decodeIfPresent(String.self, forKey: .allow_back_order)
        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
        product_brand_id = try values.decodeIfPresent(String.self, forKey: .product_brand_id)
        brand_name = try values.decodeIfPresent(String.self, forKey: .brand_name)
        product_type = try values.decodeIfPresent(String.self, forKey: .product_type)
        product_image = try values.decodeIfPresent(String.self, forKey: .product_image)
        product_images = try values.decodeIfPresent([String].self, forKey: .product_images)
        rated_users = try values.decodeIfPresent(String.self, forKey: .rated_users)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        sale_price = try values.decodeIfPresent(String.self, forKey: .sale_price)
        regular_price = try values.decodeIfPresent(String.self, forKey: .regular_price)
        product_vendor_id = try values.decodeIfPresent(String.self, forKey: .product_vendor_id)
        moda_sub_category = try values.decodeIfPresent(String.self, forKey: .moda_sub_category)
        moda_main_category = try values.decodeIfPresent(String.self, forKey: .moda_main_category)
        size_chart = try values.decodeIfPresent(String.self, forKey: .size_chart)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
        offer_enabled = try values.decodeIfPresent(String.self, forKey: .offer_enabled)
        offer_percentage = try values.decodeIfPresent(String.self, forKey: .offer_percentage)
        vendor_rating = try values.decodeIfPresent(String.self, forKey: .vendor_rating)
        is_liked = try values.decodeIfPresent(String.self, forKey: .is_liked)
        share_link = try values.decodeIfPresent(String.self, forKey: .share_link)
        store_details = try values.decodeIfPresent(Store_details.self, forKey: .store_details)
        specifications = try values.decodeIfPresent([String].self, forKey: .specifications)
        product_variations = try values.decodeIfPresent([Product_variations].self, forKey: .product_variations)
        shop_products = try values.decodeIfPresent([Shop_products].self, forKey: .shop_products)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}


struct ProductDetails_Inventory : Codable {
    let product_attribute_id : String?
    let stock_quantity : String?
    let sale_price : String?
    let regular_price : String?
    let image : [String]?
    let size_chart : String?

    enum CodingKeys: String, CodingKey {

        case product_attribute_id = "product_attribute_id"
        case stock_quantity = "stock_quantity"
        case sale_price = "sale_price"
        case regular_price = "regular_price"
        case image = "image"
        case size_chart = "size_chart"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        product_attribute_id = try values.decodeIfPresent(String.self, forKey: .product_attribute_id)
        stock_quantity = try values.decodeIfPresent(String.self, forKey: .stock_quantity)
        sale_price = try values.decodeIfPresent(String.self, forKey: .sale_price)
        regular_price = try values.decodeIfPresent(String.self, forKey: .regular_price)
        image = try values.decodeIfPresent([String].self, forKey: .image)
        size_chart = try values.decodeIfPresent(String.self, forKey: .size_chart)
    }

}

struct Shop_products : Codable {
    let id : String?
    let product_name : String?
    let product_type : String?
    let default_attribute_id : String?
    let is_liked : String?
    let inventory : Inventory?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case product_name = "product_name"
        case product_type = "product_type"
        case default_attribute_id = "default_attribute_id"
        case is_liked = "is_liked"
        case inventory = "inventory"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
        product_type = try values.decodeIfPresent(String.self, forKey: .product_type)
        default_attribute_id = try values.decodeIfPresent(String.self, forKey: .default_attribute_id)
        is_liked = try values.decodeIfPresent(String.self, forKey: .is_liked)
        inventory = try values.decodeIfPresent(Inventory.self, forKey: .inventory)
    }

}

struct Store_details : Codable {
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
    let firebase_user_key : String?
    let user_location : User_location?
    let is_liked: String?


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
        case user_location = "user_location"
        case firebase_user_key = "firebase_user_key"
        case is_liked = "is_liked"
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
        user_location = try values.decodeIfPresent(User_location.self, forKey: .user_location)
        firebase_user_key = try values.decodeIfPresent(String.self, forKey: .firebase_user_key)
        is_liked = try values.decodeIfPresent(String.self, forKey: .is_liked)
    }

}

struct User_location : Codable {
    let id : String?
    let user_id : String?
    let lattitude : String?
    let longitude : String?
    let created_at : String?
    let updated_at : String?
    let location_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case lattitude = "lattitude"
        case longitude = "longitude"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case location_name = "location_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        lattitude = try values.decodeIfPresent(String.self, forKey: .lattitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        location_name = try values.decodeIfPresent(String.self, forKey: .location_name)
    }

}
struct Product_variations : Codable {
    let product_attribute_id : String?
    let attribute_id : String?
    let attribute_type : String?
    let attribute_name : String?
    let attribute_values : [Attribute_values]?

    enum CodingKeys: String, CodingKey {

        case product_attribute_id = "product_attribute_id"
        case attribute_id = "attribute_id"
        case attribute_type = "attribute_type"
        case attribute_name = "attribute_name"
        case attribute_values = "attribute_values"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        product_attribute_id = try values.decodeIfPresent(String.self, forKey: .product_attribute_id)
        attribute_id = try values.decodeIfPresent(String.self, forKey: .attribute_id)
        attribute_type = try values.decodeIfPresent(String.self, forKey: .attribute_type)
        attribute_name = try values.decodeIfPresent(String.self, forKey: .attribute_name)
        attribute_values = try values.decodeIfPresent([Attribute_values].self, forKey: .attribute_values)
    }

}
struct Attribute_values : Codable {
    let attribute_value_id : String?
    let attribute_value_name : String?
    let attribute_value_color : String?
    let is_selected : String?

    enum CodingKeys: String, CodingKey {

        case attribute_value_id = "attribute_value_id"
        case attribute_value_name = "attribute_value_name"
        case attribute_value_color = "attribute_value_color"
        case is_selected = "is_selected"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attribute_value_id = try values.decodeIfPresent(String.self, forKey: .attribute_value_id)
        attribute_value_name = try values.decodeIfPresent(String.self, forKey: .attribute_value_name)
        attribute_value_color = try values.decodeIfPresent(String.self, forKey: .attribute_value_color)
        is_selected = try values.decodeIfPresent(String.self, forKey: .is_selected)
    }

}

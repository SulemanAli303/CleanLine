//
//  FoodCart_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 05/05/23.
//

import Foundation

struct FoodCart_Base : Codable {
    let status : String?
    let message : String?
    let oData : FoodCartData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(FoodCartData.self, forKey: .oData)
    }

}
struct FoodCartData : Codable {
    var cart_items : [Cart_items]?
    var cart_count : String?
    let currency_code : String?
    let cart_subtotal : String?
    let tax_amount : String?
    let delivery_charge : String?
    let cart_grand_total : String?
    let coupon_applied : String?
    let default_address : Default_address?
    let address_list : [Address_list]?
    let discount : String?
    let storeDetails : FoodCartStoreDetails?


    enum CodingKeys: String, CodingKey {

        case cart_items = "cart_items"
        case cart_count = "cart_count"
        case currency_code = "currency_code"
        case cart_subtotal = "cart_subtotal"
        case tax_amount = "tax_amount"
        case delivery_charge = "delivery_charge"
        case cart_grand_total = "cart_grand_total"
        case coupon_applied = "coupon_applied"
        case default_address = "default_address"
        case address_list = "address_list"
        case discount = "discount"
        case storeDetails = "store_details"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cart_items = try values.decodeIfPresent([Cart_items].self, forKey: .cart_items)
        cart_count = try values.decodeIfPresent(String.self, forKey: .cart_count)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        cart_subtotal = try values.decodeIfPresent(String.self, forKey: .cart_subtotal)
        tax_amount = try values.decodeIfPresent(String.self, forKey: .tax_amount)
        delivery_charge = try values.decodeIfPresent(String.self, forKey: .delivery_charge)
        cart_grand_total = try values.decodeIfPresent(String.self, forKey: .cart_grand_total)
        coupon_applied = try values.decodeIfPresent(String.self, forKey: .coupon_applied)
        default_address = try values.decodeIfPresent(Default_address.self, forKey: .default_address)
        address_list = try values.decodeIfPresent([Address_list].self, forKey: .address_list)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        storeDetails = try values.decodeIfPresent(FoodCartStoreDetails.self, forKey: .storeDetails)

    }

}

struct Product : Codable {
    let id : String?
    let store_id : String?
    let product_name : String?
    let regular_price : String?
    let sale_price : String?
    let is_veg : String?
    let promotion : String?
    let product_images : [String]?
    let pieces : String?

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
    }

}
struct Cart_items : Codable {
    let id : String?
    let product_id : String?
    let quantity : String?
    let user_id : String?
    let store_id : String?
    let device_cart_id : String?
    let created_at : String?
    let updated_at : String?
    let subtotal : String?
    let product : Product?
    let combo:[FoodProductComboElement]?
    let cart_combos:[Cart_Combos]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case product_id = "product_id"
        case quantity = "quantity"
        case user_id = "user_id"
        case store_id = "store_id"
        case device_cart_id = "device_cart_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case subtotal = "subtotal"
        case product = "product"
        case combo
        case cart_combos = "cart_combos"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        product_id = try values.decodeIfPresent(String.self, forKey: .product_id)
        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
        device_cart_id = try values.decodeIfPresent(String.self, forKey: .device_cart_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        subtotal = try values.decodeIfPresent(String.self, forKey: .subtotal)
        product = try values.decodeIfPresent(Product.self, forKey: .product)
        combo = try values.decodeIfPresent([FoodProductComboElement].self, forKey: .combo) ?? []
        cart_combos = try values.decodeIfPresent([Cart_Combos].self, forKey: .cart_combos) ?? []

    }
}


struct Cart_Combos : Codable {
    let cart_id : String?
    let combo_quantity : String?
    let combo_item:Combo_Item?

    enum CodingKeys: String, CodingKey {
        case cart_id = "cart_id"
        case combo_item = "combo_item"
        case combo_quantity = "combo_quantity"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cart_id = try values.decodeIfPresent(String.self, forKey: .cart_id)
        combo_quantity = try values.decodeIfPresent(String.self, forKey: .combo_quantity)
        combo_item = try values.decodeIfPresent(Combo_Item.self, forKey: .combo_item)
    }
}

struct Combo_Item : Codable {
    let cart_id : String?
    let currency_code : String?
    let extra_price : String?
    let food_product_combo_id : String?
    let food_product_id : String?
    let id : String?
    let food_item:Product?

    enum CodingKeys: String, CodingKey {
        case cart_id = "cart_id"
        case currency_code = "currency_code"
        case extra_price = "extra_price"
        case food_product_combo_id = "food_product_combo_id"
        case food_product_id = "food_product_id"
        case id = "id"
        case food_item = "food_item"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cart_id = try values.decodeIfPresent(String.self, forKey: .cart_id)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        extra_price = try values.decodeIfPresent(String.self, forKey: .extra_price)
        food_product_combo_id = try values.decodeIfPresent(String.self, forKey: .food_product_combo_id)
        food_product_id = try values.decodeIfPresent(String.self, forKey: .food_product_id)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        food_item = try values.decodeIfPresent(Product.self, forKey: .food_item)
    }
}

struct Address_list : Codable {
    let id : String?
    let full_name : String?
    let dial_code : String?
    let phone : String?
    let address : String?
    let address_type : String?
    let country_id : String?
    let state_id : String?
    let city_id : String?
    let land_mark : String?
    let building_name : String?
    let latitude : String?
    let longitude : String?
    let is_default : String?
    let flat_no : String?
    let postcode : String?
    let country_name : String?
    let state_name : String?
    let city_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case full_name = "full_name"
        case dial_code = "dial_code"
        case phone = "phone"
        case address = "address"
        case address_type = "address_type"
        case country_id = "country_id"
        case state_id = "state_id"
        case city_id = "city_id"
        case land_mark = "land_mark"
        case building_name = "building_name"
        case latitude = "latitude"
        case longitude = "longitude"
        case is_default = "is_default"
        case flat_no = "flat_no"
        case postcode = "postcode"
        case country_name = "country_name"
        case state_name = "state_name"
        case city_name = "city_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        address_type = try values.decodeIfPresent(String.self, forKey: .address_type)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        state_id = try values.decodeIfPresent(String.self, forKey: .state_id)
        city_id = try values.decodeIfPresent(String.self, forKey: .city_id)
        land_mark = try values.decodeIfPresent(String.self, forKey: .land_mark)
        building_name = try values.decodeIfPresent(String.self, forKey: .building_name)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        is_default = try values.decodeIfPresent(String.self, forKey: .is_default)
        flat_no = try values.decodeIfPresent(String.self, forKey: .flat_no)
        postcode = try values.decodeIfPresent(String.self, forKey: .postcode)
        country_name = try values.decodeIfPresent(String.self, forKey: .country_name)
        state_name = try values.decodeIfPresent(String.self, forKey: .state_name)
        city_name = try values.decodeIfPresent(String.self, forKey: .city_name)
    }

}
struct Default_address : Codable {
    let id : String?
    let user_id : String?
    let full_name : String?
    let dial_code : String?
    let phone : String?
    let address : String?
    let country_id : String?
    let state_id : String?
    let city_id : String?
    let address_type : String?
    let status : String?
    let is_default : String?
    let created_at : String?
    let updated_at : String?
    let land_mark : String?
    let building_name : String?
    let latitude : String?
    let longitude : String?
    let flat_no : String?
    let postcode : String?
    let country_name : String?
    let state_name : String?
    let city_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case full_name = "full_name"
        case dial_code = "dial_code"
        case phone = "phone"
        case address = "address"
        case country_id = "country_id"
        case state_id = "state_id"
        case city_id = "city_id"
        case address_type = "address_type"
        case status = "status"
        case is_default = "is_default"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case land_mark = "land_mark"
        case building_name = "building_name"
        case latitude = "latitude"
        case longitude = "longitude"
        case flat_no = "flat_no"
        case postcode = "postcode"
        case country_name = "country_name"
        case state_name = "state_name"
        case city_name = "city_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        state_id = try values.decodeIfPresent(String.self, forKey: .state_id)
        city_id = try values.decodeIfPresent(String.self, forKey: .city_id)
        address_type = try values.decodeIfPresent(String.self, forKey: .address_type)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        is_default = try values.decodeIfPresent(String.self, forKey: .is_default)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        land_mark = try values.decodeIfPresent(String.self, forKey: .land_mark)
        building_name = try values.decodeIfPresent(String.self, forKey: .building_name)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        flat_no = try values.decodeIfPresent(String.self, forKey: .flat_no)
        postcode = try values.decodeIfPresent(String.self, forKey: .postcode)
        country_name = try values.decodeIfPresent(String.self, forKey: .country_name)
        state_name = try values.decodeIfPresent(String.self, forKey: .state_name)
        city_name = try values.decodeIfPresent(String.self, forKey: .city_name)
    }

}


struct FoodCartStoreDetails : Codable {
   
    let id : String?
    let user_type_id : String?

    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_type_id = "user_type_id"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_type_id = try values.decodeIfPresent(String.self, forKey: .user_type_id)
    }

}

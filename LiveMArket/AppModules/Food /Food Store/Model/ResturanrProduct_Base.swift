//
//  ResturanrProduct_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 05/05/23.
//

import Foundation
struct ResturanrProduct_Base : Codable {
    let status : String?
    let message : String?
    let oData : ResturantMenuData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ResturantMenuData.self, forKey: .oData)
    }

}

struct ResturantMenuData : Codable {
    let menus : [Menus]?
    let currency_code : String?

    enum CodingKeys: String, CodingKey {

        case menus = "menus"
        case currency_code = "currency_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        menus = try values.decodeIfPresent([Menus].self, forKey: .menus)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }

}
struct Menus : Codable {
    let id : String?
    let store_id : String?
    let product_name : String?
    let regular_price : String?
    let sale_price : String?
    let is_veg : String?
    let promotion : String?
    let product_images : [String]?
    let pieces : String?
    let isLiked : String?
    let product_combo:[FoodProductComboElement]?

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
        case isLiked = "isLiked"
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
        isLiked = try values.decodeIfPresent(String.self, forKey: .isLiked)
        product_combo = try values.decodeIfPresent([FoodProductComboElement].self, forKey: .product_combo) ?? []
    }

}

class FoodProductComboElement: Codable {
    let id, foodProductID, foodHeadingID, isRequired: String?
    let minSelect, maxSelect, createdAt, updatedAt: String?
    let comboItems: [ComboItem]?
    let foodHeading: FoodHeading?

    enum CodingKeys: String, CodingKey {
        case id
        case foodProductID = "food_product_id"
        case foodHeadingID = "food_heading_id"
        case isRequired = "is_required"
        case minSelect = "min_select"
        case maxSelect = "max_select"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case comboItems = "combo_items"
        case foodHeading = "food_heading"
    }

    init(id: String, foodProductID: String, foodHeadingID: String, isRequired: String, minSelect: String, maxSelect: String, createdAt: String, updatedAt: String, comboItems: [ComboItem], foodHeading: FoodHeading) {
        self.id = id
        self.foodProductID = foodProductID
        self.foodHeadingID = foodHeadingID
        self.isRequired = isRequired
        self.minSelect = minSelect
        self.maxSelect = maxSelect
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.comboItems = comboItems
        self.foodHeading = foodHeading
    }
}

    // MARK: - ComboItem
class ComboItem: Codable {
    let id, foodProductComboID, isDefault, extraPrice: String?
    let createdAt, updatedAt, foodProductID, allowQuantityUpdate: String?
    let foodItem: FoodItem?

    enum CodingKeys: String, CodingKey {
        case id
        case foodProductComboID = "food_product_combo_id"
        case isDefault = "is_default"
        case extraPrice = "extra_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case foodProductID = "food_product_id"
        case allowQuantityUpdate = "allow_quantity_update"
        case foodItem = "food_item"
    }

    init(id: String, foodProductComboID: String, isDefault: String, extraPrice: String, createdAt: String, updatedAt: String, foodProductID: String, allowQuantityUpdate: String, foodItem: FoodItem
    ) {
        self.id = id
        self.foodProductComboID = foodProductComboID
        self.isDefault = isDefault
        self.extraPrice = extraPrice
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.foodProductID = foodProductID
        self.allowQuantityUpdate = allowQuantityUpdate
        self.foodItem = foodItem
    }
}

    // MARK: - FoodItem
class FoodItem: Codable {
    let id, vendorID, sharedProduct, storeID: String?
    let isEditableByOutlets, productName, regularPrice, salePrice: String?
    let isVeg, promotion: String?
    let productImages: [String]?
    let description, deleted, productStatus, createdAt: String?
    let updatedAt, pieces, isAddOnProductOnly: String?
    let processedProductImages: [String]?
    let processedDefaultImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case sharedProduct = "shared_product"
        case storeID = "store_id"
        case isEditableByOutlets = "is_editable_by_outlets"
        case productName = "product_name"
        case regularPrice = "regular_price"
        case salePrice = "sale_price"
        case isVeg = "is_veg"
        case promotion
        case productImages = "product_images"
        case description, deleted
        case productStatus = "product_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pieces
        case isAddOnProductOnly = "is_add_on_product_only"
        case processedProductImages = "processed_product_images"
        case processedDefaultImage = "processed_default_image"
    }

    init(id: String, vendorID: String, sharedProduct: String, storeID: String, isEditableByOutlets: String, productName: String, regularPrice: String, salePrice: String, isVeg: String, promotion: String, productImages: [String], description: String, deleted: String, productStatus: String, createdAt: String, updatedAt: String, pieces: String, isAddOnProductOnly: String, processedProductImages: [String], processedDefaultImage: String) {
        self.id = id
        self.vendorID = vendorID
        self.sharedProduct = sharedProduct
        self.storeID = storeID
        self.isEditableByOutlets = isEditableByOutlets
        self.productName = productName
        self.regularPrice = regularPrice
        self.salePrice = salePrice
        self.isVeg = isVeg
        self.promotion = promotion
        self.productImages = productImages
        self.description = description
        self.deleted = deleted
        self.productStatus = productStatus
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pieces = pieces
        self.isAddOnProductOnly = isAddOnProductOnly
        self.processedProductImages = processedProductImages
        self.processedDefaultImage = processedDefaultImage
    }
}


    // MARK: - FoodHeading
class FoodHeading: Codable {
    let id, name, active, deleted: String
    let createdAt, updatedAt, storeID: String

    enum CodingKeys: String, CodingKey {
        case id, name, active, deleted
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case storeID = "store_id"
    }

    init(id: String, name: String, active: String, deleted: String, createdAt: String, updatedAt: String, storeID: String) {
        self.id = id
        self.name = name
        self.active = active
        self.deleted = deleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.storeID = storeID
    }
}

//
//  MyOrderDetails_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 21/04/23.
//

import Foundation
struct MyOrderDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : MyOrderDetailsData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(MyOrderDetailsData.self, forKey: .oData)
    }

}
struct MyOrderDetailsData : Codable {
    let order_id : String?
    let invoice_id : String?
    let user_id : String?
    let address_id : String?
    let total : String?
    let vat : String?
    let discount : String?
    let grand_total : String?
    let payment_mode : String?
    var status : String?
    let booking_date : String?
    let total_qty : String?
    let total_items_qty : String?
    let oder_type : String?
    let admin_commission : String?
    let vendor_commission : String?
    let shipping_charge : String?
    let created_at : String?
    let updated_at : String?
    let coupon_code : String?
    let coupon_id : String?
    let store_id : String?
    let request_deligate : String?
    let order_otp : String?
    let driver_id : String?
    let driver_rating : String?
    let driver_review : String?
    let store_rating : String?
    let store_review : String?
    let show_pay_button : String?
    let show_cancel : String?
    let currency_code:String?
    let status_text:String?
    let address : Address?
    let products : [Products]?
    let store : Store?
    let deligate : Deligate?
    let driver : Driver?
    let customer : Customer?
    let user_type_id : String?
    let activity_type_id: String?
    let delivery_date: String?
    let scheduled_date : String
    let scheduled_date_text : String

    enum CodingKeys: String, CodingKey {

        case order_id = "order_id"
        case invoice_id = "invoice_id"
        case user_id = "user_id"
        case address_id = "address_id"
        case total = "total"
        case vat = "vat"
        case discount = "discount"
        case grand_total = "grand_total"
        case payment_mode = "payment_mode"
        case status = "status"
        case booking_date = "booking_date"
        case total_qty = "total_qty"
        case total_items_qty = "total_items_qty"
        case oder_type = "oder_type"
        case admin_commission = "admin_commission"
        case vendor_commission = "vendor_commission"
        case shipping_charge = "shipping_charge"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case coupon_code = "coupon_code"
        case coupon_id = "coupon_id"
        case store_id = "store_id"
        case request_deligate = "request_deligate"
        case order_otp = "order_otp"
        case driver_id = "driver_id"
        case driver_rating = "driver_rating"
        case driver_review = "driver_review"
        case store_rating = "store_rating"
        case store_review = "store_review"
        case show_pay_button = "show_pay_button"
        case show_cancel = "show_cancel"
        case status_text = "status_text"
        case currency_code = "currency_code"
        case address = "address"
        case products = "products"
        case store = "store"
        case deligate = "deligate"
        case driver = "driver"
        case customer = "customer"
        case user_type_id = "user_type_id"
        case activity_type_id = "activity_type_id"
        case delivery_date = "delivery_date"
        case scheduled_date = "scheduled_date"
        case scheduled_date_text = "scheduled_date_text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        address_id = try values.decodeIfPresent(String.self, forKey: .address_id)
        total = try values.decodeIfPresent(String.self, forKey: .total)
        vat = try values.decodeIfPresent(String.self, forKey: .vat)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        grand_total = try values.decodeIfPresent(String.self, forKey: .grand_total)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        booking_date = try values.decodeIfPresent(String.self, forKey: .booking_date)
        total_qty = try values.decodeIfPresent(String.self, forKey: .total_qty)
        total_items_qty = try values.decodeIfPresent(String.self, forKey: .total_items_qty)
        oder_type = try values.decodeIfPresent(String.self, forKey: .oder_type)
        admin_commission = try values.decodeIfPresent(String.self, forKey: .admin_commission)
        vendor_commission = try values.decodeIfPresent(String.self, forKey: .vendor_commission)
        shipping_charge = try values.decodeIfPresent(String.self, forKey: .shipping_charge)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        coupon_code = try values.decodeIfPresent(String.self, forKey: .coupon_code)
        coupon_id = try values.decodeIfPresent(String.self, forKey: .coupon_id)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
        request_deligate = try values.decodeIfPresent(String.self, forKey: .request_deligate)
        order_otp = try values.decodeIfPresent(String.self, forKey: .order_otp)
        driver_id = try values.decodeIfPresent(String.self, forKey: .driver_id)
        driver_rating = try values.decodeIfPresent(String.self, forKey: .driver_rating)
        driver_review = try values.decodeIfPresent(String.self, forKey: .driver_review)
        store_rating = try values.decodeIfPresent(String.self, forKey: .store_rating)
        store_review = try values.decodeIfPresent(String.self, forKey: .store_review)
        show_pay_button = try values.decodeIfPresent(String.self, forKey: .show_pay_button)
        show_cancel = try values.decodeIfPresent(String.self, forKey: .show_cancel)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        status_text = try values.decodeIfPresent(String.self, forKey: .status_text)
        address = try values.decodeIfPresent(Address.self, forKey: .address)
        products = try values.decodeIfPresent([Products].self, forKey: .products)
        store = try values.decodeIfPresent(Store.self, forKey: .store)
        deligate = try values.decodeIfPresent(Deligate.self, forKey: .deligate)
        driver = try values.decodeIfPresent(Driver.self, forKey: .driver)
        customer = try values.decodeIfPresent(Customer.self, forKey: .customer)
        user_type_id = try values.decodeIfPresent(String.self, forKey: .user_type_id)
        activity_type_id = try values.decodeIfPresent(String.self, forKey: .activity_type_id)
        delivery_date = try values.decodeIfPresent(String.self, forKey: .delivery_date)
        scheduled_date = try (values.decodeIfPresent(String?.self, forKey: .scheduled_date) ?? "") ?? ""
        scheduled_date_text = try (values.decodeIfPresent(String?.self, forKey: .scheduled_date_text) ?? "") ?? ""

        
    }

}
struct Address : Codable {
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
struct Deligate : Codable {
    let id : String?
    let deligate_name : String?
    let deligate_icon : String?
    let deligate_status : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case deligate_name = "deligate_name"
        case deligate_icon = "deligate_icon"
        case deligate_status = "deligate_status"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        deligate_name = try values.decodeIfPresent(String.self, forKey: .deligate_name)
        deligate_icon = try values.decodeIfPresent(String.self, forKey: .deligate_icon)
        deligate_status = try values.decodeIfPresent(String.self, forKey: .deligate_status)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
struct Products : Codable {
    let id : String?
    let order_id : String?
    let product_id : String?
    let product_attribute_id : String?
    let product_type : String?
    let quantity : String?
    let price : String?
    let discount : String?
    let total : String?
    let vendor_id : String?
    let order_status : String?
    let admin_commission : String?
    let vendor_commission : String?
    let shipping_charge : String?
    let delivered_on : String?
    let is_returned : String?
    let ret_status : String?
    let returned_on : String?
    let ret_reason : String?
    let ret_status_changed_on : String?
    let ret_status_changed_by : String?
    let influencer_id : String?
    let influencer_qty : String?
    let product_variant_id : String?
    let default_attribute_id : String?
    let product_name : String?
    let ret_policy : String?
    let order_status_text : String?
    let is_return_applicable : String?
    let image : String?
    let product_attribute_list: ProductAttributions?
    let product_combo:[ComboItemsSelectedElement]

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case order_id = "order_id"
        case product_id = "product_id"
        case product_attribute_id = "product_attribute_id"
        case product_type = "product_type"
        case quantity = "quantity"
        case price = "price"
        case discount = "discount"
        case total = "total"
        case vendor_id = "vendor_id"
        case order_status = "order_status"
        case admin_commission = "admin_commission"
        case vendor_commission = "vendor_commission"
        case shipping_charge = "shipping_charge"
        case delivered_on = "delivered_on"
        case is_returned = "is_returned"
        case ret_status = "ret_status"
        case returned_on = "returned_on"
        case ret_reason = "ret_reason"
        case ret_status_changed_on = "ret_status_changed_on"
        case ret_status_changed_by = "ret_status_changed_by"
        case influencer_id = "influencer_id"
        case influencer_qty = "influencer_qty"
        case product_variant_id = "product_variant_id"
        case default_attribute_id = "default_attribute_id"
        case product_name = "product_name"
        case ret_policy = "ret_policy"
        case order_status_text = "order_status_text"
        case is_return_applicable = "is_return_applicable"
        case image = "image"
        case product_attribute_list = "product_attribute_list"
        case product_combo = "combo_items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        product_id = try values.decodeIfPresent(String.self, forKey: .product_id)
        product_attribute_id = try values.decodeIfPresent(String.self, forKey: .product_attribute_id)
        product_type = try values.decodeIfPresent(String.self, forKey: .product_type)
        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        total = try values.decodeIfPresent(String.self, forKey: .total)
        vendor_id = try values.decodeIfPresent(String.self, forKey: .vendor_id)
        order_status = try values.decodeIfPresent(String.self, forKey: .order_status)
        admin_commission = try values.decodeIfPresent(String.self, forKey: .admin_commission)
        vendor_commission = try values.decodeIfPresent(String.self, forKey: .vendor_commission)
        shipping_charge = try values.decodeIfPresent(String.self, forKey: .shipping_charge)
        delivered_on = try values.decodeIfPresent(String.self, forKey: .delivered_on)
        is_returned = try values.decodeIfPresent(String.self, forKey: .is_returned)
        ret_status = try values.decodeIfPresent(String.self, forKey: .ret_status)
        returned_on = try values.decodeIfPresent(String.self, forKey: .returned_on)
        ret_reason = try values.decodeIfPresent(String.self, forKey: .ret_reason)
        ret_status_changed_on = try values.decodeIfPresent(String.self, forKey: .ret_status_changed_on)
        ret_status_changed_by = try values.decodeIfPresent(String.self, forKey: .ret_status_changed_by)
        influencer_id = try values.decodeIfPresent(String.self, forKey: .influencer_id)
        influencer_qty = try values.decodeIfPresent(String.self, forKey: .influencer_qty)
        product_variant_id = try values.decodeIfPresent(String.self, forKey: .product_variant_id)
        default_attribute_id = try values.decodeIfPresent(String.self, forKey: .default_attribute_id)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
        ret_policy = try values.decodeIfPresent(String.self, forKey: .ret_policy)
        order_status_text = try values.decodeIfPresent(String.self, forKey: .order_status_text)
        is_return_applicable = try values.decodeIfPresent(String.self, forKey: .is_return_applicable)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        product_attribute_list = try values.decodeIfPresent(ProductAttributions.self, forKey: .product_attribute_list)
        product_combo = try values.decodeIfPresent([ComboItemsSelectedElement].self, forKey: .product_combo) ?? []
    }

}

class ComboItemsSelectedElement: Codable {
    let id, orderID, orderProductID, userID: String
    let foodProductComboID, foodProductItemID, foodProductID, comboQuantity: String
    let comboUnitPrice, comboTotalPrice, createdAt, updatedAt: String
    let productItem: FoodItem

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case orderProductID = "order_product_id"
        case userID = "user_id"
        case foodProductComboID = "food_product_combo_id"
        case foodProductItemID = "food_product_item_id"
        case foodProductID = "food_product_id"
        case comboQuantity = "combo_quantity"
        case comboUnitPrice = "combo_unit_price"
        case comboTotalPrice = "combo_total_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case productItem = "product_item"
    }

    init(id: String, orderID: String, orderProductID: String, userID: String, foodProductComboID: String, foodProductItemID: String, foodProductID: String, comboQuantity: String, comboUnitPrice: String, comboTotalPrice: String, createdAt: String, updatedAt: String, productItem: FoodItem) {
        self.id = id
        self.orderID = orderID
        self.orderProductID = orderProductID
        self.userID = userID
        self.foodProductComboID = foodProductComboID
        self.foodProductItemID = foodProductItemID
        self.foodProductID = foodProductID
        self.comboQuantity = comboQuantity
        self.comboUnitPrice = comboUnitPrice
        self.comboTotalPrice = comboTotalPrice
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.productItem = productItem
    }
}
struct ProductAttributions: Codable {

    let allow_back_order: String?
    let barcode: String?
    let height: String?
    let image: String?
    let image_action: String?
    let image_temp: String?
    let length: String?
    let manage_stock: String?
    let pr_code: String?
    let product_attribute_id: String?
    let product_desc: String?
    let product_full_descr: String?
    let product_id: String?
    let rated_users: String?
    let rating: String?
    let regular_price: String?
    let sale_price: String?
    let shipping_class: String?
    let shipping_note: String?
    let size_chart: String?
    let sold_individually: String?
    let stock_quantity: String?
    let stock_status: String?
    let taxable: String?
    let title: String?
    let weight: String?
    let width: String?
    let product_variations : [ProductVariations]?

    
    enum CodingKeys: String, CodingKey {
        case allow_back_order = "allow_back_order"
        case barcode = "barcode"
        case height = "height"
        case image = "image"
        case image_action = "image_action"
        case image_temp = "image_temp"
        case length = "length"
        case manage_stock = "manage_stock"
        case pr_code = "pr_code"
        case product_attribute_id = "product_attribute_id"
        case product_desc = "product_desc"
        case product_full_descr = "product_full_descr"
        case product_id = "product_id"
        case rated_users = "rated_users"
        case rating = "rating"
        case regular_price = "regular_price"
        case sale_price = "sale_price"
        case shipping_class = "shipping_class"
        case shipping_note = "shipping_note"
        case size_chart = "size_chart"
        case sold_individually = "sold_individually"
        case stock_quantity = "stock_quantity"
        case stock_status = "stock_status"
        case taxable = "taxable"
        case title = "title"
        case weight = "weight"
        case width = "width"
        case product_variations = "product_variations"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        allow_back_order = try values.decodeIfPresent(String.self, forKey: .allow_back_order)
        barcode = try values.decodeIfPresent(String.self, forKey: .barcode)
        height = try values.decodeIfPresent(String.self, forKey: .height)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        image_action = try values.decodeIfPresent(String.self, forKey: .image_action)
        image_temp = try values.decodeIfPresent(String.self, forKey: .image_temp)
        length = try values.decodeIfPresent(String.self, forKey: .length)
        manage_stock = try values.decodeIfPresent(String.self, forKey: .manage_stock)
        pr_code = try values.decodeIfPresent(String.self, forKey: .pr_code)
        product_attribute_id = try values.decodeIfPresent(String.self, forKey: .product_attribute_id)
        product_desc = try values.decodeIfPresent(String.self, forKey: .product_desc)
        product_full_descr = try values.decodeIfPresent(String.self, forKey: .product_full_descr)
        product_id = try values.decodeIfPresent(String.self, forKey: .product_id)
        rated_users = try values.decodeIfPresent(String.self, forKey: .rated_users)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        regular_price = try values.decodeIfPresent(String.self, forKey: .regular_price)
        sale_price = try values.decodeIfPresent(String.self, forKey: .sale_price)
        shipping_class = try values.decodeIfPresent(String.self, forKey: .shipping_class)
        shipping_note = try values.decodeIfPresent(String.self, forKey: .shipping_note)
        size_chart = try values.decodeIfPresent(String.self, forKey: .size_chart)
        sold_individually = try values.decodeIfPresent(String.self, forKey: .sold_individually)
        stock_quantity = try values.decodeIfPresent(String.self, forKey: .stock_quantity)
        stock_status = try values.decodeIfPresent(String.self, forKey: .stock_status)
        taxable = try values.decodeIfPresent(String.self, forKey: .taxable)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        width = try values.decodeIfPresent(String.self, forKey: .width)

        product_variations = try values.decodeIfPresent([ProductVariations].self, forKey: .product_variations)
    }
}

struct ProductVariations: Codable {
    let product_variations_id : String?
    let attribute_id : String?
    let attribute_values_id : String?
    let product_attribute_id : String?
    let product_id: String?
    let product_variation_attribute : Product_Variation_Attribute?
    let product_variation_attribute_value : Product_Variation_Attribute_Value?

    enum CodingKeys: String, CodingKey {

        case product_variations_id = "product_attribute_id"
        case attribute_id = "attribute_id"
        case attribute_values_id = "attribute_type"
        case product_attribute_id = "attribute_name"
        case product_id = "attribute_values"
        case product_variation_attribute = "product_variation_attribute"
        case product_variation_attribute_value = "product_variation_attribute_value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        product_variations_id = try values.decodeIfPresent(String.self, forKey: .product_variations_id)
        attribute_id = try values.decodeIfPresent(String.self, forKey: .attribute_id)
        attribute_values_id = try values.decodeIfPresent(String.self, forKey: .attribute_values_id)
        product_attribute_id = try values.decodeIfPresent(String.self, forKey: .product_attribute_id)
        product_id = try values.decodeIfPresent(String.self, forKey: .product_id)
        product_variation_attribute = try values.decodeIfPresent(Product_Variation_Attribute.self, forKey: .product_variation_attribute)
        product_variation_attribute_value = try values.decodeIfPresent(Product_Variation_Attribute_Value.self, forKey: .product_variation_attribute_value)

    }
}

struct Product_Variation_Attribute: Codable {

    let attribute_id: String?
    let attribute_name: String?
    let attribute_name_arabic: String?
    
    enum CodingKeys: String, CodingKey {

        case attribute_id = "attribute_id"
        case attribute_name = "attribute_name"
        case attribute_name_arabic = "attribute_name_arabic"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attribute_id = try values.decodeIfPresent(String.self, forKey: .attribute_id)
        attribute_name = try values.decodeIfPresent(String.self, forKey: .attribute_name)
        attribute_name_arabic = try values.decodeIfPresent(String.self, forKey: .attribute_name_arabic)
    }
}

struct Product_Variation_Attribute_Value: Codable {

    let attribute_color: String?
    let attribute_value_in: String?
    let attribute_values: String?
    let attribute_values_arabic: String?
    let attribute_values_id: String?
    
    enum CodingKeys: String, CodingKey {

        case attribute_color = "attribute_color"
        case attribute_value_in = "attribute_value_in"
        case attribute_values = "attribute_values"
        case attribute_values_arabic = "attribute_values_arabic"
        case attribute_values_id = "attribute_values_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attribute_color = try values.decodeIfPresent(String.self, forKey: .attribute_color)
        attribute_value_in = try values.decodeIfPresent(String.self, forKey: .attribute_value_in)
        attribute_values = try values.decodeIfPresent(String.self, forKey: .attribute_values)
        attribute_values_arabic = try values.decodeIfPresent(String.self, forKey: .attribute_values_arabic)
        attribute_values_id = try values.decodeIfPresent(String.self, forKey: .attribute_values_id)
    }
    
}

struct Customer : Codable {
    let id : String?
    let name : String?
    let user_image : String?
    let dial_code : String?
    let phone : String?
    let email : String?
    let profile_url : String?
    let firebase_user_key : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case user_image = "user_image"
        case dial_code = "dial_code"
        case phone = "phone"
        case email = "email"
        case profile_url = "profile_url"
        case firebase_user_key = "firebase_user_key"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
        firebase_user_key = try values.decodeIfPresent(String.self, forKey: .firebase_user_key)
    }

}

//
//  DriverOrderDetails_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 27/04/23.
//

import Foundation
struct DriverOrderDetails_Base : Codable {
    let status : String?
    let message : String?
    let oData : DriverOrderDetailsData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(DriverOrderDetailsData.self, forKey: .oData)
    }

}

struct DriverOrderDetailsData : Codable {
    let order_id : String?
    let invoice_id : String?
    let user_id : String?
    let address_id : String?
    let total : String?
    let vat : String?
    let discount : String?
    let grand_total : String?
    let payment_mode : String?
    let status : String?
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
    let status_text : String?
    let show_pay_button : String?
    let show_cancel : String?
    let address : Address?
    let products : [Products]?
    let driver_store_distance : Driver_store_distance?
    let user_store_distance : User_store_distance?
    let total_distance : Total_distance?
    let store : Store?
    let deligate : Deligate?
    let driver : Driver?
    let currency_code: String?
    let customer : Customer?
    let type: String?

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
        case status_text = "status_text"
        case show_pay_button = "show_pay_button"
        case show_cancel = "show_cancel"
        case address = "address"
        case products = "products"
        case driver_store_distance = "driver_store_distance"
        case user_store_distance = "user_store_distance"
        case total_distance = "total_distance"
        case store = "store"
        case deligate = "deligate"
        case driver = "driver"
        case currency_code = "currency_code"
        case customer = "customer"
        case type = "type"
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
        status_text = try values.decodeIfPresent(String.self, forKey: .status_text)
        show_pay_button = try values.decodeIfPresent(String.self, forKey: .show_pay_button)
        show_cancel = try values.decodeIfPresent(String.self, forKey: .show_cancel)
        address = try values.decodeIfPresent(Address.self, forKey: .address)
        products = try values.decodeIfPresent([Products].self, forKey: .products)
        driver_store_distance = try values.decodeIfPresent(Driver_store_distance.self, forKey: .driver_store_distance)
        user_store_distance = try values.decodeIfPresent(User_store_distance.self, forKey: .user_store_distance)
        total_distance = try values.decodeIfPresent(Total_distance.self, forKey: .total_distance)
        store = try values.decodeIfPresent(Store.self, forKey: .store)
        deligate = try values.decodeIfPresent(Deligate.self, forKey: .deligate)
        driver = try values.decodeIfPresent(Driver.self, forKey: .driver)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        customer = try values.decodeIfPresent(Customer.self, forKey: .customer)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }

}
struct Driver_store_distance : Codable {
    let distance : String?
    let time : String?
    let km : String?
    let tm : String?

    enum CodingKeys: String, CodingKey {

        case distance = "distance"
        case time = "time"
        case km = "km"
        case tm = "tm"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        km = try values.decodeIfPresent(String.self, forKey: .km)
        tm = try values.decodeIfPresent(String.self, forKey: .tm)
    }

}
struct Driver : Codable {
    let id : String?
    let name : String?
    let user_image : String?
    let dial_code : String?
    let phone : String?
    let profile_url : String?
    let firebase_user_key :String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case user_image = "user_image"
        case dial_code = "dial_code"
        case phone = "phone"
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
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
        firebase_user_key = try values.decodeIfPresent(String.self, forKey: .firebase_user_key)
    }

}
struct Location_data : Codable {
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
struct Total_distance : Codable {
    let distance : String?
    let time : String?

    enum CodingKeys: String, CodingKey {

        case distance = "distance"
        case time = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        time = try values.decodeIfPresent(String.self, forKey: .time)
    }

}
struct User_store_distance : Codable {
    let distance : String?
    let time : String?
    let km : String?
    let tm : String?

    enum CodingKeys: String, CodingKey {

        case distance = "distance"
        case time = "time"
        case km = "km"
        case tm = "tm"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        km = try values.decodeIfPresent(String.self, forKey: .km)
        tm = try values.decodeIfPresent(String.self, forKey: .tm)
    }

}

//
//  MyReceiveOrders_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 24/04/23.
//

import Foundation
struct MyReceiveOrders_Base : Codable {
    let status : String?
    let message : String?
    let oData : MyReceiveOrdersData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(MyReceiveOrdersData.self, forKey: .oData)
    }

}
struct MyReceiveOrdersData : Codable {
    let list : [MyReceiveOrdersList]?
    let currency_code : String?
    let pagination : Pagination?

    enum CodingKeys: String, CodingKey {

        case list = "list"
        case currency_code = "currency_code"
        case pagination = "pagination"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([MyReceiveOrdersList].self, forKey: .list)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)
    }

}
struct MyReceiveOrdersList : Codable {
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
    let products : [Products]?
    let store : Store?
    let customer: Customer?
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
        case products = "products"
        case store = "store"
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
        products = try values.decodeIfPresent([Products].self, forKey: .products)
        store = try values.decodeIfPresent(Store.self, forKey: .store)
        customer = try values.decodeIfPresent(Customer.self, forKey: .customer)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }

}

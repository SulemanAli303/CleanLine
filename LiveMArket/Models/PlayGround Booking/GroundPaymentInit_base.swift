//
//  GroundPaymentInit_base.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/08/23.
//

import Foundation

struct GroundPaymentInit_base : Codable {
    let status : String?
    let message : String?
    let oData : GroundPaymentInitData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(GroundPaymentInitData.self, forKey: .oData)
    }

}

struct GroundPaymentInitData : Codable {
    let booking_id : String?
    let invoice_number : String?
    let payment_ref : GroundBookingPayment_ref?

    enum CodingKeys: String, CodingKey {

        case booking_id = "booking_id"
        case invoice_number = "invoice_number"
         case payment_ref = "payment_ref"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        booking_id = try values.decodeIfPresent(String.self, forKey: .booking_id)
        invoice_number = try values.decodeIfPresent(String.self, forKey: .invoice_number)
        payment_ref = try values.decodeIfPresent(GroundBookingPayment_ref.self, forKey: .payment_ref)
    }

}

struct GroundBookingPayment_ref : Codable {
    let invoice_id : String?
    let payment_ref : String?

    enum CodingKeys: String, CodingKey {

        case invoice_id = "invoice_id"
        case payment_ref = "payment_ref"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
        payment_ref = try values.decodeIfPresent(String.self, forKey: .payment_ref)
    }

}

//
//  GymPackageDetailBase.swift
//  LiveMArket
//
//  Created by Muhammad Junaid Babar on 02/09/2023.
//

import Foundation

// MARK: - GymPackageDetailBase

struct GymPackageDetailBase: Codable {
    let status: String?
    let message: String?
    let oData: GymPackageDetail?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
}

// MARK: - OData
struct GymPackageDetail: Codable {
    let id: String?
    let packageName: String?
    let noOfDays: String?
    let price: String?
    let packageDescription: String?
    let storeID: String?
    let serviceCharge: String?
    let tax: String?
    let grandTotal: String?
    let currencyCode: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case packageName = "package_name"
        case noOfDays = "no_of_days"
        case price = "price"
        case packageDescription = "package_description"
        case storeID = "store_id"
        case serviceCharge = "service_charge"
        case tax = "tax"
        case grandTotal = "grand_total"
        case currencyCode = "currency_code"
    }
}

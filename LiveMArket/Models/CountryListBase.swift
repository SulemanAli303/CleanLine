//
//  CountryListBase.swift
//  LiveMArket
//
//  Created by Muhammad Junaid Babar on 31/08/2023.
//

import Foundation

// MARK: - CountryListBase
struct CountryListBase: Codable {
    let status: String?
    let message: String?
    let oData: [CountryObj]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
}

// MARK: - ODatum
struct CountryObj: Codable {
    let id: Int?
    let name: String?
    let oDatumPrefix: String?
    let dialCode: String?
    let active: String?
    let createdAt: String?
    let updatedAt: String?
    let deleted: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case oDatumPrefix = "prefix"
        case dialCode = "dial_code"
        case active = "active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deleted = "deleted"
    }
}

//
//  CitiesListBase.swift
//  LiveMArket
//
//  Created by Muhammad Junaid Babar on 31/08/2023.
//

import Foundation

// MARK: - CitiesListBase
struct CitiesListBase: Codable {
    let status: String?
    let message: String?
    let oData: CitiesList?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
}

// MARK: - OData
struct CitiesList: Codable {
    let list: [CityObj]?

    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

// MARK: - List
struct CityObj: Codable {
    let id: String?
    let name: String?
    let active: String?
    let countryID: String?
    let stateID: String?
    let createdUid: String?
    let updatedUid: String?
    let deleted: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case active = "active"
        case countryID = "country_id"
        case stateID = "state_id"
        case createdUid = "created_uid"
        case updatedUid = "updated_uid"
        case deleted = "deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Position list
struct TablePositionBase: Codable {
    let status: String?
    let message: String?
    let oData: TablePositionData?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
}
// MARK: - OData
struct TablePositionData: Codable {
    var list: [Postionlist]?
}

// MARK: - List
struct Postionlist: Codable {
    var id, positionName, status, createdAt: String?
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case positionName = "position_name"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

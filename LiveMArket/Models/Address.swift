//
//  Authentication.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation

struct Address_Base : Codable {
    let status : String?
    let message : String?
    let oData : AddressData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(AddressData.self, forKey: .oData)
    }
}

struct AddressData : Codable {
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let id, fullName, dialCode, phone: String
    let address, addressType, countryID, stateID: String
    let cityID, landMark, buildingName, latitude: String
    let longitude, isDefault, flatNo, postcode: String
    let countryName, stateName, cityName: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case dialCode = "dial_code"
        case phone, address
        case addressType = "address_type"
        case countryID = "country_id"
        case stateID = "state_id"
        case cityID = "city_id"
        case landMark = "land_mark"
        case buildingName = "building_name"
        case latitude, longitude
        case isDefault = "is_default"
        case flatNo = "flat_no"
        case postcode
        case countryName = "country_name"
        case stateName = "state_name"
        case cityName = "city_name"
    }
}

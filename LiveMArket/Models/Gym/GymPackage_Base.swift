//
//  GymPackage_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 15/05/23.
//

import Foundation

struct GymPackage_Base : Codable {
    let status : String?
    let message : String?
    let oData : PackageData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(PackageData.self, forKey: .oData)
    }

}

struct PackageData : Codable {
    let list : [PackageList]?

    enum CodingKeys: String, CodingKey {

        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([PackageList].self, forKey: .list)
    }

}



struct PackageList : Codable {
    let id : String?
    let package_name : String?
    let no_of_days : String?
    let price : String?
    let package_description : String?
    let store_id : String?
    let service_charge : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case package_name = "package_name"
        case no_of_days = "no_of_days"
        case price = "price"
        case package_description = "package_description"
        case store_id = "store_id"
        case service_charge = "service_charge"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        package_name = try values.decodeIfPresent(String.self, forKey: .package_name)
        no_of_days = try values.decodeIfPresent(String.self, forKey: .no_of_days)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        package_description = try values.decodeIfPresent(String.self, forKey: .package_description)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
        service_charge = try values.decodeIfPresent(String.self, forKey: .service_charge)
    }

}

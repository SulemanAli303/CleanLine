//
//  GroundBookingDate_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 01/08/23.
//

import Foundation
struct GroundBookingDate_Base : Codable {
    let data : [GroundBookingDate]?
    let current_page : String?
    let limit : String?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case current_page = "current_page"
        case limit = "limit"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([GroundBookingDate].self, forKey: .data)
        current_page = try values.decodeIfPresent(String.self, forKey: .current_page)
        limit = try values.decodeIfPresent(String.self, forKey: .limit)
    }

}
struct GroundBookingDate : Codable {
    let month_year : String?
    let date : String?
    let day : String?
    let full_date : String?
    let slots : [Slots]?

    enum CodingKeys: String, CodingKey {

        case month_year = "month_year"
        case date = "date"
        case day = "day"
        case full_date = "full_date"
        case slots = "slots"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        month_year = try values.decodeIfPresent(String.self, forKey: .month_year)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        day = try values.decodeIfPresent(String.self, forKey: .day)
        full_date = try values.decodeIfPresent(String.self, forKey: .full_date)
        slots = try values.decodeIfPresent([Slots].self, forKey: .slots)
    }

}
struct Slots : Codable {
    let id : Int?
    let start_time : Int?
    let end_time : Int?
    let slot_value : String?
    let is_available : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case start_time = "start_time"
        case end_time = "end_time"
        case slot_value = "slot_value"
        case is_available = "is_available"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        slot_value = try values.decodeIfPresent(String.self, forKey: .slot_value)
        is_available = try values.decodeIfPresent(Bool.self, forKey: .is_available)
    }

}

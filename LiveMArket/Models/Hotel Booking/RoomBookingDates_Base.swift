//
//  RoomBookingDates_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 07/08/23.
//

import Foundation
struct RoomBookingDates_Base : Codable {
    let status : String?
    let message : String?
    let errors : Errors?
    let oData : RoomBookingDatesData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case errors = "errors"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        errors = try values.decodeIfPresent(Errors.self, forKey: .errors)
        oData = try values.decodeIfPresent(RoomBookingDatesData.self, forKey: .oData)
    }

}
struct RoomBookingDatesData : Codable {
    let room : Rooms?
    let bookings : [String]?

    enum CodingKeys: String, CodingKey {

        case room = "room"
        case bookings = "bookings"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        room = try values.decodeIfPresent(Rooms.self, forKey: .room)
        bookings = try values.decodeIfPresent([String].self, forKey: .bookings)
    }

}

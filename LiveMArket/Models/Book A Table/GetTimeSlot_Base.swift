//
//  GetTimeSlot_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 27/09/23.
//

import Foundation
struct GetTimeSlot_Base : Codable {
    let status : String?
    let message : String?
    let oData : SlotData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(SlotData.self, forKey: .oData)
    }

}
struct SlotData : Codable {
    let slot_list : [Slot_list]?
 
    let currency_code : String
    let tax : String
    let service_charge : String
    let grand_total : String
    let max_no_of_seats_can_be_selected : String
    
    enum CodingKeys: String, CodingKey {

        case slot_list = "slot_list"

        case currency_code = "currency_code"
        case tax = "tax"
        case service_charge = "service_charge"
        case grand_total = "grand_total"
        case max_no_of_seats_can_be_selected = "max_no_of_seats_can_be_selected"

        
    }

    init(from decoder: Decoder) throws {
     
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slot_list = try values.decodeIfPresent([Slot_list].self, forKey: .slot_list)
       
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code) ?? ""
        tax = try values.decodeIfPresent(String.self, forKey: .tax) ?? ""
        service_charge = try values.decodeIfPresent(String.self, forKey: .service_charge) ?? ""
        grand_total = try values.decodeIfPresent(String.self, forKey: .grand_total) ?? ""
        max_no_of_seats_can_be_selected = try values.decodeIfPresent(String.self, forKey: .max_no_of_seats_can_be_selected) ?? ""

        
    }

}
struct Slot_list : Codable {
    let slot_text : String?
    let slot_from : String?
    let slot_to : String?
    let is_available : String?
    let max_no_of_seats_can_be_selected : String

    enum CodingKeys: String, CodingKey {

        case slot_text = "slot_text"
        case slot_from = "slot_from"
        case slot_to = "slot_to"
        case is_available = "is_available"
        case max_no_of_seats_can_be_selected = "max_no_of_seats_can_be_selected"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slot_text = try values.decodeIfPresent(String.self, forKey: .slot_text)
        slot_from = try values.decodeIfPresent(String.self, forKey: .slot_from)
        slot_to = try values.decodeIfPresent(String.self, forKey: .slot_to)
        is_available = try values.decodeIfPresent(String.self, forKey: .is_available)
        max_no_of_seats_can_be_selected = try values.decodeIfPresent(String.self, forKey: .max_no_of_seats_can_be_selected) ?? ""

    }

}

//
//  GenericResponse.swift
//  ISHELF
//
//  Created by A2 MacBook Pro 2012 on 17/08/20.
//  Copyright © 2020 a2solution. All rights reserved.
//
import UIKit
import Foundation

struct GenericResponse : Codable {
    let message : String?
    let status : String?
    
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}


struct DeliveryRepresentative {
    var userImg : UIImageView? = nil
    var driverName: String? = nil
    var residencyNo : String? = nil
    var dob : String? = nil
    var nationality :String? = nil
}

struct StartLive_Base : Codable {
    let status : String?
    let message : String?
    let oData : StartLive_Response?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
}
struct StartLive_Response : Codable {
    let story_id : String?
    enum CodingKeys: String, CodingKey {
        case story_id = "story_id"
    }
}

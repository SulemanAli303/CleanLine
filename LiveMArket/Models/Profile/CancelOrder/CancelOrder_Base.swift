//
//  CancelOrder_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 24/04/23.
//

import Foundation

struct CancelOrder_Base : Codable {
    
    let status : String?
    let message : String?
    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

//
//  PlaceModel.swift
//  Oodle
//
//  Created by Albin Jose on 25/11/21.
//

import Foundation
struct PlaceModel: Codable {
    let name : String?
    let latitude : Double?
    let longitude : Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
    }
}

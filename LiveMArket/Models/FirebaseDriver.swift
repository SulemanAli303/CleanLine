//
//  FirebaseDriver.swift
//  orderat
//
//  Created by A2 MacBook Pro 2012 on 04/01/21.
//

import Foundation
import CoreLocation

struct FirebaseDriver : Codable {
    let latitude : Double?
    let longitude : Double?
    var coordinate:CLLocationCoordinate2D?
    var bearing : Double?
    
    enum CodingKeys: String, CodingKey {

        case latitude = "latitude"
        case longitude = "longitude"
        case bearing = "Bearing"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        bearing = try values.decodeIfPresent(Double.self, forKey: .bearing)
        self.coordinate = CLLocationCoordinate2D(latitude: Double(latitude ?? 0.00) , longitude: Double(longitude ?? 0.00))
    }
}

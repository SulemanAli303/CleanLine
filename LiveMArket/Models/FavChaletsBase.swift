//
//  FavChaletsBase.swift
//  LiveMArket
//
//  Created by Muhammad Junaid Babar on 31/08/2023.
//

import Foundation

struct FavChaletsBase: Codable {
    let status: String?
    let message: String?
    let oData: [ChaletsList]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
}

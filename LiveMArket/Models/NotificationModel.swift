
//
//  NotificationModel.swift
//  Khiat
//
//  Created by Mac User on 13/03/20.
//  Copyright © 2020 Mac User. All rights reserved.
//

import UIKit

class NotificationModel: Codable {
    var key : String?
    let title : String?
    let orderId : String?
    let description : String?
    let notificationType : String?
    let read : String?
    let seen : String?
    let createdAt : String?
    let imageURL : String?
    let url : String?
    let enquiryType : String?
    let type : String?
    let user_id : Int?
    let follow_id : String?
    let invoiceId: String?
    let showPopup : String?
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case title = "title"
        case orderId = "orderId"
        case description = "description"
        case notificationType = "notificationType"
        case read = "read"
        case seen = "seen"
        case createdAt = "createdAt"
        case imageURL = "imageURL"
        case url = "url"
        case enquiryType = "enquiryType"
        case type = "type"
        case user_id = "user_id"
        case follow_id = "follow_id"
        case invoiceId = "invoiceId"
        case showPopup = "showPopup"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
        read = try values.decodeIfPresent(String.self, forKey: .read)
        seen = try values.decodeIfPresent(String.self, forKey: .seen)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        enquiryType = try values.decodeIfPresent(String.self, forKey: .enquiryType)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        follow_id = try values.decodeIfPresent(String.self, forKey: .follow_id)
        invoiceId = try values.decodeIfPresent(String.self, forKey: .invoiceId)
        showPopup = try values.decodeIfPresent(String.self, forKey: .showPopup)
    }
}

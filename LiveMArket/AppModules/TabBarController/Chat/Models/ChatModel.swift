
//
//  NotificationModel.swift
//  Khiat
//
//  Created by Mac User on 13/03/20.
//  Copyright © 2020 Mac User. All rights reserved.
//

import UIKit

class ChatModel: Codable {
    var id : String?
    var senderId : Int?
    var senderImageURL : String?
    var senderName : String?
    var text : String?
    var timeStamp : Int64?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case senderId = "senderId"
        case senderImageURL = "senderImageURL"
        case senderName = "senderName"
        case text = "text"
        case timeStamp = "timeStamp"

    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        senderId = try values.decodeIfPresent(Int.self, forKey: .senderId)
        senderImageURL = try values.decodeIfPresent(String.self, forKey: .senderImageURL)
        senderName = try values.decodeIfPresent(String.self, forKey: .senderName)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        timeStamp = try values.decodeIfPresent(Int64.self, forKey: .timeStamp)

    }
}
struct ChatModel2: Codable {
    public var message : String?
    public var userId : String?
    public var messageTimeStamp : Int?
    public var type : String?
    public var read:String?
    public var senderImageURL : String?
    public var ImageURL : String?
    public var audioURL : String?
    var key : String?
    var isPlaying: Bool?
    var id : String?
    var localFile: URL?
    var waveFormImage: String?

    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case userId = "sentBy"
        case messageTimeStamp = "messageTimeStamp"
        case type = "type"
        case read = "read"
        case senderImageURL = "senderImageURL"
        case ImageURL = "ImageURL"
        case audioURL = "audioURL"
        case key = "key"
        case isPlaying = "isPlaying"
        case id = "id"
        case localFile = "localFile"
        case waveFormImage = "waveFormImage"
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        messageTimeStamp = try values.decodeIfPresent(Int.self, forKey: .messageTimeStamp)
//        type = try values.decodeIfPresent(String.self, forKey: .type)
//        read =  try values.decodeIfPresent(String.self, forKey: .read)
//        senderImageURL = try values.decodeIfPresent(String.self, forKey: .senderImageURL)
//        ImageURL = try values.decodeIfPresent(String.self, forKey: .ImageURL)
//        audioURL = try values.decodeIfPresent(String.self, forKey: .audioURL)
//        key =  try values.decodeIfPresent(String.self, forKey: .key)
//        isPlaying =  try values.decodeIfPresent(Bool.self, forKey: .isPlaying)
//        id =  try values.decodeIfPresent(String.self, forKey: .id)
//        localFile =  try values.decodeIfPresent(URL.self, forKey: .localFile)
//        waveFormImage =  try values.decodeIfPresent(String.self, forKey: .waveFormImage)
//    }
}


struct ChatListItemModel: Codable {
    public var chatRoomId : String?
    public var lastMessage : String?
    public var profileImageUrl : String?
    public var userId : String?
    public var userName : String?
    public var socialKey : String?
    public var type : String?
    public var lastUpdatedAt : Int?
    public var sentBy : String?

    enum CodingKeys: String, CodingKey {
        case chatRoomId = "chat_room_id"
        case lastMessage = "last_message"
        case profileImageUrl = "user_img"
        case userId = "user_id"
        case userName = "user_name"
        case socialKey = "social_key"
        case lastUpdatedAt
        case type = "type"
        case sentBy = "sentBy"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        chatRoomId = try values.decodeIfPresent(String.self, forKey: .chatRoomId)
        lastMessage = try values.decodeIfPresent(String.self, forKey: .lastMessage)
        profileImageUrl = try values.decodeIfPresent(String.self, forKey: .profileImageUrl)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        socialKey = try values.decodeIfPresent(String.self, forKey: .socialKey)
        lastUpdatedAt = try values.decodeIfPresent(Int.self, forKey: .lastUpdatedAt)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sentBy  = try values.decodeIfPresent(String.self, forKey: .sentBy)
    }
}

class ChatMainModel: Codable {
    var active : String?
    var challengeId : Int?
    var chatName : String?
    var id : String?
    var type : Int?
    var lastMessage : ChatModel?
    var members : NSDictionary?
    var name : String?

    enum CodingKeys: String, CodingKey {
        case active = "active"
        case challengeId = "challengeId"
        case chatName = "chatName"
        case id = "id"
        case type = "type"
        case lastMessage = "lastMessage"
        //case members = "members"


    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(String.self, forKey: .active)
        challengeId = try values.decodeIfPresent(Int.self, forKey: .challengeId)
        chatName = try values.decodeIfPresent(String.self, forKey: .chatName)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        lastMessage = try values.decodeIfPresent(ChatModel.self, forKey: .lastMessage)
        //members = try values.decode(NSDictionary.self, forKey: .members)

    }
}
struct MembersModel : Codable {
    let companyName : String?
    let designation : String?
    let email : String?
    let id : Int?
    let imageUrl : String?
    let name : String?
   
    enum CodingKeys: String, CodingKey {
        case companyName = "companyName"
        case designation = "designation"
        case email = "email"
        case id = "id"
        case imageUrl = "imageUrl"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
        designation = try values.decodeIfPresent(String.self, forKey: .designation)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        name = try values.decodeIfPresent(String.self, forKey: .imageUrl)

    }

}

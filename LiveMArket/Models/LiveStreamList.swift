//
//  LiveStreamList.swift
//  LiveMArket
//
//  Created by Ramamoorthy on 10/06/23.
//

import Foundation

struct LiveStreamBase: Codable {
    let status: Int
    let liveStreamCollection: [LiveStreamList]
    let livestreamCount: String
    let offset: Int
}

// MARK: - LiveStreamCollection
struct LiveStreamList: Codable,Equatable {
    let storyID, userID: String
    let storyThumb: String
    let createdAt, channelID, channelKey, postedUserName: String
    let postedUserImageurl: String
    let firebaseUserKey, deviceToken: String

    enum CodingKeys: String, CodingKey {
        case storyID = "storyId"
        case userID = "userId"
        case storyThumb, createdAt
        case channelID = "channelId"
        case channelKey = "channel_key"
        case postedUserName, postedUserImageurl, firebaseUserKey, deviceToken
    }

    static func ==(lhs: LiveStreamList, rhs: LiveStreamList) -> Bool {
        return lhs.storyID == rhs.storyID && lhs.userID == rhs.userID
    }
    
    static func ==(lhs: String, rhs: LiveStreamList) -> Bool {
        return lhs == rhs.storyID
    }
}

struct LiveStreamObserverBase: Codable {
    let data: LiveStreamList
}
struct SocketGeneralResponse : Codable {
    let status: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    }
}

/// Live view
struct LiveStreamViewsBase: Codable {
    let status: Int
  //  let viewerCollection: [LiveStreamViewsList]
    let viewerCount: String
}

struct LiveStreamViewsList: Codable {
    let userName, userID: String
    let userImageurl: String

    enum CodingKeys: String, CodingKey {
        case userName = "userName"
        case userID = "userId"
        case userImageurl = "userImageurl"
    }
}

/// Live comments
struct LiveStreamCommentsBase: Codable {
    let status: Int
    let commentCollection : [LiveStreamComments]
  //  let commentCount: String
}

struct LiveStreamComments: Codable {
    let commentId : String
    let commentAt : String
    let comment: String
    let commentedUserName: String
    let commentedUserImageurl : String
    //    let commentedUserId : Int
    
    enum CodingKeys: String, CodingKey {
        case commentId = "commentId"
        case commentAt = "commentAt"
        case comment = "comment"
        case commentedUserName = "commentedUserName"
        case commentedUserImageurl = "commentedUserImageurl"
        //        case commentedUserId = "commentedUserId"
    }
}

/// Live single comment
struct LiveStreamSingleCommentBase: Codable {
    let storyId: Int
    let comment: [LiveStreamComments]
    let commentCount: String
}

/// Live view count
struct LiveViewCount : Codable {
    let storyId: Int
    let viewerCount: String
    
    enum CodingKeys: String, CodingKey {
        case storyId = "storyId"
        case viewerCount = "viewerCount"
    }
}

struct EndStream : Codable {
    let storyId: Int
    
    enum CodingKeys: String, CodingKey {
        case storyId = "storyId"
    }
}

/// Live view count
struct LiveComment : Codable {
    let storyId: String
   
    
    enum CodingKeys: String, CodingKey {
        case storyId = "storyId"
    }
}

//
//  PostCommont_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 26/06/23.
//

import Foundation
struct PostCommont_Base : Codable {
    let status : Int?
    let offset : Int?
    let limit : String?
    let commentCount : String?
    let commentCollection:[CommentCollection]?
    

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case commentCollection = "commentCollection"
        case offset = "offset"
        case limit = "limit"
        case commentCount = "commentCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
        limit = try values.decodeIfPresent(String.self, forKey: .limit)
        commentCount = try values.decodeIfPresent(String.self, forKey: .commentCount)
        commentCollection = try values.decodeIfPresent([CommentCollection].self, forKey: .commentCollection)
    }

}
struct CommentCollection : Codable {
        let commentId : String?
        let commentAt : String?
        let comment : String?
        let commentedUserName : String?
        let commentedUserId : String?
        let commentedUserImageurl : String?
        let isLiked : String?
        let likeCount : String?
        let taggedUsers : [String]?
        let childComments : [CommentCollection]?

        enum CodingKeys: String, CodingKey {

            case commentId = "commentId"
            case commentAt = "commentAt"
            case comment = "comment"
            case commentedUserName = "commentedUserName"
            case commentedUserId = "commentedUserId"
            case commentedUserImageurl = "commentedUserImageurl"
            case isLiked = "isLiked"
            case likeCount = "likeCount"
            case taggedUsers = "taggedUsers"
            case childComments = "childComments"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            commentId = try values.decodeIfPresent(String.self, forKey: .commentId)
            commentAt = try values.decodeIfPresent(String.self, forKey: .commentAt)
            comment = try values.decodeIfPresent(String.self, forKey: .comment)
            commentedUserName = try values.decodeIfPresent(String.self, forKey: .commentedUserName)
            commentedUserId = try values.decodeIfPresent(String.self, forKey: .commentedUserId)
            commentedUserImageurl = try values.decodeIfPresent(String.self, forKey: .commentedUserImageurl)
            isLiked = try values.decodeIfPresent(String.self, forKey: .isLiked)
            likeCount = try values.decodeIfPresent(String.self, forKey: .likeCount)
            taggedUsers = try values.decodeIfPresent([String].self, forKey: .taggedUsers)
            childComments = try values.decodeIfPresent([CommentCollection].self, forKey: .childComments)
        }

    }

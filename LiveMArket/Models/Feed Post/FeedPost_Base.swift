//
//  FeedPost_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 01/06/23.
//

import Foundation


struct FeedPost_Base : Codable {
    let status : Int?
    let postCollection : [PostCollection]?
    //let currentPage : Int?
    let totalPostCount:String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case postCollection = "postCollection"
        case totalPostCount = "totalPostCount"
       // case currentPage = "currentPage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        postCollection = try values.decodeIfPresent([PostCollection].self, forKey: .postCollection)
        totalPostCount = try values.decodeIfPresent(String.self, forKey: .totalPostCount)
        //currentPage = try values.decodeIfPresent(Int.self, forKey: .currentPage)
    }

}
struct PostCollection : Codable {
    let postId : String?
    let postCaption : String?
    let postCreatedAt : String?
    let postedUserId : String?
    let postedUserName : String?
    var isIamFollowing : String?
    var commentCount : String?
    let likeCount : String?
    let isIReacted : Int?
    let activityType : String?
    let acccountType : String?
    let commentId : String?
    let commentAt : String?
    let comment : String?
    let commentedUserName : String?
    let commentedUserId : String?
    let postsFiles : [PostsFiles]?
    let postedUserImageurl : String?
    let activityTypeId : String?
    let userTypeId : String?
    let shareUrl : String?
    let hasProduct : Int?
    let isLive : Int?
    let orderCount : Int?
    let activityTypeLogo: String?
    let isDefaultPost : String?

    enum CodingKeys: String, CodingKey {

        case postId = "postId"
        case postCaption = "postCaption"
        case postCreatedAt = "postCreatedAt"
        case postedUserId = "postedUserId"
        case postedUserName = "postedUserName"
        case isIamFollowing = "isIamFollowing"
        case commentCount = "commentCount"
        case likeCount = "likeCount"
        case isIReacted = "isIReacted"
        case activityType = "activityType"
        case acccountType = "acccountType"
        case commentId = "commentId"
        case commentAt = "commentAt"
        case comment = "comment"
        case commentedUserName = "commentedUserName"
        case commentedUserId = "commentedUserId"
        case postsFiles = "postsFiles"
        case postedUserImageurl = "postedUserImageurl"
        case activityTypeId = "activityTypeId"
        case userTypeId = "userTypeId"
        case shareUrl = "shareUrl"
        case hasProduct = "hasProduct"
        case isLive = "isLive"
        case orderCount = "orderCount"
        case activityTypeLogo = "activityTypeLogo"
        case isDefaultPost = "isDefaultPost"
        
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId = try values.decodeIfPresent(String.self, forKey: .postId)
        postCaption = try values.decodeIfPresent(String.self, forKey: .postCaption)
        postCreatedAt = try values.decodeIfPresent(String.self, forKey: .postCreatedAt)
        postedUserId = try values.decodeIfPresent(String.self, forKey: .postedUserId)
        postedUserName = try values.decodeIfPresent(String.self, forKey: .postedUserName)
        isIamFollowing = try values.decodeIfPresent(String.self, forKey: .isIamFollowing)
        commentCount = try values.decodeIfPresent(String.self, forKey: .commentCount)
        likeCount = try values.decodeIfPresent(String.self, forKey: .likeCount)
        isIReacted = try values.decodeIfPresent(Int.self, forKey: .isIReacted)
        activityType = try values.decodeIfPresent(String.self, forKey: .activityType)
        acccountType = try values.decodeIfPresent(String.self, forKey: .acccountType)
        commentId = try values.decodeIfPresent(String.self, forKey: .commentId)
        commentAt = try values.decodeIfPresent(String.self, forKey: .commentAt)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        commentedUserName = try values.decodeIfPresent(String.self, forKey: .commentedUserName)
        commentedUserId = try values.decodeIfPresent(String.self, forKey: .commentedUserId)
        postsFiles = try values.decodeIfPresent([PostsFiles].self, forKey: .postsFiles)
        postedUserImageurl = try values.decodeIfPresent(String.self, forKey: .postedUserImageurl)
        activityTypeId = try values.decodeIfPresent(String.self, forKey: .activityTypeId)
        userTypeId = try values.decodeIfPresent(String.self, forKey: .userTypeId)
        shareUrl = try values.decodeIfPresent(String.self, forKey: .shareUrl)
        hasProduct = try values.decodeIfPresent(Int.self, forKey: .hasProduct)
        isLive = try values.decodeIfPresent(Int.self, forKey: .isLive)
        orderCount = try values.decodeIfPresent(Int.self, forKey: .orderCount)
        activityTypeLogo = try values.decodeIfPresent(String.self, forKey: .activityTypeLogo)
        isDefaultPost = try values.decodeIfPresent(String.self, forKey: .isDefaultPost)
    }

}
struct PostsFiles : Codable {
    let height : String?
    let width : String?
    let extensions : String?
    let is_default : String?
    let url : String?
    let created_at : String?
    let duration : String?
    let thumb_image : String?
    let have_hls_url : String?
    let hls_url : String?
    let hls_cdn_url : String?
    let thumb_cdn_image : String?
    

    enum CodingKeys: String, CodingKey {

        case height = "height"
        case width = "width"
        case extensions = "extension"
        case is_default = "is_default"
        case url = "url"
        case created_at = "created_at"
        case duration = "duration"
        case thumb_image = "thumb_image"
        case have_hls_url = "have_hls_url"
        case hls_url = "hls_url"
        case hls_cdn_url = "hls_cdn_url"
        case thumb_cdn_image = "thumb_cdn_image"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        height = try values.decodeIfPresent(String.self, forKey: .height)
        width = try values.decodeIfPresent(String.self, forKey: .width)
        extensions = try values.decodeIfPresent(String.self, forKey: .extensions)
        is_default = try values.decodeIfPresent(String.self, forKey: .is_default)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)
        thumb_image = try values.decodeIfPresent(String.self, forKey: .thumb_image)
        have_hls_url = try values.decodeIfPresent(String.self, forKey: .have_hls_url)
        hls_url = try values.decodeIfPresent(String.self, forKey: .hls_url)
        hls_cdn_url = try values.decodeIfPresent(String.self, forKey: .hls_cdn_url)
        thumb_cdn_image = try values.decodeIfPresent(String.self, forKey: .thumb_cdn_image)
        
    }

}

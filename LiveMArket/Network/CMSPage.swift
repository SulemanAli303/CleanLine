//
//  CMSPage.swift
//  LiveMArket
//
//  Created by Albin Jose on 13/07/23.
//

import Foundation

struct CMS_Base : Codable {
    let status : String?
    let message : String?
    let oData : CMS_Data?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
}

struct CMS_Data : Codable {
    let title_en : String?
    let title_ar : String?
    let status : Int?
    let desc_en : String?
    let desc_ar : String?
    let meta_title : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case title_en = "title_en"
        case title_ar = "title_ar"
        case status = "status"
        case desc_en = "desc_en"
        case desc_ar = "desc_ar"
        case meta_title = "meta_title"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

}

//
//  ProfileDetailModel.swift
//  CounselHub
//
//  Created by ZAFAR on 10/08/2022.
//

import Foundation

struct ProfileDetailUser : Codable {
    var key : String?
    var user_id: Int?
    var name : String?
    var email : String?
    var dial_code : String?
    var phone : String?
    var phone_verified : Int?
    var email_verified_at : String?
    var user_type : String?
    var first_name : String?
    var last_name : String?
    var user_image : String?
    var user_phone_otp : String?
    var user_device_token : String?
    var user_device_type : String?
    var user_access_token : String?
    var firebase_user_key : String?
    var created_at : String?
    var updated_at : String?
    var company_name : String?
    var linkedin : String?
    var instagram : String?
    var twitter : String?
    var facebook : String?
    var website : String?
    var is_active:Bool?
    var designation : String?
    var profile_type_id : String?
    var status : Int?
    var service_1 : String?
    var service_2 : String?
    var service_3 : String?
    var no_of_emplyees : String?
    var age_of_company : String?
   // var business_type_id : String?
    var gender : String?
    var nationality : String?
    var trade_license : String?
    var social_key : String?
    var user_post_as : String?
    var bio : String?
    var business_name : String?
    var imgUrl : [String]?
    var password:String?
    var anonymous_name:String?

    
}


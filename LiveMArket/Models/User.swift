//
//  User.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation

struct User : Codable {
    
    let id : String?
    let accessToken : String?
    let name : String?
    let email : String?
    let image : String?
    let dial_code : String?
    let phone_number : String?
    let firebase_user_key : String?
    let user_type : String?
    let first_name : String?
    let last_name : String?
    let device_token : String?
    let company_name : String?
    let instagram : String?
    let twitter : String?
    let facebook : String?
    let status : Int?
    let gender : String?
    let device_type : String?
    let is_face_login_set : Bool?
    let phone_otp : String?
    let points  : String?
    let used_points : String?
    let cart_count : String?
    
    let is_email_verifed : String?
    let is_phone_verified : String?
    let user_name : String?
    let family_type : String?
    let referral_code : String?
    let address : String?
    let profile_url : String?
    let nin_no : String?
    let dob : String?
    let family_type_id : String?
    let family_name : String?
    let user_type_id:String?
    let activity_type_id: String?
    var is_notifiable : String?
    var hide_profile : String?
    var show_table_booking_enable_button : String?
    var table_booking_count: String?
    var received_table_booking_count: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case accessToken = "access_token"
        case name = "name"
        case email = "email"
        case image = "user_image"
        case dial_code = "dial_code"
        case phone_number = "phone"
        case firebase_user_key = "firebase_user_key"
        case user_type = "user_type"
        case first_name = "first_name"
        case last_name = "last_name"
        case device_token = "device_token"
        case company_name = "company_name"
        case instagram = "instagram_link"
        case twitter = "twitter_link"
        case facebook = "facebook_link"
        case status = "status"
        case gender = "gender"
        case device_type = "device_type"
        case phone_otp = "phone_otp"
        case points = "points"
        case used_points = "used_points"
        case cart_count = "cart_count"
       
        case is_face_login_set = "is_face_login_set"
        case is_email_verifed = "is_email_verifed"
        
        case is_phone_verified = "is_phone_verified"
        case user_name = "user_name"
        case family_type = "family_type"
        case referral_code = "referral_code"
        case address = "address"
        case profile_url = "profile_url"
        case nin_no = "nin_no"
        case dob = "dob"
        case family_type_id = "family_type_id"
        case family_name = "family_name"
        case user_type_id = "user_type_id"
        case activity_type_id = "activity_type_id"
        case is_notifiable  = "is_notifiable"
        case hide_profile = "hide_profile"
        case show_table_booking_enable_button,table_booking_count,received_table_booking_count
        
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone_number = try values.decodeIfPresent(String.self, forKey: .phone_number)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        firebase_user_key = try values.decodeIfPresent(String.self, forKey: .firebase_user_key)
       
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        company_name = try values.decodeIfPresent(String.self, forKey: .company_name)
        instagram = try values.decodeIfPresent(String.self, forKey: .instagram)
        twitter = try values.decodeIfPresent(String.self, forKey: .twitter)
        facebook = try values.decodeIfPresent(String.self, forKey: .facebook)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        phone_otp = try values.decodeIfPresent(String.self, forKey: .phone_otp)
        points = try values.decodeIfPresent(String.self, forKey: .points)
        used_points = try values.decodeIfPresent(String.self, forKey: .used_points)
        cart_count = try values.decodeIfPresent(String.self, forKey: .cart_count)
        
        
        is_face_login_set = try values.decodeIfPresent(Bool.self, forKey: .is_face_login_set)
        is_email_verifed = try values.decodeIfPresent(String.self, forKey: .is_email_verifed)
        
        is_phone_verified = try values.decodeIfPresent(String.self, forKey: .is_phone_verified)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        family_type = try values.decodeIfPresent(String.self, forKey: .family_type)
        referral_code = try values.decodeIfPresent(String.self, forKey: .referral_code)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
        nin_no = try values.decodeIfPresent(String.self, forKey: .nin_no)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        family_type_id = try values.decodeIfPresent(String.self, forKey: .family_type_id)
        family_name = try values.decodeIfPresent(String.self, forKey: .family_name)
        user_type_id = try values.decodeIfPresent(String.self, forKey: .user_type_id)
        activity_type_id = try values.decodeIfPresent(String.self, forKey: .activity_type_id)
        is_notifiable = try values.decodeIfPresent(String.self, forKey: .is_notifiable)
        hide_profile = try values.decodeIfPresent(String.self, forKey: .hide_profile)
        show_table_booking_enable_button = try values.decodeIfPresent(String.self, forKey: .show_table_booking_enable_button)
        table_booking_count = try values.decodeIfPresent(String.self, forKey: .table_booking_count)
        received_table_booking_count = try values.decodeIfPresent(String.self, forKey: .received_table_booking_count)
    }
    
}


//
//  Profile_Base.swift
//  LiveMArket
//
//  Created by Greeniitc on 02/05/23.
//

import Foundation

struct Profile_Base : Codable {
    let status : String?
    let message : String?
    let oData : ProfileData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(ProfileData.self, forKey: .oData)
    }

}
struct ProfileData : Codable {
    let data : ProfileDetails?

    enum CodingKeys: String, CodingKey {

        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ProfileDetails.self, forKey: .data)
    }

}
struct ProfileDetails : Codable {
    let id : String?
    let name : String?
    let email : String?
    let dial_code : String?
    let phone : String?
    let user_image : String?
    let user_device_token : String?
    let firebase_user_key : String?
    let dob : String?
    let about_me : String?
    let user_type_id : String?
    let res_dial_code : String?
    let banner_image : String?
    let gender : String?
    let hide_profile : String?
    let rating : String?
    let rated_users : String?
    let wallet_amount : String?
    let commercial_license : String?
    let commercial_reg_no : String?
    let associated_license : String?
    let profile_url : String?
    let bank_details : Bank_details?
    let location_data : Location_data?
    let active_accounts : [Active_accounts]?
    let request_count : String?
    let my_order_count : String?
    let received_order_count : String?
    let service_request_count : String?
    let received_service_request_count : String?
    let gym_subscription_count : String?
    let received_gym_subscription_count : String?
    let reservation_count : String?
    let received_reservation_count : String?
    let hotel_booking_count : String?
    let received_hotel_booking_count : String?
    let ground_booking_count : String?
    let received_ground_booking_count : String?
    let chalet_booking_count : String?
    let received_chalet_booking_count : String?
    let currency_code : String?
    let followers_count : String?
    let following_count : String?
    let post_count : String?
    let subscription_count : String?
    let allow_profile_pic_upload: String?
//    let commercial_reg_no: String?
//    let associated_license: String?
//    let commercial_license: String?
    let vehicle_data: Vehicle_data?
    let delivery_request_count : String?
    var is_notifiable : String?
    var new_order : String?
    var in_process : String?
    var my_refereal_code : String?
    var referel_text : String?
    var show_table_booking_enable_button : String?
    var table_booking_count: String?
    var received_table_booking_count: String?
    var activity_type_id : String?
    var is_table_booking_available : String?
    var driver_verified: String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case email = "email"
        case dial_code = "dial_code"
        case phone = "phone"
        case user_image = "user_image"
        case user_device_token = "user_device_token"
        case firebase_user_key = "firebase_user_key"
        case dob = "dob"
        case about_me = "about_me"
        case user_type_id = "user_type_id"
        case res_dial_code = "res_dial_code"
        case banner_image = "banner_image"
        case gender = "gender"
        case hide_profile = "hide_profile"
        case rating = "rating"
        case rated_users = "rated_users"
        case wallet_amount = "wallet_amount"
        case commercial_license = "commercial_license"
        case commercial_reg_no = "commercial_reg_no"
        case associated_license = "associated_license"
        case profile_url = "profile_url"
        case bank_details = "bank_details"
        case location_data = "location_data"
        case active_accounts = "active_accounts"
        case request_count = "request_count"
        case my_order_count = "my_order_count"
        case received_order_count = "received_order_count"
        case service_request_count = "service_request_count"
        case received_service_request_count = "received_service_request_count"
        case gym_subscription_count = "gym_subscription_count"
        case received_gym_subscription_count = "received_gym_subscription_count"
        case reservation_count = "reservation_count"
        case received_reservation_count = "received_reservation_count"
        case hotel_booking_count = "hotel_booking_count"
        case received_hotel_booking_count = "received_hotel_booking_count"
        case ground_booking_count = "ground_booking_count"
        case received_ground_booking_count = "received_ground_booking_count"
        case chalet_booking_count = "chalet_booking_count"
        case received_chalet_booking_count = "received_chalet_booking_count"
        case currency_code = "currency_code"
        case followers_count = "followers_count"
        case following_count = "following_count"
        case post_count = "post_count"
        case subscription_count = "subscription_count"
//        case associated_license = "associated_license"
//        case commercial_license = "commercial_license"
//        case commercial_reg_no = "commercial_reg_no"
        case vehicle_data = "vehicle_data"
        case delivery_request_count = "delivery_request_count"
        case is_notifiable = "is_notifiable"
        case new_order,in_process
        case my_refereal_code = "my_refereal_code"
        case referel_text = "referel_text"
        case is_table_booking_available = "is_table_booking_available"
        case show_table_booking_enable_button,table_booking_count,received_table_booking_count,activity_type_id
        case driver_verified = "driver_verified"
        case allow_profile_pic_upload = "allow_profile_pic_upload"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        dial_code = try values.decodeIfPresent(String.self, forKey: .dial_code)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        user_device_token = try values.decodeIfPresent(String.self, forKey: .user_device_token)
        firebase_user_key = try values.decodeIfPresent(String.self, forKey: .firebase_user_key)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        about_me = try values.decodeIfPresent(String.self, forKey: .about_me)
        user_type_id = try values.decodeIfPresent(String.self, forKey: .user_type_id)
        res_dial_code = try values.decodeIfPresent(String.self, forKey: .res_dial_code)
        banner_image = try values.decodeIfPresent(String.self, forKey: .banner_image)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        hide_profile = try values.decodeIfPresent(String.self, forKey: .hide_profile)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        rated_users = try values.decodeIfPresent(String.self, forKey: .rated_users)
        wallet_amount = try values.decodeIfPresent(String.self, forKey: .wallet_amount)
        commercial_license = try values.decodeIfPresent(String.self, forKey: .commercial_license)
        commercial_reg_no = try values.decodeIfPresent(String.self, forKey: .commercial_reg_no)
        associated_license = try values.decodeIfPresent(String.self, forKey: .associated_license)
        profile_url = try values.decodeIfPresent(String.self, forKey: .profile_url)
        bank_details = try values.decodeIfPresent(Bank_details.self, forKey: .bank_details)
        location_data = try values.decodeIfPresent(Location_data.self, forKey: .location_data)
        active_accounts = try values.decodeIfPresent([Active_accounts].self, forKey: .active_accounts)
        request_count = try values.decodeIfPresent(String.self, forKey: .request_count)
        my_order_count = try values.decodeIfPresent(String.self, forKey: .my_order_count)
        received_order_count = try values.decodeIfPresent(String.self, forKey: .received_order_count)
        service_request_count = try values.decodeIfPresent(String.self, forKey: .service_request_count)
        received_service_request_count = try values.decodeIfPresent(String.self, forKey: .received_service_request_count)
        gym_subscription_count = try values.decodeIfPresent(String.self, forKey: .gym_subscription_count)
        received_gym_subscription_count = try values.decodeIfPresent(String.self, forKey: .received_gym_subscription_count)
        reservation_count = try values.decodeIfPresent(String.self, forKey: .reservation_count)
        received_reservation_count = try values.decodeIfPresent(String.self, forKey: .received_reservation_count)
        hotel_booking_count = try values.decodeIfPresent(String.self, forKey: .hotel_booking_count)
        received_hotel_booking_count = try values.decodeIfPresent(String.self, forKey: .received_hotel_booking_count)
        ground_booking_count = try values.decodeIfPresent(String.self, forKey: .ground_booking_count)
        received_ground_booking_count = try values.decodeIfPresent(String.self, forKey: .received_ground_booking_count)
        chalet_booking_count = try values.decodeIfPresent(String.self, forKey: .chalet_booking_count)
        received_chalet_booking_count = try values.decodeIfPresent(String.self, forKey: .received_chalet_booking_count)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        followers_count = try values.decodeIfPresent(String.self, forKey: .followers_count)
        following_count = try values.decodeIfPresent(String.self, forKey: .following_count)
        post_count = try values.decodeIfPresent(String.self, forKey: .post_count)
        subscription_count = try values.decodeIfPresent(String.self, forKey: .subscription_count)
//        commercial_reg_no = try values.decodeIfPresent(String.self, forKey: .commercial_reg_no)
//        associated_license = try values.decodeIfPresent(String.self, forKey: .associated_license)
//        commercial_license = try values.decodeIfPresent(String.self, forKey: .commercial_license)
        vehicle_data = try values.decodeIfPresent(Vehicle_data.self, forKey: .vehicle_data)
        delivery_request_count = try values.decodeIfPresent(String.self, forKey: .delivery_request_count)
        is_notifiable = try values.decodeIfPresent(String.self, forKey: .is_notifiable)
        new_order = try values.decodeIfPresent(String.self, forKey: .new_order)
        in_process = try values.decodeIfPresent(String.self, forKey: .in_process)
        my_refereal_code = try values.decodeIfPresent(String.self, forKey: .my_refereal_code)
        referel_text = try values.decodeIfPresent(String.self, forKey: .referel_text)
        show_table_booking_enable_button = try values.decodeIfPresent(String.self, forKey: .show_table_booking_enable_button)
        table_booking_count = try values.decodeIfPresent(String.self, forKey: .table_booking_count)
        received_table_booking_count = try values.decodeIfPresent(String.self, forKey: .received_table_booking_count)
        activity_type_id = try values.decodeIfPresent(String.self, forKey: .activity_type_id)
        is_table_booking_available = try values.decodeIfPresent(String.self, forKey: .is_table_booking_available)
        driver_verified = try values.decodeIfPresent(String.self, forKey: .driver_verified)
        allow_profile_pic_upload = try values.decodeIfPresent(String.self, forKey: .allow_profile_pic_upload)

    }




}
struct Bank_details : Codable {
    let id : String?
    let bank_name : String?
    let company_account : String?
    let code_type : String?
    let account_no : String?
    let branch_code : String?
    let branch_name : String?
    let bank_statement_doc : String?
    let credit_card_sta_doc : String?
    let country : String?
    let user_id : String?
    let created_at : String?
    let updated_at : String?
    let iban_code : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case bank_name = "bank_name"
        case company_account = "company_account"
        case code_type = "code_type"
        case account_no = "account_no"
        case branch_code = "branch_code"
        case branch_name = "branch_name"
        case bank_statement_doc = "bank_statement_doc"
        case credit_card_sta_doc = "credit_card_sta_doc"
        case country = "country"
        case user_id = "user_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case iban_code = "iban_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        bank_name = try values.decodeIfPresent(String.self, forKey: .bank_name)
        company_account = try values.decodeIfPresent(String.self, forKey: .company_account)
        code_type = try values.decodeIfPresent(String.self, forKey: .code_type)
        account_no = try values.decodeIfPresent(String.self, forKey: .account_no)
        branch_code = try values.decodeIfPresent(String.self, forKey: .branch_code)
        branch_name = try values.decodeIfPresent(String.self, forKey: .branch_name)
        bank_statement_doc = try values.decodeIfPresent(String.self, forKey: .bank_statement_doc)
        credit_card_sta_doc = try values.decodeIfPresent(String.self, forKey: .credit_card_sta_doc)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        iban_code = try values.decodeIfPresent(String.self, forKey: .iban_code)
    }

}

struct Vehicle_data : Codable {
    let id: String?
    let vehicle_type: String?
    let user_id: String?
    let vehicle_front: String?
    let vehicle_back: String?
    let vehicle_registration: String?
    let driving_license: String?
    let deleted: String?
    let created_at: String?
    let updated_at: String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case vehicle_type = "vehicle_type"
        case user_id = "user_id"
        case vehicle_front = "vehicle_front"
        case vehicle_back = "vehicle_back"
        case vehicle_registration = "vehicle_registration"
        case driving_license = "driving_license"
        case deleted = "deleted"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        vehicle_type = try values.decodeIfPresent(String.self, forKey: .vehicle_type)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        vehicle_front = try values.decodeIfPresent(String.self, forKey: .vehicle_front)
        vehicle_back = try values.decodeIfPresent(String.self, forKey: .vehicle_back)
        vehicle_registration = try values.decodeIfPresent(String.self, forKey: .vehicle_registration)
        driving_license = try values.decodeIfPresent(String.self, forKey: .driving_license)
        deleted = try values.decodeIfPresent(String.self, forKey: .deleted)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
struct Active_accounts : Codable {
    let id : String?
    let user_id : String?
    let account_type_id : String?
    let activity_type_id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case account_type_id = "account_type_id"
        case activity_type_id = "activity_type_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        account_type_id = try values.decodeIfPresent(String.self, forKey: .account_type_id)
        activity_type_id = try values.decodeIfPresent(String.self, forKey: .activity_type_id)
    }

}

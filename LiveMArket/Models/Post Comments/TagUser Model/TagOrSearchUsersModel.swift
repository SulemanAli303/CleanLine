//
//  TagOrSearchUsersModel.swift
//  LiveMArket
//
//  Created by Rupesh E on 28/06/23.
//

import Foundation
// MARK: - Welcome
struct TagOrSearchUsersModel: Codable {
    let status: String?
    let message: String?
    let oData: [ODatum]?
    
    // MARK: - ODatum
    struct ODatum: Codable {
        let id: String?
        let name: String?
        let email, dialCode, phone, phoneVerified: String?
        let role, firstName, lastName: String?
        let userImage: String?
        let userPhoneOtp, userDeviceToken: String?
        let userDeviceType: String?
        let userAccessToken, firebaseUserKey, createdAt, updatedAt: String?
        let countryID, stateID, cityID, area: String?
        let active, displayName, businessName, emailVerified: String?
        let userEmailOtp, dob, vendor, store: String?
        let aboutMe, verified, designationID, isPrivateProfile: String?
        let userName, gender, website, walletAmount: String?
        let passwordResetCode, passwordResetTime: String?
        var isSelected:Bool?

        enum CodingKeys: String, CodingKey {
            case id, name, email
            case dialCode = "dial_code"
            case phone
            case phoneVerified = "phone_verified"
            case role
            case firstName = "first_name"
            case lastName = "last_name"
            case userImage = "user_image"
            case userPhoneOtp = "user_phone_otp"
            case userDeviceToken = "user_device_token"
            case userDeviceType = "user_device_type"
            case userAccessToken = "user_access_token"
            case firebaseUserKey = "firebase_user_key"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case countryID = "country_id"
            case stateID = "state_id"
            case cityID = "city_id"
            case area, active
            case displayName = "display_name"
            case businessName = "business_name"
            case emailVerified = "email_verified"
            case userEmailOtp = "user_email_otp"
            case dob, vendor, store
            case aboutMe = "about_me"
            case verified
            case designationID = "designation_id"
            case isPrivateProfile = "is_private_profile"
            case userName = "user_name"
            case gender, website
            case walletAmount = "wallet_amount"
            case passwordResetCode = "password_reset_code"
            case passwordResetTime = "password_reset_time"
        }
    }
}

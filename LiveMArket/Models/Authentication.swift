//
//  Authentication.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation

struct Authentication_Base : Codable {
    let status : String?
    let message : String?
    let oData : AuthenticationData?
    var needRegistration: String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case needRegistration = "needRegistration"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(AuthenticationData.self, forKey: .oData)
        needRegistration = try values.decodeIfPresent(String.self, forKey: .needRegistration)
    }
}


struct AuthenticationData : Codable {
    let user : User?
    let token : String?
    
    enum CodingKeys: String, CodingKey {
        
        case user = "user"
        case token = "token"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}


struct AccountType_base : Codable {
    let status : String?
    let message : String?
    let oData : [AccountType]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent([AccountType].self, forKey: .oData)
    }
}


struct BusinessType_base : Codable {
    let status : String?
    let message : String?
    let oData : BusinessTypeData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case oData = "oData"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(BusinessTypeData.self, forKey: .oData)
    }
}
struct BusinessTypeData : Codable {
    let list : [AccountType]?
      enum CodingKeys: String, CodingKey {
        
        case list = "list"
     
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        list = try values.decodeIfPresent([AccountType].self, forKey: .list)
    }
}


struct AccountType : Codable {
    let id : Int?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

// MARK: - Temperatures
struct WalletHistory_base: Codable {
    let status, message: String
    let oData: WalletHistoryData
}

// MARK: - OData
struct WalletHistoryData: Codable {
    let balance, currenctCode, lastRecharged, lastUpdated: String
    let transaction: Transaction

    enum CodingKeys: String, CodingKey {
        case balance
        case currenctCode = "currenct_code"
        case lastRecharged = "last_recharged"
        case lastUpdated = "last_updated"
        case transaction
    }
}

// MARK: - Transaction
struct Transaction: Codable {
    let list: [WalletEarningsList]
}
// MARK: - List
//struct walletList: Codable {
//    let id, userID, walletAmount, payType: String
//    let description, createdAt, updatedAt, payMethod: String
//    let transactionID: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case walletAmount = "wallet_amount"
//        case payType = "pay_type"
//        case description
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case payMethod = "pay_method"
//        case transactionID = "transaction_id"
//    }
//}

// MARK: - Temperatures
struct WalletRechare_base: Codable {
    let status: Int
    let message: String
    let oData: WalletRechareData
}
// MARK: - OData
struct WalletRechareData: Codable {
    let paymentRef, invoiceID: String

    enum CodingKeys: String, CodingKey {
        case paymentRef = "payment_ref"
        case invoiceID = "invoice_id"
    }
}

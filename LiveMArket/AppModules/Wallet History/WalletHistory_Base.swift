//
//  WalletHistory_Base.swift
//  LiveMArket
//
//  Created by Rupesh E on 07/10/23.
//

import Foundation

struct WalletEarnings_Base : Codable {
    let status : String?
    let message : String?
    let oData : WalletEarningsData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(WalletEarningsData.self, forKey: .oData)
    }

}
struct WalletEarningsData : Codable {
    let balance : String?
    let earnings : String?
    let withdrawels : String?
    let earning_balance : String?
    let last_requested_amount : String?
    let last_withdraw_requested_date : String?
    let currenct_code : String?
    let last_recharged : String?
    let last_updated : String?
    let transaction : WalletTransaction?

    enum CodingKeys: String, CodingKey {

        case balance = "balance"
        case earnings = "earnings"
        case withdrawels = "withdrawels"
        case earning_balance = "earning_balance"
        case last_requested_amount = "last_requested_amount"
        case last_withdraw_requested_date = "last_withdraw_requested_date"
        case currenct_code = "currenct_code"
        case last_recharged = "last_recharged"
        case last_updated = "last_updated"
        case transaction = "transaction"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        balance = try values.decodeIfPresent(String.self, forKey: .balance)
        earnings = try values.decodeIfPresent(String.self, forKey: .earnings)
        withdrawels = try values.decodeIfPresent(String.self, forKey: .withdrawels)
        earning_balance = try values.decodeIfPresent(String.self, forKey: .earning_balance)
        last_requested_amount = try values.decodeIfPresent(String.self, forKey: .last_requested_amount)
        last_withdraw_requested_date = try values.decodeIfPresent(String.self, forKey: .last_withdraw_requested_date)
        currenct_code = try values.decodeIfPresent(String.self, forKey: .currenct_code)
        last_recharged = try values.decodeIfPresent(String.self, forKey: .last_recharged)
        last_updated = try values.decodeIfPresent(String.self, forKey: .last_updated)
        transaction = try values.decodeIfPresent(WalletTransaction.self, forKey: .transaction)
    }

}
struct WalletTransaction : Codable {
    let list : [WalletEarningsList]?

    enum CodingKeys: String, CodingKey {

        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([WalletEarningsList].self, forKey: .list)
    }

}
struct WalletEarningsList : Codable {
    let id : String?
    let user_id : String?
    let wallet_amount : String?
    let pay_type : String?
    let description : String?
    let created_at : String?
    let updated_at : String?
    let pay_method : String?
    let is_earning : String?
    let transaction_id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case wallet_amount = "wallet_amount"
        case pay_type = "pay_type"
        case description = "description"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case pay_method = "pay_method"
        case is_earning = "is_earning"
        case transaction_id = "transaction_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        wallet_amount = try values.decodeIfPresent(String.self, forKey: .wallet_amount)
        pay_type = try values.decodeIfPresent(String.self, forKey: .pay_type)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        pay_method = try values.decodeIfPresent(String.self, forKey: .pay_method)
        is_earning = try values.decodeIfPresent(String.self, forKey: .is_earning)
        transaction_id = try values.decodeIfPresent(String.self, forKey: .transaction_id)
    }

}

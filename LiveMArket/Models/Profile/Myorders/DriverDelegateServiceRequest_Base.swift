//
//  DriverDelegateServiceRequest_Base.swift
//  LiveMArket
//
//  Created by Farhan on 30/08/2023.
//

import Foundation

struct DriverDelegateServiceRequest_Base : Codable {
    let status : String?
    let message : String?
    let oData : DriverDelegateServiceRequests?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case oData = "oData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        oData = try values.decodeIfPresent(DriverDelegateServiceRequests.self, forKey: .oData)
    }

}
struct DriverDelegateServiceRequests : Codable {
    let list : [DriverDelegateServiceRequestModel]?
    let currency_code : String?
    let pagination : Pagination?

    enum CodingKeys: String, CodingKey {

        case list = "list"
        case currency_code = "currency_code"
        case pagination = "pagination"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([DriverDelegateServiceRequestModel].self, forKey: .list)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)
    }

}

// MARK: - List
struct DriverDelegateServiceRequestModel: Codable {
    var id, serviceInvoiceID, userID, deligateServiceID: String?
    var pickupLocation, pickupLattitude, pickupLongitude, dropoffLocation: String?
    var dropoffLattitude, dropoffLongitude, serviceDescription, modeOfDelivery: String?
    var specialCare, serviceStatus, paymentMethod, driverID: String?
    var orderOtp, review, rating, billTotal: String?
    var deliveryCharge, serviceCharge, grandTotal, createdAt: String?
    var updatedAt, deletedAt, completedOn: String?
    var user: Driver?
    var deligateService: DeligateService?
    var images: [Image]?
    var driver: DelegateDriver?
    var deliveryType: DeliveryType?
    var serviceStatusText: String?

    enum CodingKeys: String, CodingKey {
        case id
        case serviceInvoiceID = "service_invoice_id"
        case userID = "user_id"
        case deligateServiceID = "deligate_service_id"
        case pickupLocation = "pickup_location"
        case pickupLattitude = "pickup_lattitude"
        case pickupLongitude = "pickup_longitude"
        case dropoffLocation = "dropoff_location"
        case dropoffLattitude = "dropoff_lattitude"
        case dropoffLongitude = "dropoff_longitude"
        case serviceDescription = "service_description"
        case modeOfDelivery = "mode_of_delivery"
        case specialCare = "special_care"
        case serviceStatus = "service_status"
        case paymentMethod = "payment_method"
        case driverID = "driver_id"
        case orderOtp = "order_otp"
        case review, rating
        case billTotal = "bill_total"
        case deliveryCharge = "delivery_charge"
        case serviceCharge = "service_charge"
        case grandTotal = "grand_total"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case completedOn = "completed_on"
        case user
        case deligateService = "deligate_service"
        case images, driver
        case deliveryType = "delivery_type"
        case serviceStatusText = "service_status_text"
    }
}

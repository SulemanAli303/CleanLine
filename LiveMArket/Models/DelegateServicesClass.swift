//
//  User.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation

// MARK: - Get Delegate Services
struct DelegateServices_base: Codable {
    var status, message: String?
    var oData: DelegateServicesData?
}
// MARK: - List
// MARK: - OData
struct DelegateServicesData: Codable {
    let list: [DelegateServicesList]
}
struct DelegateServicesList: Codable {
    var id, serviceName, serviceStatus, imagePath: String?
    var createdAt, updatedAt: String?
    var processedImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case serviceName = "service_name"
        case serviceStatus = "service_status"
        case imagePath = "image_path"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case processedImageURL = "processed_image_url"
    }
}

// MARK: - Get Delegate Services
struct Vehicle_base: Codable {
    var status, message: String?
    var oData: VehicleData?
}
// MARK: - OData
struct VehicleData: Codable {
    var list: [VehicleList]?
}
// MARK: - List
struct VehicleList: Codable {
    var id, deligateName: String?
    var deligateIcon: String?
    var deligateStatus, createdAt, updatedAt, shippingCharge: String?

    enum CodingKeys: String, CodingKey {
        case id
        case deligateName = "deligate_name"
        case deligateIcon = "deligate_icon"
        case deligateStatus = "deligate_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case shippingCharge = "shipping_charge"
    }
}


struct ServicesCare {
    var name: String?
    var selectedImg: String?
    var unSelectedImg: String?
}


// MARK: - Temperatures
struct DelegateDetailsServices_Base: Codable {
    var status, message: String?
    var oData: DelegateDetailsServicesData?
}
// MARK: - OData
struct DelegateDetailsServicesData: Codable {
    var data: DataClass?
    var currencyCode: String?

    enum CodingKeys: String, CodingKey {
        case data
        case currencyCode = "currency_code"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    var id, serviceInvoiceID, userID, deligateServiceID: String?
    var pickupLocation, pickupLattitude, pickupLongitude, dropoffLocation: String?
    var dropoffLattitude, dropoffLongitude, serviceDescription, modeOfDelivery: String?
    var specialCare, serviceStatus, paymentMethod, driverID: String?
    var orderOtp, review, rating, billTotal: String?
    var deliveryCharge, serviceCharge, grandTotal, createdAt: String?
    var updatedAt, deletedAt, completedOn, serviceStatusText: String?
    var user: DelegateDriver?
    var deligateService: DeligateService?
    var images: [Image]?
    var driver: DelegateDriver?
    var deliveryType: DeliveryType?
    var driverStoreDistance, userStoreDistance: ErStoreDistance?
    var totalDistance: TotalDistance?
    var tax: String?

    enum CodingKeys: String, CodingKey {
        case driverStoreDistance = "driver_store_distance"
        case userStoreDistance = "user_store_distance"
        case totalDistance = "total_distance"
        case id
        case tax
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
        case serviceStatusText = "service_status_text"
        case user
        case deligateService = "deligate_service"
        case images, driver
        case deliveryType = "delivery_type"
    }
}

// MARK: - DeligateService
struct DeligateService: Codable {
    var id, serviceName, serviceStatus, imagePath: String?
    var createdAt, updatedAt: String?
    var processedImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case serviceName = "service_name"
        case serviceStatus = "service_status"
        case imagePath = "image_path"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case processedImageURL = "processed_image_url"
    }
}

// MARK: - DeliveryType
struct DeliveryType: Codable {
    var id, deligateName: String?
    var deligateIcon: String?
    var deligateStatus, createdAt, updatedAt, shippingCharge: String?

    enum CodingKeys: String, CodingKey {
        case id
        case deligateName = "deligate_name"
        case deligateIcon = "deligate_icon"
        case deligateStatus = "deligate_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case shippingCharge = "shipping_charge"
    }
}

// MARK: - Driver
struct DelegateDriver: Codable {
    var id, name, email, dialCode: String?
    var phone, firebaseUserKey, userDeviceToken: String?
    var userImage: String?
    var profileURL: String?
    var driver_rating:String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case dialCode = "dial_code"
        case phone
        case firebaseUserKey = "firebase_user_key"
        case userDeviceToken = "user_device_token"
        case userImage = "user_image"
        case profileURL = "profile_url"
        case driver_rating = "driver_rating"
    }
}

// MARK: - Image
struct Image: Codable {
    var id, userDeligateServiceID, imageFileName, createdAt: String?
    var updatedAt: String?
    var processedImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userDeligateServiceID = "user_deligate_service_id"
        case imageFileName = "image_file_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case processedImageURL = "processed_image_url"
    }
}


// MARK: - Temperatures
struct UserRequestDelegates_basic: Codable {
    var status, message: String?
    var oData: UserRequestDelegatesData?
}
// MARK: - OData
struct UserRequestDelegatesData: Codable {
    var list: [DataClass]?
    var currencyCode: String?

    enum CodingKeys: String, CodingKey {
        case list
        case currencyCode = "currency_code"
    }
}


// MARK: - ErStoreDistance
struct ErStoreDistance: Codable {
    var distance, time, km, tm: String?
}

// MARK: - TotalDistance
struct TotalDistance: Codable {
    var distance, time: String?
}

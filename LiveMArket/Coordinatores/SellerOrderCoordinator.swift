//
//  ShopCoordinator.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import Foundation
import UIKit
class SellerOrderCoordinator {
//    static func setRoot() {
//        let  rootVC = AppStoryboard.ShopProfile.instance.instantiateViewController(withIdentifier: "ShopProfileViewController") as! ShopProfileViewController
//        let root = UINavigationController(rootViewController: rootVC)
//        rootVC.modalPresentationStyle = .fullScreen
//        UIApplication.shared.setRoot(vc: root)
//    }
    static func setRoot() {
        let  rootVC = AppStoryboard.SellerOrder.instance.instantiateViewController(withIdentifier: "SellerOrderViewController") as! SellerOrderViewController
        let root = UINavigationController(rootViewController: rootVC)
        rootVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.setRoot(vc: root)
    }
    static func goToSellerOrder(controller:UIViewController?) {
        let  VC = AppStoryboard.SellerOrder.instance.instantiateViewController(withIdentifier: "SellerOrderViewController") as! SellerOrderViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToSellerOrderDetail(controller:UIViewController?) {
        let  VC = AppStoryboard.SellerOrderDetail.instance.instantiateViewController(withIdentifier: "SellerOrderDetailViewController") as! SellerOrderDetailViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToNewOrder(controller:UIViewController?,status:String?) {
        let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
        VC.VCtype = status ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToSellerBookingDetail(controller:UIViewController?,orderId:String?,isSeller:Bool,isThankYouPage:Bool,isFromNotify:Bool? = false,assignValue:String? = "", isFromChatDelegate: Bool? = false, chatRoomId: String? = "", firebaseKey: String? = "") {
        let  VC = AppStoryboard.SellerBookingDetails.instance.instantiateViewController(withIdentifier: "SellerBookingDetailsVC") as! SellerBookingDetailsVC
        VC.order_ID = orderId ?? ""
        VC.isFromSeller = isSeller
        VC.isFromThankYouPage = isThankYouPage
        VC.isFromNotification = isFromNotify ?? false
        VC.assignValue = assignValue ?? ""
        VC.isFromChatDelegate = isFromChatDelegate ?? false
        VC.chatRoomId = chatRoomId ?? ""
        VC.fireBaseKey = firebaseKey ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToFoodOrderDetail(controller:UIViewController?,orderId:String?,isSeller:Bool,isThankYouPage:Bool,isFromNotify:Bool? = false,assignValue:String? = "", isFromChatDelegate:Bool? = false, chatRoomId: String? = "", firebaseKey: String? = "") {
        let  VC = AppStoryboard.FoodStore.instance.instantiateViewController(withIdentifier: "FoodOrderDetailsViewController") as! FoodOrderDetailsViewController
        VC.order_ID = orderId ?? ""
        VC.isFromSeller = isSeller
        VC.isFromThankYouPage = isThankYouPage
        VC.isFromNotification = isFromNotify ?? false
        VC.assignValue = assignValue ?? ""
        VC.isFromChatDelegate = isFromChatDelegate ?? false
        VC.chatRoomId = chatRoomId ?? ""
        VC.fireBaseKey = firebaseKey ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToFoodOrderDetail_new(controller:UIViewController?,orderId:String?,isSeller:Bool,isThankYouPage:Bool) {
        let  VC = AppStoryboard.FoodStore.instance.instantiateViewController(withIdentifier: "FoodOrderDetailsViewController") as! FoodOrderDetailsViewController
        VC.order_ID = orderId ?? ""
        VC.isFromSeller = isSeller
        VC.isFromThankYouPage = isThankYouPage
        let navController = UINavigationController(rootViewController: VC)
        
    }
    static func goToSellerBookingStatus(controller:UIViewController?,status:String?) {
        let  VC = AppStoryboard.SellerBookingDetails.instance.instantiateViewController(withIdentifier: "SellerBookingDetailsVC") as! SellerBookingDetailsVC
        VC.VCtype = status ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToMyReviews(controller:UIViewController?,store_id:String,isFromProfile:Bool, isFromDriver:Bool? = false) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "MyReviewsViewController") as! MyReviewsViewController
        VC.storeID = store_id
        VC.isFromMyProfile = isFromProfile
        VC.isFromDriver = isFromDriver ?? false
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToBalance(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "BalanceViewController") as! BalanceViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToSettings(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDeliveryRequests(controller:UIViewController?,type : String? = nil,selectedCategory:DriverOrderType? = .delivery ,verified:String? = "" , singleOrderMode:Bool? = false) {
        let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderListViewController") as! DriverOrderListViewController
        VC.selectedtype = type ?? ""
        VC.driverVerified = verified ?? ""
        VC.singleOrderMode = singleOrderMode ?? false
        VC.selectedCategory = selectedCategory ?? .delivery
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToIndividualSellerOrderDetail(controller:UIViewController?) {
        let  VC = AppStoryboard.ISellerOrderDetail.instance.instantiateViewController(withIdentifier: "ISellerOrderDetailViewController") as! ISellerOrderDetailViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToEditProfileVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChangePassVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToBannedAccountsVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "BannedAccountsVC") as! BannedAccountsVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToInviteFriendVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "InviteFriendsViewController") as! InviteFriendsViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToAddNewAddress(controller:UIViewController?,isEdit : Bool,Item : List? = nil) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
        VC.isUpdateAdd = isEdit
        VC.selectedAddress = Item
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToMyBookingVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "MyBookingsVC") as! MyBookingsVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToHelpCenterVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToTaxCertificateVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "TaxCertificateVC") as! TaxCertificateVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToComplaintVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "ComplaintVC") as! ComplaintVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToAddressVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "AddressListVC") as! AddressListVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToAfterSaleService(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "AfterSaleServiceVC") as! AfterSaleServiceVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToLanguageVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
}



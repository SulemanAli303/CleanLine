//
//  ShopCoordinator.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import Foundation
import UIKit
class ShopCoordinator {
//    static func setRoot() {
//        let  rootVC = AppStoryboard.ShopProfile.instance.instantiateViewController(withIdentifier: "ShopProfileViewController") as! ShopProfileViewController
//        let root = UINavigationController(rootViewController: rootVC)
//        rootVC.modalPresentationStyle = .fullScreen
//        UIApplication.shared.setRoot(vc: root)
//    }
    static func setRoot() {
        let  rootVC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "ResturantListViewController") as! ResturantListViewController
        let root = UINavigationController(rootViewController: rootVC)
        rootVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.setRoot(vc: root)
    }
    static func goToShopProfilePage(controller:UIViewController?,storeID : String? = nil) {
        let  VC = AppStoryboard.ShopProfile.instance.instantiateViewController(withIdentifier: "ShopProfileViewController") as! ShopProfileViewController
        VC.storeID = storeID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToRateVCBase() {
        let  rootVC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
        let root = UINavigationController(rootViewController: rootVC)
        rootVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.setRoot(vc: root)
    }
    static func goToRateVC(controller:UIViewController?) {
        let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func setBookingDetails() {
        let  rootVC = AppStoryboard.BookingDetails.instance.instantiateViewController(withIdentifier: "BookingDetailsVC") as! BookingDetailsVC
        let root = UINavigationController(rootViewController: rootVC)
        rootVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.setRoot(vc: root)
    }
    
    static func setCartDetails() {
        let  rootVC = AppStoryboard.UserCart.instance.instantiateViewController(withIdentifier: "UserCartVC") as! UserCartVC
        let root = UINavigationController(rootViewController: rootVC)
        rootVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.setRoot(vc: root)
    }
    static func goToShopProfileDetail(controller:UIViewController?,storeID : String? = nil) {
        let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        VC.storeID = storeID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
        
    }
    static func goToFoodShopProfileDetail(controller:UIViewController?,resturantID:String?) {
        let  VC = AppStoryboard.FoodStore.instance.instantiateViewController(withIdentifier: "FoodStoreDetailsViewController") as! FoodStoreDetailsViewController
        VC.resturant_ID = resturantID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
        
    }
    static func goToReceivingOptions(controller:UIViewController?) {
        let  VC = AppStoryboard.ReceivingOption.instance.instantiateViewController(withIdentifier: "ReceivingViewController") as! ReceivingViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToRequestDelegate(controller:UIViewController?) {
        let  VC = AppStoryboard.ReceivingOption.instance.instantiateViewController(withIdentifier: "RequestViewController") as! RequestViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToSelectActivityTyoe(controller:UIViewController?,rowType:Int?) {
        let  VC = AppStoryboard.ReceivingOption.instance.instantiateViewController(withIdentifier: "SelectActivityTypeViewController") as! SelectActivityTypeViewController
        VC.RowType = rowType ?? 0
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToSelectBusinessType(controller:UIViewController?,VCtype : Int) {
        let  VC = AppStoryboard.ReceivingOption.instance.instantiateViewController(withIdentifier: "SelectBusinessTypeViewController") as! SelectBusinessTypeViewController
        VC.ROWType = VCtype
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToResturantList(controller:UIViewController?) {
        let  VC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "ResturantListViewController") as! ResturantListViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCart(controller:UIViewController?,isSelected :Bool) {
        let  VC = AppStoryboard.UserCart.instance.instantiateViewController(withIdentifier: "UserCartVC") as! UserCartVC
        VC.isAssigned = isSelected
        Constants.shared.appliedCoupon = ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToFoodCart(controller:UIViewController?,isSelected :Bool,storeID:String) {
        let  VC = AppStoryboard.FoodStore.instance.instantiateViewController(withIdentifier: "FoodCartViewController") as! FoodCartViewController
        VC.isAssigned = isSelected
        VC.storeID = storeID
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToBookingDetail(controller:UIViewController?,VCtype:String?) {
        let  VC = AppStoryboard.BookingDetails.instance.instantiateViewController(withIdentifier: "BookingDetailsVC") as! BookingDetailsVC
        VC.VCtype = VCtype
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
   
}


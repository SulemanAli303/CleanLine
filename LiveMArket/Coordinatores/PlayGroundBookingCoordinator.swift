//
//  PlayGroundBookingCoordinator.swift
//  LiveMArket
//
//  Created by Zain falak on 27/01/2023.
//

import Foundation
import UIKit

class PlayGroundCoordinator {
    
    
    static func setRoot() {
        let  rootVC = AppStoryboard.BookNow.instance.instantiateViewController(withIdentifier: "BookNowViewController") as! BookNowViewController
        let root = UINavigationController(rootViewController: rootVC)
        rootVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.setRoot(vc: root)
    }
    static func goToBookNow(controller:UIViewController?,store_ID:String?) {
        let  VC = AppStoryboard.BookNow.instance.instantiateViewController(withIdentifier: "BookNowViewController") as! BookNowViewController
        VC.storeID = store_ID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToBookNowDetail(controller:UIViewController?,store_ID:String?) {
        let  VC = AppStoryboard.BookNowDetail.instance.instantiateViewController(withIdentifier: "BookNowDetailViewController") as! BookNowDetailViewController
        VC.storeID = store_ID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCompleteBooking(controller:UIViewController?) {
        let  VC = AppStoryboard.CompleteBooking.instance.instantiateViewController(withIdentifier: "CompleteBookingViewController") as! CompleteBookingViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToBookingDetail(controller:UIViewController?,isFromReceive:Bool? = false,booking_ID:String?,isFromThankYou:Bool? = false,isFromNotify:Bool? = false) {
        let  VC = AppStoryboard.PGBookingDetails.instance.instantiateViewController(withIdentifier: "PGBookingDetailsVC") as! PGBookingDetailsVC
        VC.isFromReceivedBooking = isFromReceive ?? false
        VC.bookingID = booking_ID ?? ""
        VC.isFromThankYouPage = isFromThankYou ?? false
        VC.isFromNotification = isFromNotify ?? false
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDateTime(controller:UIViewController?,groundID:String?,storeID:String?) {
        let  VC = AppStoryboard.DateTime.instance.instantiateViewController(withIdentifier: "DateTimeViewController") as! DateTimeViewController
        VC.ground_ID = groundID ?? ""
        VC.store_ID = storeID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
}

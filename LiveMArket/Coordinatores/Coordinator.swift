//
//  Coordinator.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import Foundation
import UIKit
class Coordinator {

    static func updateRootVCToTab(selectedIndex: Int = 0) {
        let  rootVC =  AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        let root = UINavigationController(rootViewController: rootVC)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        removeAllObservers(controller: appDelegate.window?.rootViewController)
        appDelegate.window?.rootViewController = root
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            rootVC.selectedIndex = selectedIndex
        }
    }

    static func removeAllObservers(controller: UIViewController?) {
        if let tabBarController = controller as? UITabBarController {
            for viewController in tabBarController.viewControllers ?? [] {
                NotificationCenter.default.removeObserver(viewController)
                removeAllObservers(controller: viewController)
            }
        }
        if let navigationController = controller as? UINavigationController {
            for viewController in navigationController.viewControllers {
                NotificationCenter.default.removeObserver(viewController)
                removeAllObservers(controller: viewController)
            }
        }
    }

    static func updateRootVCToTab() {

        let  rootVC =  AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        let root = UINavigationController(rootViewController: rootVC)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        removeAllObservers(controller: appDelegate.window?.rootViewController)
        appDelegate.window?.rootViewController = root
        
    }
    static func moveToRooVC() {
        if let window = (UIApplication.shared.delegate as? AppDelegate)?.window,let rootvc = window.rootViewController as? UINavigationController,let tabb = rootvc.viewControllers.first as? TabbarController {
            tabb.selectedIndex = 0
            if let home = tabb.viewControllers?.first as? UINavigationController {
                home.popToRootViewController(animated: true)
            }
        }
    }
    static func gotoRespectiveOrdersList(fromController:UIViewController, category:String) {

        /*
         if let navController = fromController.navigationController
         {
         navController.popToRootViewController(animated: false)

         let  appDeleg = UIApplication.shared.delegate as? AppDelegate
         if let rootNavVC = appDeleg?.window?.rootViewController as? UINavigationController
         {
         if let rootVC = rootNavVC.viewControllers.first as? TabbarController
         {
         rootVC.selectedIndex = 4
         if let navController = rootVC.viewControllers![rootVC.selectedIndex] as? UINavigationController
         {
         if let profileVC = navController.viewControllers.first as? ProfileViewController{
         DispatchQueue.main.asyncAfter(deadline: .now())
         {
         profileVC.gotoListScreenForType(listType: category)
         }
         }
         }
         }
         }
         }
         */
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let  rootVC =  AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        let root = UINavigationController(rootViewController: rootVC)
        removeAllObservers(controller: appDelegate.window?.rootViewController)
        appDelegate.window?.rootViewController = root
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            rootVC.selectedIndex = 4
            if let navController = rootVC.viewControllers![rootVC.selectedIndex] as? UINavigationController
            {
            if let profileVC = navController.viewControllers.first as? ProfileViewController{
                profileVC.gotoListScreenForType(listType: category)
            }
            }
        }
    }
    
    static func updateProfileVCToTab() {
        
        let  appDeleg = UIApplication.shared.delegate as? AppDelegate
        if let rootNavVC = appDeleg?.window?.rootViewController as? UINavigationController
        {
            if let rootVC = rootNavVC.viewControllers.first as? TabbarController
            {
                if let navController = rootVC.viewControllers![rootVC.selectedIndex] as? UINavigationController
                {
                    navController.popToRootViewController(animated: false)
                }
                rootVC.selectedIndex = 4
            }
        }
    }
    
    static func updateProfileVCToTabWithoutDelay() {
        
        let  rootVC =  AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        let root = UINavigationController(rootViewController: rootVC)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        removeAllObservers(controller: appDelegate.window?.rootViewController)
        appDelegate.window?.rootViewController = root

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            rootVC.selectedIndex = 4
        }
    }
    
//    static func updateProfileVCToTab() {
//        
//        let  rootVC =  AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
//        let root = UINavigationController(rootViewController: rootVC)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = root
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            rootVC.selectedIndex = 4
//        }
//        
//    }
    
    static func setRoot(controller:UIViewController?) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "LMLoginViewController") as! LMLoginViewController
        VC.isFromOptions = false
        //        let mainNavigationController = UINavigationController.init(rootViewController: VC)
        //        mainNavigationController.modalPresentationStyle = .fullScreen
        //        VC.modalPresentationStyle = .fullScreen
        controller?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func presentLogin(viewController: UIViewController?) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "LMLoginViewController") as! LMLoginViewController
        VC.isFromOptions = false
        viewController?.navigationController?.pushViewController(VC, animated: false)
        //        let mainNavigationController = UINavigationController.init(rootViewController: VC)
        //        mainNavigationController.modalPresentationStyle = .fullScreen
        //        VC.modalPresentationStyle = .fullScreen
        //        viewController?.present(mainNavigationController, animated: true, completion: nil)
    }
    
    static func goToLoginTypeChoosenPage(controller:UIViewController?) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "LMLoginTypeSelectionViewController") as! LMLoginTypeSelectionViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCreateAccountPage(controller:UIViewController?) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "LMCreateAccountViewController") as! LMCreateAccountViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToAddBankDetailsPage(controller:UIViewController?) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "LMAddBankDetailsViewController") as! LMAddBankDetailsViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToAddLocationPage(controller:UIViewController?) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "LMAddLocationViewController") as! LMAddLocationViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToRegisterSuccessPage(controller:UIViewController?) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "LMRegisterSuccessViewController") as! LMRegisterSuccessViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goTThankYouPage(controller:UIViewController?,vcType:String, invoiceId:String, order_id:String,isFromFoodStore:Bool,isFromPlayGround:Bool? = false,isFromPGDetail:Bool? = false,title:String? = "" , isPaymentDone : Bool = false) {
        let  VC = AppStoryboard.ThankYou.instance.instantiateViewController(withIdentifier: "ThankYouViewController") as! ThankYouViewController
        VC.vcType = vcType
        VC.invoiceId = invoiceId
        VC.orderID = order_id
        VC.isFromFoodStore = isFromFoodStore
        VC.isFromPlayGroundBooking = isFromPlayGround ?? false
        VC.isFromPGDetailsPage = isFromPGDetail ?? false
        VC.titleHead = title ?? ""
        VC.isForPaymentDone = isPaymentDone
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToSubmitPictureVideo(controller:UIViewController?,isTakePicture:Bool,isLive:Bool , channelID : String = "") {
        let  VC = AppStoryboard.SubmitPicture.instance.instantiateViewController(withIdentifier: "SubmitPictureVC") as! SubmitPictureVC
        VC.isFromPicture = isTakePicture
        VC.isFromLive = isLive
        VC.channelID = channelID
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToLivePreviewVideo(controller:UIViewController?,video_URL:URL , channelID : String = "") {
        let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "LiveVideoViewController") as! LiveVideoViewController
        VC.videoURL = video_URL
        VC.channelID = channelID
        
        let appDeleg = UIApplication.shared.delegate as? AppDelegate
        if let navVC = appDeleg?.window?.rootViewController as? UINavigationController{
            navVC.pushViewController(VC, animated: true)
        } else if let tabbarVC = appDeleg?.window?.rootViewController as? TabbarController{
            if let navCont = tabbarVC.selectedViewController as? UINavigationController{
                navCont.pushViewController(VC, animated: true)
            }
        }
        print("root is \(appDeleg?.window?.rootViewController)")
        
    }
    static func goToTakePicture(controller:UIViewController?) {
        let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "TakePictureVC") as! TakePictureVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToTakeVideo(controller:UIViewController?) {
        let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "TakeVideoVC") as! TakeVideoVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToLive(controller:UIViewController?) {
        if SessionManager.isLoggedIn() {
            if Constants.shared.isAlreadyLive{
                Utilities.showWarningAlert(message: "You are already broadcasting live. To start a new live session, please close your current live broadcast.")
            } else {
                    requestAccessForVideo()
            }
        }else {
            Coordinator.updateRootVCToTab()
        }
    }

   static func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
       switch status  {
           case AVAuthorizationStatus.notDetermined:
               AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                   if(granted){
                       DispatchQueue.main.async {
                           if #available(iOS 15.0, *) {
                               let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "LiveVC") as! LiveVC
                               PIPKit.show(with:VC )
                           }
                       }
                   } else {
                       DispatchQueue.main.async {
                           self.showPermissionAlert()
                       }
                   }
               })
               break;
           case AVAuthorizationStatus.authorized:
               DispatchQueue.main.async {
                   if #available(iOS 15.0, *) {
                       let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "LiveVC") as! LiveVC
                       PIPKit.show(with:VC )
                   }
               }
               break;
           case AVAuthorizationStatus.denied,AVAuthorizationStatus.restricted :
               DispatchQueue.main.async {
                   showPermissionAlert()
               }
           default:
               break;
       }
    }
    static func  showPermissionAlert() {
        Utilities.showMultipleChoiceAlert(message: "Camera Permissions are required please enable it from setting. do you want to go to settings?", firstHandler:{
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        } ,secondHandler: {
            Coordinator.moveToRooVC()
        } )
    }

    static func goToPostComment(controller:UIViewController?,isAdmin : String = "0") {
        let  VC = AppStoryboard.PostComment.instance.instantiateViewController(withIdentifier: "PostCommentVC") as! PostCommentVC
        VC.isAdmin = isAdmin
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToList(controller:UIViewController?) {
        let  VC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "ResturantListViewController") as! ResturantListViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToServices(controller:UIViewController?,storeID:String?) {
        let  VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "UserServicesBooking") as! UserServicesBooking
        VC.store_id = storeID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToAddServices(controller:UIViewController?,serviceId:String? = nil) {
        let  VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "AddServiceVC") as! AddServiceVC
        VC.storeId = serviceId ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToServiceThank(controller:UIViewController?,step:String , invoiceId:String? = nil,serviceId:String? = nil , isPaymentSuccess : Bool = false) {
        let  VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "ThankYouViewControllerServices") as! ThankYouViewControllerServices
        VC.vcType = step
        VC.invoiceId = invoiceId
        VC.serviceId = serviceId ?? ""
        VC.isPaymentSuccess = isPaymentSuccess
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDelegateThank(controller:UIViewController?,step:String , invoiceId:String? = nil,serviceId:String? = nil) {
        let  VC = AppStoryboard.BookingDelegate.instance.instantiateViewController(withIdentifier: "ThankYouViewControllerDelegate") as! ThankYouViewControllerDelegate
        VC.vcType = step
        VC.invoiceId = invoiceId
        VC.serviceId = serviceId ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToServiceRequestDetails(controller:UIViewController?,step:String? = nil,serviceID :String? = nil , isFromThanks :Bool? = nil,isFromNotify:Bool? = false ) {
        let  VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "ServiceRequestDetails") as! ServiceRequestDetails
        VC.step = step ?? "0"
        VC.serviceId = serviceID ?? "0"
        VC.isOpenfrom = isFromThanks ?? false
        VC.isFromNotification = isFromNotify ?? false
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToServiceDelegateRequestDetails(controller:UIViewController?,step:String? = nil,serviceID :String? = nil , isDriver :Bool? = false,isFromNotify:Bool? = false,isFromThanku:Bool? = false, isFromChatDelegate:Bool? = false, chatRoomId:String? = "", senderID:String? = "") {
        let  VC = AppStoryboard.BookingDelegate.instance.instantiateViewController(withIdentifier: "ServiceDelegateRequestDetails") as! ServiceDelegateRequestDetails
        VC.step = step ?? "0"
        VC.serviceId = serviceID ?? "0"
        VC.isDriver = isDriver ?? false
        VC.isFromNotification = isFromNotify ?? false
        VC.isfromThankuPage = isFromThanku ?? false
        VC.isFromChatDelegate = isFromChatDelegate ?? false
        VC.chatRoomID = chatRoomId ?? ""
        VC.senderID = senderID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToDriverOrderDetails(controller:UIViewController?, orderId: String? = "", lat: String? = "", lng:String? = "", driverAddress:String? = "", fromFoodOrder:Bool? = false, isFromChatDelegate: Bool? = false, whoIsParent:String? = "") {
        let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
        VC.order_ID = orderId ?? ""
        VC.latitude = lat ?? ""
        VC.longitude = lng ?? ""
        VC.driverAddress = driverAddress ?? ""
        VC.isFromFoodOrder = fromFoodOrder ?? false
        VC.isFromChatDelegate = isFromChatDelegate ?? false
        VC.parentController = whoIsParent ?? ""
        
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    static func goToServiceRate(controller:UIViewController?,RequestData :ChaletsBookingDetailsData? = nil,isFromChalet: Bool = false ) {
        let  VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "ServiceRateVC") as! ServiceRateVC
        VC.RequestData = RequestData
        VC.isFromChaletBooking = isFromChalet
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToServiceLocation(controller:UIViewController?) {
        let  VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "ServicesLocation") as! ServicesLocation
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToGymList(controller:UIViewController?,storeID:String) {
        let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "UserGymList") as! UserGymList
        VC.store_ID = storeID
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToGymSelectPackage(controller:UIViewController?,store_id:String) {
        let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "AddGymPackages") as! AddGymPackages
        VC.storeID = store_id
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToGymThanks(controller:UIViewController?,id:String,subscriptionid:String) {
        let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "ThankYouViewControllerGym") as! ThankYouViewControllerGym
        VC.invoiceID = id
        VC.subscriptionID = subscriptionid
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToGymRequestDetails(controller:UIViewController?,subscriptionID:String,isFromReceived:Bool,isFromNotify:Bool? = false, isFromThankYou:Bool? = false) {
        let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
        VC.subscriptionID = subscriptionID
        VC.isFromReceivedSubscription = isFromReceived
        VC.isFrommThankuPage = isFromThankYou ?? false
        VC.isFromNotification = isFromNotify ?? false
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCharletsList(controller:UIViewController?,chaletID:String? = nil) {
        let  VC = AppStoryboard.Chalets.instance.instantiateViewController(withIdentifier: "ChaletsBooking") as! ChaletsBooking
        VC.chaletID = chaletID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCharletsListVC(controller:UIViewController?,venderID:String?) {
        let  VC = AppStoryboard.Chalets.instance.instantiateViewController(withIdentifier: "ChaletsListVC") as! ChaletsListVC
        VC.store_id = venderID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCharletsRoom(controller:UIViewController?,chaletID:String? = nil) {
        let  VC = AppStoryboard.Chalets.instance.instantiateViewController(withIdentifier: "CharletRoomDetails") as! CharletRoomDetails
        VC.chaletID = chaletID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChaletCart(controller:UIViewController?,chaletID:String? = nil,start_date_time:String? = nil,end_date_time:String? = nil) {
        let  VC = AppStoryboard.Chalets.instance.instantiateViewController(withIdentifier: "ChaletCartVC") as! ChaletCartVC
        VC.chaletID = chaletID ?? ""
        VC.startDate = start_date_time ?? ""
        VC.endDate = end_date_time ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChaletThanks(controller:UIViewController?,step:String,chaletID:String? = nil,invoiceId :String? = nil,isPaymentAction : Bool = false) {
        let  VC = AppStoryboard.Chalets.instance.instantiateViewController(withIdentifier: "ThanksChaletsVC") as! ThanksChaletsVC
        VC.vcType = step
        VC.chaletID = chaletID ?? ""
        VC.invoice = invoiceId ?? ""
        VC.isPaymentAction = isPaymentAction
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChaletRequestDetails(controller:UIViewController?,step:String,chaletID:String? = nil,isFromThankPage:Bool? = false,isFromNotify:Bool? = false) {
        let  VC = AppStoryboard.Chalets.instance.instantiateViewController(withIdentifier: "ChaletsRequestDetails") as! ChaletsRequestDetails
        VC.step = step
        VC.chaletID = chaletID ?? ""
        VC.isFromThankYouPage = isFromThankPage ?? false
        VC.isFromNotification = isFromNotify ?? false
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChaletSetDate(controller:UIViewController? , chaletId:String? = nil) {
        let  VC = AppStoryboard.Chalets.instance.instantiateViewController(withIdentifier: "DateAndCalanderVC") as! DateAndCalanderVC
        VC.chaletID = chaletId ?? ""
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        
        controller?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        controller?.navigationController?.pushViewController(VC, animated: false)
    }
    
    static func goToChatDetails(delegate: UIViewController?,user_id :String? = nil , user_name : String? = nil,userImgae:String? = "",firebaseUserKey:String? = "",roomId:String? = "",isFromDelegate:Bool? = false,isDeliverd:Bool? = false,orderID:String? = "", serviceID:String? = "", isDriver:Bool? = false, isSeller:Bool? = false, parentController:String? = "", myOrderId: String? = "") {
        
        
        let  chatVC = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: "LTChatViewController") as! LTChatViewController
        chatVC.secondPersonUserId = user_id
        chatVC.firbaseUserId = firebaseUserKey
        chatVC.secondPersonName = user_name
        chatVC.secondPersonImageURL = userImgae
        chatVC.chatRoomId = roomId
        chatVC.isFromDelegateService = isFromDelegate ?? false
        chatVC.isDeliverd = isDeliverd ?? false
        chatVC.delegateOrderID = orderID ?? ""
        chatVC.serviceID = serviceID ?? ""
        chatVC.isDriver = isDriver ?? false
        chatVC.isSeller = isSeller ?? false
        chatVC.orderIdDetails = myOrderId ?? ""
        
        chatVC.parentController = parentController ?? ParentController.None.rawValue
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        delegate?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        delegate?.navigationController?.pushViewController(chatVC, animated: false)
        
    }
    static func goToHotelBookingFlow(controller:UIViewController?,store_ID:String?) {
        let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "HotelBooking") as! HotelBooking
        VC.storeID = store_ID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToSelectRoom(controller:UIViewController?) {
        let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "SelectRoomViewController") as! SelectRoomViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToBookNoww(controller:UIViewController?,room_ID:String?) {
        let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "BookNowVC") as! BookNowVC
        VC.roomID = room_ID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToBookDateAndTime(controller:UIViewController?,room_ID:String?) {
        let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "HotelDateTimeViewController") as! HotelDateTimeViewController
        VC.roomID = room_ID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCompleteBooking(controller:UIViewController?) {
        let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "CompleteBookingVC") as! CompleteBookingVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToHotelBookingThanks(controller:UIViewController?,step:String,invoiceID:String?,bookingID:String? , isPaymentSuccess : Bool = false) {
        let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "ThanksBookingHotelVC") as! ThanksBookingHotelVC
        VC.vcType = step
        VC.invoiceID = invoiceID ?? ""
        VC.bookingID = bookingID ?? ""
        VC.isPaymentSuccess = isPaymentSuccess
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToHotelBookingDetail(controller:UIViewController?,isFromReceive:Bool? = false,booking_ID:String?,isFromThankYou:Bool? = false,isFromNotify:Bool? = false) {
        let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "HotelBookingDetail") as! HotelBookingDetail
        VC.isFromReceivedBooking = isFromReceive ?? false
        VC.bookingID = booking_ID ?? ""
        VC.isFromThankYouPage = isFromThankYou ?? false
        VC.isFromNotification = isFromNotify ?? false
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToHotelBookingList(controller:UIViewController?) {
        let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "HotelBookingListViewController") as! HotelBookingListViewController
        
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToHotelRating(controller:UIViewController?,VCtype : String) {
        let  VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "ServiceRateVC") as! ServiceRateVC
        VC.VCtype = VCtype
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCarBookingFlow(controller:UIViewController?, store_ID:String?) {
        let  VC = AppStoryboard.CarBooking.instance.instantiateViewController(withIdentifier: "CarBookingViewController") as! CarBookingViewController
        VC.storeID = store_ID ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCarBookingProfile(controller:UIViewController?,VCtype : String) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        VC.VCtype = VCtype
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToNotifications(controller:UIViewController?) {
        let  VC = AppStoryboard.Notifications.instance.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCommentsList(controller:UIViewController?,postID:String,orderCount:Int? = 0,userID:String? , onDone:(() -> ())?) {
        let  VC = AppStoryboard.LiveComments.instance.instantiateViewController(withIdentifier: "LiveCommentVC") as! LiveCommentVC
        VC.post_ID = postID
        VC.orderCountValue = orderCount ?? 0
        VC.postUserID = userID ?? ""
        VC.onDone = onDone
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToHotelReservationManagment(controller:UIViewController?) {
        let  VC = AppStoryboard.HotelReservationManagment.instance.instantiateViewController(withIdentifier: "HotelReservationManagment") as! HotelReservationManagment
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToRoomLIst(controller:UIViewController?,store_id:String ) {
        let  VC = AppStoryboard.HotelReservationManagment.instance.instantiateViewController(withIdentifier: "RoomListVC") as! RoomListVC
        VC.storeID = store_id
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToHotelNewBooking(controller:UIViewController?) {
        let  VC = AppStoryboard.HotelReservationManagment.instance.instantiateViewController(withIdentifier: "HotelNewBooking") as! HotelNewBooking
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToHotelReservedBooking(controller:UIViewController?) {
        let  VC = AppStoryboard.HotelReservationManagment.instance.instantiateViewController(withIdentifier: "HotelReservedBooking") as! HotelReservedBooking
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToHotelNewReservationRequest(controller:UIViewController?,VCtype : String) {
        let  VC = AppStoryboard.HotelReservationManagment.instance.instantiateViewController(withIdentifier: "HotelNewBookingRequest") as! HotelNewBookingRequest
        VC.step = VCtype
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToHotelReservationRequest(controller:UIViewController?,VCtype : String) {
        let  VC = AppStoryboard.HotelReservationManagment.instance.instantiateViewController(withIdentifier: "HotelReserveRequest") as! HotelReserveRequest
        VC.step = VCtype
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    static func goToChaletsReservationManagment(controller:UIViewController?) {
        let  VC = AppStoryboard.ChaletsReservationManagment.instance.instantiateViewController(withIdentifier: "ChaletsReservationManagment") as! ChaletsReservationManagment
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChaletsLIstDetails(controller:UIViewController?,chaledId:String? = nil) {
        let  VC = AppStoryboard.ChaletsReservationManagment.instance.instantiateViewController(withIdentifier: "ChaletsListVCDetails") as! ChaletsListVCDetails
        VC.chaledId = chaledId ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChaletsNewBooking(controller:UIViewController?) {
        let  VC = AppStoryboard.ChaletsReservationManagment.instance.instantiateViewController(withIdentifier: "ChaletsNewBooking") as! ChaletsNewBooking
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChaletsReservedBooking(controller:UIViewController?) {
        let  VC = AppStoryboard.ChaletsReservationManagment.instance.instantiateViewController(withIdentifier: "ChaletsReservedBooking") as! ChaletsReservedBooking
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChaletsNewReservationRequest(controller:UIViewController?,VCtype : String) {
        let  VC = AppStoryboard.ChaletsReservationManagment.instance.instantiateViewController(withIdentifier: "ChaletsNewBookingRequest") as! ChaletsNewBookingRequest
        VC.step = VCtype
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToChaletsReservationRequest(controller:UIViewController?,VCtype : String,chaletID:String? = nil,isFromNotify:Bool? = false,isFromThankYou:Bool? = false) {
        let  VC = AppStoryboard.ChaletsReservationManagment.instance.instantiateViewController(withIdentifier: "ChaletsReserveRequest") as! ChaletsReserveRequest
        VC.step = VCtype
        VC.chaletID = chaletID ?? ""
        VC.isFromThankYou = isFromThankYou ?? false
        VC.isFromNotification = isFromNotify ?? false
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToGymManagment(controller:UIViewController?) {
        let  VC = AppStoryboard.GymManagmentFlow.instance.instantiateViewController(withIdentifier: "GymManagment") as! GymManagment
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToGymNewBooking(controller:UIViewController?) {
        let  VC = AppStoryboard.GymManagmentFlow.instance.instantiateViewController(withIdentifier: "GymNewBooking") as! GymNewBooking
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToGymNewReservationRequest(controller:UIViewController?,VCtype : String) {
        let  VC = AppStoryboard.GymManagmentFlow.instance.instantiateViewController(withIdentifier: "GymNewBookingRequest") as! GymNewBookingRequest
        VC.step = VCtype
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToGymNewReservationRequestAccept(controller:UIViewController?) {
        let  VC = AppStoryboard.GymManagmentFlow.instance.instantiateViewController(withIdentifier: "GymManagmentRate") as! GymManagmentRate
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToGymPackegesList(controller:UIViewController?,id:String) {
        let  VC = AppStoryboard.GymManagmentFlow.instance.instantiateViewController(withIdentifier: "GymPackegesList") as! GymPackegesList
        VC.sellerID = id
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToServiceProviderBooking(controller:UIViewController?) {
        let  VC = AppStoryboard.ServiceProviderBooking.instance.instantiateViewController(withIdentifier: "ServiceProviderBooking") as! ServiceProviderBooking
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToActiveSubscription(controller:UIViewController?) {
        let  VC = AppStoryboard.ServiceProviderBooking.instance.instantiateViewController(withIdentifier: "ActiveSubscriptionViewController") as! ActiveSubscriptionViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToServicProviderThank(controller:UIViewController?,step:String,service_inVoice:String? = nil,serviceId: String? = nil) {
        let  VC = AppStoryboard.ServiceProviderBooking.instance.instantiateViewController(withIdentifier: "ServiceProviderThankcVC") as! ServiceProviderThankcVC
        VC.vcType = step
        VC.service_inVoice = service_inVoice ?? ""
        VC.service_id = serviceId ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToServicProviderDetail(controller:UIViewController?,step:String,serviceId: String? = nil,isFromThank:Bool?,isFromNotify:Bool? = false) {
        let  VC = AppStoryboard.ServiceProviderBooking.instance.instantiateViewController(withIdentifier: "ServiceProviderServiceDetailVC") as! ServiceProviderServiceDetailVC
        VC.step = step
        VC.serviceId = serviceId ?? ""
        VC.isFromThankYouPage = isFromThank ?? false
        VC.isFromNotification = isFromNotify ?? false
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToAcceptRequestVC(controller:UIViewController?,step:String,service_request_id:String? = nil,service_inVoice : String? = nil) {
        let  VC = AppStoryboard.ServiceProviderBooking.instance.instantiateViewController(withIdentifier: "AcceptRequestVC") as! AcceptRequestVC
        VC.step = step
        VC.service_request_id = service_request_id ?? ""
        VC.service_inVoice = service_inVoice ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDeliveryRequest(controller:UIViewController?,step:String) {
        let  VC = AppStoryboard.CarBooking.instance.instantiateViewController(withIdentifier: "DeliveryRequestVC") as! DeliveryRequestVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToCarbookingDetail(controller:UIViewController?,step:String) {
        let  VC = AppStoryboard.CarBookingDetails.instance.instantiateViewController(withIdentifier: "CarBookingDetailsVC") as! CarBookingDetailsVC
        VC.VCtype = step 
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToIndvidualSellerFlow(controller:UIViewController?,step:String) {
        let  VC = AppStoryboard.ISellerOrder.instance.instantiateViewController(withIdentifier: "ISellerOrderViewController") as! ISellerOrderViewController
        VC.storeID = step 
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToTrackOrder(controller:UIViewController?,trackType:String? = nil, Orderid:String? = nil , getDriverRequestDetails:Bool? = false) {
        let  VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
        VC.TrackType = trackType ?? ""
        VC.order_ID = Orderid ?? ""
        VC.getDriverRequestDetail = getDriverRequestDetails ?? false
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToForgotPassword(controller:UIViewController?) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "ForgotPaswordVC") as! ForgotPaswordVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToResetPassword(controller:UIViewController?, email:String? = nil) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        VC.emailID = email ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToVerifyOTP(controller:UIViewController?, email:String? = nil) {
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
        VC.emailID = email ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToCMSPage(controller:UIViewController?) {
        let  VC = AppStoryboard.CMS.instance.instantiateViewController(withIdentifier: "CMSPageViewController") as! CMSPageViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func gotoRecharge(controller:UIViewController?) {
        let  VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "RechargeWalletView") as! RechargeWalletView
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func gotoWithdrawView(controller:UIViewController?,data:WalletEarningsData?) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "WithdrawViewController") as! WithdrawViewController
        VC.walletData = data
        controller?.present(VC, animated: true)
    }
    static func goToOptionsCategory(controller:UIViewController?,fUserType:String?,accountTypeID:String?,searchText:String?,headString:String?,selectedColor:String?,unselectedColor:String?,individual_id:String?) {
        let  VC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "CategoryDetailsList") as! CategoryDetailsList
        VC.userTypeString = fUserType ?? ""
        VC.accountTypeID = accountTypeID ?? ""
        VC.searchText = searchText ?? ""
        VC.heading = headString ?? ""
        VC.selectedColor = selectedColor ?? ""
        VC.unselectedColor = unselectedColor ?? ""
        VC.individualID = individual_id ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToFilter(controller:UIViewController?) {
        let  VC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "FilterView") as! FilterView
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToApplyFilter(controller:UIViewController?) {
        let  VC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "ApplyFilterVC") as! ApplyFilterVC
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToChooseDelegate(controller:UIViewController?) {
        let  VC = AppStoryboard.BookingDelegate.instance.instantiateViewController(withIdentifier: "ChooseDelegateServices") as! ChooseDelegateServices
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToAddDelegateServices(controller:UIViewController?,deligate_service_id:String? = nil,pickup_location:String? = nil,pickup_lattitude:String? = nil,pickup_longitude:String? = nil,dropoff_location:String? = nil,
                                        dropoff_lattitude:String? = nil,dropoff_longitude:String? = nil) {
        let  VC = AppStoryboard.BookingDelegate.instance.instantiateViewController(withIdentifier: "AddDelegateServiceVC") as! AddDelegateServiceVC
        VC.deligate_service_id = deligate_service_id ?? ""
        VC.pickup_location = pickup_location ?? ""
        VC.pickup_lattitude = pickup_lattitude ?? ""
        VC.pickup_longitude = pickup_longitude ?? ""
        VC.dropoff_location = dropoff_location ?? ""
        VC.dropoff_lattitude = dropoff_lattitude ?? ""
        VC.dropoff_longitude = dropoff_longitude ?? ""
        
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToServiceUserList(controller:UIViewController?) {
        let  VC = AppStoryboard.BookingDelegate.instance.instantiateViewController(withIdentifier: "UserServicesList") as! UserServicesList
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goAddBillVC(controller:UIViewController?,step:String,service_request_id:String? = nil,service_inVoice : String? = nil) {
        let  VC = AppStoryboard.BookingDelegate.instance.instantiateViewController(withIdentifier: "AddBillVC") as! AddBillVC
        VC.step = step
        VC.service_request_id = service_request_id ?? ""
        VC.service_inVoice = service_inVoice ?? ""
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToTablePlaceOrder(controller:UIViewController?,shopDetails:SellerData?,personCount:String,date:String,selectedSlot:Slot_list?,selectedPostion:Postionlist? = nil) {
        let  VC = AppStoryboard.TableBooking.instance.instantiateViewController(withIdentifier: "TableBookingPlace") as! TableBookingPlace
        VC.personCount = personCount
        VC.selectedDate = date
        VC.timeSlot = selectedSlot
        VC.shopData = shopDetails
        VC.postionTbl = selectedPostion
        controller?.navigationController?.pushViewController(VC, animated: true)
    }

    static func goToTableRequest(controller:UIViewController?,bookID:String,isFromReceved:Bool? = false,isFromPopup:Bool) {
        let  VC = AppStoryboard.TableBooking.instance.instantiateViewController(withIdentifier: "TableRequestDetails") as! TableRequestDetails
        VC.bookingID = bookID
        VC.isFromReceivedBooking = isFromReceved ?? false
        VC.isFromThankYouPage = isFromPopup
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    
    static func goToTableDateAndTime(controller:UIViewController?,data:SellerData) {
        let  VC = AppStoryboard.TableBooking.instance.instantiateViewController(withIdentifier: "TableBookingDateTimeViewController") as! TableBookingDateTimeViewController
        VC.shopData = data
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
}

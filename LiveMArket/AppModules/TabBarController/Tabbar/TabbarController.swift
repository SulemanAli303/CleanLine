//
//  TabbarController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import FirebaseCore
import FirebaseMessaging
import FirebaseDatabase

import UIKit
import Firebase
import Alamofire
protocol PopupProtocol{
    func openPopup()
}

class TabbarController: UITabBarController {
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var popupDelegate:PopupProtocol?
    var customTabBarView: UIView = UIView()
    let centerButton = UIButton(type: .custom)
    var cartTabItem: UITabBarItem?
    var userData: User?
    var isFirstTriggered = false
    private var animatingImage : UIImageView?
    var notificationDBRefrence =  Database.database().reference().child("Nottifications")
    var userDBRefrence =  Database.database().reference().child("Users")
    var currentUserToken:String = ""
    var timer:Timer?
    var topVC: UINavigationController? {
        guard let topVC = AppDelegate.appDelegateInstance?.getTopViewController?.navigationController else { return nil }
        return topVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.delegate = self
        if SessionManager.isLoggedIn() {
            currentUserToken = SessionManager.getFCMToken() ?? ""
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onClickNotification(_:)), name: Notification.Name("ShowDialogNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationCountObserver), name: Notification.Name("loginStatusChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onClickNotificationDetails(_:)), name: Notification.Name("ShowDialogNotificationDetails"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearDB(_:)), name: Notification.Name("clearDB"), object: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.fetchUserDetails()
            })
        setupTabbar()
        addCustomTabBarView()
        addCenterItem()
        addViewControllers()
        setupNotificationCountObserver()
        if SessionManager.isLoggedIn() {
            timer = Timer.init(timeInterval: 900.0, repeats:true , block: updateActionLoginOnFirebase)
        }

        if let sharedInstance = NetworkReachabilityManager.default {
            sharedInstance.startListening(onQueue: .main) { status in
                switch status {
                    case .reachable(let from):
                        Utilities.hideAlertView()
                        print("connection Reachable fromt ==> \(from)")
                    case .notReachable:
                        Utilities.showWarningAlert(message: "Sorry, we are unable to detect the internet connection on your mobile. Please check your data package/wifi settings.")
                        print("connection not Reachable  ==>  ")
                        break
                    case .unknown:
                        print("connection unknown  ==>  ")
                        break
                }

                print("connection ==> \(status)")
            }

        } else {
            print("No Internet")
        }
    }

    deinit{
        timer?.invalidate()
    }

    func updateActionLoginOnFirebase(_ timer:Timer) {
        if SessionManager.isLoggedIn() {
            let firebsLoc = [
                "last_login": Date().millisecondsSince1970 ,
            ] as [String : Any]
            userDBRefrence.child(SessionManager.getUserData()?.firebase_user_key ?? "").setValue(firebsLoc)
        } else {
            timer.invalidate()
        }
    }

    @objc func clearDB(_ notification: NSNotification) {
        NotificationCenter.default.removeObserver(self)
        if SessionManager.isLoggedIn() {
            userData = SessionManager.getUserData()
        }else{ return }
            //  userData = SessionManager.getUserData()

        guard let userId = userData?.firebase_user_key, userId != "" else { return }
        print("firebase_user_key",userId)
            //        notificationTabItem.badgeValue = nil
        notificationCount = "0"
        Database.database().reference().removeAllObservers()
        notificationDBRefrence.removeAllObservers()
        notificationDBRefrence.child(userId).removeAllObservers()
    }
    @objc func onClickNotificationDetails(_ notification: NSNotification) {

        if let dict = notification.userInfo as NSDictionary? {
            if let type = dict["type"] as? String{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    Constants.shared.isCommingFromOrderPopup = true
                    let visibelVC = self.getVisibleViewController(self)
                    switch type.lowercased() {
                    case "new_order":
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        SellerOrderCoordinator.goToSellerBookingDetail(controller: visibelVC,orderId: orderId,isSeller: true, isThankYouPage: true)
                    case "food_new_order":
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        SellerOrderCoordinator.goToFoodOrderDetail(controller: visibelVC, orderId: orderId, isSeller: true, isThankYouPage: true)
                    case "driver_new_order":
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
                        VC.order_ID = orderId
                        VC.isFromThankYou = true
                        visibelVC?.navigationController?.pushViewController(VC, animated: true)
                    case "food_driver_new_order":
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
                        VC.order_ID = orderId
                        VC.isFromFoodOrder = true
                        VC.isFromThankYou = true
                        visibelVC?.navigationController?.pushViewController(VC, animated: true)
                    case "deligate_new_order_driver" :
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        Coordinator.goToServiceDelegateRequestDetails(controller: visibelVC,step: "1",serviceID: orderId,isDriver: true , isFromThanku: true)
                    case "new_service_request" :
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        Coordinator.goToServicProviderDetail(controller:  visibelVC, step: "", serviceId: orderId, isFromThank: true)
                    case "new_playground_booking" :
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                            PlayGroundCoordinator.goToBookingDetail(controller: visibelVC,isFromReceive: true,booking_ID: orderId,isFromThankYou:true)
                    case "new_chalet_booking" :
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        Coordinator.goToChaletsReservationRequest(controller: visibelVC, VCtype: "",chaletID: orderId, isFromThankYou:true)
                    case "new_hotel_booking" :
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        Coordinator.goToHotelBookingDetail(controller: visibelVC,isFromReceive: true,booking_ID: orderId ,isFromThankYou:true)
                    case "new_gym_subscription" :
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        Coordinator.goToGymRequestDetails(controller: visibelVC, subscriptionID: orderId, isFromReceived: true, isFromThankYou: true)
                    case "new_table_booking_placed_store" :
                        guard let orderId = notification.userInfo?["orderId"] as? String else { return }
                        Coordinator.goToTableRequest(controller: visibelVC,bookID: orderId,isFromReceved: true,isFromPopup: true)
                    default:
                        break
                    }
                }
            }
        }
    }

    func fetchUserDetails() {
        if SessionManager.isLoggedIn() {
            userData = SessionManager.getUserData()
        }else{ return }
        guard let userId = userData?.firebase_user_key, userId != "" else { return }
        userDBRefrence.child(userId).observe(.value) { [weak self] (snapShot) in
            guard let weakSelf = self else { return }
            guard snapShot.exists() else {
                return
            }
            if let snap = snapShot.value as? [String:Any] {
                weakSelf.currentUserToken = snap["fcm_token"] as? String ?? ""
                if weakSelf.currentUserToken != SessionManager.getFCMToken() {
                    weakSelf.notificationDBRefrence.child(userId).removeAllObservers()
                    NotificationCenter.default.post(name: Notification.Name("user_logout"), object: nil)
                    SessionManager.clearLoginSession()
                    return
                }
            }
        }
    }

    @objc func onClickNotification(_ notification: NSNotification) {
        if let vc = self.viewControllers?.last, vc.isKind(of: ValidateFacePopup.self)  {
            return
        }

        guard let type = notification.userInfo?["type"] as? String else { return }
        if let isSeen = notification.userInfo?["IsPopupSeen"] as? Int, isSeen == 1 {
            return
        } else if let key =  notification.userInfo?["key"] as? String ,  let userId = userData?.firebase_user_key, userId != ""{
            self.notificationDBRefrence.child(userId).child(key).updateChildValues(["IsPopupSeen":1])
        }

        switch type.lowercased() {
        case "new_order":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "food_new_order":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "food_driver_new_order":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "driver_new_order":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "deligate_new_order_driver" :
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "new_service_request" :
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "new_playground_booking" :
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "new_chalet_booking" :
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "new_hotel_booking" :
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "new_gym_subscription" :
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        case "new_table_booking_placed_store" :
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            self.showNotificationPopup(notiType: type,orderId:orderId )
        default:
            break
        }
    }

    func showNotificationPopup(notiType : String, orderId: String) {
        NotificationCenter.default.post(name: Notification.Name("ShowDialogNotificationToLiveVC"), object: nil,userInfo: nil)

        let  rootVC =  AppStoryboard.NotificationPopup.instance.instantiateViewController(withIdentifier: "ReservationNotificationPopup") as! ReservationNotificationPopup
        rootVC.orderId = orderId
        rootVC.notiType = notiType
        rootVC.modalPresentationStyle = .overFullScreen
        if topVC == nil{
            self.present(rootVC, animated: true)
        }else{
            topVC?.present(rootVC, animated: true, completion: nil)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    //    override func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //        updateTabbarFrame()
    //    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = true
        updateTabbarFrame()
        
        if #available(iOS 13, *) {
            self.tabBar.standardAppearance.shadowImage = nil
            self.tabBar.standardAppearance.shadowColor = nil
            self.tabBar.backgroundColor = UIColor.clear
            self.tabBar.backgroundImage = UIImage()
            self.tabBar.isTranslucent = true
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.yellow.color()], for: .selected)
            UITabBar.appearance().tintColor = Color.yellow.color()
            UITabBar.appearance().unselectedItemTintColor = UIColor.white
            
        }
        Constants.shared.tabbarHeight = self.tabBar.frame.size.height 
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupTabbar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.yellow.color()], for: .selected)
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
    }
    
    func hideTabBar() {
        self.tabBar.isHidden = true
        self.centerButton.isHidden = true
        self.customTabBarView.isHidden = true
    }
    
    func showTabBar() {
        self.tabBar.isHidden = false
        self.centerButton.isHidden = false
        self.customTabBarView.isHidden = false
        //  centerButtonBringToFront()
    }
    
    private func addCustomTabBarView() {
        let imageView = UIImageView(image: UIImage(named: "254540584880"))
        imageView.layer.shadowColor = UIColor.lightText.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        imageView.layer.shadowOpacity = 0.10
        imageView.layer.shadowRadius = 10.0
        
        let containerStack = UIStackView(arrangedSubviews: [imageView, bottomView])
        containerStack.axis = .vertical
        
        customTabBarView = containerStack
        view.addSubview(customTabBarView)
        view.bringSubviewToFront(self.tabBar)
    }
    
    private func updateTabbarFrame() {
        var bottomOffset: CGFloat = 0
        if view.safeAreaInsets.bottom > 0 {
            bottomOffset = (view.safeAreaInsets.bottom - 35)
        } else {
            bottomOffset = 22
        }
        tabBar.frame.size.height = tabBar.frame.size.height + bottomOffset
        tabBar.frame.origin.y = tabBar.frame.origin.y - bottomOffset
        customTabBarView.frame = tabBar.frame
    }
    
    func addViewControllers() {
        self.viewControllers = [home, discover,moreOptions,message, profile]
    }
    func addCenterItem() {
        centerButton.addColorShadow = true
        centerButton.addTarget(self, action: #selector(centerItemTapped), for: .touchUpInside)
        centerButton.setBackgroundImage(#imageLiteral(resourceName: "center").withRenderingMode(.alwaysOriginal), for: .normal)
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        centerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        centerButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(centerButton)
        view.centerXAnchor.constraint(equalTo: centerButton.centerXAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: centerButton.bottomAnchor, constant: tabBar.frame.size.height - 40).isActive = true
    }
    
    @objc func centerItemTapped() {
        print(selectedIndex)
        if (selectedIndex == 0){
            Constants.shared.isPopupShow = false
            self.popupDelegate?.openPopup()
            //NotificationCenter.default.post(name: Notification.Name("openOptionsHome"), object: nil)
        }else if (selectedIndex == 1){
            //NotificationCenter.default.post(name: Notification.Name("openOptionsDiscover"), object: nil)
            self.popupDelegate?.openPopup()
        }else if (selectedIndex == 3){
            //NotificationCenter.default.post(name: Notification.Name("openOptionsMessage"), object: nil)
            self.popupDelegate?.openPopup()
        }else if (selectedIndex == 4){
            //NotificationCenter.default.post(name: Notification.Name("openOptionsProfile"), object: nil)
            self.popupDelegate?.openPopup()
        }
        
        
        
    }
    
    func setCenterSelected() {
        centerButton.setBackgroundImage(#imageLiteral(resourceName: "icon_post_requirement").withRenderingMode(.alwaysOriginal), for: .normal)
    }
    func getNavigationController() -> UINavigationController? {
        if let currentNavController = tabBarController?.selectedViewController as? UINavigationController {
            return currentNavController
        }
        return nil
    }
    
    
    func setCenterUnselected() {
        centerButton.setBackgroundImage(#imageLiteral(resourceName: "icon_post_requirement").withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func set(selectedIndex index : Int) {
        _ = self.tabBarController(self, shouldSelect: self.viewControllers![index])
        selectedIndex = index
    }
    
    var home: UINavigationController {
        let VC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        VC.delegateToReset = self
        let tabBarItem = UITabBarItem(title: "Home".localiz(), image: UIImage(named: "Home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "HomeSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        //tabBarItem.imageInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        setTabbarItemSize(tabBarItem: tabBarItem)
        print(self.tabBar.bounds.size.height)
        VC.tabBarItem = tabBarItem
        return UINavigationController.init(rootViewController: VC)
    }

    var discover: UINavigationController {
        let  VC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "ResturantListViewController") as! ResturantListViewController
        let tabBarItem = UITabBarItem(title: "Discover".localiz(), image: UIImage(named: "Discover")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "DiscoverSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        setTabbarItemSize(tabBarItem: tabBarItem)
        VC.tabBarItem = tabBarItem
        return UINavigationController.init(rootViewController: VC)
    }
    
    var moreOptions: UINavigationController {
        let VC = AppStoryboard.MoreOptions.instance.instantiateViewController(withIdentifier: "MoreOptionsViewController") as! MoreOptionsViewController
        let tabBarItem = UITabBarItem(title: "".uppercased(), image: UIImage(), selectedImage: nil)
        VC.tabBarItem = tabBarItem
        return UINavigationController.init(rootViewController: VC)
    }
    
    var message: UINavigationController {
        let VC = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        let tabBarItem = UITabBarItem(title: "Messages".localiz(), image: UIImage(named: "message")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "messageSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        //  setTabbarItemSize(tabBarItem: tabBarItem)
        // tabBarItem.badgeValue = "5"
        // tabBarItem.badgeColor = .red
        VC.tabBarItem = tabBarItem
        cartTabItem = tabBarItem
        return UINavigationController.init(rootViewController: VC)
    }
    
    var profile: UINavigationController {
        let VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let tabBarItem = UITabBarItem(title: "Profile".localiz(), image: UIImage(named: "profile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "profileSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        // setTabbarItemSize(tabBarItem: tabBarItem)
        VC.tabBarItem = tabBarItem
        return UINavigationController.init(rootViewController: VC)
    }
    func setTabbarItemSize(tabBarItem:UITabBarItem) {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136,1334:
                // tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                break
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
                
            case 2436:
                print("iPhone X/XS/11 Pro")
                // tabBarItem.imageInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
                break
                
            case 2688:
                print("iPhone XS Max/11 Pro Max")
                // tabBarItem.imageInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
                break
                
            case 1792:
                print("iPhone XR/ 11 ")
                //  tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                break
                
            default:
                // tabBarItem.imageInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)\
                break
            }
        }
    }
}

extension TabbarController: UITabBarControllerDelegate {
    
    fileprivate func reloadNewsFeedFromTabbar(in vc: UIViewController) -> Bool{
        
        guard let navVc = vc as? HomeViewController, navVc .isKind(of: HomeViewController.self) else {return true}
        tabBar.items?.first?.image = UIImage(named: "reload3x")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBar.items?.first?.selectedImage = UIImage(named: "reload3x")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        guard let item = tabBar.items?.first else {return false}
        item.title = ""
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx + 1, let imageView = tabBar.subviews[idx + 5].subviews.first as? UIImageView else {
            return false
        }
        animatingImage = imageView
        imageView.rotate(duration: 1.0)
        //NotificationCenter.default.post(name: Notification.Name("reloadHomePage"), object: nil)
        navVc.tabbarHomeButtonRefresh()
        return false
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let visibelVC = self.getVisibleViewController(self)
        
        guard let navigationVC = viewController as? UINavigationController else { return true }
        
        switch navigationVC.viewControllers.first {
            
        case  is MoreOptionsViewController :
            return false
        case is ResturantListViewController:
            //            if !SessionManager.isLoggedIn() {
            //                Coordinator.presentLogin(viewController: self)
            //            }
            //            return SessionManager.isLoggedIn()
            VideoPlayerManager.shared.reset()
            return true
        case is ChatVC:
            if !SessionManager.isLoggedIn() {
                //Coordinator.presentLogin(viewController: self)
                Coordinator.setRoot(controller: self)
            }
            return SessionManager.isLoggedIn()
        case is ProfileViewController:
            if !SessionManager.isLoggedIn() {
                //Coordinator.presentLogin(viewController: self)
                Coordinator.setRoot(controller: self)
            }
            return SessionManager.isLoggedIn()
        case  is HomeViewController :
            //NotificationCenter.default.post(name: NSNotification.Name("RefreshPosts"), object: nil)
            guard self.selectedIndex == 0 else{
                return true
            }
            VideoPlayerManager.shared.reset()
            if let vc = navigationVC.viewControllers.last {
                return reloadNewsFeedFromTabbar(in: vc)
            }else{
                return true
            }
            
        default:
            break
        }
        return true
    }
    
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
}
extension TabbarController {
    @objc func setupNotificationCountObserver()  {
        if SessionManager.isLoggedIn() {
            userData = SessionManager.getUserData()
        }else{ return }
        //  userData = SessionManager.getUserData()
        
        guard let userId = userData?.firebase_user_key, userId != "" else { return }
        print("firebase_user_key",userId)
        //        notificationTabItem.badgeValue = nil
        notificationCount = "0"
        
        notificationDBRefrence.child(userId).observe(.childAdded, with: { snapshot in
            if let value = snapshot.value as? [String:Any], let read = value["read"] as? String, read == "0" {
                if let value = Int(notificationCount ) {
                    
                    notificationCount = String(value + 1)
                } else {
                    
                    notificationCount =  "1"
                }
            }
            
        })
        notificationDBRefrence.child(userId).observe(.value , with:{[weak self] snapshot in
            guard let self = self else {return}

            if !self.isFirstTriggered {
                self.isFirstTriggered = true
                return
            }

            guard snapshot.exists(), let notifications = snapshot.children.allObjects as? [DataSnapshot] else {
            return
            }

           if self.currentUserToken != SessionManager.getFCMToken() {
               self.notificationDBRefrence.child(userId).removeAllObservers()
               return
           }
            if var value = notifications.last?.value as? [String:Any],let key =  notifications.last?.key {

                if value["type"] == nil {
                    if value["notificationType"] != nil {
                        value["type"] = value["notificationType"]
                    }
                }
                value["key"] = key

                guard let type = value["type"] as? String else { return }
                switch type.lowercased() {
                    case "driver_new_order", "new_order", "new_service_request", "new_chalet_booking", "gym_subscription_completed", "new_gym_subscription", "new_hotel_booking", "new_playground_booking",
                        "food_new_order", "new_table_booking_placed_store", "deligate_new_order_driver" :
                        if let isSeen = value["IsPopupSeen"] as? Int, isSeen == 1 {

                        } else {
                            (UIApplication.shared.delegate as? AppDelegate)?.playBeep()
                        }
                    case "identity_verification":
                        if SessionManager.isLoggedIn() {
                            NotificationCenter.default.post(name: Notification.Name("verifyYourIdentity"), object: nil,userInfo: value)
                        }
                    default:
                        break
                }
                NotificationCenter.default.post(name: Notification.Name("ShowDialogNotification"), object: nil,userInfo: value)

            }
        })

        notificationDBRefrence.child(userId).observe(.childChanged, with: {[weak self] snapshot in

            guard let self = self else {return}


            if let value = snapshot.value as? [String:Any], let read = value["read"] as? String, read == "1" {
                if let value = Int(notificationCount ) {
                    if value - 1 <= 0 {
                        notificationCount = "0"
                    } else {
                        notificationCount = String(value - 1)
                    }
                } else {
                    
                    notificationCount = "1"
                }
                
            }
        })
        
        notificationDBRefrence.child(userId).observe(.childRemoved, with: { [weak self] snapshot in
            guard let self = self else {return}
            if let value = snapshot.value as? [String:Any], let read = value["read"] as? String, read == "0" {
                if let value = Int(notificationCount ) {
                    if value - 1 <= 0 {
                        
                        notificationCount = "0"
                    } else {
                        
                        notificationCount = String(value - 1)
                    }
                } else {
                    
                    notificationCount = "1"
                }
                
            }
        })
    }
}

extension TabbarController: FeedDelegate{
    func finishResetingFeed() {
        animatingImage?.stopRotating()
        tabBar.items?.first?.title = "Home"
        tabBar.items?.first?.image = UIImage(named: "Home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBar.items?.first?.selectedImage = UIImage(named: "HomeSelected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
    }
}


extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.toValue = 0.0
            rotationAnimation.fromValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}
extension TabbarController : ReservationNotificationPopupProtocol {
    func viewDetails(notiyType: String, orderId: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let visibelVC = self.getVisibleViewController(self)
            switch notiyType.lowercased() {
            case "new_order":
                SellerOrderCoordinator.goToSellerBookingDetail(controller: self.topVC,orderId: orderId,isSeller: true, isThankYouPage: false)
            case "food_new_order":
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self.topVC, orderId: orderId, isSeller: true, isThankYouPage: true)
            case "driver_new_order":
                let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
                VC.order_ID = orderId
                self.topVC?.navigationController?.pushViewController(VC, animated: true)
            case "food_driver_new_order":
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self.topVC, orderId: orderId, isSeller: false, isThankYouPage: true)
            case "deligate_new_order_driver" :
                Coordinator.goToServiceDelegateRequestDetails(controller: self.topVC,step: "1",serviceID: orderId,isDriver: true , isFromThanku: true)
            case "new_service_request" :
                Coordinator.goToServicProviderDetail(controller:  self.topVC, step: "", serviceId: orderId, isFromThank: true)
            case "new_playground_booking" :
                PlayGroundCoordinator.goToBookingDetail(controller: self.topVC,isFromReceive: true,booking_ID: orderId)
            case "new_chalet_booking" :
                Coordinator.goToChaletsReservationRequest(controller: self.topVC, VCtype: "",chaletID: orderId)
            case "new_hotel_booking" :
                Coordinator.goToHotelBookingDetail(controller: self.topVC,isFromReceive: true,booking_ID: orderId )
            case "new_gym_subscription" :
                Coordinator.goToGymRequestDetails(controller: self.topVC, subscriptionID: orderId, isFromReceived: true, isFromThankYou: true)
            default:
                break
            }
        }
    }
}

//
//  ProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit
import FittedSheets
import STRatingControl
import ContextMenuSwift
import AVFAudio
import Cosmos

struct ManageProfile{
    var name:String?
    var icon:String?
    var count:String?
}

class ProfileViewController: BaseViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var stackViewBottamConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bookTabelSwitchButton: UIButton!
    @IBOutlet weak var bookATabelView: UIView!
    @IBOutlet weak var newOrdersCountLabel: UILabel!
    @IBOutlet weak var processCountLabel: UILabel!
   // @IBOutlet weak var hotelBookingCountLabel: UILabel!
   // @IBOutlet weak var subscriptionCountLabel: UILabel!
    @IBOutlet weak var feedColletionView: UICollectionView!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    //@IBOutlet weak var manageStackView: UIStackView!
    @IBOutlet weak var postStackView: UIStackView!
    
    @IBOutlet weak var orderOnProcessLabel: UILabel!
    @IBOutlet weak var newOrderLabel: UILabel!
    @IBOutlet weak var myFeedButton: UIButton!
    
    var imagePicker: ImagePicker!
    var imgType = ""
    
    @IBOutlet weak var hideProfileButton: UIButton!
   // @IBOutlet weak var deliveryRequestStackView: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingCount: UILabel!
    @IBOutlet weak var ratingView: CosmosView!{
        didSet{
            ratingView.settings.fillMode = .half
            ratingView.settings.starMargin = 5
            ratingView.settings.starSize = 20
            ratingView.settings.minTouchRating = 0
        }
    }
    //@IBOutlet weak var deliveryRequestCountLabel: UILabel!
    //@IBOutlet weak var currencyLabel: UILabel!
    //@IBOutlet weak var balaceCountLabel: UILabel!
   // @IBOutlet weak var myReveiwCountLabel: UILabel!
   // @IBOutlet weak var myOrdersCountLabel: UILabel!
   // @IBOutlet weak var serviceCountLbl: UILabel!
    @IBOutlet weak var simpleProfile: UIView!
    @IBOutlet weak var simpleProfile_2: UIView!
    @IBOutlet weak var chaletView: UIView!
    
    var VCtype : String?
    var module = 0
    @IBOutlet weak var profileImageBgView: UIView!
    @IBOutlet weak var profileBg: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    //@IBOutlet weak var myBooking: UILabel!
    
    var userData: User?
    var postCollectionArray : [PostCollection] = []
    private var initialPageCount = 100
    var selectedPostID:String = ""
    var isToggled:Bool = true
    var notificationSoundEffect = AVAudioPlayer()
    var manageProfileArray:[ManageProfile] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .accountsTop
        viewControllerTitle = ""//"My Account"
       
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("openOptionsProfile"), object: nil)
        
        // Do any additional setup after loading the view.
        
        if VCtype == "car"
        {
            profileBg.image = UIImage(named: "carbg")
            profileImageView.image = UIImage(named: "carp")
            titleLbl.text = ""
            
        }
//        self.manageProfile.backgroundColor = UIColor(hex: "E77F1A")
//        self.manageProfileLbl.textColor = UIColor(hex: "ffffff")
//        self.manageProfile.layer.borderColor = UIColor(hex: "ffffff").cgColor
//        self.myFeed.backgroundColor = UIColor(hex: "ffffff")
//        self.myFeedLbl.textColor = UIColor(hex: "535353")
//        self.myFeed.layer.borderColor = UIColor(hex: "B7B7B7").cgColor
        self.postStackView.isHidden = false
        self.setFeedPostCell()
        setupLongGestureRecognizerOnCollection()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)

        type = .accountsTop
        viewControllerTitle = ""//"My Account"
        userData = SessionManager.getUserData()
        
        guard SessionManager.getAccessToken() ?? "" != "" else {
            self.tabBarController?.selectedIndex = 0
            return
        }
        
        module = UserDefaults.standard.integer(forKey: "flow")
        //changeProfileImg()
        if self.imgType == "" {
            if userData?.user_type_id == "6"{
                self.driverProfileAPI()
            } else {
                self.commonProfileAPI()
            }
        }
        self.setGradientBackground()
        
        if SessionManager.getUserData()?.user_type_id ?? "" == "2" {
            self.chaletView.isHidden = false
            self.simpleProfile.isHidden = true
            self.simpleProfile_2.isHidden = true
        }else {
            self.chaletView.isHidden = true
            self.simpleProfile.isHidden = false
            self.simpleProfile_2.isHidden = false
        }
        let tabbar = tabBarController as? TabbarController
        tabbar?.popupDelegate = self
        tabbar?.showTabBar()
        if hasTopNotch {
            stackViewBottamConstraint.constant = 80
        }else{
            stackViewBottamConstraint.constant = 30
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    func configureLanguage(){
        orderOnProcessLabel.text = "Orders on Process".localiz()
        newOrderLabel.text = "New Orders".localiz()
        myFeedButton.setTitle("My Feed".localiz(), for: .normal)
    }
    @objc func setupNotificationObserver(){
        if userData?.user_type_id == "6"{
            self.driverProfileAPI()
        } else {
            self.commonProfileAPI()
        }
    }

    var profileData:ProfileData?{
        didSet{
            
            if let viewControllers = self.navigationController?.viewControllers{
                if viewControllers.count == 1 
                {
                    self.imgType = ""
                    if let data = profileData?.data{
                        profileDetails = data
                        Constants.shared.referralCode = data.my_refereal_code ?? ""
                        Constants.shared.referralText = data.referel_text ?? ""

                        //NotificationCenter.default.post(name: Notification.Name(rawValue: "switchAccount"), object: nil)
                        
                        if data.show_table_booking_enable_button == "1"{
                            self.bookATabelView.isHidden = false
                            if data.is_table_booking_available == "1"{
                                bookTabelSwitchButton.setImage(UIImage(named: "foodServingSwitchOn"), for: .normal)
                            }else{
                                bookTabelSwitchButton.setImage(UIImage(named: "foodServingSwitchOff"), for: .normal)
                            }
                            
                        }
                        else
                        {
                            self.bookATabelView.isHidden = true
                        }
                }
            }
                self.setUpAccountsVC(isDriver: false)
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "switchAccount"), object: nil)
            }
        }
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        feedColletionView?.addGestureRecognizer(longPressedGesture)
        
    }
    override func SwitchBtnAction() {
        self.SwitchAccount()
    }
    override func SwitchBtnAction_hide() {
        Utilities.showQuestionAlert(message: profileDetails?.hide_profile == "1" ? "Your account will be visible, and you will start receiving requests.".localiz() : "Your account will no longer be visible to others.".localiz()){
            self.hideAndUnhideProfileAPI()
        }
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        if !isToggled{
            let p = gestureRecognizer.location(in: feedColletionView)
            
            if let indexPath = feedColletionView?.indexPathForItem(at: p) {
                print("Long press at item: \(indexPath.row)")
                if self.postCollectionArray[indexPath.row].postedUserId ?? "" == userData?.id ?? ""{
                    guard let cell = feedColletionView.cellForItem(at: indexPath) else { return  }
                    //let share = ContextMenuItemWithImage(title: "Share", image: #imageLiteral(resourceName: "Group 236131"))
                    let edit = "Set Default"
                    self.selectedPostID = self.postCollectionArray[indexPath.row].postId ?? ""
                    let delete = "Delete"
                    CM.MenuConstants.horizontalDirection = .right
                    CM.items = [edit,delete]
                    CM.showMenu(viewTargeted:cell, delegate: self)
                }
            }
        }
    }
    
    var profileDetails:ProfileDetails?{
        didSet{
            
            //serviceCountLbl.text = profileDetails?.service_request_count ?? ""
            titleLbl.text = profileDetails?.name ?? ""
            locationLabel.text = profileDetails?.location_data?.location_name ?? ""
          //  print( ratingView.rating = Int(profileDetails?.rating ?? "") ?? 0)
           
            ratingView.rating =  Double(profileDetails?.rating ?? "") ?? 0
           // myOrdersCountLabel.text = (profileDetails?.my_order_count ?? "")
            
//            if SessionManager.getUserData()?.user_type_id == "2"{
//                self.newOrdersCountLabel.isHidden = true
//                self.processCountLabel.isHidden = true
//            }else{
                
                let total = (Int(profileData?.data?.new_order ?? "") ?? 0)
                self.newOrdersCountLabel.text = String(total)
                if total > 0 {
                    self.newOrdersCountLabel.isHidden = false
                }else {
                    self.newOrdersCountLabel.isHidden = true
                }
                
                let total2 = (Int(profileData?.data?.in_process ?? "") ?? 0)
                self.processCountLabel.text = String(total2)
                if total2 > 0 {
                    self.processCountLabel.isHidden = false
                }else {
                    self.processCountLabel.isHidden = true
                }
        //    }

            //deliveryRequestCountLabel.text = profileDetails?.request_count ?? ""
//            myReveiwCountLabel.text = profileDetails?.rated_users ?? ""
//            balaceCountLabel.text = profileDetails?.wallet_amount ?? ""
//            currencyLabel.text = profileDetails?.currency_code ?? ""
            profileBg.sd_setImage(with: URL(string: profileDetails?.banner_image ?? ""), placeholderImage: UIImage(named: "placeholder_banner"))
            profileImageView.sd_setImage(with: URL(string: profileDetails?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            ratingCount.text = "\(profileDetails?.rating ?? "")/5"
            /// Check user is driver
            if profileDetails?.user_type_id == "6"{
               // deliveryRequestStackView.isHidden = false
            }else{
              //  deliveryRequestStackView.isHidden = true
            }
            if profileDetails?.hide_profile == "1" {
                hideProfileButton.setImage(UIImage(named: "switch_on"), for: .normal)
            }else{
                hideProfileButton.setImage(UIImage(named: "switch_off"), for: .normal)
            }
            setUpAccountsVC(isDriver: profileDetails?.user_type_id == "6")
            postCountLabel.text = profileDetails?.post_count ?? ""
            followersCountLabel.text = profileDetails?.followers_count ?? ""
            followingCountLabel.text = profileDetails?.following_count ?? ""
            //subscriptionCountLabel.text = profileDetails?.subscription_count ?? ""
            
            self.manageProfileArray.removeAll()
            let myOrderCount:Int = (Int(profileDetails?.my_order_count ?? "0") ?? 0) + (Int(profileDetails?.received_order_count ?? "0") ?? 0)
            if myOrderCount > 0{
                let profile = ManageProfile(name: "My Orders".localiz(), icon: "myOrderIcon", count: "\(myOrderCount)")
                manageProfileArray.append(profile)
            }
            
            //let userInfo = ["isDriver":false]
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "switchAccount"), object: nil,userInfo: userInfo)
            
            if let accountTypeArray = profileDetails?.active_accounts{
                if accountTypeArray.contains(where: {$0.account_type_id == "6"}){
                    //let userInfo = ["isDriver":true]
                    //NotificationCenter.default.post(name: Notification.Name(rawValue: "switchAccount"), object: nil,userInfo: userInfo)
                    //if profileDetails?.is_notifiable == "1" {
                    let deliveryRequest = ManageProfile(name: "Delivery Requests".localiz(), icon: "DelegateServicesIcon", count: profileDetails?.delivery_request_count ?? "")
                        manageProfileArray.append(deliveryRequest)
                   // }else {
                    let delegateService = ManageProfile(name: "Delivery Services".localiz(), icon: "DelegateServicesIcon", count: "")
                        manageProfileArray.append(delegateService)
                   // }
                }else{
                    let delegateService = ManageProfile(name: "Delivery Services".localiz(), icon: "DelegateServicesIcon", count: "")
                    manageProfileArray.append(delegateService)
                }
            }
            
            
//            if profileDetails?.user_type_id == "6"{
//                if profileDetails?.is_notifiable == "1" {
//                    let delegateService = ManageProfile(name: "Delivery Requests", icon: "DelegateServicesIcon", count: profileDetails?.delivery_request_count ?? "")
//                    manageProfileArray.append(delegateService)
//
//                }else {
//                    let delegateService = ManageProfile(name: "Delivery Services", icon: "DelegateServicesIcon", count: "")
//                    manageProfileArray.append(delegateService)
//                }
//            }else {
//                let delegateService = ManageProfile(name: "Delivery Services", icon: "DelegateServicesIcon", count: "")
//                manageProfileArray.append(delegateService)
//            }
            
            
            let serviceRequestCount:Int = (Int(profileDetails?.service_request_count ?? "0") ?? 0) + (Int(profileDetails?.received_service_request_count ?? "0") ?? 0)
            if serviceRequestCount > 0{
                let profile = ManageProfile(name: "Service Booking".localiz(), icon: "serviceBookingIcon", count: "\(serviceRequestCount)")
                manageProfileArray.append(profile)
            }
//            if (profileDetails?.activity_type_id ?? "0") == "12" {
//                if (Int(profileDetails?.received_table_booking_count ?? "0") ?? 0) > 0 {
//                    let profile = ManageProfile(name: "Table Booking", icon: "myOrderIcon", count: "")
//                    manageProfileArray.append(profile)
//                }
//            }else {
//                if (Int(profileDetails?.table_booking_count ?? "0") ?? 0) > 0 {
//                    let profile = ManageProfile(name: "Table Booking", icon: "myOrderIcon", count: "")
//                    manageProfileArray.append(profile)
//                }
//            }
            
            //let chaletCount:Int = (Int(profileDetails?.chalet_booking_count ?? "0") ?? 0) + (Int(profileDetails?.received_chalet_booking_count ?? "0") ?? 0)
            let chaletCount:Int = (Int(profileDetails?.chalet_booking_count ?? "0") ?? 0) + (Int(profileDetails?.received_chalet_booking_count ?? "0") ?? 0)
            if chaletCount > 0{
                let profile = ManageProfile(name: "My Bookings".localiz(), icon: "myBookingIcon", count: "\(chaletCount)")
                manageProfileArray.append(profile)
            }
            
            let gymSubscriptionCount:Int = (Int(profileDetails?.gym_subscription_count ?? "0") ?? 0) + (Int(profileDetails?.received_gym_subscription_count ?? "0") ?? 0)
            if gymSubscriptionCount > 0{
                let profile = ManageProfile(name: "Subscriptions".localiz(), icon: "subscriptionIcon", count: "\(gymSubscriptionCount)")
                manageProfileArray.append(profile)
            }
            
            //let groundBookingCount:Int = (Int(profileDetails?.ground_booking_count ?? "0") ?? 0) + (Int(profileDetails?.received_ground_booking_count ?? "0") ?? 0)
            let groundBookingCount:Int = (Int(profileDetails?.ground_booking_count ?? "0") ?? 0) + (Int(profileDetails?.received_ground_booking_count ?? "0") ?? 0)
            if groundBookingCount > 0{
                let profile = ManageProfile(name: "Ground Booking", icon: "groundBookingIcon", count: "\(groundBookingCount)")
                manageProfileArray.append(profile)
            }
            
//            let hotelBookingCount:Int = (Int(profileDetails?.hotel_booking_count ?? "0") ?? 0) + (Int(profileDetails?.received_hotel_booking_count ?? "0") ?? 0)
            let hotelBookingCount:Int = (Int(profileDetails?.hotel_booking_count ?? "0") ?? 0) + (Int(profileDetails?.received_hotel_booking_count ?? "0") ?? 0)
            if hotelBookingCount > 0{
                let profile = ManageProfile(name: "Hotel Booking", icon: "HotelBookingIcon", count: "\(hotelBookingCount)")
                manageProfileArray.append(profile)
            }
            
            let reviewCount:Int = (Int(profileDetails?.rated_users ?? "0") ?? 0)
            if reviewCount > 0{
                let profile = ManageProfile(name: "My Review", icon: "MyReviewIcon", count: "\(reviewCount)")
                manageProfileArray.append(profile)
            }
            
            //let walletAmount:Float = (Float(profileDetails?.wallet_amount ?? "0.0") ?? 0.0)
//            if walletAmount > 0{
//                let profile = ManageProfile(name: "Balance", icon: "MyBalanceIcon", count: "\(walletAmount)")
//                manageProfileArray.append(profile)
//            }
            //let walletAmount:Double = (Double(profileDetails?.wallet_amount ?? "0") ?? 0)
            let balance = ManageProfile(name: "Balance", icon: "MyBalanceIcon", count: profileDetails?.wallet_amount ?? "0.0")
            manageProfileArray.append(balance)
            
            let tableBooking = ManageProfile(name: "Table Booking", icon: "tableBookingIcon", count: "")
            manageProfileArray.append(tableBooking)
            
            let settings = ManageProfile(name: "Settings", icon: "MySettingsIcon", count: "")
            manageProfileArray.append(settings)
            
           // let logout = ManageProfile(name: "Logout", icon: "logouticonmanage", count: "")
           // manageProfileArray.append(logout)
            
//            let logout = ManageProfile(name: "Logout", icon: "MyReviewIcon", count: "")
//            manageProfileArray.append(logout)
            
            
            DispatchQueue.main.async {
                self.feedColletionView.reloadData()
            }
            

            //    var manageProfileArray = ["My Orders","Service Booking","My Bookings","Subscriptions","Ground Booking","Hotel Booking","My Review","Balance","Settings"]
            //    var manageProfileImageArray = ["myOrderIcon","serviceBookingIcon","MyBookingIcon","subscriptionIcon","MyReviewIcon","MyReviewIcon","MyReviewIcon","MyBalanceIcon","MySettingsIcon"]
        }
    }

    //   func changeProfileImg()
    //    {
    //        if module == 0  //INDIVIDUALS
    //        {
    //
    //            profileBg.image = UIImage(named: "iprofile")
    //            profle.image = UIImage(named: "iprofile2")
    //            titleLbl.text = "Olivia Stanford"
    //
    //        } else if module == 1 //WHOLESSALLER
    //        {
    //
    //            profileBg.image = UIImage(named: "Path 321175")
    //            profle.image = UIImage(named: "Ellipse 636")
    //            titleLbl.text = "Stuffed Zucchini"
    //
    //        }else if module == 2 //COMMERCIAL CENTERS (SHOPS)
    //        {
    //            profileBg.image = UIImage(named: "Path 321175")
    //            profle.image = UIImage(named: "Ellipse 636")
    //            titleLbl.text = "Stuffed Zucchini"
    //
    //        }else if module == 3    //"DELIVERY REPRESENTATIVE"
    //        {
    //
    //            profileBg.image = UIImage(named: "carbg")
    //            profle.image = UIImage(named: "carp")
    //            titleLbl.text = "Daniel Alexandar"
    //
    //        }
    //        else if module == 4 //RESERVATIONS
    //        {
    //            profileBg.image = UIImage(named: "Path 321175 (3)")
    //            profle.image = UIImage(named: "CompositeLayer (3)")
    //            titleLbl.text = "Crown Palace"
    //
    //        }else if module == 5 //SERVICE PROVIDER
    //        {
    //
    //            profileBg.image = UIImage(named: "Path 321176")
    //            profle.image = UIImage(named: "CompositeLayer 1")
    //            titleLbl.text = "Skill Providers"
    //        }
    //    }
    
    func setFeedPostCell() {
        feedColletionView.delegate = self
        feedColletionView.dataSource = self
        feedColletionView.register(UINib.init(nibName: "SellerOrderCell", bundle: nil), forCellWithReuseIdentifier: "SellerOrderCell")
        feedColletionView.register(UINib.init(nibName: "ManageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ManageCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.feedColletionView.collectionViewLayout = layout
        
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        OpenPopUp()
    }
    
    @IBAction func Lgout(_ sender: UIButton) {
        Utilities.showQuestionAlert(message: "Are you sure you want to logout?".localiz()){
            self.logoutAPI()
        }
    }
    @IBAction func moveToNext(_ sender: UIButton) {
        //        if SessionManager.getUserData()?.user_type_id ?? "" == "2" {
        //            Coordinator.goToCharletsListVC(controller: self, venderID: "")
        //        }else {
        //        }
        isToggled.toggle() // Toggle the boolean value
        if isToggled {
            sender.setTitle("My Feed".localiz(), for: .normal)
            self.manageProfileAction(sender)
        } else {
            sender.setTitle("Manage Profile".localiz(), for: .normal)
            self.myFeedAction(sender)
        }
    }
    
    func logoutAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AuthenticationAPIManager.logoutAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Constants.shared.searchHashTagText = ""
                UserDefaults.standard.removeObject(forKey: "flow")
                SessionManager.clearLoginSession()
                Coordinator.setRoot(controller: self)
                let tabbar = self.tabBarController as? TabbarController
                tabbar?.hideTabBar()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    override func likeAction() {
        let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "FavouriteListViewController") as! FavouriteListViewController
        VC.isFromResturant = true
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func updateProfileImage(_ sender: UIButton) {
        if profileDetails?.user_type_id == UserAccountType.ACCOUNT_TYPE_DELIVERY_REPRESENTATIVE.rawValue {
            if profileDetails?.allow_profile_pic_upload == "1" {
                imgType = "1"
                self.imagePicker.present(from: self.view)
            } else {
                showRequestAlert()
            }
        } else {
            imgType = "1"
            self.imagePicker.present(from: self.view)
        }
    }

    func showRequestAlert() {
        let vc = UIAlertController(title: "Request to Change Profile Image?".localiz(), message: "", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Yes".localiz(), style: .default){ ac in
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? ""
            ]
            AuthenticationAPIManager.profilePicChangeRequest(parameters: parameters) { response in
                Utilities.showWarningAlert(message: response.message ?? "") {

                }
            }
        })

        vc.addAction(UIAlertAction(title: "No".localiz(), style: .cancel){ ac in

        })

        self.present(vc,animated: true)
    }

    @IBAction func updateProfileBanner(_ sender: UIButton) {
        imgType = "2"
        self.imagePicker.present(from: self.view)
    }
    @IBAction func MyOrders(_ sender: UIButton) {
        if userData?.user_type_id == "6"{
            let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
            VC.isFromDriver = true
            self.navigationController?.pushViewController(VC, animated: true)
        }else if userData?.user_type_id == "1"{
            let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
            
            if userData?.activity_type_id == "12"{
                VC.isFromResturant = true
            }else if userData?.activity_type_id == "10"{
                VC.isFromResturant = false
            }else{
                VC.isFromResturant = false
            }
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else{
            SellerOrderCoordinator.goToNewOrder(controller: self, status: "")
        }
        
    }
    
    @IBAction func MyReviews(_ sender: UIButton) {
        
        if userData?.user_type_id == "6"{
            SellerOrderCoordinator.goToMyReviews(controller: self,store_id: SessionManager.getUserData()?.id ?? "",isFromProfile: true,isFromDriver: true)
        }else{
            SellerOrderCoordinator.goToMyReviews(controller: self,store_id: SessionManager.getUserData()?.id ?? "",isFromProfile: true,isFromDriver: false)
        }
        
    }
    @IBAction func Balance(_ sender: UIButton) {
        
        SellerOrderCoordinator.goToBalance(controller: self)
        
    }
    @IBAction func Settings(_ sender: UIButton) {
        SellerOrderCoordinator.goToSettings(controller: self)
      //  SellerOrderCoordinator.goToDeliveryRequests(controller: self)
        
    }
    @IBAction func deliveryRequests(_ sender: UIButton) {
        SellerOrderCoordinator.goToDeliveryRequests(controller: self,verified: "1")
        
    }
    
    @IBAction func MyServices(_ sender: UIButton) {
        
        let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewServicesViewController") as! NewServicesViewController
        VC.isFromDriver = false
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    @IBAction func hotelBookingAction(_ sender: UIButton) {
        
        let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "HotelBookingListViewController") as! HotelBookingListViewController
        VC.isFromDriver = false
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func groundBookingAction(_ sender: UIButton) {
        let  VC = AppStoryboard.BookNowDetail.instance.instantiateViewController(withIdentifier: "PGBookingListViewController") as! PGBookingListViewController
        VC.isFromDriver = false
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func DelegateServices(_ sender: UIButton) {
        
        Coordinator.goToServiceUserList(controller: self)
       // Coordinator.goToChooseDelegate(controller: self)
       // Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: "51")
    }
    
    @IBAction func myBookingAction(_ sender: UIButton) {
        let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewBookingViewController") as! NewBookingViewController
        VC.isFromDriver = false
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func hideProfileAction(_ sender: UIButton) {
        
        if profileDetails?.hide_profile == "1" {
            Utilities.showQuestionAlert(message: "Hurray! you will start receiving orders and you can post and go live now.".localiz()){
                self.hideAndUnhideProfileAPI()
            }
        }else{
            Utilities.showQuestionAlert(message: "Your account will not receive any orders, and you cannot go live and post videos.".localiz()){
                self.hideAndUnhideProfileAPI()
            }
        }
        
        
    }
    @IBAction func manageProfileAction(_ sender: UIButton) {
//        self.manageProfile.backgroundColor = UIColor(hex: "E77F1A")
//        self.manageProfileLbl.textColor = UIColor(hex: "ffffff")
//        self.manageProfile.layer.borderColor = UIColor(hex: "ffffff").cgColor
//        self.myFeed.backgroundColor = UIColor(hex: "ffffff")
//        self.myFeedLbl.textColor = UIColor(hex: "535353")
//        self.myFeed.layer.borderColor = UIColor(hex: "B7B7B7").cgColor
       // self.manageStackView.isHidden = true
        self.postStackView.isHidden = false
        self.feedColletionView.reloadData()
    }
    @IBAction func myFeedAction(_ sender: UIButton) {
        self.getUserPosts()
//        self.myFeed.backgroundColor = UIColor(hex: "E77F1A")
//        self.myFeedLbl.textColor = UIColor(hex: "ffffff")
//        self.myFeed.layer.borderColor = UIColor(hex: "ffffff").cgColor
//        self.manageProfile.backgroundColor = UIColor(hex: "ffffff")
//        self.manageProfileLbl.textColor = UIColor(hex: "535353")
//        self.manageProfile.layer.borderColor = UIColor(hex: "B7B7B7").cgColor
       // self.manageStackView.isHidden = true
        self.postStackView.isHidden = false
    }
    @IBAction func mySubscriptionAction(_ sender: UIButton) {
        let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "MySubscriptionViewController") as! MySubscriptionViewController
        VC.isFromDriver = false
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func followersBtnAction(_ sender: Any) {
        let  VC = AppStoryboard.ISellerOrder.instance.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
        VC.postUserID = userData?.id ?? ""
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func followingBtnAction(_ sender: Any) {
        let  VC = AppStoryboard.ISellerOrder.instance.instantiateViewController(withIdentifier: "FollowingsViewController") as! FollowingsViewController
        VC.postUserID = userData?.id ?? ""
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func reviewBtnAction(_ sender: UIButton) {
        if userData?.user_type_id == "6"{
            SellerOrderCoordinator.goToMyReviews(controller: self,store_id: SessionManager.getUserData()?.id ?? "",isFromProfile: true,isFromDriver: true)
        }else{
            SellerOrderCoordinator.goToMyReviews(controller: self,store_id: SessionManager.getUserData()?.id ?? "",isFromProfile: true,isFromDriver: false)
        }
    }
    @IBAction func newOrdersAction(_ sender: UIButton) {
        if userData?.user_type_id == "6"
        {
            
            SellerOrderCoordinator.goToDeliveryRequests(controller: self,type: "1",verified: profileData?.data?.driver_verified ?? "", singleOrderMode: true)

        // Delegate Service if is empty then food order and seller order
        // now boht call at once 
////            let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
////            VC.isFromDriver = true
////            self.navigationController?.pushViewController(VC, animated: true)
//
//            let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewBookingViewController") as! NewBookingViewController
//            VC.isFromDriver = true
//            VC.isFromNewOrdersFromProfile = true
//            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if userData?.user_type_id == "1" || userData?.user_type_id == UserAccountType.ACCOUNT_TYPE_INDIVIDUAL.rawValue
        {
            let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
            
            if userData?.activity_type_id == "12"
            {
                VC.isFromResturant = true
            }
            else if userData?.activity_type_id == "10"
            {
                VC.isFromResturant = false
            }
            else
            {
                VC.isFromResturant = false
            }
            VC.isFromNewOrdersFromProfile = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if userData?.user_type_id == "2"
        {
            if userData?.activity_type_id == "16"
            {
                let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "MySubscriptionViewController") as! MySubscriptionViewController
                VC.isFromDriver = false
                VC.isFromProfileNewOrder = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else if userData?.activity_type_id == "6"
            {
                let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewBookingViewController") as! NewBookingViewController
                VC.isFromDriver = false
                VC.isFromNewOrdersFromProfile = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else if userData?.activity_type_id == "4"
            {
                let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "HotelBookingListViewController") as! HotelBookingListViewController
                VC.isFromDriver = false
                VC.isFromNewOrdersFromProfile = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else if userData?.activity_type_id == "17"
            {
                let  VC = AppStoryboard.BookNowDetail.instance.instantiateViewController(withIdentifier: "PGBookingListViewController") as! PGBookingListViewController
                VC.isFromDriver = false
                VC.isFromNewOrdersFromProfile = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        else if userData?.user_type_id == "4"
        {
            let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewServicesViewController") as! NewServicesViewController
            VC.isFromDriver = false
            VC.isFromNewOrdersFromProfile = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else
        {
            SellerOrderCoordinator.goToNewOrder(controller: self, status: "")
        }
    }
    @IBAction func orderOnProcessAction(_ sender: UIButton) {

        if userData?.user_type_id == "6"
        {
            SellerOrderCoordinator.goToDeliveryRequests(controller: self,type: "2",verified: profileData?.data?.driver_verified ?? "" , singleOrderMode: true)
        }
        else if userData?.user_type_id == "1" || userData?.user_type_id == UserAccountType.ACCOUNT_TYPE_INDIVIDUAL.rawValue
        {
            let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
            
            if userData?.activity_type_id == "12"
            {
                VC.isFromResturant = true
                VC.isMyOrderListClicked = false

            }
            else if userData?.activity_type_id == "10"
            {
                VC.isFromResturant = false
            }
            else
            {
                VC.isFromResturant = false
            }
            VC.isFromNewProcessOrdersFromProfile = true
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if userData?.user_type_id == "2"
        {
            if userData?.activity_type_id == "16"
            {
                let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "MySubscriptionViewController") as! MySubscriptionViewController
                VC.isFromDriver = false
                VC.isFromProfileOrderProcess = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else if userData?.activity_type_id == "6"
            {
                let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewBookingViewController") as! NewBookingViewController
                VC.isFromDriver = false
                VC.isFromNewProcessOrdersFromProfile = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else if userData?.activity_type_id == "4"
            {
                let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "HotelBookingListViewController") as! HotelBookingListViewController
                VC.isFromDriver = false
                VC.isFromNewProcessOrdersFromProfile = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
            else if userData?.activity_type_id == "17"
            {
                let  VC = AppStoryboard.BookNowDetail.instance.instantiateViewController(withIdentifier: "PGBookingListViewController") as! PGBookingListViewController
                VC.isFromDriver = false
                VC.isFromNewProcessOrdersFromProfile = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        else if userData?.user_type_id == "4"
        {
            let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewServicesViewController") as! NewServicesViewController
            VC.isFromDriver = false
            VC.isFromNewProcessOrdersFromProfile = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if userData?.user_type_id == UserAccountType.ACCOUNT_TYPE_INDIVIDUAL.rawValue
        {
            
        }
        else
        {
            SellerOrderCoordinator.goToNewOrder(controller: self, status: "")
        }
    }
    
    @IBAction func tableBookingAction(_ sender: Any) {
        let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "TabelBookingViewController") as! TabelBookingViewController
        VC.isFromDriver = false
        VC.isFromNewProcessOrdersFromProfile = false
        
        if profileDetails == nil {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? ""
            ]
            Utilities.showIndicatorView()
            StoreAPIManager.userProfileAPI(parameters: parameters) { result in
                Utilities.hideIndicatorView()
                switch result.status {
                case "1":
                    self.profileData = result.oData
                    let count = Int( self.profileDetails?.received_table_booking_count ?? "") ?? 0
                    if count > 0 {
                        VC.isReceivedEnable = true
                    } else {
                        VC.isReceivedEnable = false
                    }
                    self.navigationController?.pushViewController(VC, animated: true)

                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                    }
                }
            }
        } else {
            let count = Int( self.profileDetails?.received_table_booking_count ?? "") ?? 0
            if count > 0 {
                VC.isReceivedEnable = true
            } else {
                VC.isReceivedEnable = false
            }
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func bookTabelSwitchButtonAction(_ sender: UIButton) {
        self.foodServingHandleAPI()
    }
    
    
    func OpenPopUp(){
        let tabbar = tabBarController as? TabbarController
        tabbar?.selectedIndex = 0
        
        DispatchQueue.main.async {
            Constants.shared.isPopupShow = false
            NotificationCenter.default.post(name: Notification.Name("openOptionsHome"), object: nil)
        }
        
//        let  controller =  AppStoryboard.Floating.instance.instantiateViewController(withIdentifier: "FloatingVC") as! FloatingVC
//        controller.delegate = self
//        let sheet = SheetViewController(
//            controller: controller,
//            sizes: [.fullscreen],
//            options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
//        sheet.minimumSpaceAbovePullBar = 0
//        sheet.dismissOnOverlayTap = false
//        sheet.dismissOnPull = false
//        sheet.contentBackgroundColor = .clear
//        
//        self.present(sheet, animated: true, completion: nil)
    }
    
    //MARK: - API Calls
    
    func checkUserProductExistOrNotAPI() {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "user_id" : SessionManager.getUserData()?.id ?? ""
            ]
            CMSAPIManager.checkUserProductExistAPI(parameters: parameters) { [weak self] result in
                switch result.status {
                case "1":
                    let  controller =  AppStoryboard.Floating.instance.instantiateViewController(withIdentifier: "FloatingVC") as! FloatingVC
                    controller.delegate = self
                    let sheet = SheetViewController(
                        controller: controller,
                        sizes: [.fullscreen],
                        options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
                    sheet.minimumSpaceAbovePullBar = 0
                    sheet.dismissOnOverlayTap = false
                    sheet.dismissOnPull = false
                    sheet.contentBackgroundColor = .clear

                    self?.present(sheet, animated: true, completion: nil)
                default:
                    DispatchQueue.main.async {
                        Utilities.showWarningAlert(message: result.message ?? "") {
                            
                        }
                    }
                }
            }
        }
    
    func removePostAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "post_id" : self.selectedPostID
        ]
        print(parameters)
        StoreAPIManager.removePostAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getUserPosts()
                Constants.shared.deletedPostID = self.selectedPostID
                // self.SellerData = result.oData?.sellerData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func setDefaultPostAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "post_id" : self.selectedPostID
        ]
        print(parameters)
        StoreAPIManager.setDefaultPostAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getUserPosts()
                //Constants.shared.deletedPostID = self.selectedPostID
                // self.SellerData = result.oData?.sellerData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func foodServingHandleAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""        ]
        print(parameters)
        StoreAPIManager.tableBookingEnableDisbleAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.commonProfileAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func driverProfileAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.driverProfileAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                    DispatchQueue.main.async {
                        self.profileData = result.oData
                    }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func hideAndUnhideProfileAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.profileHideAndUnhideAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.playTone()
                if self.userData?.user_type_id == "6"{
                    self.driverProfileAPI()
                }else {
                    self.commonProfileAPI()
                }
                //self.profileData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func commonProfileAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.userProfileAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.profileData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                }
            }
        }
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.profileImageBgView.bounds
        gradientLayer.cornerRadius = self.profileImageBgView.bounds.width/2
        self.profileImageBgView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func updateBannerImg() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        let userFile:[String:[UIImage?]] = ["image" :[self.profileBg.image]]
        AuthenticationAPIManager.updateBannerAPI(images:userFile, parameters: parameters) { response in
            switch response.status {
            case "1":
                if self.userData?.user_type_id == "6"{
                    self.driverProfileAPI()
                }else {
                    self.commonProfileAPI()
                }
            default :
                Utilities.showWarningAlert(message: response.message ?? "") {
                    
                }
            }
        }
    }
    
    func SwitchAccount() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.driverSwitchProfileAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                if self.userData?.user_type_id == "6"{
                    self.driverProfileAPI()
                }else {
                    self.commonProfileAPI()
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func updateProfileImg() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        let userFile:[String:[UIImage?]] = ["image" :[self.profileImageView.image]]
        AuthenticationAPIManager.updateProfileImgAPI(images:userFile, parameters: parameters) { response in
            switch response.status {
            case "1":
                if self.userData?.user_type_id == "6"{
                    self.driverProfileAPI()
                }else {
                    self.commonProfileAPI()
                }
            default :
                Utilities.showWarningAlert(message: response.message ?? "") {
                    self.profileImageView.image = UIImage(named: "placeholder_profile")
                }
            }
        }
    }
    
    
    
    func getUserPosts(){
        let parameter = ["userId": userData?.id ?? "",
                         "limitPerPage": initialPageCount] as [String : Any]
        print(parameter)
        self.postCollectionArray.removeAll()
        Utilities.showIndicatorView()
        let socket = SocketIOManager.sharedInstance
        socket.getUserPosts(request: parameter) {[weak self] dataArray in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                Utilities.hideIndicatorView()
            }
            
            guard self != nil else {return}
            //weakSelf.loading = false
            guard let dict = dataArray[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                
                if let decodedArray:FeedPost_Base = try? decoder.decode(FeedPost_Base.self, from: json){
                    print(decodedArray.postCollection ?? [])
                    self?.postCollectionArray = decodedArray.postCollection ?? []
                    self?.feedColletionView.reloadData()
                }else{
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func playTone(){
        if let path = Bundle.main.path(forResource: "hideTone", ofType:"mp3"){
            let url = URL(fileURLWithPath: path)
            
            do {
                self.notificationSoundEffect = try AVAudioPlayer(contentsOf: url)
                self.notificationSoundEffect.play()
                self.notificationSoundEffect.numberOfLoops = 1
            } catch {
                // couldn't load file :(
                
            }
        }
    }
    
}
extension ProfileViewController: FloatingVCDelegate {
    func goToLive() {
        Coordinator.goToLive(controller: self)
    }
    func goToVideo() {
        Coordinator.goToTakeVideo(controller: self)
    }
    func goToImage() {
        Coordinator.goToTakePicture(controller: self)
    }
}
extension ProfileViewController:ImagePickerDelegate {
    func didSelect(image: UIImage?, fileName: String, fileSize: String) {
        if(image != nil){
            if self.imgType == "1" {
                self.profileImageView.image = image
                self.updateProfileImg()
            }else if self.imgType == "2" {
                self.profileBg.image = image
                self.updateBannerImg()
            }
        }
    }
}
extension ProfileViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isToggled{
            collectionView.backgroundView = nil
            return manageProfileArray.count
        }else{
            guard self.postCollectionArray.count != 0  else {
                collectionView.setEmptyView(title: "", message: "No Feeds Found".localiz(), image: UIImage(named: "noStoreData"))
                
                return 0
            }
            collectionView.backgroundView = nil
            return self.postCollectionArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isToggled{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageCollectionViewCell", for: indexPath) as? ManageCollectionViewCell else
            { return UICollectionViewCell()
            }
            cell.nameLabel.text = manageProfileArray[indexPath.row].name?.localiz() ?? ""
            cell.imageIconView.image = UIImage(named: manageProfileArray[indexPath.row].icon ?? "")
            cell.countLabel.text = manageProfileArray[indexPath.row].count ?? ""
            
            if manageProfileArray[indexPath.row].name?.localiz() ?? "" == "Delivery Services".localiz() || manageProfileArray[indexPath.row].name?.localiz() ?? "" == "Settings".localiz() || manageProfileArray[indexPath.row].name?.localiz() ?? "" == "Logout".localiz() ||
                manageProfileArray[indexPath.row].name?.localiz() ?? "" == "Table Booking".localiz()
                 {
                cell.arrowButton.isHidden = false
            }else{
                cell.arrowButton.isHidden = true
            }
           
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerOrderCell", for: indexPath) as? SellerOrderCell else
            { return UICollectionViewCell()
            }
            
            cell.shareIcon.tag = indexPath.row
            cell.shareIcon.isHidden = false
            cell.postData = self.postCollectionArray[indexPath.row]
            cell.shareIcon.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)

            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isToggled{
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width - 30
            return CGSize(width: screenWidth/2, height:110)
        }else{
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width - 30
            return CGSize(width: screenWidth/3, height:145)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isToggled
        {
            self.gotoListScreenForType(listType: self.manageProfileArray[indexPath.row].name?.localiz() ?? "")
        } else {
            let  VC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "PostListViewController") as! PostListViewController
            VC.postCollectionDummyArray = self.postCollectionArray
            VC.videoIndexPath = indexPath
            VC.isFromProfile = true
            VC.delegate = self
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    @objc func didButtonClick(_ sender: UIButton) {
        guard let cell = feedColletionView.cellForItem(at: IndexPath(row: sender.tag, section: 0)) else { return  }
        let edit = "Set Default"
        self.selectedPostID = self.postCollectionArray[sender.tag].postId ?? ""
        let delete = "Delete"
        CM.MenuConstants.horizontalDirection = .right
        CM.items = [edit,delete]
        CM.showMenu(viewTargeted:cell, delegate: self)
    }
    
    func gotoListScreenForType(listType:String)
    {
        if listType == "Table Booking".localiz()
        {
            self.tableBookingAction(UIButton())
        }
        else if listType == "My Orders".localiz()
        {
            self.MyOrders(UIButton())
        }
        else if listType == "Service Booking".localiz()
        {
            self.MyServices(UIButton())
        }
        else if listType == "Delivery Services".localiz()
        {
            self.DelegateServices(UIButton())
        }
        else if listType == "Delivery Requests".localiz()
        {
        SellerOrderCoordinator.goToDeliveryRequests(controller: self,selectedCategory:.delivery,verified: "1")
            //self.deliveryRequests(UIButton())
        }
        else if listType == "My Bookings".localiz()
        {
            self.myBookingAction(UIButton())
        }
        else if listType == "Subscriptions".localiz()
        {
            self.mySubscriptionAction(UIButton())
        }
        else if listType == "Ground Booking".localiz()
        {
            self.groundBookingAction(UIButton())
        }
        else if listType == "Hotel Booking".localiz()
        {
            self.hotelBookingAction(UIButton())
        }
        else if listType == "My Review".localiz()
        {
            self.MyReviews(UIButton())
        }
        else if listType == "Balance".localiz()
        {
            self.Balance(UIButton())
        }
        else if listType == "Logout".localiz()
        {
            self.Lgout(UIButton())
        }
        else if listType == "Settings".localiz()
        {
            self.Settings(UIButton())
        }
        else if listType == "Logout".localiz()
        {
            self.Lgout(UIButton())
        }
    }
    
}
extension ProfileViewController : ContextMenuDelegate {
    func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
        print("contextMenuDidSelect", item.title)
        if item.title == "Delete"{
            self.removePostAPI()
        }else if item.title == "Set Default"{
            self.setDefaultPostAPI()
        }else{
            
        }
        return true
    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) {
        print("contextMenuDidDeselect")
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("contextMenuDidAppear")
    }
    
    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
        print("contextMenuDidDisappear")
    }
    
}

extension ProfileViewController:PostListProtocol{
    func moveDiscoverController(hashTag: String) {
        Constants.shared.searchHashTagText = hashTag
        self.tabBarController?.selectedIndex = 1
    }
}
extension ProfileViewController: PopupProtocol{
    func openPopup() {
        
        if SessionManager.isLoggedIn() {
            self.checkUserProductExistOrNotAPI()
        }else{
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
    }
}

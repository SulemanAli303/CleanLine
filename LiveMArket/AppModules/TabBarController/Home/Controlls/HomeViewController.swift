//
//  HomeViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit
import AsyncDisplayKit
import FittedSheets
import Firebase
import FirebaseDatabase
import FirebaseStorage
import CoreLocation
import ALProgressView
import SnapKit
import AVFAudio
import AVFoundation
import AudioToolbox
import SoundModeManager
import PIPKit
import SwiftGifOrigin

protocol FeedDelegate : AnyObject {
    func finishResetingFeed()
}

class HomeViewController: BaseViewController, ObserverProtocol {
    
    var id: Int!
    
    func onSocketConnect(_ status: Bool) {
        if Constants.shared.uploading{
            self.uploadingProgress()
        }else{
            lastFetchedPost = ""
            self.getAllPosts(page: 1) { (status) in
            }
        }
    }
    
    func newPost(_ post: [FeedPost_Base]) {
        
    }
    
    var locationManager = CLLocationManager()
    var currentHeading:CLLocationDirection = 0.0

    var currentLocation: CLLocation?
    var locationCoordinates: CLLocation? {
        didSet {
        }
    }
    
    var longPressPopupShowing = false
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var videoPostView: UIView!
    @IBOutlet weak var videoPostProgressView: ALProgressRing!
    private lazy var progressLabel = UILabel()
    
    internal var scrollOperation: DelayedBlockOperation!
    internal var currentIndex:Int = -1
    
    var beforeContentOFfset : CGPoint?
    var _collectionNode: ASCollectionNode!
    var containerStack = UIStackView()
    var offSet = CGPoint.zero
    var stackSuperViewTopConstraint: NSLayoutConstraint!
    var stackSafeAreaTopConstraint: NSLayoutConstraint!
    
    var postCollectionArray : [PostCollection] = []
    var postPlayer : [String:AVPlayer] = [:]
    var postCollectionDummyArray : [PostCollection] = []
    var currentPlayingVideo : PostCollection?
    var userTypeString:String = ""
    private var lastFetchedPost: String = ""
    private var currentPostlastFetchedTime: String = ""
    private var pageIndex: Int = 0
    private var initialPageCount = 100
    var currentPage = 1
    var currentPostIndexPath:IndexPath?
    var isLoading = false
    var isFromProfile:Bool = false
    var isLiveListClicked = false
    let refreshControl = UIRefreshControl()
    weak var delegateToReset : FeedDelegate?
    var isSelectedUser:Bool = false
    
    private var observer: NSObjectProtocol?
    private var observerBackGorund: NSObjectProtocol?
    
    var timer: Timer?
    var timerValue : Float = 0.0
    var outputVolumeObserve: NSKeyValueObservation?
    let audioSession = AVAudioSession.sharedInstance()
    
    // MARK: - Private Properties
    private var isObserved = false
    private var observationToken: SoundModeManager.ObservationToken?
    
    // MARK: - Dependencies
    private let manager = SoundModeManager()
    var lasttSelectedUser:String = ""
    
    var facePopupShowing = false
    
    var adminLiveStatus = false
    var locationAlert:UIAlertController?
    var islocationAlertPresented = false

    var scrollingPoint: CGPoint = .zero
    var endPoint: CGPoint = .zero
    var scrollingTimer: Timer?

    func scrollSlowly() {
            // Set the point where the scrolling stops.
        endPoint = CGPoint(x: 0, y: 300)
            // Assuming that you are starting at {0, 0} and scrolling along the x-axis.
        scrollingPoint = .zero
            // Change the timer interval for speed regulation.
        scrollingTimer = Timer.scheduledTimer(timeInterval: 0.015, target: self, selector: #selector(scrollSlowlyToPoint), userInfo: nil, repeats: true)
    }

    @objc func scrollSlowlyToPoint() {
        _collectionNode.contentOffset = scrollingPoint
            // Here you have to respond to user interactions or else the scrolling will not stop until it reaches the endPoint.
        if scrollingPoint.equalTo(endPoint) {
            scrollingTimer?.invalidate()
        }
            // Going one pixel to the right.
        scrollingPoint = CGPoint(x: scrollingPoint.x, y: scrollingPoint.y + 1)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let flowLayout = UICollectionViewFlowLayout() //CustomPaging
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        self._collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        setupInitialState()
        containerStack = UIStackView(arrangedSubviews: [_collectionNode.view])
        containerStack.axis = .vertical
        containerStack.alignment = .fill
        containerStack.distribution = .fill
        // Enable pull-to-refresh
        let refreshText = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 14)!, NSAttributedString.Key.foregroundColor: Color.darkOrange.color()]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localiz(),attributes: refreshText)
        _collectionNode.view.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerStack)
        setupStackConstraints()
        _collectionNode.view.contentInsetAdjustmentBehavior = .never
        _collectionNode.isPagingEnabled = true
        _collectionNode.view.alwaysBounceVertical = true
        stackSuperViewTopConstraint.isActive = true
        stackSafeAreaTopConstraint.isActive = false
        _collectionNode.cornerRadius = 0
        _collectionNode.maskedCorners =  []
        _collectionNode.backgroundColor = .black
        if self.beforeContentOFfset != nil{
            self._collectionNode.view.isScrollEnabled = true
            self._collectionNode.setContentOffset(self.beforeContentOFfset!, animated: false)
        }
        
        self.containerStack.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openShare), name: Notification.Name("OpenSahre"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveUserActivity(_:)), name: Notification.Name("newUserActivityLoaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("openOptionsHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadVideo(_:)), name: Notification.Name("PostUpload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAllPosts(_:)), name: Notification.Name("RefreshPosts"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onClickNotification(_:)), name: Notification.Name("newNotificationClickEvent"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetToAllPosts(_:)), name: Notification.Name("reloadHomePage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.chatBadgeUpdate(_:)), name: Notification.Name("chatBadge"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkOnGoingOrders), name: Notification.Name("verifyYourIdentity"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkLocationAuthorization), name: UIApplication.willEnterForegroundNotification, object: nil)
        //self.getAllPosts()
        self.progressView.isHidden = true
        self.percentageLabel.isHidden = true
        self.videoPostView.isHidden = true

        
        let socket = SocketIOManager.sharedInstance
        if socket.socket.status == .connected {
            
            if Constants.shared.uploading{
                self.uploadingProgress()
            }else{
                lastFetchedPost = ""
                self.getAllPosts(page: 1) { (status) in
                }
            }
            
        } else {
            socket.closeConnection()
            Utilities.hideIndicatorView()
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                socket.establishConnection() // Retry after 5 seconds.
            }
        }
        //Silent observer
        observeSoundMode()
        setupView()
        
    }
    func updateUserLocationBasedOnType(currentLocation:CLLocation) {
        let coordinate = currentLocation.coordinate
            // currentLocation?.course
        if (SessionManager.getUserData()?.firebase_user_key ?? "" != "") {

            if (SessionManager.getUserData()?.user_type_id == "6" || SessionManager.getUserData()?.user_type_id == "4")
            {
            let driverLoc = Database.database().reference().child("Driver_location")
            let firebsLoc = [
                "latitude": coordinate.latitude ,
                "longitude": coordinate.longitude,
                "Bearing" : currentHeading ,
            ] as [String : Any]
            driverLoc.child(SessionManager.getUserData()?.firebase_user_key ?? "").setValue(firebsLoc)
            self.updateDriverLocation()
            }
        }
    }
    deinit {
        scrollingTimer?.invalidate()
        timer?.invalidate()
        VideoPlayerManager.shared.reset()
        NotificationCenter.default.removeObserver(self)
    }

    @objc func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.islocationAlertPresented = false
                locationAlert?.dismiss(animated: true)
                print("Location Access Granted")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                showAlert()
            @unknown default:
                print("Unknown location authorization status")
        }
    }

    func showAlert() {
        if locationAlert == nil {
            locationAlert = UIAlertController(title: "Location Permission Required".localiz(), message: "Please enable location services in Settings.".localiz(), preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings".localiz(), style: .default) { (_) -> Void in
                self.islocationAlertPresented = false
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            locationAlert!.addAction(settingsAction)
        }

        if !islocationAlertPresented {
            islocationAlertPresented = true
            present(locationAlert!, animated: true, completion: nil)
        }

    }


    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        self.checkFaceSignVerificationNeeded()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        VideoPlayerManager.shared.isVideoPaused = false
        if let visibleCell = self.visibleNode{
            VideoPlayerManager.shared.playVideo(in: visibleCell)
        }
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            DispatchQueue.main.async {
                VideoPlayerManager.shared.resume()
            }
            
        }
        observerBackGorund = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            DispatchQueue.main.async {
                VideoPlayerManager.shared.pause(.hidden)
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func setupNotificationObserver()
    {
        let socket = SocketIOManager.sharedInstance
        if socket.socket.status == .connected {
            if Constants.shared.uploading{
                self.uploadingProgress()
            }else{
                lastFetchedPost = ""
                self.getAllPosts(page: 1) { (status) in
                }
            }
        }else{
            socket.closeConnection()
            Utilities.hideIndicatorView()
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                socket.establishConnection() // Retry after 5 seconds.
            }
        }
    }
    
    // MARK: - Services
    
    func observeSoundMode() {
        observationToken = manager.observeCurrentMode { [weak self] _ in
            self?.updateSoundModeLabel()
        }
    }
    
    // MARK: - View
    
    func setupView() {
        manager.beginUpdatingCurrentMode()
        updateSoundModeLabel()
    }
    func updateSoundModeLabel() {
        switch manager.currentMode {
        case .notDetermined:
            print("Not determined")
        case .silent:
            print("Silent")
            self.visibleNodeSoundmanagerFromSilentButtonChanged(value: true)
        case .ring:
            print("Ring")
            self.visibleNodeSoundmanagerFromSilentButtonChanged(value: false)
        }
    }
    
    @objc private func refresh(_ sender: Any) {
        // Perform your refresh actions here (e.g., fetch new data from a server)
        // Once the refresh is complete, make sure to end refreshing
        // You might use some asynchronous operation like fetching data from a server, then when it's done, call `endRefreshing`
        // Example:
        lastFetchedPost = ""
        self.refreshControl.endRefreshing()
        self.getAllPosts(page: 1) { (status) in
            
        }
    }
    
    func startTimer() {
        // Invalidate any existing timer
        timer?.invalidate()
        
        // Create a new timer that fires after 5 seconds
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc func timerFired() {
        print("Timer fired after 5 seconds")
        timerValue = timerValue + 0.2
        self.videoPostProgressView.setProgress(timerValue, animated: true)
        let val = timerValue * 100
        let percentageVal = String(format: "%.0f", val)
        self.progressLabel.text = "\(percentageVal)%"
        if(timerValue > 1){
            timer?.invalidate()
            timerValue = 0.0
            self.progressView.isHidden = true
            self.progressView.setProgress(0, animated: true)
            
            self.videoPostView.isHidden = true
            self.videoPostProgressView.setProgress(0, animated: true)
            
            self.lastFetchedPost = ""
            self.getAllPosts(page: 1) { (status) in
                
            }
            let userInfo = ["type":false]
            NotificationCenter.default.post(name: Notification.Name("HideProgressBar"), object: nil,userInfo: userInfo)
        }
    }
    
    
    func LocMag(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 2
        locationManager.allowsBackgroundLocationUpdates  = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.headingFilter = 1
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    @objc func onReceiveUserActivity(_ notification: NSNotification) {
      
        if notification.userInfo?["serviceName"] as? String == "profile"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let profileID = notification.userInfo?["serviceId"] as? String else { return }
                let  VC = AppStoryboard.ShopProfile.instance.instantiateViewController(withIdentifier: "ShopProfileViewController") as! ShopProfileViewController
                VC.storeID = profileID
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
        }else if notification.userInfo?["serviceName"] as? String == "referralCode"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let profileID = notification.userInfo?["serviceId"] as? String else { return }
                Constants.shared.sharedReferralCode = profileID
                if SessionManager.isLoggedIn() {
                    Coordinator.updateRootVCToTab()
                }else {
                    DispatchQueue.main.async {
                        let  rootVC =  AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "LMLoginViewController") as! LMLoginViewController
                        let root = UINavigationController(rootViewController: rootVC)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = root
                    }
                }
            }
            
        }else if notification.userInfo?["serviceName"] as? String == "homePost"{
            guard let postID = notification.userInfo?["serviceId"] as? String else { return }
            let  VC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "PostListViewController") as! PostListViewController
            VC.currentPostID = postID
            VC.isFromProfile = false
            self.navigationController?.pushViewController(VC, animated: true)
        }else{
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.LocMag()
        self.navigationController?.navigationBar.isHidden = true
        self._collectionNode.setContentOffset(self.offSet, animated: false)
        
        videoPostProgressView.lineWidth = 5
        videoPostProgressView.startColor = UIColor(hex: "EF9417")
        videoPostProgressView.endColor = UIColor(hex: "EF9417")
        videoPostProgressView.grooveColor = .clear
        progressLabel.text = "0%"
        progressLabel.font = .systemFont(ofSize: 8, weight: .regular)
        progressLabel.textColor = .white
        videoPostProgressView.addSubview(progressLabel)
        progressLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.view.bringSubviewToFront(progressView)
        self.view.bringSubviewToFront(percentageLabel)
        self.view.bringSubviewToFront(videoPostView)
        
        isLiveListClicked = false
        
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        tabbar?.popupDelegate = self

        self.observeLiveUsers()
        self.observeLiveEndUsers()
        
        if Constants.shared.deletedPostID != ""{
            self.deletePostFromID(postID: Constants.shared.deletedPostID)
        }
        checkHomePageReload()
        listenVolumeButton()
        if SessionManager.isLoggedIn() {
            SocketIOManager.sharedInstance.ObserveStartStream(completionHandler: {_ in})
            SocketIOManager.sharedInstance.GetLiveComment(completionHandler: {_ in})
            SocketIOManager.sharedInstance.GetLiveViewCount(completionHandler: {_ in})
            SocketIOManager.sharedInstance.ObserveEndStream(completionHandler: {_ in})
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.offSet = self._collectionNode.contentOffset
        if currentIndex >= 0 {
            if let node = _collectionNode.nodeForItem(at: IndexPath(item: currentIndex, section: 0)) as? FeedNode {
                
            }
        }
        self.navigationController?.navigationBar.isHidden = false
        //NotificationCenter.default.removeObserver(self, name: Notification.Name("newUserActivityLoaded"), object: nil)
        VideoPlayerManager.shared.pause(.hidden)
        VideoPlayerManager.shared.isVideoPaused = true
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }

    
    func listenVolumeButton() {
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        } catch _ {
        }
        do {
            try audioSession.setActive(true)
        } catch {}
        outputVolumeObserve = audioSession.observe(\.outputVolume, changeHandler: {(audioSession, changes) in
            self.visibleNodeSoundManagerFromVolumeButtonChanged()
        })
        
    }
    
    func visibleNodeSoundManagerFromVolumeButtonChanged(){
        if self.visibleNode != nil {
            if self.visibleNode?.postType == .Video || self.visibleNode?.postType == .Multiple {
                VideoPlayerManager.shared.muted = false
                self.visibleNode?.isMuted = false
                if audioSession.outputVolume >= 0.05 {
                    VideoPlayerManager.shared.muted = false
                    self.visibleNode?.isMuted = false
                } else {
                    VideoPlayerManager.shared.muted = true
                    self.visibleNode?.isMuted = true
                }
                NotificationCenter.default.post(name: NSNotification.Name("updateMuteIcon"), object: nil)
            }
        }
    }
    func visibleNodeSoundmanagerFromSilentButtonChanged(value:Bool){
        if self.visibleNode != nil {
            if self.visibleNode?.postType == .Video || self.visibleNode?.postType == .Multiple {
                VideoPlayerManager.shared.muted = false
                self.visibleNode?.isMuted = false
                if value == false {
                    VideoPlayerManager.shared.muted = false
                    self.visibleNode?.isMuted = false
                } else {
                    VideoPlayerManager.shared.muted = true
                    self.visibleNode?.isMuted = true
                }
                NotificationCenter.default.post(name: NSNotification.Name("updateMuteIcon"), object: nil)
            }
        }
    }
    
    
    @objc func onClickNotification(_ notification: NSNotification) {
        
        NotificationCenter.default.post(name: NSNotification.Name("PIPDismiss"), object: nil)
        
        if notification.userInfo?["type"] as? String == "chat"{
            let chatRoomId = notification.userInfo?["chatRoomId"] as? String ?? ""
            let fireBaseKey = notification.userInfo?["sender_id"] as? String ?? ""
            Coordinator.goToChatDetails(delegate: self,firebaseUserKey: fireBaseKey, roomId: chatRoomId)
            return
        }
        if notification.userInfo?["type"] as? String == "chatDelegate" {
            let chatRoomId = notification.userInfo?["chatRoomId"] as? String ?? ""
            let fireBaseKey = notification.userInfo?["sender_id"] as? String ?? ""
            let serviceIdKey = notification.userInfo?["serviceId"] as? String ?? ""
            var isDriver = notification.userInfo?["isDriver"] as? Bool ?? false
            var isSeller = false
            if let sellerString = notification.userInfo?["isSeller"] as? String {
                if sellerString == "1" {
                    isSeller = true
                }
            }
            Constants.shared.isCommingFromOrderPopup = false
            let orderId = notification.userInfo?["orderId"] as? String ?? "" //"2580"//"LM-11951709625885"//
            //2805
            //2580 //seller booking
            let userData = SessionManager.getUserData()
            if SessionManager.isLoggedIn() {
                if userData?.user_type_id == UserAccountType.ACCOUNT_TYPE_DELIVERY_REPRESENTATIVE.rawValue
                {
                    isDriver = true
                }
            }
            
            if isDriver,let vc = self.tabBarController?.viewControllers?.last, vc.isKind(of: ValidateFacePopup.self)  {
                return
            }

            let parentController = notification.userInfo?["parentController"] as? String ?? ""
            if parentController == ParentController.FoodOrderDetail.rawValue {
                if isDriver {
                    Coordinator.goToDriverOrderDetails(controller: self, orderId: orderId, lat: currentLocation?.coordinate.latitude.description ?? "", lng: currentLocation?.coordinate.longitude.description ?? "", driverAddress: userData?.address ?? "", fromFoodOrder: true, isFromChatDelegate: true, whoIsParent: parentController)
                } else {
                    SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: orderId, isSeller: isSeller, isThankYouPage: true, isFromChatDelegate: true, chatRoomId: chatRoomId, firebaseKey: fireBaseKey)
                }
                
            } else if parentController == ParentController.SellerBookingDetail.rawValue {
                if isDriver {
                    Coordinator.goToDriverOrderDetails(controller: self, orderId: orderId, lat: currentLocation?.coordinate.latitude.description ?? "", lng: currentLocation?.coordinate.longitude.description ?? "", driverAddress: userData?.address ?? "", fromFoodOrder: false, isFromChatDelegate: true, whoIsParent: parentController)
                } else {
                    SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: orderId,isSeller: isSeller, isThankYouPage: true, isFromChatDelegate: true, chatRoomId: chatRoomId, firebaseKey: fireBaseKey)
                }
            } else {
                Coordinator.goToServiceDelegateRequestDetails(controller: self,
                                                              step: "1",
                                                              serviceID: serviceIdKey,
                                                              isDriver: isDriver,
                                                              isFromChatDelegate: true,
                                                              chatRoomId: chatRoomId,
                                                              senderID: fireBaseKey)
            }
            return
        }
        guard let type = notification.userInfo?["type"] as? String else { return }
        // Utilities.showWarningAlert(message:type )
        self.tabBarController?.selectedIndex = 0
        switch type.lowercased() {
        case "new_table_booking_placed_store","table_booking_accepted_store","table_booking_rejected_store","table_booking_completed_store":
            guard let bookingID = notification.userInfo?["orderId"] as? String else { return }
            Coordinator.goToTableRequest(controller: self,bookID: bookingID,isFromReceved: true,isFromPopup: true)
        case "new_table_booking_placed_user","table_booking_accepted_user","table_booking_rejected_user","table_booking_completed_user":
            guard let bookingID = notification.userInfo?["orderId"] as? String else { return }
            Coordinator.goToTableRequest(controller: self,bookID: bookingID,isFromReceved: false,isFromPopup: true)
        case "live-notification":
            Coordinator.goToPostComment(controller: self)
        case "order_placed","order_accepted", "order_ready_for_delivery", "order_dispatched","order_delivered","order_cancelled", "order_returned", "order_rejected","order_payment_completed":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            if type == "order_delivered"{
                SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: orderId,isSeller: false, isThankYouPage: true,isFromNotify: true)
            }else{
                SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: orderId,isSeller: false, isThankYouPage: true,isFromNotify: false)
            }
            
        case "new_order", "store_order_payment_completed", "store_order_delivered","store_order_cancelled","store_order_returned","store_order_accepted_driver":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            
            if type == "store_order_delivered"{
                SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: orderId,isSeller: true, isThankYouPage: true,isFromNotify: true)
            }else{
                SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: orderId,isSeller: true, isThankYouPage: true,isFromNotify: false)
            }
        case "food_order_accepted","food_order_ready_for_delivery","food_order_dispatched","food_order_delivered","food_order_cancelled","food_order_returned","food_order_rejected","food_order_payment_completed","food_driver_order_delivered","food_driver_new_order":
            guard let orderId = notification.userInfo?["invoiceId"] as? String else { return }
            
            if type == "food_order_delivered"{
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: orderId, isSeller: false, isThankYouPage: true,isFromNotify: true)
            }else{
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: orderId, isSeller: false, isThankYouPage: true,isFromNotify: false)
            }
        case "food_new_order","food_store_order_payment_completed","food_store_order_delivered","food_store_order_cancelled","food_store_order_returned","food_store_driver_accepted","food_store_driver_dispatched":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            
            if type == "food_store_order_delivered"{
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: orderId, isSeller: true, isThankYouPage: true,isFromNotify: true)
            }else{
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: orderId, isSeller: true, isThankYouPage: true,isFromNotify: false)
            }
            
        case "food_driver_order_accepted","food_driver_order_dispatched":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
            VC.order_ID = orderId
            self.navigationController?.pushViewController(VC, animated: true)
        case "driver_new_order", "driver_order_delivered":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
            VC.order_ID = orderId
            self.navigationController?.pushViewController(VC, animated: true)
        case "new_service_request_placed","quote_added_by_seller","quote_accepted_user","on_the_way_user","work_started_user","work_completed_user","payment_completed_user","service_request_rejected_by_seller","work_finished_user":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            
            if type == "work_finished_user"{
                Coordinator.goToServiceRequestDetails(controller: self,serviceID:orderId,isFromThanks: true,isFromNotify: true )
            }else{
                Coordinator.goToServiceRequestDetails(controller: self,serviceID:orderId,isFromThanks: true )
            }
        case "payment_completed","new_service_request","service_request_rejected","quote_added","quote_accepted","on_the_way","work_started","work_completed","work_finished":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            if type == "work_finished"{
                Coordinator.goToServicProviderDetail(controller: self, step: "", serviceId: orderId,isFromThank: true,isFromNotify: true)
            }else{
                Coordinator.goToServicProviderDetail(controller: self, step: "", serviceId: orderId,isFromThank: true)
            }
            
            
        case "gym_subscription_user","gym_request_rejected_user","gym_subscription_completed_user":
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            if type == "gym_subscription_completed_user"{
                Coordinator.goToGymRequestDetails(controller: self, subscriptionID: orderId, isFromReceived: false,isFromNotify: true, isFromThankYou: true)
            }else{
                Coordinator.goToGymRequestDetails(controller: self, subscriptionID: orderId, isFromReceived: false, isFromThankYou: true)
            }
            
        case "new_gym_subscription","gym_request_rejected","gym_subscription_completed":
            
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            if type == "gym_subscription_completed"{
                Coordinator.goToGymRequestDetails(controller: self, subscriptionID: orderId, isFromReceived: true,isFromNotify: true, isFromThankYou: true)
            }else{
                Coordinator.goToGymRequestDetails(controller: self, subscriptionID: orderId, isFromReceived: true, isFromThankYou: true)
            }
            
            
        case "deligate_new_order", "deligate_request_accepted", "deligate_waiting_for_payment","deligate_payment_completed","deligate_service_on_the_way", "deligate_service_completed":
            
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            if type == "deligate_service_completed"{
                Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: orderId,isFromNotify: true,isFromThanku: true)
            }else{
                Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: orderId,isFromThanku: true)
            }
            
        case "deligate_new_order_driver",
            "deligate_request_accepted_driver",
            "deligate_payment_completed_driver",
            "deligate_service_on_the_way_driver",
            "deligate_service_completed_driver" :
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            if type == "deligate_service_completed_driver"{
                Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: orderId,isDriver: true,isFromNotify: true,isFromThanku: true)
            }else{
                Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: orderId,isDriver: true,isFromThanku: true)
            }
            
        case "user_new_chalet_booking","user_confirmed_chalet_booking","user_wait_for_schedule_chalet_booking","user_reserved_chalet_booking","user_completed_chalet_booking","user_rejected_chalet_booking","user_reviews_submitted" :
            guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            if type == "user_completed_chalet_booking"{
                Coordinator.goToChaletRequestDetails(controller: self,step: "1",chaletID: orderId,isFromThankPage: true, isFromNotify: true)
            }else{
                Coordinator.goToChaletRequestDetails(controller: self,step: "1",chaletID: orderId, isFromThankPage: true)
            }
            
        case "new_chalet_booking",
            "confirmed_chalet_booking",
            "wait_for_schedule_chalet_booking",
            "reserved_chalet_booking",
            "completed_chalet_booking",
            "rejected_chalet_booking"    :
            guard let userID = notification.userInfo?["orderId"] as? String else { return }
            
            if type == "completed_chalet_booking"{
                Coordinator.goToChaletsReservationRequest(controller: self, VCtype: "",chaletID: userID,isFromNotify: true)
            }else{
                Coordinator.goToChaletsReservationRequest(controller: self, VCtype: "",chaletID: userID)
            }
            
        case "user-follow-notification" :
            guard let userID = notification.userInfo?["key_id"] as? String else { return }
            Coordinator.goToIndvidualSellerFlow(controller: self, step: userID)
        case "new_hotel_booking",
            "confirmed_hotel_booking",
            "wait_for_schedule_hotel_booking",
            "reserved_hotel_booking",
            "completed_hotel_booking",
            "rejected_hotel_booking",
            "cancelled_hotel_booking":
            guard let bookingID = notification.userInfo?["orderId"] as? String else { return }
            if type == "completed_hotel_booking"{
                Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: true,booking_ID: bookingID,isFromThankYou: true, isFromNotify: true )
            }else{
                Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: true,booking_ID: bookingID, isFromThankYou: true )
            }
            
        case "user_new_hotel_booking",
            "user_confirmed_hotel_booking",
            "user_wait_for_schedule_hotel_booking",
            "user_reserved_hotel_booking",
            "user_completed_hotel_booking",
            "user_rejected_hotel_booking",
            "user_cancelled_hotel_booking":
            guard let bookingID = notification.userInfo?["orderId"] as? String else { return }
            if type == "user_completed_hotel_booking"{
                Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: false,booking_ID: bookingID,isFromThankYou: true, isFromNotify: true)
            }else{
                Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: false,booking_ID: bookingID, isFromThankYou: true )
            }
            
        
        case "user_new_playground_booking",
            "user_confirmed_playground_booking",
            "user_wait_for_schedule_playground_booking",
            "user_reserved_playground_booking",
            "user_completed_playground_booking",
            "user_rejected_playground_booking",
            "user_cancelled_playground_booking":
            guard let bookingID = notification.userInfo?["orderId"] as? String else { return }
            
            if type == "user_completed_playground_booking"{
                PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: false,booking_ID: bookingID,isFromThankYou: true, isFromNotify: true)

            }else{
                PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: false,booking_ID: bookingID, isFromThankYou: true)

            }
        
            
        case "new_playground_booking",
            "confirmed_playground_booking",
            "wait_for_schedule_playground_booking",
            "reserved_playground_booking",
            "completed_playground_booking",
            "rejected_playground_booking",
            "cancelled_playground_booking":
            guard let bookingID = notification.userInfo?["orderId"] as? String else { return }
            
            if type == "completed_playground_booking"{
                PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: true,booking_ID: bookingID,isFromThankYou: true, isFromNotify: true)
            }else{
                PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: true,booking_ID: bookingID, isFromThankYou: true)
            }
            
            
        case "comment-notification","comment-like-notification" :
            guard let postID = notification.userInfo?["post_id"] as? String else { return }
            let  VC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "PostListViewController") as! PostListViewController
            VC.currentPostID = postID
            VC.isFromProfile = false
            self.navigationController?.pushViewController(VC, animated: true)
        default:
            
            break
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        if Constants.shared.isPopupShow == false{
            OpenPopUp()
            Constants.shared.isPopupShow = true
        }
    }
    @objc private func refreshAllPosts(_ notification: Notification) {
        lastFetchedPost = ""
        self.getAllPosts(page: 1) { (status) in
            
        }
    }
    
    @objc func resetToAllPosts(_ notification: Notification) {
        lastFetchedPost = ""
        VideoPlayerManager.shared.reset()
        VideoPlayerManager.shared.playVideo(in: nil)
        self.getAllPosts(page: 1) { (status) in
            self.delegateToReset?.finishResetingFeed()
        }
    }
    @objc func chatBadgeUpdate(_ notification: Notification) {
        if let tabbar = tabBarController as? TabbarController {
            if tabbar.selectedIndex != 3 {
                if let tabItems = tabbar.tabBar.items {
                        // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[3]
                    Constants.shared.chatBadgeCount += 1
                    tabItem.badgeValue = "\(Constants.shared.chatBadgeCount)"
                }
            } else {
                let vcArray = tabbar.viewControllers
                if let navVC = vcArray![3] as? UINavigationController {
                    if navVC.viewControllers.count == 1 {
                        if let chatVC = navVC.viewControllers.first as? ChatVC{
                            chatVC.setListner()
                        }
                    }
                }
            }
        }
    }
    
    
    
    func tabbarHomeButtonRefresh() {
        lastFetchedPost = ""
        VideoPlayerManager.shared.reset()
        VideoPlayerManager.shared.playVideo(in: nil)
        self.getAllPosts(page: 1) { (status) in
            self.delegateToReset?.finishResetingFeed()
        }
    }
    
    func deletePostFromID(postID:String){
        
        guard let index = self.postCollectionArray.firstIndex(where: {$0.postId == postID}) else{return}
        self.postCollectionArray.remove(at: index)
        self._collectionNode.reloadData()
        Constants.shared.deletedPostID = ""
    }
    
    func checkHomePageReload(){
        if UserDefaults.standard.bool(forKey: "isReload") == true{
            self.lastFetchedPost = ""
            UserDefaults.standard.set(false, forKey: "isReload")
            self.getAllPosts(page: 1) { (status) in
                
            }
        }
    }
    
    
    @objc private func uploadVideo(_ notification: Notification) {
        /// self.progressView.setProgress(0, animated: true)
        let userInfo = ["type":true]
        NotificationCenter.default.post(name: Notification.Name("HideProgressBar"), object: nil,userInfo: userInfo)
        
        self.videoPostView.isHidden = false
        self.progressView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            startTimer()
        }
    }
    
    func uploadingProgress(){
        DispatchQueue.main.async {
            Constants.shared.uploading = false
            self.progressView.isHidden = false
            self.progressView.setProgress(0, animated: true)
            
            self.videoPostView.isHidden = false
            self.videoPostProgressView.setProgress(0, animated: true)
            
            UIView.animate(withDuration: 5, animations: { () -> Void in
                self.progressView.setProgress(1.0, animated: true)
                self.videoPostProgressView.setProgress(1.0, animated: true)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.progressView.isHidden = true
            self.videoPostView.isHidden = true
            self.lastFetchedPost = ""
            self.getAllPosts(page: 1) { (status) in
                
            }
        }
    }
    
    @objc func openShare(linkString:String)  {
        let message = "LiveMarket".localiz()
        if let link = URL(string: linkString) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true)
        }
        
    }
    
    func OpenPopUp(){
        
        if SessionManager.isLoggedIn() {
            //self.checkUserProductExistOrNotAPI()
            DispatchQueue.main.async {
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
                self.present(sheet, animated: true, completion: nil)
            }
            
        }else{
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
        
    }
    
    func setupInitialState() {
        
        _collectionNode.dataSource = self
        _collectionNode.delegate = self
        _collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        _collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionFooter)
        _collectionNode.leadingScreensForBatching = 80
        _collectionNode.view.isPagingEnabled = true
        _collectionNode.alwaysBounceVertical = true
        _collectionNode.view.decelerationRate = UIScrollView.DecelerationRate.normal
        //_collectionNode.view.addSubview(refreshControl)
    }
    
    func setupStackConstraints() {
        stackSafeAreaTopConstraint = NSLayoutConstraint(item: containerStack, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0)
        stackSuperViewTopConstraint = NSLayoutConstraint(item: containerStack, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        
        stackSuperViewTopConstraint.isActive = true
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        [containerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ].forEach({ $0.isActive = true })
    }
    
    fileprivate func emptyCell() -> ASCellNodeBlock{
        let cellNodeBlock = {() -> ASCellNode in
            return { ASCellNode() }()
        }
        return cellNodeBlock
    }
    
    
    //MARK: - Socket Calls
    func observeLiveUsers(){
        let socket = SocketIOManager.sharedInstance
        socket.ObserveStartStream { [weak self] dataArray in
            print("socket.ObserveStartStream ", dataArray)
            guard let dict = dataArray[0] as? [String:Any] else {return}
            if let _ = dict["data"] as? [String: Any] {
                print("admin is live")
                self?.updateLiveAdminGif(isLive: true)
            }
        }
    }
    
    func observeLiveEndUsers() {
        let socket = SocketIOManager.sharedInstance
        socket.ObserveEndStream { [weak self] dataArray in
            print("socket.ObserveEndStream ", dataArray)
            guard let self = self,let dict = dataArray.first as? [String:Any] else {
                return
            }
            if let _ = dict["data"] as? [String: Any] {
            } else if let isAdminLive = dict["isAdminLive"] as? Bool{
                if isAdminLive != self.adminLiveStatus {
                    self.updateLiveAdminGif(isLive: isAdminLive)
                }
            } else {
                print("admin is not live")
                self.updateLiveAdminGif(isLive: false)
            }
        }
    }

    func startDownload(postData:PostCollection?) {

        if let content = postData?.postsFiles?.first {
            let filePath : String? = {
                if content.have_hls_url == "1" {
                    if let hlsCDNString = content.hls_cdn_url, content.hls_cdn_url != ""{
                        if URL(string: hlsCDNString) != nil{
                            return hlsCDNString
                        }
                    }else if let hlsString = content.hls_url, content.hls_url != ""{
                        if URL(string: hlsString) != nil{
                            return hlsString
                        }
                    }
                }
                return content.url
            }()
            var videoUrl: URL? {

                if let videoUrlString = filePath, let videoURL = URL(string:videoUrlString ) {
                    print("77cdnCdn77Url \(videoUrlString)")
                    return videoURL
                } else if let videoUrlString = content.url, let videoURL = URL(string: videoUrlString) {
                    print("77cdnCdn77Url \(videoUrlString)")
                    return videoURL
                } else {
                    return nil
                }
            }
            if let videoUrl = videoUrl {
                let pathExt = videoUrl.pathExtension.lowercased()
                guard  pathExt == "m3u8" || pathExt == "mp4" else {
                    return
                }
                let asset = CachingPlayerItem(url: videoUrl)
                print("Suleman","Start Downloading At \(videoUrl.absoluteString)")
                postPlayer[videoUrl.absoluteString] = AVPlayer(playerItem: asset)
                asset.delegate = self
                asset.download()
            }
        }
    }

    func updateLiveAdminGif(isLive: Bool) {
        adminLiveStatus = isLive
        self._collectionNode.reloadData()
    }
    
    func updateDriverLocation(){
        let parameter = ["userId": SessionManager.getUserData()?.id ?? "0",
                         "lattitude": Double(currentLocation?.coordinate.latitude.description ?? "") ?? 0 ,
                         "longitude":  Double(currentLocation?.coordinate.longitude.description ?? "") ?? 0
        ] as [String : Any]
        print(parameter)
        let socket = SocketIOManager.sharedInstance
        socket.updateDriverLocations(request: parameter) {dataArray in
            print("socket.updateDriverLocations ", dataArray)
            //print(dataArray)
        }
    }
    
    func getAllPosts(page:Int,showLoader : Bool = true, completion:@escaping(Bool)->()){
        isLoading = true
        let parameter = ["userId": SessionManager.getUserData()?.id ?? "0",
                         "limitPerPage": initialPageCount ,
                         "lastFetechedPostDateTime":  lastFetchedPost,
                         "latitude":"\(SessionManager.getLat())",
                         "longitude":"\(SessionManager.getLng())",
                         "fUserType":userTypeString] as [String : Any]
        print(parameter)
        guard Constants.shared.uploading == false else{
            return
        }
        //self.postCollectionArray.removeAll()
        if(showLoader){
            Utilities.showIndicatorView()
        }
        let socket = SocketIOManager.sharedInstance
        socket.getPublicPosts(request: parameter) {[weak self] dataArray in
            print("socket.getPublicPosts ", dataArray)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                //Utilities.hideIndicatorView()
                self?.refreshControl.endRefreshing()
                self?.isLoading = false
            }
            
            guard self != nil else {return}
            //weakSelf.loading = false
            guard let dict = dataArray[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                
                if let decodedArray:FeedPost_Base = try? decoder.decode(FeedPost_Base.self, from: json){
                    print(decodedArray.postCollection ?? [])
//                    decodedArray.postCollection?.forEach{
//                        self?.startDownload(postData:    $0)
//                    }
                    if page == 1 {
                        if self?.isSelectedUser == true {
                            if decodedArray.postCollection?.count == 0 {
                                if self?.lasttSelectedUser == "Individual"{
                                    self?.individualAction()
                                }else if self?.lasttSelectedUser == "Store"{
                                    self?.storeAction()
                                }else{
                                    self?.storeAndIndividualAction()
                                }
                                Utilities.showWarningAlert(message: "No post is available!".localiz())
                            }
                        }
                        self?.postCollectionArray = decodedArray.postCollection ?? []
                    } else {
                        self?.postCollectionArray.append(contentsOf: decodedArray.postCollection ?? [])
                    }
                    if Constants.shared.selectedMode == "Individual"{
                        self?.lasttSelectedUser = "Individual"
                    }else if Constants.shared.selectedMode == "Store"{
                        self?.lasttSelectedUser = "Store"
                    }else{
                        self?.lasttSelectedUser = "Both"
                    }
                    self?.currentPage = page
                    //self?.postCollectionArray = decodedArray.postCollection ?? []
                    //Constants.shared.lastFeedPost = decodedArray.postCollection ?? []
                    self?._collectionNode.reloadData()
                    self?.lastFetchedPost = self?.postCollectionArray.last?.postCreatedAt ?? ""
    
                    
                    if page == 1{
                        self?._collectionNode.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(row: 0, section: 0)
                            guard let node = self?._collectionNode.nodeForItem(at: indexPath) as? FeedNode else {return}
                            self?.currentIndex = indexPath.item
                            print("SETCURRENTINDEX \(self?.currentIndex)")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                VideoPlayerManager.shared.playVideo(in: node)
                                VideoPlayerManager.shared.playerView?.playVideo()
                            }
                        }
                    }else{
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        Utilities.hideIndicatorView()
                    }
                    Constants.shared.uploading = false
                    completion(true)
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        Utilities.hideIndicatorView()
                    }
                    Constants.shared.uploading = false
                    completion(false)
                }
            } catch {
                Constants.shared.uploading = false
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    Utilities.hideIndicatorView()
                }
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func getSinglePosts(postID:String){
        let parameter = ["userId": SessionManager.getUserData()?.id ?? "0",
                         "postId": postID
        ] as [String : Any]
        print(parameter)
        //self.postCollectionArray.removeAll()
        Utilities.showIndicatorView()
        let socket = SocketIOManager.sharedInstance
        socket.getSinglePosts(request: parameter) {[weak self] dataArray in
            print("socket.getSinglePosts ", dataArray)
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
                    //self?.postCollectionArray = decodedArray.postCollection ?? []
                    Constants.shared.lastFeedPost = decodedArray.postCollection ?? []
                    self?._collectionNode.reloadData()
                    
                    
                }else{
                    print("error.localizedDescription")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - API Call
    
    func followAndUnfollowAPI(follow_userID:String,id:String) {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "follow_user_id" : follow_userID
        ]
        StoreAPIManager.followAndUnfollowAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                //                if let index = self.postCollectionArray.firstIndex(where:{$0.postId == id}){
                //                    if result.message ?? "" == "Un followed"{
                //                        self.postCollectionArray[index].isIamFollowing =  "0"
                //                    }else{
                //                        self.postCollectionArray[index].isIamFollowing =  "1"
                //                    }
                //                    self._collectionNode.reloadItems(at: [IndexPath(item: index, section: 0)])
                //                }
                
                for indexValue in 0..<self.postCollectionArray.count{
                    if self.postCollectionArray[indexValue].postedUserId == follow_userID{
                        if result.message ?? "" == "Un followed"{
                            self.postCollectionArray[indexValue].isIamFollowing =  "0"
                        }else{
                            self.postCollectionArray[indexValue].isIamFollowing =  "1"
                        }
                        self._collectionNode.reloadItems(at: [IndexPath(item: indexValue, section: 0)])
                    }
                }
                
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func checkUserProductExistOrNotAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "user_id" : SessionManager.getUserData()?.id ?? ""
        ]
        CMSAPIManager.checkUserProductExistAPI(parameters: parameters) { [weak self] result in
            switch result.status {
            case "1":
                    DispatchQueue.main.async {
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
                    }
            default:
                DispatchQueue.main.async {
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
    func uploadVideoAPI(info:[AnyHashable : Any]) {
        
        guard Constants.shared.uploadVideoArray.count > 0  else {
            Utilities.showWarningAlert(message:  "Please add your post videos.".localiz()) {
                
            }
            return
        }
        
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "caption":"\(info["caption"] ?? "")",
            "file_type":"2",
            "location":"\(info["location"] ?? "")",
            "lattitude":"\(info["lattitude"] ?? "")",
            "longitude":"\(info["longitude"] ?? "")"
        ]
        
        print(parameters)
        /// First showed video // Proirity set
        //        var firstVideoArray:[URL] = []
        //        firstVideoArray = Constants.shared.uploadVideoArray
        
        var remainingVideoArray:[URL] = []
        //        if Constants.shared.uploadVideoArray.count > 2{
        //            for index in 0..<Constants.shared.uploadVideoArray.count {
        //                if index != 0{
        //                    remainingVideoArray.append(Constants.shared.uploadVideoArray[index])
        //                }
        //            }
        //        }
        // APIClient.delegate = self
        AddPostAPIManager.addPostVideoApi(video: remainingVideoArray, firstVideo: Constants.shared.uploadVideoArray, parameters: parameters) { result  in
            DispatchQueue.main.async {
                self.progressView.isHidden = true
                self.percentageLabel.isHidden = true
                
                self.videoPostView.isHidden = true
                self.videoPostProgressView.setProgress(0, animated: true)
            }
            
            switch result.status {
            case "1":
                Constants.shared.uploadImageArray.removeAll()
                self.lastFetchedPost = ""
                self.getAllPosts(page: 1) { (status) in
                    
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension HomeViewController: CachingPlayerItemDelegate {

    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        print("Suleman","File is downloaded and ready for storing \(playerItem.tracks.first)")

    }

    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
        print("Suleman","\(bytesDownloaded)/\(bytesExpected)")
    }

    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
        print("Suleman","Not enough data for playback. Probably because of the poor network. Wait a bit and try to play later.")
    }

    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print("Suleman",error)
    }

}
extension HomeViewController: ASCollectionDataSource,ASCollectionDelegate{
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        
        if postCollectionArray.count > 0{
            return postCollectionArray.count
        }else{
            return Constants.shared.lastFeedPost.count
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellNodeBlockFianl = {[weak self]() -> ASCellNode in
            guard let self = self else {return ASCellNode()}

            if !self.postCollectionArray.isEmpty {
                let cell  = FeedNode(post: self.postCollectionArray[indexPath.row], isProfilePage: false,delegate: self)
                cell.isAdminIsLive = self.adminLiveStatus
                cell.delegate = self
                self.pageIndex += 1
                if self.adminLiveStatus {
                    cell.iconImageNode.setImage(UIImage(named: "liveLogoAdmin"), for: .normal)
                } else {
                    cell.iconImageNode.setImage(UIImage(named: "liveLogo"), for: .normal)
                }
                return cell
            } else {
                let cell  = FeedNode(post: Constants.shared.lastFeedPost[indexPath.row], isProfilePage: false, delegate: self)

                if self.adminLiveStatus {
                    cell.iconImageNode.setImage(UIImage(named: "liveLogoAdmin"), for: .normal)
                } else {
                    cell.iconImageNode.setImage(UIImage(named: "liveLogo"), for: .normal)
                }
                cell.delegate = self
                cell.layoutIfNeeded()
                return cell
            }
        }
        return cellNodeBlockFianl
    }
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        
        return ASSizeRange(min: self.view.frame.size,max: self.view.frame.size)
        
    }
    func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
        
        if userTypeString == ""{
            if postCollectionArray.count > 0{
                self.currentPostlastFetchedTime = postCollectionArray[node.indexPath?.item ?? 0].postCreatedAt ?? ""
            }
        }
        guard collectionNode.visibleNodes.count > 0 else {return}
        pageIndex -= 1
        if node.indexPath?.item == 0{
            if currentIndex == -1{
                self.currentIndex = 0
            }
        }
        if VideoPlayerManager.shared.playerView == nil {
            let _node = node as? FeedNode
            _node?.isMuted = Constants.shared.videoMuted
            VideoPlayerManager.shared.playVideo(in: _node)
        }
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        let total = initialPageCount * currentPage
        if(self.postCollectionArray.count >= total){
            return true
        }
        
        return false
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        //Thread.sleep(forTimeInterval: 1)
        guard !isLoading else {return}
        let nextPage = self.postCollectionArray.count / initialPageCount + 1 // Assuming 10 items per page
        print("########## \(nextPage)")
        
        let total = initialPageCount * currentPage
        // Perform batch fetch for the next page
        if(self.postCollectionArray.count >= total){
            self.getAllPosts(page: nextPage,showLoader: false) { (status) in
                context.completeBatchFetching(true)
            }
        }
        
        // Signal the completion of batch fetch
    }
    /*
     func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
     
     Thread.sleep(forTimeInterval: 1)
     self.getAllPosts { (status) in
     context.completeBatchFetching(true)
     }
     return
     }
     func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
     guard collectionNode.numberOfItems(inSection: 0) > 0 else {return  false}
     if pageIndex == 1 {
     return true
     }else{
     return false
     }
     
     
     }*/
}

extension HomeViewController:CellActionsProtocol{
    
    func updateProgress(time: CMTime, videoPlayer: AVPlayer?) {
        guard let player = videoPlayer else { return }
        guard let currentItem = player.currentItem else { return }
        
        let duration = currentItem.duration.seconds
        let currentTime = time.seconds
        self.progressView.isHidden = false
        self.videoPostView.isHidden = false
        // Update the progress view
        let progress = Float(currentTime / duration)
        //progressView.setProgress(progress, animated: true)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.progressView.setProgress(progress, animated: true)
            self.videoPostProgressView.setProgress(progress, animated: true)
        })
    }
    
    func longPressForVideo(postID:String){
     
        
        if longPressPopupShowing{
            return
        }
        longPressPopupShowing = true
        Utilities.showMultipleChoiceAlert(message: "Report this video".localiz()) {
            print("ok pressed")
            self.longPressPopupShowing = false
            if SessionManager.isLoggedIn()
            {
                let vcObject = self.storyboard?.instantiateViewController(withIdentifier: "ReportVideoReasonVC") as? ReportVideoReasonVC
                vcObject?.postID = postID
                self.navigationController?.pushViewController(vcObject!, animated: true)
            }
            else
            {
                Coordinator.setRoot(controller: self)
            }
        } secondHandler: {
            print("cancel pressed")
            self.longPressPopupShowing = false
        }

    }
    
    func usernameAction(userID: String) {
        ShopCoordinator.goToShopProfilePage(controller: self,storeID: userID)
    }
    
    func backActions() {
    }
    
    func menuAction() {
        
    }
    
    func shareAction() {
        
    }
    
    func followAction(followerID: String, postID: String) {
        
        if SessionManager.isLoggedIn() {
            self.followAndUnfollowAPI(follow_userID: followerID, id: postID )
        }else {
            Coordinator.setRoot(controller: self)
        }
    }
    
    func liveStreamList() {
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if SessionManager.isLoggedIn() {
           // Coordinator.goToLive(controller: self)
            Coordinator.goToPostComment(controller: self,isAdmin: "1")
        }else {
            let tabbar = self.tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
        //}
    }
    
    func liveActions() {
        // DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if SessionManager.isLoggedIn() {
            Coordinator.goToPostComment(controller: self,isAdmin: "0")
        }else {
            let tabbar = self.tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
        //}
    }
    
    func goToProfile() {
        if SessionManager.isLoggedIn() {
            self.tabBarController?.selectedIndex = 4
        }else{
            Coordinator.presentLogin(viewController: self)
        }
    }
    
    func profileAction(userTypeID: String, activityID: String,store_id:String,sender:ASButtonNode) {
        sender.isEnabled = false
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ShopCoordinator.goToShopProfilePage(controller: self,storeID: store_id)
            sender.isEnabled = true
        //}
    }
    
    
    func commentAction(postID:String,orderCount:Int,postUser_id:String) {
        
        if SessionManager.isLoggedIn() {
            Coordinator.goToCommentsList(controller: self,postID: postID,orderCount: orderCount,userID: postUser_id, onDone: 
                                            {
                guard let index = self.postCollectionArray.firstIndex(where: {$0.postId == postID}) else{return}
                var commentCount = Int(self.postCollectionArray[index].commentCount ?? "0") ?? 0
                commentCount += 1
                self.postCollectionArray[index].commentCount = "\(commentCount)"
                self._collectionNode.reloadItems(at: [IndexPath(item: index, section: 0)])

            })
        }else {
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
        
        //self.getSinglePosts(postID: "370")
    }
    
    func menuAction(userTypeID: String, activityID: String,store_id:String) {
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if userTypeID == "1"{//COMMERCIAL CENTERS(SHOPS)
            if activityID == "12"{//Restaurant
                ShopCoordinator.goToFoodShopProfileDetail(controller: self,resturantID: store_id)
            }else{
                ShopCoordinator.goToShopProfileDetail(controller: self,storeID: store_id)
            }
            
        }else if userTypeID == "2"{//RESERVATIONS
            
            if activityID == "6"{//Chalets
                Coordinator.goToCharletsListVC(controller: self, venderID: store_id)
            }else if activityID == "16"{//Gym
                Coordinator.goToGymPackegesList(controller: self,id: store_id)
            }else if activityID == "4"{//Hotels
                Coordinator.goToRoomLIst(controller: self,store_id: store_id)
            }else if activityID == "24"{//Wedding Halls
                
            }else if activityID == "17"{//Playground
                PlayGroundCoordinator.goToBookNowDetail(controller: self, store_ID: store_id )
            }else{
                
            }
        }else if userTypeID == "3"{//INDIVIDUALS
            if activityID == "7"{//Car Repaire
                ShopCoordinator.goToShopProfileDetail(controller: self,storeID: store_id)
            }else if activityID == "12"{//Food store
                ShopCoordinator.goToFoodShopProfileDetail(controller: self,resturantID: store_id)
            }else if activityID == "6"{//Chalets
                Coordinator.goToCharletsListVC(controller: self, venderID: store_id)
            }else if activityID == "16"{//Gym
                Coordinator.goToGymPackegesList(controller: self,id: store_id)
            }else if activityID == "4"{//Hotels
                Coordinator.goToRoomLIst(controller: self,store_id: store_id)
            }else if activityID == "24"{//Wedding Halls
                
            }else if activityID == "17"{//Playground
                PlayGroundCoordinator.goToBookNowDetail(controller: self, store_ID: store_id )
            }else {//individuals
                ShopCoordinator.goToShopProfileDetail(controller: self,storeID: store_id)
                //SellerOrderCoordinator.goToIndividualSellerOrderDetail(controller: self)
            }
            
        }else if userTypeID == "4"{//SERVICES PROVIDERS
            Coordinator.goToAddServices(controller: self,serviceId: store_id)
        }else if userTypeID == "5"{
            if activityID == "5"{//Appartments
                
            }else if activityID == "2"{//Wedding Halls
                
            }else if activityID == "1"{//Sports Clubs
                
            }else{
                
            }
        }else if userTypeID == "6"{//DELIVERY REPRESENTATIVE
            if activityID == "8"{//Restaurants
                
            }else{
                
            }
        }else{
            
        }
        // }
    }
    
    func shareAction(obj: PostCollection?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if SessionManager.isLoggedIn() {
                self.createShareURL(id: obj?.postId ?? "", type: "homePost", title: obj?.postedUserName ?? "", image: obj?.postedUserImageurl ?? "")
            }else {
                let tabbar = self.tabBarController as? TabbarController
                tabbar?.hideTabBar()
                Coordinator.setRoot(controller: self)
            }
        }
    }
    
//    func shareAction(shareLink:String?) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if SessionManager.isLoggedIn() {
//                self.openShare(linkString: shareLink ?? "")
//            }else {
//                let tabbar = self.tabBarController as? TabbarController
//                tabbar?.hideTabBar()
//                Coordinator.setRoot(controller: self)
//            }
//        }
//    }
    
    func storeAction() {
        isSelectedUser = true
        userTypeString = "shop"
        lastFetchedPost = ""
        Constants.shared.selectedMode = "Store"
        lastFetchedPost = currentPostlastFetchedTime
        self.getAllPosts(page: 1,showLoader: false) { (status) in
            
        }
    }
    
    func individualAction() {
        isSelectedUser = true
        userTypeString = "user"
        lastFetchedPost = ""
        Constants.shared.selectedMode = "Individual"
//        postCollectionArray = postCollectionArray.filter { $0.acccountType == "INDIVIDUALS"}
//        DispatchQueue.main.async {
//            CATransaction.begin()
//            CATransaction.setDisableActions(true) // Disable animations
//            self._collectionNode.reloadData()
//            CATransaction.commit()
//
//        }
        lastFetchedPost = currentPostlastFetchedTime
        self.getAllPosts(page: 1,showLoader: false) { (status) in

        }
    }
    
    func storeAndIndividualAction() {
        userTypeString = ""
        lastFetchedPost = ""
        Constants.shared.selectedMode = "Both"
        self.getAllPosts(page: 1) { (status) in
            
        }
    }
    
    func proAction() {
        
    }
    
}
extension HomeViewController: FloatingVCDelegate {
    func goToLive() {
        VideoPlayerManager.shared.pause(.hidden)
        VideoPlayerManager.shared.isVideoPaused = true
       Coordinator.goToLive(controller: self)
    }
    func goToVideo() {
        Coordinator.goToTakeVideo(controller: self)
    }
    func goToImage() {
        Coordinator.goToTakePicture(controller: self)
    }
}
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy > 0 {
            currentHeading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let lastLocation = locations.last {
            currentLocation = lastLocation
            SessionManager.setLat(lat: String(lastLocation.coordinate.latitude))
            SessionManager.setLng(lng: String(lastLocation.coordinate.longitude))
            updateUserLocationBasedOnType(currentLocation: lastLocation)
            let dataDic = ["bearing" : currentHeading]
            NotificationCenter.default.post(name: NSNotification.Name("updateDriverLocation"), object: dataDic)
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
extension HomeViewController:PostNodeDelegate{
    func tapOnHashTag(value: String) {
        Constants.shared.searchHashTagText = value
        self.tabBarController?.selectedIndex = 1
    }
    
    
}

extension HomeViewController: PopupProtocol{
    func openPopup() {
        if SessionManager.isLoggedIn() {
                self.checkUserProductExistOrNotAPI()
        }else{
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
    }
    
    func openFaceImagePopup(){
        
        if facePopupShowing {
            return
        }
        self.hideExistingPopup()
        let  VC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "ValidateFacePopup") as! ValidateFacePopup
        VC.delegate = self
        self.tabBarController?.view.addSubview(VC.view)
        self.tabBarController?.addChild(VC)
        facePopupShowing = true
    }
    
    func hideExistingPopup(){
      
        //Shoaib : If already face validation popup is appreared, let hide it first
        for child in self.tabBarController?.children ?? []{
            if child.view.tag == 1234567
            {
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
    }
}


extension HomeViewController : FacePopupProtocol{
    
    func userFaceValidated(){
        
        if SessionManager.isLoggedIn() {
            let token = SessionManager.getUserData()?.firebase_user_key
            let refChats = Database.database().reference().child("UserChecks")
            refChats.child(token ?? "").child("driver_id_verification_status").setValue("1")
            facePopupShowing = false
        }
             
    }

   @objc func checkOnGoingOrders() {
       let parameters:[String:String] = [
        "access_token" : SessionManager.getAccessToken() ?? ""
       ]
       print(parameters)

       StoreAPIManager.driverProfileAPI(parameters: parameters) { result in
           switch result.status {
               case "1":
                   DispatchQueue.main.async {
                       let total2 = (Int(result.oData?.data?.in_process ?? "") ?? 0)
                       if total2 == 0 {
                           self.openFaceImagePopup()
                           self.facePopupShowing = true
                       }
                   }
               default:
                   Utilities.showWarningAlert(message: result.message ?? "") {
                   }
           }
       }
    }

    func checkFaceSignVerificationNeeded(){
       
        
        if SessionManager.isLoggedIn() {
            let token = SessionManager.getUserData()?.firebase_user_key
            if (token ?? "").isEmpty {
                print("firebase_user_key is empty")
            } else {
                self.getFirebaseStatus(firebaseKey: token ?? "")
            }
        }
    }
    
    func getFirebaseStatus(firebaseKey:String){


        if firebaseKey.isEmpty{
            return
        }

        let refChats = Database.database().reference().child("UserChecks")

        refChats.child(firebaseKey).child("driver_id_verification_status").observeSingleEvent(of: .value, with: { (snapshot) in
            if let status = snapshot.value as? String {
                if status == "0" {
                    self.checkOnGoingOrders()
                } else {
                    self.hideExistingPopup()
                    self.facePopupShowing = false
                }
                print("Driver ID Verification Status: \(status)")
                    // Handle the fetched status
            }
        })


        Database.database().reference().child("UserChecks").child(firebaseKey).child("driver_id_verification_status").observe(.value) { snapshot in

            if let status = snapshot.value as? String {
                print(status)
                if status == "0" {
                    self.checkOnGoingOrders()
                } else {
                    self.hideExistingPopup()
                    self.facePopupShowing = false
                }
            }
        }
    }
    

}

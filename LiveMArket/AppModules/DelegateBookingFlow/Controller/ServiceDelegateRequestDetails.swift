    //
    //  ServiceRequestDetails.swift
    //  LiveMArket
    //
    //  Created by Zain on 28/01/2023.
    //

import UIKit
import FloatRatingView
import Stripe
import Cosmos
import DPOTPView
import CoreLocation
import GoogleMaps
import FittedSheets
import NVActivityIndicatorView
import FirebaseDatabase
import goSellSDK
class ServiceDelegateRequestDetails: BaseViewController {

    var balanceAmount: WalletHistoryData? {
        didSet {
        }
    }


    @IBOutlet weak var callToCustomer: UIButton!
    @IBOutlet weak var callToStore: UIButton!
    @IBOutlet weak var ratingContainerView: UIView!
    
    @IBOutlet var clearOrderBtn: UIButton!
    
    @IBOutlet weak var driverRatingView: CosmosView!{
        didSet{
            driverRatingView.settings.fillMode = .half
            driverRatingView.settings.starMargin = 5
            driverRatingView.settings.starSize = 25
            driverRatingView.settings.minTouchRating = 0
            
            driverRatingView.settings.filledColor = UIColor(hex: "#FFCC19")
            driverRatingView.settings.filledImage = UIImage(named: "star-1")
            driverRatingView.settings.emptyImage = UIImage(named: "star-11")
        }
    }
    var isDriver = false
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var acceptButtonStackView: UIStackView!
    @IBOutlet weak var locationButtonStackView: UIStackView!
    @IBOutlet weak var finishButtonStackView: UIStackView!
    
    @IBOutlet weak var chatDelegateButton: UIButton!
    @IBOutlet weak var mapContainerView: GMSMapView!
    var mapViewW = GMSMapView()
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var pScrollView: UIScrollView!
    
    @IBOutlet weak var lblchatCount: UILabel!
    @IBOutlet weak var lblTaxView: UIView!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var pickUpLocation: UILabel!
    @IBOutlet weak var dropOffLocation: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    
    @IBOutlet weak var myDistance: UILabel!
    @IBOutlet weak var myTime: UILabel!
    
    @IBOutlet weak var totalDistacnce: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    @IBOutlet weak var pickDistance: UILabel!
    @IBOutlet weak var pickTime: UILabel!
    

    @IBOutlet weak var distanceStack: UIStackView!
    @IBOutlet weak var distanceTotalk: UIView!
    @IBOutlet weak var onTheWay: UIView!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var deliverdVw: UIStackView!
    @IBOutlet weak var delieryDtLBl: UILabel!
    
    @IBOutlet weak var customerImng: UIImageView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    
    @IBOutlet weak var rejectView: UIView!
        //  @IBOutlet weak var spcialCareView: UIStackView!
    @IBOutlet weak var uploadView: UIStackView!
    
    @IBOutlet weak var trackView: UIView!
    @IBOutlet weak var deletageImng: UIImageView!
    @IBOutlet weak var userOtpTxt1: UITextField!
    @IBOutlet weak var userOtpTxt2: UITextField!
    @IBOutlet weak var userOtpTxt3: UITextField!
    
    @IBOutlet weak var userTxt1: UITextField!
    @IBOutlet weak var userTxt2: UITextField!
    @IBOutlet weak var userTxt3: UITextField!
    
    @IBOutlet weak var mspButtonView: UIView!
    
    @IBOutlet weak var verificationView: UIStackView!
    @IBOutlet weak var serviceAcceptdView: UIView!
    @IBOutlet weak var serviceType2: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var rateingView: CosmosView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var serviceIdLbl: UILabel!
    @IBOutlet weak var servicedateLbl: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storyImg: UIImageView!
    @IBOutlet weak var mapImg: UIImageView!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerImg: UIImageView!
    @IBOutlet weak var providerCompete: UILabel!
    @IBOutlet weak var providerActivity: NVActivityIndicatorView!
    @IBOutlet weak var codBtn: UIButton!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var servicePriceLbl: UILabel!
    @IBOutlet weak var taxCharges: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var paymentTypeLbl: UILabel!
    
    @IBOutlet weak var floatRt: UIStackView!
    @IBOutlet weak var deliveryDetails: UIStackView!
    @IBOutlet weak var paymentTypeHolderView: UIView!
    @IBOutlet weak var finishedView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var providerView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var billing: UIView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var StatusView: UIView!
    @IBOutlet weak var StatusImg: UIView!
    @IBOutlet weak var Statuslbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    @IBOutlet weak var collectionViewImage: UICollectionView!
    @IBOutlet var floatRatingView: FloatRatingView!
    
        //    @IBOutlet weak var btnStatus: UIButton!
        //    @IBOutlet var providerComment: UIStackView!
        //    @IBOutlet var providerCommentLbl: UILabel!

    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var paymentService:PaymentViaTapPayService!

    var isFirstTimeCalled = false
    var serviceId = ""
    var step = ""
    var paymentMethod = "2"
    var paymentSheet: PaymentSheet?

    var transID = ""
    var bookingID:String = ""
    var isFromNotification:Bool = false
    var isOrderDeliverd:Bool = false
    var isfromThankuPage:Bool = false
    var isFromChatDelegate:Bool = false
    var chatRoomID: String = ""
    var senderID: String = ""
    let refNotifications = Database.database().reference().child("Nottifications")
    var observceFirebaseValue = true
    var cardToken:String?
    var payment : OTabTransaction? {
        didSet {
            self.transID = self.serviceData?.service_invoice_id ?? ""
            if self.selectedPaymentType == "1" {
                paymentService.paymentResponse = payment
//                self.launchStripePaymentSheet()
            } else if self.selectedPaymentType == "4" {
                self.paymentCompletedAPI()
            }
        }
    }
    var servicesDetails : DelegateDetailsServicesData? {
        didSet {
            topStackView.isHidden = false
            pScrollView.isHidden = servicesDetails == nil
            viewControllerTitle = servicesDetails?.data?.serviceInvoiceID ?? ""
            self.des.text = servicesDetails?.data?.serviceDescription ?? ""
            self.servicedateLbl.text = (servicesDetails?.data?.createdAt ?? "").changeTimeToFormat_new(frmFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", toFormat: "dd EEE yyyy hh:mm a")
            self.providerCompete.text = (servicesDetails?.data?.completedOn ?? "").changeTimeToFormat_new(frmFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd EEE yyyy hh:mm a")
            self.delieryDtLBl.text = (servicesDetails?.data?.completedOn ?? "").changeTimeToFormat_new(frmFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd EEE yyyy hh:mm a")
            self.deliverdVw.isHidden = true
            self.serviceIdLbl.text = servicesDetails?.data?.serviceInvoiceID ?? ""
                // self.serviceType.text = servicesDetails?.data?.deligateService?.serviceName ?? ""
            self.serviceType2.text = servicesDetails?.data?.deligateService?.serviceName ?? ""
                //   self.pickUplbl.text = servicesDetails?.data?.pickupLocation ?? ""
                //  self.dropUplbl.text = servicesDetails?.data?.dropoffLocation ?? ""
                // self.modDelivery.text = servicesDetails?.data?.deliveryType?.deligateName ?? ""
                // self.sepcialCareLbl.text = servicesDetails?.data?.specialCare ?? ""
            if (servicesDetails?.data?.specialCare ?? "") == ""{
                    // self.spcialCareView.isHidden = true
            }
            if (servicesDetails?.data?.images?.count ?? 0) == 0 {
                self.uploadView.isHidden = true
            }
            if isDriver == true {
                self.storeName.text = servicesDetails?.data?.user?.name ?? ""
                storyImg.sd_setImage(with: URL(string:servicesDetails?.data?.user?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
                
                self.customerName.text = servicesDetails?.data?.user?.name ?? ""
                self.customerPhone.text = "+\((servicesDetails?.data?.user?.dialCode ?? "").replacingOccurrences(of: "+", with: "")) \(servicesDetails?.data?.user?.phone ?? "")"
                customerImng.sd_setImage(with: URL(string:servicesDetails?.data?.user?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            } else {
                
                self.storeName.text = servicesDetails?.data?.deliveryType?.deligateName ?? ""
                storyImg.sd_setImage(with: URL(string: servicesDetails?.data?.deliveryType?.deligateIcon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                deletageImng.sd_setImage(with: URL(string: servicesDetails?.data?.deliveryType?.deligateIcon ?? ""), placeholderImage: UIImage(named: "placeholder_profile")){ image, error, cache, url in
                    self.deletageImng.image = image
                    let tintColor = UIColor(hex: "F6B400")
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    self.deletageImng.tintColor = tintColor
                    self.deletageImng.image = tintedImage
                }
            }
            
            self.collectionViewImage.reloadData()
            if isDriver {
                setDataDriver()
                if servicesDetails?.data?.serviceStatus == "0" || servicesDetails?.data?.serviceStatus == "1" || servicesDetails?.data?.serviceStatus == "5" || servicesDetails?.data?.serviceStatus == "6" || servicesDetails?.data?.serviceStatus == "7" || servicesDetails?.data?.serviceStatus == "11"{
                    clearOrderBtn.isHidden = true
                }else{
                    clearOrderBtn.isHidden = false
                }
            } else {
                clearOrderBtn.isHidden = true
                setData()
            }
            paymentService.invoiceId = servicesDetails?.data?.serviceInvoiceID ?? ""
        }
    }
    var serviceData : ServiceData? {
        didSet {
            pScrollView.isHidden = false
            viewControllerTitle = serviceData?.service_invoice_id ?? ""
            self.des.text = serviceData?.description ?? ""
            self.serviceIdLbl.text = serviceData?.service_invoice_id ?? ""
            self.servicedateLbl.text = serviceData?.booking_date ?? ""
            self.storeName.text = serviceData?.store?.name ?? ""
            storyImg.sd_setImage(with: URL(string:serviceData?.store?.profile_url ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            self.collectionViewImage.reloadData()
            setData()
        }
    }
    var addressList : [List]? {
        didSet {
            if addressList != nil {
                for (index,item) in addressList!.enumerated() {
                    if item.isDefault == "1" {
                        self.addressPrime = item
                        addressList?.remove(at: index)
                        break
                    }else if (index == ((addressList?.count ?? 0) - 1)){
                        self.addressPrime = item
                    }
                }
            }
        }
    }
    var addressPrime : List? {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        topStackView.isHidden = true
        ratingContainerView.isHidden = true
        type = .backWithTop
        viewControllerTitle = ""
        super.viewDidLoad()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        setPayCollectionCell()
        mspButtonView.isHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        
        pScrollView.isHidden = true
        if isFromChatDelegate {
            pushDirectlyToChatController()
        }
    }
    
    
    @IBAction func clearBtnTapped(_ sender: Any) {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : serviceId,
            "type":"3"
        ]
        print(parameters)
        FoodAPIManager.driverClearOrderAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
            }
        }
    }
    
    func observiceFirebaseValuesForOrderStatus() {

        print(self.serviceId)
        if let userId = SessionManager.getUserData()?.firebase_user_key {


            refNotifications.child(userId).observe(.value) { snapshot in
                guard snapshot.exists(), let notifications = snapshot.children.allObjects as? [DataSnapshot] else { return }
                if self.observceFirebaseValue == false{
                    return
                }
                var tempNotifications: [NotificationModel] = []
                for item in notifications {
                    guard let value = item.value as? [String: Any] else { continue }
                    do {
                        let json = try JSONSerialization.data(withJSONObject: value)
                        let notification = try JSONDecoder().decode(NotificationModel.self, from: json)
                        notification.key = item.key
                        tempNotifications.insert(notification, at: 0)
                    } catch (let error){
                        print(error.localizedDescription)
                    }
                }

                var orderNotifications: [NotificationModel] = []
                for n in tempNotifications {
                    if let invoiceId = n.invoiceId {
                        if invoiceId == self.serviceId {
                            orderNotifications.append(n)
                        }
                    }
                    if let orderId = n.orderId {
                        if orderId == self.serviceId {
                            orderNotifications.append(n)
                        }
                    }
                }

                var shouldShowPopup = false
                if orderNotifications.count > 0 {
                    for n in orderNotifications {
                        let notificationType = n.notificationType
                        if notificationType == "deligate_service_completed" {
                            if let showPopup = n.showPopup{
                                if showPopup == "0" {
                                    shouldShowPopup = true
                                }
                            } else {
                                shouldShowPopup = true
                            } 
                            if let key = n.key {
                                self.observceFirebaseValue = false
                                self.refNotifications.child(userId).child(key).child("showPopup").setValue("1")
                                self.refNotifications.child(userId).removeAllObservers()
                                break
                            }
                        }
                    }
                    if shouldShowPopup {
                        self.isFromNotification = true
                    }
                    if self.isFirstTimeCalled {
                        if self.isDriver {
                            self.getDriverServiceDetails()
                        } else {
                            self.getServiceDetails()
                        }
                    }
                    self.isFirstTimeCalled = true
                }
            }
        }
    }
    
    var commonReviewData:ReviewData?{
        didSet{
            self.ratingContainerView.isHidden = false
            driverRatingView.rating = Double(commonReviewData?.rating ?? "0") ?? 0.0
        }
    }
    
    func commonReviewAPI() {
        if let id = servicesDetails?.data?.driver?.id {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "page":"1",
                "limit":"3",
                "store_id":id
            ]
            print(parameters)
            StoreAPIManager.commonReviewAPI(parameters: parameters) { result in
                switch result.status {
                    case "1":
                        DispatchQueue.main.async{
                            
                            self.commonReviewData = result.oData?.data
                        }
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {
                            
                        }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            //self.resetChatBadge()
        let chatRoom = viewControllerTitle ?? ""
        if Constants.shared.chatDelegateCountID[chatRoom] == nil {
            Constants.shared.chatDelegateCountID[chatRoom] = 0
        }
        if Constants.shared.chatDelegateCountID[chatRoom]! > 0 {
            self.lblchatCount.isHidden = false
            self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[chatRoom]!)"
        }else {
            self.lblchatCount.isHidden = true
        }
    }
    @objc func chatBadgeUpdate(_ notification: Notification) {
        
        self.updateChatBadge()
    }
    
    @IBAction func didTapOnRatingView(_ sender: Any) {
        if let id = servicesDetails?.data?.driver?.id {
            SellerOrderCoordinator.goToMyReviews(controller: self, store_id:id , isFromProfile: false, isFromDriver: false)
        }
    }
    
    func updateChatBadge(){
        self.lblchatCount.isHidden = true
        let chatRoom = viewControllerTitle ?? ""
        if chatView.isHidden == false {
            Constants.shared.chatDelegateCountID[chatRoom] = (Constants.shared.chatDelegateCountID[chatRoom] ?? 0) + 1
            print(Constants.shared.chatDelegateCountID[chatRoom]!)
            if Constants.shared.chatDelegateCountID[chatRoom]! > 0 {
                self.lblchatCount.isHidden = false
                self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[chatRoom]!)"
            }else {
                self.lblchatCount.isHidden = true
            }
        }
    }
    
    func resetChatBadge(){
        let chatRoom = viewControllerTitle ?? ""
        self.lblchatCount.isHidden = true
        if chatView.isHidden == false {
            Constants.shared.chatDelegateCountID[chatRoom] = 0
            self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[chatRoom]!)"
            self.lblchatCount.isHidden = true
        }
    }
    
    @objc func setupNotificationObserver()
    {
    isFromNotification = true
    if self.isDriver {
        self.getDriverServiceDetails()
    }else {
        getServiceDetails()
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.stopAlaram()
    }
    @IBAction func callToStoreAction(_ sender: UIButton) {
        var phoneNumer =  ""
        if isDriver == true {
            phoneNumer = "+\((servicesDetails?.data?.user?.dialCode ?? "").replacingOccurrences(of: "+", with: ""))\(servicesDetails?.data?.user?.phone ?? "")"
        } else {
            phoneNumer = "+\((servicesDetails?.data?.driver?.dialCode ?? "").replacingOccurrences(of: "+", with: ""))\(servicesDetails?.data?.driver?.phone ?? "")"
        }
        
        let url = URL(string: "TEL://\(phoneNumer)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    @IBAction func viewMapBtn(_ sender: Any) {
        openMap(sender)
            //        Coordinator.goToTrackOrder(controller: self, trackType: "5",Orderid: self.servicesDetails?.data?.id ?? "", getDriverRequestDetails: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        if let userId = SessionManager.getUserData()?.firebase_user_key{
            self.refNotifications.child(userId).removeAllObservers()
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "chatDelegate"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.chatBadgeUpdate(_:)), name: Notification.Name("chatDelegate"), object: nil)
        
        

        if cardToken == nil {
            if self.isDriver {
                self.getDriverServiceDetails()
            }else {
                getServiceDetails()
            }
        }
            // tabbar?.hideTabBar()
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.observiceFirebaseValuesForOrderStatus()
    }
    @IBAction func Trackbtn(_ sender: Any) {
        Coordinator.goToTrackOrder(controller: self,trackType: "5" , Orderid: self.servicesDetails?.data?.id ?? "")
    }
    
    @IBAction func openMap(_ sender: Any) {
        var latt = ""
        var lngg = ""
        if (self.servicesDetails?.data?.serviceStatus ?? "") == "0" ||  (self.servicesDetails?.data?.serviceStatus ?? "") == "1" ||
            (self.servicesDetails?.data?.serviceStatus ?? "") == "2" ||
            (self.servicesDetails?.data?.serviceStatus ?? "") == "3" {
            latt = self.servicesDetails?.data?.pickupLattitude ?? ""
            lngg = self.servicesDetails?.data?.pickupLongitude ?? ""
        } else {
            latt = self.servicesDetails?.data?.dropoffLattitude ?? ""
            lngg = self.servicesDetails?.data?.dropoffLongitude ?? ""
        }
        let alertController = UIAlertController(title: "Select Map".localiz(), message: "", preferredStyle: .alert)
        let appleAction = UIAlertAction(title: "Apple Map".localiz(), style: .default) { [self] (action) in
            self.openAppleMapsWithDriving(fromLat: SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
        }
        alertController.addAction(appleAction)
        let googleAction = UIAlertAction(title: "Google Map".localiz(), style: .default) { [self] (action) in
            self.openGoogleMapsDirections(fromLat: SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
        }
        alertController.addAction(googleAction)
        
            // Optionally, you can add more actions (buttons) to the alert
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { (action) in
                // Handle the "Cancel" button tap if needed
            print("Cancel tapped")
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    func setData(){
        chatDelegateButton.setTitle("  Chat with Driver".localiz(), for: .normal)
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        floatRatingView.rating = Double(servicesDetails?.data?.rating ?? "") ?? 0
        self.providerView.isHidden = true
        self.priceView.isHidden = true
        self.acceptView.isHidden = true
        acceptButtonStackView.isHidden = true
        self.paymentView.isHidden = true
        self.billing.isHidden = true
        self.mapView.isHidden = true
        mspButtonView.isHidden = true
        self.locationView.isHidden = true
        locationButtonStackView.isHidden = true
        self.numberLbl.isHidden = false
        self.deliveryDetails.isHidden = true
        self.floatRt.isHidden = true
        self.providerCompete.isHidden = true
        self.trackView.isHidden = true
        self.onTheWay.isHidden = true
        self.customerView.isHidden = true
        self.chatView.isHidden = false
            //   self.serviceDateFinish.text = "\(self.serviceData?.service_date ?? "") \(self.serviceData?.service_time ?? "")"
            //  self.providerCompete.text = self.serviceData?.completed_on ?? ""
        self.Statuslbl.text = servicesDetails?.data?.serviceStatusText ?? ""
        self.priceLbl.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.billTotal ?? "") ?? 0.0)"
        self.subLbl.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.billTotal ?? "") ?? 0.0)"
        self.servicePriceLbl.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.serviceCharge ?? "") ?? 0.0)"
        self.taxCharges.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.deliveryCharge ?? "") ?? 0.0)"
        self.grandTotal.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.grandTotal ?? "") ?? 0.0)"
        self.locLbl.text = self.serviceData?.location_name ?? ""
        let array = Array(servicesDetails?.data?.orderOtp ?? "")
        if array.count>0{
            userOtpTxt1.text = "\(array[0])"
            userOtpTxt2.text = "\(array[1])"
            userOtpTxt3.text = "\(array[2])"
        }
        self.providerName.text  = servicesDetails?.data?.driver?.name ?? ""
        self.numberLbl.text  = "+\((servicesDetails?.data?.driver?.dialCode ?? "").replacingOccurrences(of: "+", with: "")) \(servicesDetails?.data?.driver?.phone ?? "")"
            //  providerComment.isHidden = true
        providerImg.sd_setImage(with: URL(string: servicesDetails?.data?.driver?.userImage ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            //self.providerCommentLbl.text =  self.serviceData?.complete_note ?? ""
        var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.pickupLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.pickupLongitude ?? "") ?? 0.0)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
        self.mapContainerView.animate(to: camera)
        
        self.paymentTypeLbl.text = ""
        if self.servicesDetails?.data?.paymentMethod == "1" {
            self.paymentTypeLbl.text = "CARD".localiz()
        }else if self.servicesDetails?.data?.paymentMethod == "2" {
            self.paymentTypeLbl.text = "COD".localiz()
        }else if self.servicesDetails?.data?.paymentMethod == "3" {
            self.paymentTypeLbl.text = "WALLET".localiz()
        }else if self.servicesDetails?.data?.paymentMethod == "4" {
            self.paymentTypeLbl.text = "APPLE PAY".localiz()
        }
        self.distanceStack.isHidden      = true
        self.distanceTotalk.isHidden     = true
        self.mapView.isHidden            = true
        self.rateButton.isHidden         = true
        self.mapView.isHidden            = true
        self.verificationView.isHidden   = true
        self.chatView.isHidden           = true
        self.priceView.isHidden          = true
        self.serviceAcceptdView.isHidden = true
        self.acceptView.isHidden         = true
        acceptButtonStackView.isHidden = true
        self.billing.isHidden            = true
        self.trackView.isHidden = true
        self.providerView.isHidden = true
        self.finishedView.isHidden = true
        finishButtonStackView.isHidden = true
        self.paymentView.isHidden = true
        
        self.lblTaxView.isHidden = true
        if (Int(self.servicesDetails?.data?.tax ?? "") ?? 0) > 0  {
            self.lblTaxView.isHidden = false
        }
        self.lblTax.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.tax ?? "") ?? 0.0)"
        
        if self.servicesDetails?.data?.serviceStatus == "5" || self.servicesDetails?.data?.serviceStatus == "6" || self.servicesDetails?.data?.serviceStatus == "7" || self.servicesDetails?.data?.serviceStatus == "11"{
            self.providerActivity.stopAnimating()
        }else{
            self.providerActivity.type = NVActivityIndicatorType.lineSpinFadeLoader
            self.providerActivity.color = .white
            self.providerActivity.startAnimating()
        }
        
        
        if (self.servicesDetails?.data?.serviceStatus == "0"){
                //            self.StatusView.backgroundColor = UIColor(hex: "FCB813")
                //            self.StatusImg.backgroundColor = UIColor(hex: "FCB813")
            Statuslbl.textColor = UIColor(hex: "FCB813")
            self.removeRightBarbuttons()
        }else if (self.serviceData?.status ?? "" == "10" || self.serviceData?.status ?? "" == "11"){
                //            self.StatusView.backgroundColor = UIColor(hex: "F57070")
                //            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor = UIColor(hex: "F57070")
                //self.providerActivity.isHidden = true
            self.StatusImg.isHidden = true
        }else  if (self.servicesDetails?.data?.serviceStatus == "1"){
            self.storeName.text = servicesDetails?.data?.driver?.name ?? ""
            storyImg.sd_setImage(with: URL(string:servicesDetails?.data?.driver?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            self.chatView.isHidden = false
            self.serviceAcceptdView.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "F57070")
                //            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor = UIColor(hex: "F57070")
            commonReviewAPI()
        }else if (self.servicesDetails?.data?.serviceStatus  == "2"){
            var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.dropoffLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.dropoffLongitude ?? "") ?? 0.0)
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
            self.mapContainerView.animate(to: camera)
            self.chatView.isHidden = false
            self.serviceAcceptdView.isHidden = false
            self.storeName.text = servicesDetails?.data?.driver?.name ?? ""
            storyImg.sd_setImage(with: URL(string:servicesDetails?.data?.driver?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            self.priceView.isHidden = false
            self.billing.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "F57070")
                //            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor = UIColor(hex: "F57070")
            self.paymentView.isHidden = false
            commonReviewAPI()
        }else if (self.servicesDetails?.data?.serviceStatus == "3"){
            var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.dropoffLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.dropoffLongitude ?? "") ?? 0.0)
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
            self.mapContainerView.animate(to: camera)
            self.storeName.text = servicesDetails?.data?.driver?.name ?? ""
            storyImg.sd_setImage(with: URL(string:servicesDetails?.data?.driver?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.chatView.isHidden = false
            self.serviceAcceptdView.isHidden = false
                //self.providerActivity.isHidden = false
            self.paymentTypeHolderView.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "5795FF")
                //            self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor = UIColor(hex: "5795FF")
                // self.Statuslbl.text = "Wait for Service Provider"
            commonReviewAPI()
        }else if (self.servicesDetails?.data?.serviceStatus == "4"){
            var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.dropoffLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.dropoffLongitude ?? "") ?? 0.0)
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
            self.mapContainerView.animate(to: camera)
            self.storeName.text = servicesDetails?.data?.driver?.name ?? ""
            storyImg.sd_setImage(with: URL(string:servicesDetails?.data?.driver?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = true
            self.trackView.isHidden = false
            self.providerView.isHidden = false
            self.verificationView.isHidden = false
            self.chatView.isHidden = false
            self.serviceAcceptdView.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "5795FF")
                //            self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor = UIColor(hex: "5795FF")
                //  self.Statuslbl.text = "On the way to site"
            commonReviewAPI()
        }else if (self.servicesDetails?.data?.serviceStatus == "5"){
            self.callToStore.isHidden = true
            self.callToCustomer.isHidden = true
            var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.dropoffLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.dropoffLongitude ?? "") ?? 0.0)
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
            self.mapContainerView.animate(to: camera)
            self.storeName.text = servicesDetails?.data?.driver?.name ?? ""
            storyImg.sd_setImage(with: URL(string:servicesDetails?.data?.driver?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = false
            self.mspButtonView.isHidden = false
            self.providerView.isHidden = false
            self.chatView.isHidden = false
            self.serviceAcceptdView.isHidden = false
            self.floatRt.isHidden = false
            self.rateButton.isHidden = false
            self.numberLbl.isHidden = true
            self.deliveryDetails.isHidden = false
            self.providerCompete.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
                //            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            Statuslbl.textColor = UIColor(hex: "00B24D")
            self.removeRightBarbuttons()
            self.isOrderDeliverd = true
            if isFromNotification{
                isFromNotification = false
                self.showCompletedPopup(titleMessage: "Delivered Successfully".localiz(), confirmMessage: "", invoiceID: self.servicesDetails?.data?.serviceInvoiceID ?? "", viewcontroller: self)
            }
            commonReviewAPI()
                //  self.Statuslbl.text = "Work on progress"
        }else if (self.serviceData?.status ?? "" == "7"){
            var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.dropoffLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.dropoffLongitude ?? "") ?? 0.0)
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
            self.mapContainerView.animate(to: camera)
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = false
            self.providerView.isHidden = false
            self.paymentTypeHolderView.isHidden = false
            self.StatusImg.isHidden = true
            self.numberLbl.isHidden = true
            self.deliveryDetails.isHidden = false
            self.floatRt.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
                //            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            Statuslbl.textColor = UIColor(hex: "00B24D")
                //self.providerActivity.isHidden = true
            self.providerCompete.isHidden = false
                //   self.providerComment.isHidden = false
        }else if (self.serviceData?.status ?? "" == "8"){
            self.rateButton.isHidden = false
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = false
            self.providerView.isHidden = false
            self.paymentTypeHolderView.isHidden = false
            self.StatusImg.isHidden = true
            self.numberLbl.isHidden = true
            self.deliveryDetails.isHidden = false
            self.floatRt.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
                //            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            Statuslbl.textColor = UIColor(hex: "00B24D")
                // self.providerActivity.isHidden = true
            self.providerCompete.isHidden = false
                //     self.providerComment.isHidden = false
                //   self.Statuslbl.text = " Completed "
            
            
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
                case userTxt1:
                    userTxt2.becomeFirstResponder()
                case userTxt2:
                    userTxt3.becomeFirstResponder()
                case userTxt3:
                    userTxt3.resignFirstResponder()
                        //self.SetOPT()
                default:
                    break
            }
        }
        if  text?.count == 0 {
            switch textField{
                case userTxt1:
                    userTxt1.becomeFirstResponder()
                case userTxt2:
                    userTxt1.becomeFirstResponder()
                case userTxt3:
                    userTxt2.becomeFirstResponder()
                case userTxt3:
                    userTxt3.becomeFirstResponder()
                default:
                    break
            }
        }
        else{
            
        }
    }
    
    func setDataDriver(){
        otpTextFieldSetup()
        let tabbar = tabBarController as? TabbarController
        chatDelegateButton.setTitle("      Chat with Customer", for: .normal)
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        floatRatingView.rating = Double(servicesDetails?.data?.rating ?? "") ?? 0
        self.providerView.isHidden = true
        self.priceView.isHidden = true
        self.acceptView.isHidden = true
        acceptButtonStackView.isHidden = true
        self.paymentView.isHidden = true
        self.billing.isHidden = true
        self.mapView.isHidden = true
        self.locationView.isHidden = true
        locationButtonStackView.isHidden = true
        self.numberLbl.isHidden = false
        self.deliveryDetails.isHidden = true
        self.floatRt.isHidden = true
        self.providerCompete.isHidden = true
        self.trackView.isHidden = true
        self.onTheWay.isHidden = true
        self.chatView.isHidden = false
        self.pickUpLocation.text = "\(servicesDetails?.data?.pickupLocation ?? "") "
        self.dropOffLocation.text = "\(servicesDetails?.data?.dropoffLocation ?? "") "
        
        
        if self.servicesDetails?.data?.serviceStatus == "5" || self.servicesDetails?.data?.serviceStatus == "6" || self.servicesDetails?.data?.serviceStatus == "7" || self.servicesDetails?.data?.serviceStatus == "11"{
            self.providerActivity.stopAnimating()
        }else{
            self.providerActivity.type = NVActivityIndicatorType.lineSpinFadeLoader
            self.providerActivity.color = .white
            self.providerActivity.startAnimating()
        }
        
        
            //   self.serviceDateFinish.text = "\(self.serviceData?.service_date ?? "") \(self.serviceData?.service_time ?? "")"
            //  self.providerCompete.text = self.serviceData?.completed_on ?? ""
        self.Statuslbl.text = "\(servicesDetails?.data?.serviceStatusText ?? "") "
        self.priceLbl.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.billTotal ?? "") ?? 0.0)"
        print(self.priceLbl.text)
        self.subLbl.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.billTotal ?? "") ?? 0.0)"
        self.servicePriceLbl.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.serviceCharge ?? "") ?? 0.0)"
        self.taxCharges.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.deliveryCharge ?? "") ?? 0.0)"
        self.grandTotal.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.grandTotal ?? "") ?? 0.0)"
        self.locLbl.text = self.serviceData?.location_name ?? ""
        let array = Array(servicesDetails?.data?.orderOtp ?? "")
        if array.count>0{
            userOtpTxt1.text = "\(array[0])"
            userOtpTxt2.text = "\(array[1])"
            userOtpTxt3.text = "\(array[2])"
        }
        self.providerName.text  = servicesDetails?.data?.driver?.name ?? ""
        self.numberLbl.text  = "+\((servicesDetails?.data?.driver?.dialCode ?? "").replacingOccurrences(of: "+", with: "")) \(servicesDetails?.data?.driver?.phone ?? "")"
            // providerComment.isHidden = true
        providerImg.sd_setImage(with: URL(string: servicesDetails?.data?.driver?.userImage ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            //  self.providerCommentLbl.text =  self.serviceData?.complete_note ?? ""
        
        var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.pickupLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.pickupLongitude ?? "") ?? 0.0)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
        self.mapContainerView.animate(to: camera)
        self.paymentTypeLbl.text = ""
        if self.servicesDetails?.data?.paymentMethod == "1" {
            self.paymentTypeLbl.text = "CARD".localiz()
        }else if self.servicesDetails?.data?.paymentMethod == "2" {
            self.paymentTypeLbl.text = "COD".localiz()
        }else if self.servicesDetails?.data?.paymentMethod == "3" {
            self.paymentTypeLbl.text = "WALLET".localiz()
        }else if self.servicesDetails?.data?.paymentMethod == "4" {
            self.paymentTypeLbl.text = "APPLE PAY".localiz()
        }
        self.rejectView.isHidden = true
        self.rateButton.isHidden = true
        self.serviceAcceptdView.isHidden = false
        self.mapView.isHidden = false
        self.mspButtonView.isHidden = false
        self.verificationView.isHidden = true
        self.customerView.isHidden = true
        self.lblTaxView.isHidden = true
        self.chatView.isHidden = true
        
        if (Int(self.servicesDetails?.data?.tax ?? "") ?? 0) > 0  {
            self.lblTaxView.isHidden = false
        }
        self.lblTax.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.tax ?? "") ?? 0.0)"
        
            // self.priceView.isHidden = false
        
        self.myDistance.text = self.servicesDetails?.data?.driverStoreDistance?.distance ?? ""
        self.myTime.text = self.servicesDetails?.data?.driverStoreDistance?.time ?? ""
        
        self.pickTime.text = self.servicesDetails?.data?.userStoreDistance?.time ?? ""
        self.pickDistance.text = self.servicesDetails?.data?.userStoreDistance?.distance ?? ""
        
        self.totalTime.text = self.servicesDetails?.data?.totalDistance?.time ?? ""
        self.totalDistacnce.text = self.servicesDetails?.data?.totalDistance?.distance ?? ""
        
        
        self.distanceStack.isHidden = false
        self.distanceTotalk.isHidden = false
        self.getAddress()
        
        if (self.servicesDetails?.data?.serviceStatus == "0"){
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = false
            self.acceptView.isHidden = false
            acceptButtonStackView.isHidden = false
            self.chatView.isHidden = true
            self.serviceAcceptdView.isHidden = false
            self.priceView.isHidden = true
                //            self.StatusView.backgroundColor = UIColor(hex: "FCB813")
                //            self.StatusImg.backgroundColor = UIColor(hex: "FCB813")
            Statuslbl.textColor =  UIColor(hex: "FCB813")
            self.removeRightBarbuttons()
            
        }else if (self.serviceData?.status ?? "" == "10" || self.serviceData?.status ?? "" == "11"){
                //            self.StatusView.backgroundColor = UIColor(hex: "F57070")
                //            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor =  UIColor(hex: "F57070")
                //self.providerActivity.isHidden = true
                //self.StatusImg.isHidden = true
        }else  if (self.servicesDetails?.data?.serviceStatus == "1"){
                //  self.mapView.isHidden = true
            self.chatView.isHidden = false
            self.acceptView.isHidden = true
            acceptButtonStackView.isHidden = true
            self.priceView.isHidden = true
            self.serviceAcceptdView.isHidden = false
            self.billing.isHidden = true
            self.finishedView.isHidden = false
            finishButtonStackView.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "F57070")
                //            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor =  UIColor(hex: "F57070")
        }else if (self.servicesDetails?.data?.serviceStatus  == "2"){
            self.chatView.isHidden = false
            self.serviceAcceptdView.isHidden = false
            self.finishedView.isHidden = true
            finishButtonStackView.isHidden = true
            self.priceView.isHidden = false
            self.billing.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "5795FF")
                //            self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor =  UIColor(hex: "5795FF")
            self.paymentView.isHidden = true
        }else if (self.servicesDetails?.data?.serviceStatus == "3"){
            self.chatView.isHidden = false
            self.serviceAcceptdView.isHidden = false
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.trackView.isHidden = true
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = false
            self.providerView.isHidden = true
            self.paymentTypeHolderView.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "5795FF")
                //            self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor =  UIColor(hex: "5795FF")
            self.onTheWay.isHidden = false
                // self.Statuslbl.text = "Wait for Service Provider"
        }else if (self.servicesDetails?.data?.serviceStatus == "4"){
            var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.dropoffLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.dropoffLongitude ?? "") ?? 0.0)
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
            self.mapContainerView.animate(to: camera)
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = false
            self.trackView.isHidden = true
            self.providerView.isHidden = true
            self.verificationView.isHidden = false
            Statuslbl.textColor =  UIColor(hex: "5795FF")
            self.customerView.isHidden = false
            self.chatView.isHidden = false
            self.serviceAcceptdView.isHidden = false
            
                //  self.Statuslbl.text = "On the way to site"
        }else if (self.servicesDetails?.data?.serviceStatus == "5"){
            var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.dropoffLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.dropoffLongitude ?? "") ?? 0.0)
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
            self.mapContainerView.animate(to: camera)
            self.priceView.isHidden = false
            self.deliverdVw.isHidden = false
            self.chatView.isHidden = false
            self.billing.isHidden = false
            self.paymentTypeHolderView.isHidden = false
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = false
            self.providerView.isHidden = true
            self.finishedView.isHidden = true
            self.paymentView.isHidden = true
            self.floatRt.isHidden = false
            self.rateButton.isHidden = false
            self.numberLbl.isHidden = true
            self.deliveryDetails.isHidden = false
            self.providerCompete.isHidden = false
                //self.providerActivity.isHidden = true
                //self.StatusImg.isHidden = true
                //            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
                //            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            Statuslbl.textColor =  UIColor(hex: "00B24D")
            self.removeRightBarbuttons()
            self.serviceAcceptdView.isHidden = false
            self.isOrderDeliverd = true
                //  self.Statuslbl.text = "Work on progress"
            if isFromNotification{
                isFromNotification = false
                self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Delivered Successfully".localiz(), confirmMessage: "", invoiceID: self.servicesDetails?.data?.serviceInvoiceID ?? "", viewcontroller: self)
            }
        }else if (self.serviceData?.status ?? "" == "7" || self.serviceData?.status ?? "" == "6"){
            var coordinate = CLLocationCoordinate2D(latitude: Double(self.servicesDetails?.data?.dropoffLattitude ?? "") ?? 0.0, longitude: Double(self.servicesDetails?.data?.dropoffLongitude ?? "") ?? 0.0)
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
            self.mapContainerView.animate(to: camera)
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = false
            self.providerView.isHidden = false
            self.paymentTypeHolderView.isHidden = false
            self.StatusImg.isHidden = true
            self.numberLbl.isHidden = true
            self.deliveryDetails.isHidden = false
            self.floatRt.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
                //            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            Statuslbl.textColor =  UIColor(hex: "00B24D")
                //self.providerActivity.isHidden = true
            self.providerCompete.isHidden = false
                //  self.providerComment.isHidden = false
        }else if (self.serviceData?.status ?? "" == "8"){
            self.rateButton.isHidden = false
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.mspButtonView.isHidden = false
            self.providerView.isHidden = false
            self.paymentTypeHolderView.isHidden = false
            self.StatusImg.isHidden = true
            self.numberLbl.isHidden = true
            self.deliveryDetails.isHidden = false
            self.floatRt.isHidden = false
                //            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
                //            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            Statuslbl.textColor =  UIColor(hex: "00B24D")
                //self.providerActivity.isHidden = true
            self.providerCompete.isHidden = false
                //  self.providerComment.isHidden = false
                //   self.Statuslbl.text = " Completed "
        }
    }
    func setPayCollectionCell() {
        payCollection.delegate = self
        payCollection.dataSource = self
        payCollection.register(UINib.init(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.payCollection.collectionViewLayout = layout
        payCollection.reloadData()
        self.payCollection.layoutIfNeeded()
        
        collectionViewImage.delegate = self
        collectionViewImage.dataSource = self
        collectionViewImage.register(UINib.init(nibName: "ShowPicCell", bundle: nil), forCellWithReuseIdentifier: "ShowPicCell")
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        layout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionViewImage.collectionViewLayout = layout2
        
    }
    func otpTextFieldSetup(){
        userTxt1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        userTxt2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        userTxt3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        userTxt1.delegate = self
        userTxt2.delegate = self
        userTxt3.delegate = self
    }
    @IBAction func statsAction(_ sender: UIButton) {
        
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        self.acceptQuoatAPI()
    }
    @IBAction func rejectAction(_ sender: UIButton) {
        self.rejectQuoatAPI()
    }
    @IBAction func openChat(_ sender: UIButton) {
        resetChatBadge()
        if isDriver {
            Coordinator.goToChatDetails(delegate: self,user_id: servicesDetails?.data?.userID ?? "",user_name: servicesDetails?.data?.user?.name ?? "",userImgae: servicesDetails?.data?.user?.userImage ?? "", firebaseUserKey: servicesDetails?.data?.user?.firebaseUserKey ?? "",isFromDelegate: true,isDeliverd: isOrderDeliverd,orderID: servicesDetails?.data?.serviceInvoiceID ?? "",serviceID: self.serviceId)
        }else {
            Coordinator.goToChatDetails(delegate: self,user_id: servicesDetails?.data?.driverID ?? "",user_name: servicesDetails?.data?.driver?.name ?? "",userImgae: servicesDetails?.data?.driver?.userImage ?? "", firebaseUserKey: servicesDetails?.data?.driver?.firebaseUserKey ?? "",isFromDelegate: true,isDeliverd: isOrderDeliverd,orderID: servicesDetails?.data?.serviceInvoiceID ?? "", serviceID: self.serviceId)
        }
    }
    @IBAction func setOTP(_ sender: UIButton) {
        if userTxt1.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please valid OTP".localiz()) {
                
            }
        }
        else if userTxt2.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please valid OTP".localiz()) {
                
            }
        }else if userTxt3.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please valid OTP".localiz()) {
                
            }
        }else {
            self.SetOPTtt()
        }
    }
    @IBAction func sendLocation(_ sender: UIButton) {
        if (step == "3"){
            Coordinator.goToServiceLocation(controller: self)
            
        }
    }
    
    func pushDirectlyToChatController() {
        resetChatBadge()
        Coordinator.goToChatDetails(delegate: self,firebaseUserKey: self.senderID, roomId: self.chatRoomID, isDriver: self.isDriver)
    }
    
    override func backButtonAction() {
        if Constants.shared.isCommingFromOrderPopup {
            Constants.shared.isDeliveryOrder = true
        }
        if isfromThankuPage && self.isDriver == true {
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "Delivery Requests")
        } else {
            
            let navsArr = self.navigationController?.viewControllers
            if navsArr?.count == 3 && ((navsArr?[1].isKind(of: UserServicesList.self)) != nil)
            {
            self.navigationController?.popViewController(animated: true)
            return
            }
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "Delivery Services")
            
        }
        
    }
    @IBAction func finished(_ sender: UIButton) {
        Coordinator.goAddBillVC(controller: self, step: "",service_request_id: self.serviceId)
    }
    @IBAction func onTheyWay(_ sender: UIButton) {
        self.onTheWayFc()
    }
    @IBAction func actionCod(_ sender: UIButton) {
        self.codBtn.setImage(UIImage(named: "Group 236139"), for: .normal)
        self.paymentMethod = "2"
        self.selectedPaymentType = "2"
        self.selectedIndex = -1
        self.payCollection.reloadData()
    }
    @IBAction func payNow(_ sender: UIButton) {
        paymentService.invoiceId = self.servicesDetails?.data?.serviceInvoiceID ?? ""
        if selectedIndex == 0 {
            selectedPaymentType = "1"
            let grandTotalAmount = self.servicesDetails?.data?.grandTotal ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")

            paymentService.startPaymentViaSellSDK(amount: Decimal.init(string: grandTotal) ?? 0.0)
           // self.payNow()
        } else if selectedIndex == 1 {
            selectedPaymentType = "4"
            let grandTotalAmount = self.servicesDetails?.data?.grandTotal ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            paymentService.startApplePaymentViaSellSDK(amount: Double(grandTotal) ?? 0)

        } else if selectedIndex == 2 {
            selectedPaymentType = "3"
            let grandTotalAmount = self.servicesDetails?.data?.grandTotal ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            
            if ((Float(grandTotal ) ?? 0.0) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0)){

                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {

                    self.cardToken = nil
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                self.paymentCompletedAPI()
            }
        }
    }
    @IBAction func FloatAction(_ sender: UIButton) {
        if (Double(servicesDetails?.data?.rating ?? "") ?? 0.0) == 0 {
            let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
                //VC.serviceData = self.serviceData
            VC.isFromServices = true
            VC.isFromOrder = true
            VC.userServicesDelegateDetails = self.servicesDetails
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @objc func showRating(){
        let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
            //VC.serviceData = self.serviceData
        VC.isFromServices = true
        VC.isFromOrder = true
        VC.userServicesDelegateDetails = self.servicesDetails
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    override func ChatAction() {
        
        
    }


}
extension ServiceDelegateRequestDetails: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == payCollection){
            return imageArray.count
        }else  {
            return self.servicesDetails?.data?.images?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == payCollection){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodsCell", for: indexPath) as? PaymentMethodsCell else
            { return UICollectionViewCell()
            }
            
            cell.image.image = imageArray[indexPath.row]
            
            if indexPath.row == self.selectedIndex {
                cell.checkBoxBtn.setImage(UIImage(named: "Group 236139"), for: .normal)
            } else {
                cell.checkBoxBtn.setImage(UIImage(named: "Ellipse 1449"), for: .normal)
            }
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowPicCell", for: indexPath) as? ShowPicCell else { return UICollectionViewCell() }
            cell.img.sd_setImage(with: URL(string:self.servicesDetails?.data?.images?[indexPath.row].processedImageURL ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            cell.crossBtn.isHidden = true
            cell.btnImg.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == payCollection){
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-40
            return CGSize(width: screenWidth/2.08, height:70)
        }else {
            return CGSize(width: 103, height:130)
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
        
        if collectionView == collectionViewImage {
            
            var array = [String]()
            if let images = self.servicesDetails?.data?.images {
                let current = images[indexPath.row]
                array.append(current.processedImageURL ?? "")
                for (index,item) in images.enumerated() {
                    if(index != indexPath.row){
                        array.append(item.processedImageURL ?? "")
                    }
                }
            }

            let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
            VC.imageURLArray = array
            
            self.present(VC, animated: true)
        } else {
                self.selectedIndex = indexPath.row
                if self.selectedIndex == 0 {
                    self.selectedPaymentType = "1"
                } else if  self.selectedIndex == 1 {
                    self.selectedPaymentType = "4"
                } else if  self.selectedIndex == 2 {
                    self.selectedPaymentType = "3"
                }
                self.codBtn.setImage(UIImage(named: "Ellipse 1449"), for: .normal)

            self.payCollection.reloadData()
        }
    }
}

extension ServiceDelegateRequestDetails {
    func getServiceDetails() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_id" : self.serviceId
        ]
        DelegateServiceAPIManager.getMyRequestDetailsAPI(parameters: parameters) { result in
            switch result.status {
                case "1":

                    self.getAdressAPI()
                    self.getBalance()
                    self.servicesDetails = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        self.navigationController?.popViewController(animated: true)
                    }
            }
        }
    }
    func getDriverServiceDetails() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_id" : self.serviceId,
            "lattitude" : SessionManager.getLat(),
            "longitude" : SessionManager.getLng()
            
        ]
        DelegateServiceAPIManager.getDriverRequestDetailsAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.getAdressAPI()
                    self.getBalance()
                    self.servicesDetails = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        self.navigationController?.popViewController(animated: true)
                    }
            }
        }
    }
    
    func acceptQuoatAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_id" : self.serviceId 
        ]
        DelegateServiceAPIManager.driverAcceptServiceAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.getDriverServiceDetails()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
            }
        }
    }
    
    func rejectQuoatAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceId
        ]
        ServiceAPIManager.reject_quoteAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.getServiceDetails()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
            }
        }
    }
    
    func onTheWayFc() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_id" : self.serviceId
        ]
        DelegateServiceAPIManager.onTheWayAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.getDriverServiceDetails()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
            }
        }
    }
    
    func SetOPTtt() {
        let otp = "\(self.userTxt1.text ?? "")\(self.userTxt2.text ?? "")\(self.userTxt3.text ?? "")"
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_id" :self.serviceId,
            "otp" : otp
        ]
        
        DelegateServiceAPIManager.DriverOTPAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.isFromNotification = true
                    self.getDriverServiceDetails()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
            }
        }
    }
    
    func payNow() {
        
//        if selectedPaymentType == "" {
//            Utilities.showQuestionAlert(message: "Please select payment type")
//        }
//        else if selectedPaymentType == "2"{
//            self.paymentCompletedAPI()
//        }else if selectedPaymentType == "3"
//        {
//            if ((Float(self.serviceData?.total_amount ?? "") ?? 0.0) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0)){
//                Utilities.showSuccessAlert(message: "Insufficient wallet balance") {
//                    Coordinator.gotoRecharge(controller: self)
//                }
//            }else {
//                self.paymentCompletedAPI()
//            }
//        }else {
//            self.payNow()
//        }
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone"     : TimeZone.current.identifier,
            "address_id"   : self.addressPrime?.id ?? "0",
            "service_id"   : self.servicesDetails?.data?.id ?? "",
            "payment_type"   : self.selectedPaymentType,
            "token_id"     : self.cardToken  ?? ""
        ]
        DelegateServiceAPIManager.payment_initServicesAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                    self.payment = result.oData?.oTabTransaction
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func paymentCompletedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : self.servicesDetails?.data?.serviceInvoiceID ?? "",
            "payment_type" : self.selectedPaymentType
        ]
        print(parameters)
        DelegateServiceAPIManager.completeServicesPaymentAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                        //Coordinator.goToDelegateThank(controller: self,step: "2",invoiceId: self.servicesDetails?.data?.serviceInvoiceID,serviceId: self.servicesDetails?.data?.id)

                    DispatchQueue.main.async {
                        self.bookingID = self.servicesDetails?.data?.id ?? ""
                        let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                        controller.delegate = self
                        controller.heading = "Payment made successfully".localiz()
                        controller.confirmationText = ""
                        controller.invoiceNumber = self.servicesDetails?.data?.serviceInvoiceID ?? ""
                        let sheet = SheetViewController(
                            controller: controller,
                            sizes: [.fullscreen],
                            options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
                        sheet.minimumSpaceAbovePullBar = 0
                        sheet.dismissOnOverlayTap = true
                        sheet.dismissOnPull = false
                        sheet.contentBackgroundColor = UIColor.black.withAlphaComponent(0.5)
                        self.present(sheet, animated: true, completion: nil)
                    }
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
            }
        }
    }
}
    // MARK: - Stripe Integration
extension ServiceDelegateRequestDetails {
    func getAdressAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AddressAPIManager.listAddressAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.addressList = result.oData?.list
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
            }
        }
    }
    
}
extension ServiceDelegateRequestDetails {
    func getBalance() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AuthenticationAPIManager.getWalletAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.balanceAmount = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ) {
                        
                    }
            }
        }
    }
}
extension ServiceDelegateRequestDetails: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
            // textField.text = ""
    }
}
extension ServiceDelegateRequestDetails {
    func calculateDistacnce(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D,type:String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let origin = "\(source.latitude),\(source.longitude)"
        let destinationLocation = "\(destination.latitude),\(destination.longitude)"
        
        
        let array = [source,destination]
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destinationLocation)&sensor=false&units=metric&mode=driving&key=\(Config.googleApiKey)")!
        
        let task = session.dataTask(with: url, completionHandler: {[weak self]
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                    //                self.activityIndicator.stopAnimating()
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                                    //                                self.activityIndicator.stopAnimating()
                            }
                            return
                        }
                        
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            
                            let ArrLegs = overview_polyline?["legs"] as? NSArray
                            let legs = ArrLegs?.firstObject as? NSDictionary
                            var duration = legs?["duration"] as? NSDictionary
                            var dist = legs?["distance"] as? NSDictionary
                            
                            
                            
                            DispatchQueue.main.async {
                                
                                if type ==  "1" {
                                    self?.myDistance.text = "\("\((dist?["text"] as? String) ?? "")")"
                                    self?.myTime.text =  "\("\((duration?["text"] as? String) ?? "")")"
                                    
                                }
                                else if type ==  "2" {
                                    self?.pickDistance.text = "\("\((dist?["text"] as? String) ?? "")")"
                                    self?.pickTime.text =  "\("\((duration?["text"] as? String) ?? "")")"
                                    
                                }
                                else if type ==  "3" {
                                    self?.totalDistacnce.text = "\("\((dist?["text"] as? String) ?? "")")"
                                    self?.totalTime.text =  "\("\((duration?["text"] as? String) ?? "")")"
                                    
                                }
                                
                                
                            }
                        } else {
                            DispatchQueue.main.async {
                                
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                            //                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        })
        task.resume()
    }
    
    func getAddress() {
        var input = GInput()
        let destination = GLocation.init(latitude: Double(SessionManager.getLat() ?? "") ?? 0.0, longitude:  Double(SessionManager.getLng()) ?? 0.0)
        input.destinationCoordinate = destination
        GoogleApi.shared.callApi(.reverseGeo , input: input) { (response) in
            if let places = response.data as? [GApiResponse.ReverseGio], response.isValidFor(.reverseGeo) {
                DispatchQueue.main.async {
                    self.currentLocation.text = places.first?.formattedAddress ?? ""
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
}
extension ServiceDelegateRequestDetails:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
            // Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: self.bookingID)
    }
}
extension ServiceDelegateRequestDetails:PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        self.payNow()
    }
    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        if isSuccess {
            self.paymentCompletedAPI()
        }
    }
}

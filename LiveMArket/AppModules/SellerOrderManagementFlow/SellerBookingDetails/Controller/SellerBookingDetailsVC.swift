//
//  BookingDetailsVC.swift
//  LiveMArket
//
//  Created by Zain on 17/01/2023.
//

import UIKit
import FloatRatingView
import Cosmos
import Stripe
import FittedSheets
import NVActivityIndicatorView
import FirebaseDatabase
import goSellSDK

class SellerBookingDetailsVC: BaseViewController {
    
    

    @IBOutlet weak var driverCallButton: UIButton!
    @IBOutlet weak var pScrollView: UIScrollView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var chatWithDelegateButton: UIButton!
    @IBOutlet weak var chatWithDelegateView: UIView!
    @IBOutlet weak var taxView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountChargeLabel: UILabel!
    @IBOutlet weak var payType: UILabel!
    
    
    @IBOutlet weak var lblAddressLbl: UILabel!
    @IBOutlet weak var profileHeadingLabel: UILabel!
    @IBOutlet weak var StoreDeliveryOtpView: UIStackView!
    @IBOutlet weak var userOtpTxt1: UITextField!
    @IBOutlet weak var userOtpTxt2: UITextField!
    @IBOutlet weak var userOtpTxt3: UITextField!
    @IBOutlet weak var trackOrderView: UIView!
    
    @IBOutlet weak var driverDetailsView: UIStackView!
    @IBOutlet weak var reviewButton: UIButton!
    var paymentSheet: PaymentSheet?
    var secretkey = ""
    var transID = ""
    var isFromThankYouPage:Bool = false
    var myTimer = Timer()
    deinit {
        myTimer.invalidate()
    }
    var payment : StripePayment? {
        didSet {
            self.secretkey = payment?.ref_id ?? ""
            self.transID = payment?.invoice_id ?? ""
            self.launchStripePaymentSheet()
        }
    }
    var isFromNotification:Bool = false
    
    @IBOutlet weak var otpTxt1: UITextField!
    @IBOutlet weak var otpTxt2: UITextField!
    @IBOutlet weak var otpTxt3: UITextField!
    
    @IBOutlet weak var readyForCollectionView: UIView!
    @IBOutlet weak var orderCancelView: UIView!
    @IBOutlet weak var rejectAcceptButtonView: UIView!
    @IBOutlet weak var giveRatingLabel: UILabel!

    @IBOutlet weak var rejectAcceptButtonStackView: UIStackView!
    @IBOutlet weak var orderCancelButtonStackView: UIStackView!
    @IBOutlet weak var readyForCollectionButtnStackView: UIStackView!

    @IBOutlet weak var statusBgView: UIView!
    @IBOutlet weak var indicatorBgView: UIImageView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
    ///Driver
    @IBOutlet weak var rateingView: CosmosView!
    @IBOutlet weak var reviewStackView: UIStackView!
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var driverProfileImageView: UIImageView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverVehicleImageView: UIImageView!
    @IBOutlet weak var driverPhoneLabel: UILabel!
    
    ///Map View
    @IBOutlet weak var addressImg: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    //Billing Details
    @IBOutlet weak var totalItemCountLabel: UILabel!
    @IBOutlet weak var totalItemPriceLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    
    //Delegate
    @IBOutlet weak var delegateIconImageView: UIImageView!
    @IBOutlet weak var delegateVehicleLabel: UILabel!
    
    @IBOutlet weak var imageBgView: UIView!
   
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeIconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var tbl: IntrinsicallySizedTableView!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    
    @IBOutlet weak var paymentTypeView: UIView!
    @IBOutlet weak var paymentMethodsView: UIView!
    @IBOutlet weak var deliveryDetailView: UIStackView!
    
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var rejectView: UIView!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    
    @IBOutlet weak var verificationView: UIStackView!
    @IBOutlet weak var profileView: UIStackView!
    @IBOutlet weak var lblchatCount: UILabel!
    
    var assignValue = ""
    var VCtype :String?
    var order_ID:String = ""
    var productList:[Products] = []
    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var paymentService:PaymentViaTapPayService!
    var isFromSeller:Bool = false
    var isClickWillDoLater:Bool = false
    var orderID:String = ""
    var isOrderDeliverd:Bool = false
    var apiCallOnce:Bool = true
    var isFromChatDelegate:Bool = false
    var chatRoomId: String = ""
    var fireBaseKey: String = ""
    let refNotifications = Database.database().reference().child("Nottifications")
    var observceFirebaseValue = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        pScrollView.isHidden = true
        type = .backWithTop
        viewControllerTitle = ""
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        setData()
        setPayCollectionCell()
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        orderIDLabel.isUserInteractionEnabled = true
        orderIDLabel.addGestureRecognizer(longPressGesture)


    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            guard let textToCopy = orderIDLabel.text else {
                return
            }
            UIPasteboard.general.string = textToCopy
            Utilities.showSuccessAlert(message: "Invoice no. copied".localiz())
        }
    }
    
    func observiceFirebaseValuesForOrderStatus(){
        
        print(self.order_ID)
        if let userId = SessionManager.getUserData()?.firebase_user_key{
            
            
            refNotifications.child(userId).observe(.value) { snapshot in
                guard snapshot.exists(), let notifications = snapshot.children.allObjects as? [DataSnapshot] else
                {
                    return
                }
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
                for n in tempNotifications
                {
                    if let invoiceId = n.invoiceId
                    {
                        if invoiceId == self.order_ID
                        {
                            orderNotifications.append(n)
                        }
                    }
                    if let orderId = n.orderId
                    {
                        if orderId == self.order_ID
                        {
                            orderNotifications.append(n)
                        }
                    }
                }
                
                var shouldShowPopup = false
                if orderNotifications.count > 0
                {
                    for n in orderNotifications
                    {
                        
                        let notificationType = n.notificationType
                        if notificationType == "store_order_delivered" || notificationType == "store_order_dispatched" || notificationType == "order_dispatched" || notificationType == "order_delivered"
                        {
                            if let showPopup = n.showPopup{
                                if showPopup == "0"
                                {
                                    shouldShowPopup = true
                                }
                            }
                            else{
                                shouldShowPopup = true
                            }
                            if let key = n.key
                            {
                                self.observceFirebaseValue = false
                                self.refNotifications.child(userId).child(key).child("showPopup").setValue("1")
                                self.refNotifications.child(userId).removeAllObservers()
                                break
                            }
                        }
                    }
                    if shouldShowPopup{
                        self.isFromNotification = true
                    }
                    
                    if self.isFromSeller
                    {
                        self.receivedOrdesDetailsAPI()
                    }
                    else
                    {
                        if self.apiCallOnce
                        {
                            self.apiCallOnce = false
                            self.myOrdesDetailsAPI()
                        }
                    }
                   
                }
            }
        }
    }
    
    func pushDirectlyToChatController() {
        goToChatDetailsScreen()
    }

    @objc func setupNotificationObserver()
    {
        isFromNotification = true
        if isFromSeller{
            self.receivedOrdesDetailsAPI()
        }else{
            if apiCallOnce{
                apiCallOnce = false
                self.myOrdesDetailsAPI()
            }
            
        }
        
        self.setGradientBackground()
        self.otpTextFieldSetup()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    
    @objc func chatBadgeUpdate(_ notification: Notification) {
       
        self.updateChatBadge()
    }
    
    func updateChatBadge(){
        self.lblchatCount.isHidden = true
        if chatWithDelegateView.isHidden == false {
            Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""] = (Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""] ?? 0) + 1
            if Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""]! > 0 {
                self.lblchatCount.isHidden = false
                self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""]!)"
            }else {
                self.lblchatCount.isHidden = true
            }
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
        
    }
    var balanceAmount: WalletHistoryData? {
        didSet {
            
        }
    }
    
    var commonReviewData:ReviewData?{
        didSet{
            pScrollView.isHidden = false
            floatRatingView.rating = Double(commonReviewData?.rating ?? "0") ?? 0.0
        }
    }

    var myOrderData:MyOrderDetailsData?{
        didSet{
            pScrollView.isHidden = false
            self.trackOrderView.isHidden = true
            print(myOrderData?.address ?? "")
            viewControllerTitle = myOrderData?.invoice_id ?? ""
            orderIDLabel.text = myOrderData?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myOrderData?.booking_date ?? "")
            productCountLabel.text = ("\(myOrderData?.total_qty ?? "") Products")
            amountLabel.text = (myOrderData?.currency_code ?? "") + " " + (myOrderData?.grand_total ?? "")
            statusLbl.text = myOrderData?.status_text ?? ""
            self.productList = myOrderData?.products ?? []
            self.tbl.reloadData()
            self.addressPrime = myOrderData?.address
            self.driverDetails = myOrderData?.driver
            self.deliveryDateLabel.text = self.formatDate(date: myOrderData?.delivery_date ?? "")
            
            if myOrderData?.payment_mode == "1" {
                self.payType.text = "CARD".localiz()
            }else if myOrderData?.payment_mode == "3" {
                self.payType.text = "WALLET".localiz()
            }else {
                self.payType.text = ""
            }
            
            if isFromSeller {
                storeIconImageView.sd_setImage(with: URL(string: myOrderData?.customer?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                storeNameLabel.text = myOrderData?.customer?.name ?? ""
                
            }else{
                storeIconImageView.sd_setImage(with: URL(string: myOrderData?.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                storeNameLabel.text = myOrderData?.store?.name ?? ""
            }
            
            ///OTP handler
            let array = Array(myOrderData?.order_otp ?? "")
            if array.count>0{
                userOtpTxt1.text = "\(array[0])"
                userOtpTxt2.text = "\(array[1])"
                userOtpTxt3.text = "\(array[2])"
            }
            
            self.lblAddressLbl.text = "Delivery address".localiz()
            if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up" {
                delegateIconImageView.isHidden = true
                delegateVehicleLabel.text = myOrderData?.deligate?.deligate_name ?? ""
                
                if !isFromSeller {
                    self.lblAddressLbl.text = "Store address".localiz()
                    self.addressLabel.text = "\(myOrderData?.store?.location_data?.location_name ?? "")"
                    
                    let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(myOrderData?.store?.location_data?.lattitude ?? ""),\(myOrderData?.store?.location_data?.longitude ?? "")&\("zoom=15&size=\(510)x310")&sensor=true&key=\(Config.googleApiKey)"
                    
                    print(staticMapUrl)
                    
                
                    let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    loadMapFromURL(url!,completion: { self.addressImg.image = $0 })
                }
                
            }else{
                ///Delegation Type
                delegateIconImageView.isHidden = false
                delegateIconImageView.sd_setImage(with: URL(string: myOrderData?.deligate?.deligate_icon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                
                if let driverID = driverDetails?.id{
                    chatWithDelegateView.isHidden = true
                    if driverID == "0"{
                        delegateVehicleLabel.text = "Request a delegate".localiz()
                    }else{
                        delegateVehicleLabel.text = myOrderData?.deligate?.deligate_name ?? ""
                    }
                }
            }
            
            ///Billing Details
            totalItemCountLabel.text = ("\("Item total".localiz()) x\(myOrderData?.total_qty ?? "")")
            totalItemPriceLabel.text = (myOrderData?.total ?? "") + " " + (myOrderData?.currency_code ?? "")
            deliveryChargeLabel.text = (myOrderData?.shipping_charge ?? "") + " " + (myOrderData?.currency_code ?? "")
            discountChargeLabel.text = (myOrderData?.discount ?? "") + " " + (myOrderData?.currency_code ?? "")
            taxLabel.text = (myOrderData?.vat ?? "") + " " + (myOrderData?.currency_code ?? "")
            grandTotalLabel.text = (myOrderData?.grand_total ?? "") + " " + (myOrderData?.currency_code ?? "")
            
            if myOrderData?.shipping_charge ?? "" == "0" || myOrderData?.shipping_charge ?? "" == "0.00"{
                deliveryView.isHidden = true
            }else{
                deliveryView.isHidden = false
            }
            
            if myOrderData?.discount ?? "" == "0" || myOrderData?.discount ?? "" == "0.00"{
                discountView.isHidden = true
            }else{
                discountView.isHidden = false
            }
            if myOrderData?.vat ?? "" == "0" || myOrderData?.vat ?? "" == "0.00"{
                taxView.isHidden = true
            }else{
                taxView.isHidden = false
            }
            
            if myOrderData?.request_deligate != "2" {
                if  myOrderData?.status == "4" && isFromSeller {
                    self.trackOrderView.isHidden = true
                }else if myOrderData?.status == "5" && !isFromSeller{
                    self.trackOrderView.isHidden = false
                } else {
                    self.trackOrderView.isHidden = true
                }
            }
            ///order_status_pending = 0
            ///order_status_accepted = 1
            ///order_payment_completed = 2
            ///order_status_ready_for_delivery = 3
            ///order_status_driver_accepted = 4
            ///order_status_dispatched = 5
            ///order_status_delivered = 6
            ///order_status_cancelled = 10
            ///order_status_returned = 11
            ///order_status_rejected = 12
            
            self.rejectAcceptButtonView.isHidden = true
            self.rejectAcceptButtonStackView.isHidden = true
            self.paymentTypeView.isHidden        = true
            self.profileView.isHidden            = true
            self.verificationView.isHidden       = true
            self.readyForCollectionView.isHidden = true
            self.readyForCollectionButtnStackView.isHidden = true
            self.deliveryDetailView.isHidden     = true
            self.reviewStackView.isHidden        = true
            self.paymentMethodsView.isHidden     = true
            self.orderCancelView.isHidden        = true
            self.orderCancelButtonStackView.isHidden = true
            self.reviewButton.isHidden           = true
            self.driverDetailsView.isHidden      = true
            self.StoreDeliveryOtpView.isHidden   = true
            self.profileHeadingLabel.isHidden    = true
            self.chatWithDelegateView.isHidden   = true
            
            if isFromSeller{
                self.chatWithDelegateButton.setTitle("  Chat with Customer".localiz(), for: .normal)

                if myOrderData?.status == "0"{
                    self.rejectAcceptButtonView.isHidden = false
                    self.rejectAcceptButtonStackView.isHidden = false
                    statusColorCode(color: Color.StatusYellow.color())
                }else if myOrderData?.status == "1"{
                    statusColorCode(color: Color.StatusRed.color())
                }
                else if myOrderData?.status == "2" {
                  //  self.readyForCollectionView.isHidden = false
                  //  self.readyForCollectionButtnStackView.isHidden = false
                    self.paymentTypeView.isHidden        = false
                    statusColorCode(color: Color.StatusRed.color())
                }else if myOrderData?.status == "3"{
                    if myOrderData?.request_deligate == "2"{
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.StoreDeliveryOtpView.isHidden   = false
                                      }
                    self.paymentTypeView.isHidden = false
                    statusColorCode(color: Color.StatusRed.color())
                }
                else if myOrderData?.status == "4"{
                    self.profileHeadingLabel.isHidden    = true
                    self.paymentTypeView.isHidden = false
                    self.profileView.isHidden = false
                    self.verificationView.isHidden = false
                    self.driverDetailsView.isHidden  = false
                    //self.customer = myOrderData?.customer
                    statusColorCode(color: Color.StatusBlue.color())
                    
                    if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                        self.chatWithDelegateView.isHidden   = true

                    }
                    else{
                        self.chatWithDelegateView.isHidden   = true
                    }
                } else if myOrderData?.status == "5"{
                    self.paymentTypeView.isHidden    = false
                    //self.chatWithDelegateView.isHidden = false
                    statusColorCode(color: Color.StatusBlue.color())
                    self.deliveryDetailView.isHidden = false
                    self.profileView.isHidden = false
                    statusColorCode(color: Color.StatusBlue.color(),indicatiorHide: true)
                    
                    if myOrderData?.request_deligate != "2"
                    {
                        if isFromNotification
                        {
                            isFromNotification = false
                            self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Order delivered successfully".localiz(), confirmMessage: "", invoiceID: myOrderData?.invoice_id ?? "", viewcontroller: self)
                        }
                    }
                }else if myOrderData?.status == "6" {
                    driverCallButton.isHidden = true
                    if myOrderData?.request_deligate == "2"{
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.deliveryDetailView.isHidden = false
                    }else{
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.deliveryDetailView.isHidden = false
                        self.reviewStackView.isHidden    = false
                    }
                    self.reviewButton.isHidden       = true
                    self.isOrderDeliverd = true
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    if isFromNotification{
                        isFromNotification = false
                        self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Order delivered successfully".localiz(), confirmMessage: "", invoiceID: myOrderData?.invoice_id ?? "", viewcontroller: self)
                    }
                    
                }
                else if myOrderData?.status == "10" || myOrderData?.status == "11" || myOrderData?.status == "12" {
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                }
            } else {
                if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                    self.chatWithDelegateView.isHidden   = true //9/03/24
                    self.chatWithDelegateButton.setTitle("  Chat with Store".localiz(), for: .normal)
                }else{
                    self.chatWithDelegateButton.setTitle("  Chat with Driver".localiz(), for: .normal)
                }
                
                self.chatWithDelegateView.isHidden   = true //9/03/24
                
                if myOrderData?.status == "0"{
                    //self.orderCancelView.isHidden = false
                 //   self.orderCancelButtonStackView.isHidden = false
                    statusColorCode(color: Color.StatusYellow.color())
                    
                }else if myOrderData?.status == "1"{
                    self.paymentMethodsView.isHidden = false
                    statusColorCode(color: Color.StatusRed.color())
                }
                else if myOrderData?.status == "2"{
                    self.paymentTypeView.isHidden = false
                    statusColorCode(color: Color.StatusRed.color())
                }
                else if myOrderData?.status == "3"{
                    statusColorCode(color: Color.StatusRed.color())
                    self.paymentTypeView.isHidden = false
                    if myOrderData?.request_deligate == "2"{
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.verificationView.isHidden   = false
                        if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                            self.chatWithDelegateView.isHidden   = true

                        }
                        else{
                            self.chatWithDelegateView.isHidden   = true
                        }
                    }
                }
                else if myOrderData?.status == "4"{
                    self.profileHeadingLabel.isHidden    = false
                    self.paymentTypeView.isHidden = false
                    self.profileView.isHidden = false
                    self.driverDetailsView.isHidden = false
                    statusColorCode(color: Color.StatusBlue.color())
                    if myOrderData?.request_deligate != "2" {
                        self.reviewStackView.isHidden    = false
                        self.reviewButton.isHidden       = false
                        giveRatingLabel.isHidden = true
                        commonReviewAPI()
                    }
                } else if myOrderData?.status == "5" {
                    self.profileView.isHidden = false
                    self.deliveryDetailView.isHidden = true
                    self.profileHeadingLabel.isHidden    = false
                    self.paymentTypeView.isHidden    = false
                    self.profileView.isHidden        = false
                    self.verificationView.isHidden   = false
                    self.chatWithDelegateView.isHidden = false
                    statusColorCode(color: Color.StatusBlue.color())
                    statusColorCode(color: Color.StatusBlue.color(),indicatiorHide: true)

                    if myOrderData?.request_deligate != "2" {
                        self.driverDetailsView.isHidden = false
                        self.reviewStackView.isHidden    = false
                        self.reviewButton.isHidden       = false
                        giveRatingLabel.isHidden = true
                        commonReviewAPI()
                    }
                }
                else if myOrderData?.status == "6" {
                    driverCallButton.isHidden = true
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    giveRatingLabel.isHidden = false
                    if myOrderData?.request_deligate == "2"{
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        if self.myOrderData?.driver_review != ""
                        {
                            myTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.navigateRateStoreViewCode), userInfo: nil, repeats: false)
                        }
                    } else{
                        self.profileHeadingLabel.isHidden = false
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.deliveryDetailView.isHidden = false
                        self.driverDetailsView.isHidden  = false
                        self.reviewStackView.isHidden    = false
                        if self.myOrderData?.driver_review != ""{
                            self.reviewButton.isHidden       = true
                        }else{
                            self.reviewButton.isHidden       = false
                        }
//                        if !isFromNotification{
//                           myTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.navigateRateViewCode), userInfo: nil, repeats: false)
//
//                        }
                    }
                    self.isOrderDeliverd = true
                    if isFromNotification{
                        isFromNotification = false
                        self.showCompletedPopup(titleMessage: "Order delivered successfully".localiz(), confirmMessage: "", invoiceID: myOrderData?.invoice_id ?? "", viewcontroller: self)
                    }
                    else
                    {
                        if self.myOrderData?.store_review == "" &&  self.myOrderData?.driver_rating != ""
                        {
                            myTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.navigateRateStoreViewCode), userInfo: nil, repeats: false)
                        }
                    }
                }
                else if myOrderData?.status == "10" || myOrderData?.status == "11" || myOrderData?.status == "12" {
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                }
            }
            
            if isFromChatDelegate {
                isFromChatDelegate = false
                //Take user to Chat Screen
                pushDirectlyToChatController()
            }

            if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                mapView.isHidden = false
                if isFromSeller {
                    mapView.isHidden = true
                }
            } else {
                mapView.isHidden = true
            }

            ///preparing and onthway=5A93FF
            ///delivrd - 02B24E
        }
    }
    
    /// Status Color change
    /// - Parameters:
    ///   - color: UIColor
    ///   - isHide: hide indicator and background
    func statusColorCode(color:UIColor,indicatiorHide isHide:Bool = false)  {
//        statusBgView.backgroundColor = color
//        indicatorBgView.backgroundColor  = color
        statusLbl.textColor = color
        if isHide{
            indicator.isHidden       = true
            //indicatorBgView.isHidden = true
        }else{
            //indicatorBgView.isHidden = false
            indicator.isHidden       = false
        }
    }
    @IBAction func driverCallButtonAction(_ sender: UIButton) {
        var phoneNumer =  "+\((myOrderData?.driver?.dial_code ?? "").replacingOccurrences(of: "+", with: ""))\(myOrderData?.driver?.phone ?? "")"

        let url = URL(string: "TEL://\(phoneNumer)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    var addressPrime : Address? {
        didSet {
            self.addressLabel.text = "\(addressPrime?.building_name ?? ""), \(addressPrime?.flat_no ?? ""), \(addressPrime?.address ?? "")"
            
            let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(addressPrime?.latitude ?? ""),\(addressPrime?.longitude ?? "")&\("zoom=15&size=\(510)x310")&sensor=true&key=\(Config.googleApiKey)"
            
            print(staticMapUrl)
            
            let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            loadMapFromURL(url!,completion: { self.addressImg.image = $0 })
        }
    }
    
    var driverDetails:Driver?{
        didSet{
            pScrollView.isHidden = false
            driverNameLabel.text = myOrderData?.driver?.name ?? ""
            driverPhoneLabel.text = myOrderData?.driver?.phone ?? ""
            driverProfileImageView.sd_setImage(with: URL(string: myOrderData?.driver?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            driverVehicleImageView.sd_setImage(with: URL(string: myOrderData?.deligate?.deligate_icon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            
            floatRatingView.rating = Double(myOrderData?.driver_rating ?? "0") ?? 0
        }
    }
    
    var customer:Customer?{
        didSet{
            pScrollView.isHidden = false
            driverNameLabel.text = customer?.name ?? ""
            driverPhoneLabel.text = customer?.phone ?? ""
            driverProfileImageView.sd_setImage(with: URL(string: customer?.profile_url ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            driverVehicleImageView.sd_setImage(with: URL(string: myOrderData?.deligate?.deligate_icon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            floatRatingView.rating = Double(myOrderData?.driver_rating ?? "0") ?? 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.chatBadgeUpdate(_:)), name: Notification.Name("chatDelegate"), object: nil)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        DispatchQueue.main.async {
            if self.indicator != nil {
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }
        }
        if isFromSeller{
            mapView.isHidden = true
            self.trackOrderView.isHidden = true
            self.receivedOrdesDetailsAPI()
        }else{
            //self.myOrdesDetailsAPI()
            if apiCallOnce{
                apiCallOnce = false
                self.myOrdesDetailsAPI()
            }
        }
        self.getBalance()
        self.setGradientBackground()
        self.otpTextFieldSetup()
        self.observiceFirebaseValuesForOrderStatus()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)


        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        self.myTimer.invalidate()
        
        if let userId = SessionManager.getUserData()?.firebase_user_key
        {
            self.refNotifications.child(userId).removeAllObservers()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "chatDelegate"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""] == nil {
            Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""] = 0
        }

        if Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""]! > 0 {
            self.lblchatCount.isHidden = false
            self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""]!)"
        }else {
            self.lblchatCount.isHidden = true
        }

    }
    func resetChatBadge(){
        if chatWithDelegateView.isHidden == false {
            Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""] = 0
            self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[viewControllerTitle ?? ""]!)"
        }
    }

    func commonReviewAPI() {
        if let id = myOrderData?.driver_id{
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "page":"1",
                "limit":"3",
                "store_id":id
            ]
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

    func otpTextFieldSetup(){
        if #available(iOS 12.0, *) {
            
            otpTxt1.isUserInteractionEnabled = true
            otpTxt2.isUserInteractionEnabled = true
            otpTxt3.isUserInteractionEnabled = true
            
            otpTxt1.textContentType = .oneTimeCode
            otpTxt2.textContentType = .oneTimeCode
            otpTxt3.textContentType = .oneTimeCode
            
            otpTxt1.keyboardType = .numberPad
            otpTxt2.keyboardType = .numberPad
            otpTxt3.keyboardType = .numberPad
            
        } else {
            // Fallback on earlier versions
        }
        otpTxt1.delegate = self
        otpTxt2.delegate = self
        otpTxt3.delegate = self
    }
    
    
    @IBAction func textEditDidBegin(_ sender: UITextField) {
        print("textEditDidBegin has been pressed")
        
        if !(sender.text?.isEmpty)!{
            sender.selectAll(self)
        }else{
            print("Empty")
            sender.text = ""
            
        }
        
    }
    
    @IBAction func textEditChanged(_ sender: UITextField) {
        print("textEditChanged has been pressed")
        let count = sender.text?.count
        //
        if count == 1{
            
            switch sender {
            case otpTxt1:
                otpTxt2.becomeFirstResponder()
            case otpTxt2:
                otpTxt3.becomeFirstResponder()
            case otpTxt3:
                otpTxt3.resignFirstResponder()
            default:
                print("default")
            }
        }
        
    }
    
    //MARK: - @IBActions
    override func ChatAction() {
        resetChatBadge()

        Coordinator.goToChatDetails(delegate: self,user_id: myOrderData?.store_id ?? "",user_name: myOrderData?.store?.name,userImgae: myOrderData?.store?.user_image ?? "", firebaseUserKey: myOrderData?.store?.firebase_user_key ?? "")
    }
    
    override func backButtonAction(){
        if isFromThankYouPage == true {
                // Coordinator.updateRootVCToTab()
                //Coordinator.gotoRespectiveOrdersList(fromController: self, category: "My Orders")
            let userData = SessionManager.getUserData()
            if userData?.user_type_id == "6" {
                let VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
                VC.isFromDriver = true
                VC.isPopRoot = true
                self.navigationController?.pushViewController(VC, animated: false)
            } else if userData?.user_type_id == "1" {
                let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
                if userData?.activity_type_id == "12" {
                    VC.isFromResturant = true
                }else if userData?.activity_type_id == "10" {
                    VC.isFromResturant = false
                } else {
                    VC.isFromResturant = false
                }
                VC.isPopRoot = true
                self.navigationController?.pushViewController(VC, animated: false)
            } else {
                let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
                VC.VCtype = ""
                VC.isPopRoot = true
                navigationController?.pushViewController(VC, animated: false)
                    //SellerOrderCoordinator.goToNewOrder(controller: self, status: "")
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func statusPressed(_ sender: Any) {
        if VCtype == "true"
        {
            SellerOrderCoordinator.goToNewOrder(controller: self,status: "true")
        }else if VCtype == "ready"
        {
            SellerOrderCoordinator.goToSellerBookingStatus(controller: self, status: "way")
            
        }else if VCtype == "way"
        {
            SellerOrderCoordinator.goToSellerBookingStatus(controller: self, status: "delivery")
        }else
        {
            SellerOrderCoordinator.goToSellerBookingStatus(controller: self, status: "true")
        }
        
    }
    @IBAction func openMap(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Map".localiz(), message: "", preferredStyle: .alert)

            // Add an action (button) to the alert
        let appleAction = UIAlertAction(title: "Apple Map".localiz(), style: .default) { [self] (action) in
                // Handle the "OK" button tap if needed
            if self.myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                let latt = self.myOrderData?.store?.location_data?.lattitude ?? ""
                let lngg = self.myOrderData?.store?.location_data?.longitude ?? ""
                self.openAppleMapsWithDriving(fromLat: SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
            }else {
                let latt = addressPrime?.latitude ?? ""
                let lngg = addressPrime?.longitude ?? ""
                self.openAppleMapsWithDriving(fromLat: SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
            }

        }
        alertController.addAction(appleAction)
        let googleAction = UIAlertAction(title: "Google Map".localiz(), style: .default) { [self] (action) in
            if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                let latt = myOrderData?.store?.location_data?.lattitude ?? ""
                let lngg = myOrderData?.store?.location_data?.longitude ?? ""
                self.openAppleMapsWithDriving(fromLat: SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
            }else {
                let latt = addressPrime?.latitude ?? ""
                let lngg = addressPrime?.longitude ?? ""
                self.openAppleMapsWithDriving(fromLat: SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
            }

        }
        alertController.addAction(googleAction)

            // Optionally, you can add more actions (buttons) to the alert
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { (action) in
                // Handle the "Cancel" button tap if needed
            print("Cancel tapped")
        }
        alertController.addAction(cancelAction)

            // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func Trackbtn(_ sender: Any) {
        if isFromSeller {
            Coordinator.goToTrackOrder(controller: self,trackType: "1" , Orderid: self.order_ID)
        }else {
            Coordinator.goToTrackOrder(controller: self,trackType: "2" , Orderid: self.order_ID)
        }
    }
    @IBAction func reviewPressed(_ sender: UIButton) {
        // if self.myOrderData?.driver_review == ""{
        if myOrderData?.status == "4" || myOrderData?.status == "5" {

            if let id = myOrderData?.driver_id {
                self.myTimer.invalidate()
                SellerOrderCoordinator.goToMyReviews(controller: self, store_id:id , isFromProfile: false, isFromDriver: false)
            }
        } else {
            self.myTimer.invalidate()
            let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
            VC.myOrderData = myOrderData
            VC.isFromOrder = true
            VC.isFromStore = false
            self.navigationController?.pushViewController(VC, animated: true)
                // }
        }
    }
  
    @objc func showRating(){
        
        if myOrderData?.driver?.id != "0"
        {
            self.navigateRateViewCode()
        }
        else
        {
            self.navigateRateStoreViewCode()
        }
    }

    @IBAction func payNow(_ sender: UIButton) {
        let grandTotalAmount = myOrderData?.grand_total ?? ""
        let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
        if selectedPaymentType == "1" {
            paymentService.startPaymentViaSellSDK(amount: Decimal(string:grandTotal) ?? 0.0)
        } else if selectedPaymentType == "4" {
            paymentService.startApplePaymentViaSellSDK(amount: Double(grandTotal) ?? 0.0)
        } else if selectedPaymentType == "3" {
            if ((Float(grandTotal ) ?? 0.0) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0)){
                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                self.paymentCompletedAPI()
            }
        } else {
            selectedPaymentType = "2"
            self.paymentWithCompletedAPI()
        }
    }
    
    @IBAction func rejectAction(_ sender: UIButton) {
        self.orderRejectedAPI()
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        self.orderAcceptedAPI()
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.orderCancelAPI()
    }
    
    @IBAction func chatWithDelegateAction(_ sender: UIButton) {
        goToChatDetailsScreen()
    }
    
    func goToChatDetailsScreen() {
        resetChatBadge()
        if isFromSeller{
            Coordinator.goToChatDetails(delegate: self,user_id: myOrderData?.customer?.id ?? "",user_name: myOrderData?.customer?.name ?? "",userImgae: myOrderData?.customer?.user_image ?? "",firebaseUserKey: myOrderData?.customer?.firebase_user_key ?? "",isFromDelegate: true,isDeliverd: self.isOrderDeliverd,orderID: myOrderData?.invoice_id ?? "",isSeller: true, parentController: ParentController.SellerBookingDetail.rawValue, myOrderId: self.myOrderData?.order_id ?? "")
        }else{
            if myOrderData?.request_deligate == "2"{
                Coordinator.goToChatDetails(delegate: self,user_id: myOrderData?.store?.id ?? "",user_name: myOrderData?.store?.name ?? "",userImgae: myOrderData?.store?.user_image ?? "",firebaseUserKey: myOrderData?.store?.firebase_user_key ?? "",isFromDelegate: true,isDeliverd: self.isOrderDeliverd,orderID: myOrderData?.invoice_id ?? "", isSeller: false, parentController: ParentController.SellerBookingDetail.rawValue, myOrderId: self.myOrderData?.order_id ?? "")
            }else{
                Coordinator.goToChatDetails(delegate: self,user_id: myOrderData?.driver?.id ?? "",user_name: myOrderData?.driver?.name ?? "",userImgae: myOrderData?.driver?.user_image ?? "",firebaseUserKey: myOrderData?.driver?.firebase_user_key ?? "",isFromDelegate: true,isDeliverd: self.isOrderDeliverd,orderID: myOrderData?.invoice_id ?? "", isSeller: false, parentController: ParentController.SellerBookingDetail.rawValue, myOrderId: self.myOrderData?.order_id ?? "")
            }
            
        }
    }
    
    @IBAction func readyForCollectionAction(_ sender: UIButton) {
        
        self.orderReadyForDeliveryAPI()
        
    }
    @IBAction func storeDeliveryBtnAction(_ sender: UIButton) {
        isFromNotification = true
        storeDeliverOrderAPI()
    }
    
    func setData() {
        self.tbl.delegate = self
        self.tbl.dataSource = self
        self.tbl.separatorStyle = .none
        self.tbl.register(SellerBookingProductCell.nib, forCellReuseIdentifier: SellerBookingProductCell.identifier)
        tbl.reloadData()
        self.tbl.layoutIfNeeded()
    }
    @objc func navigateRateViewCode() {
        self.myTimer.invalidate()
        if self.myOrderData?.driver_review == ""{
            let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
            VC.myOrderData = self.myOrderData
            VC.isFromOrder = true
            VC.delegate = self
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    @objc func navigateRateStoreViewCode() {
        self.myTimer.invalidate()
        if self.isClickWillDoLater == false{
            if self.myOrderData?.store_review == ""{
                let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
                VC.myOrderData = self.myOrderData
                VC.isFromOrder = false
                VC.isFromStore = true
                VC.delegate = self
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    //MARK: - Date Convertion
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale.current
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "d MMM yyyy h:mma"
        let resultString = inputFormatter.string(from: showDate ?? Date())
        print(resultString)
        return resultString
    }
    
    //MARK: - API Calls
    
    func myOrdesDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : order_ID,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        StoreAPIManager.myOrdersDetailsAPI(parameters: parameters) { result in
            DispatchQueue.main.async{
                self.apiCallOnce = true
                switch result.status {
                    case "1":
                        self.myOrderData = result.oData
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {

                        }
                }
            }
        }
    }
    
    func receivedOrdesDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : order_ID,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        StoreAPIManager.receivedOrdersDetailsAPI(parameters: parameters) { result in
            DispatchQueue.main.async{
                switch result.status {
                    case "1":
                        self.myOrderData = result.oData
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {

                        }
                }
            }
        }
    }
    
    func paymentCompletedAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : self.myOrderData?.invoice_id ?? "",
            "payment_type" : self.selectedPaymentType
        ]
        print(parameters)
        StoreAPIManager.paymentCompletedAPI(parameters: parameters) { result in
            DispatchQueue.main.async{
                switch result.status {
                    case "1":
                        self.orderID = self.myOrderData?.order_id ?? ""
                        let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                        controller.delegate = self
                    controller.heading = "Payment made successfully".localiz()
                    controller.confirmationText = "Please wait for delivery".localiz()
                        controller.invoiceNumber = self.myOrderData?.invoice_id ?? ""
                        let sheet = SheetViewController(
                            controller: controller,
                            sizes: [.fullscreen],
                            options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
                        sheet.minimumSpaceAbovePullBar = 0
                        sheet.dismissOnOverlayTap = true
                        sheet.dismissOnPull = false
                        sheet.contentBackgroundColor = UIColor.black.withAlphaComponent(0.5)
                        self.present(sheet, animated: true, completion: nil)


                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {

                        }
                }
            }
        }
    }
    
    func paymentWithCompletedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : self.myOrderData?.invoice_id ?? "",
            "address_id" : self.myOrderData?.address_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.paymentWithCompleteAPI(parameters: parameters) { result in
            DispatchQueue.main.async{
                switch result.status {
                    case "1":
                        self.payment = result.oData
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {

                        }
                }
            }
        }
    }
    
    func orderAcceptedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.ordersAcceptedAPI(parameters: parameters) { result in
            DispatchQueue.main.async{
                switch result.status {
                    case "1":
                        self.receivedOrdesDetailsAPI()
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {

                        }
                }
            }
        }
    }
    
    func orderRejectedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.ordersRejectedAPI(parameters: parameters) { result in
            DispatchQueue.main.async{
                switch result.status {
                    case "1":
                        self.receivedOrdesDetailsAPI()
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {

                        }
                }
            }
        }
    }
    func orderCancelAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.ordersCanceledAPI(parameters: parameters) { result in
            DispatchQueue.main.async{
                switch result.status {
                    case "1":
                        self.receivedOrdesDetailsAPI()
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {

                        }
                }
            }
        }
    }
    
    func orderReadyForDeliveryAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.ordersDreadyForDeliveryAPI(parameters: parameters) { result in
            DispatchQueue.main.async{
                switch result.status {
                    case "1":
                        self.receivedOrdesDetailsAPI()
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {

                        }
                }
            }
        }
    }
    
    func storeDeliverOrderAPI() {
        
        let otpString =  "\(otpTxt1.text ?? "")\(otpTxt2.text ?? "")\(otpTxt3.text ?? "")"
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? "",
            "otp":otpString
        ]
        print(parameters)
        StoreAPIManager.storeOrderDeliveryAPI(parameters: parameters) { result in
            DispatchQueue.main.async{
                switch result.status {
                    case "1":
                        self.isFromNotification = true
                        self.receivedOrdesDetailsAPI()
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {

                        }
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
        gradientLayer.frame = self.imageBgView.bounds
        gradientLayer.cornerRadius = self.imageBgView.bounds.width/2
        
        self.imageBgView.layer.insertSublayer(gradientLayer, at:0)
    }
    
}
// MARK: - TableviewDelegate
extension SellerBookingDetailsVC : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tbl.dequeueReusableCell(withIdentifier: SellerBookingProductCell.identifier, for: indexPath) as! SellerBookingProductCell
        cell.product = self.productList[indexPath.row]
        cell.currencyCode = self.myOrderData?.currency_code ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionView DataSource And Delegates
extension SellerBookingDetailsVC: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width-70
        return CGSize(width: screenWidth/2.08, height:70)
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
        
        self.selectedIndex = indexPath.row
        if self.selectedIndex == 0 {
            self.selectedPaymentType = "1"
        } else if  self.selectedIndex == 1 {
            self.selectedPaymentType = "4"
        } else if  self.selectedIndex == 2 {
            self.selectedPaymentType = "3"
        }
        self.payCollection.reloadData()
    }
}
extension SellerBookingDetailsVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = ""
        if textField.text == "" {
            print("Backspace has been pressed")
        }
        
        if string == ""
        {
            print("Backspace was pressed")
            switch textField {
            case otpTxt2:
                otpTxt1.becomeFirstResponder()
            case otpTxt3:
                otpTxt2.becomeFirstResponder()
            default:
                print("default")
            }
            textField.text = ""
            return false
        }
        
        return true
    }
}
// MARK: - Stripe Integration
extension SellerBookingDetailsVC {
    
    fileprivate func launchStripePaymentSheet() {

        Utilities.showWarningAlert(message: "Payment via wallet is only supported method right now as pay via card is under development...".localiz())
       return
        var paymentSheetConfiguration = PaymentSheet.Configuration()
        paymentSheetConfiguration.merchantDisplayName = "Live Market".localiz()
        paymentSheetConfiguration.style = .alwaysLight
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: secretkey, configuration: paymentSheetConfiguration)
        self.paymentSheet?.present(from: self) { [self] paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                self.paymentCompletedAPI()
            case .canceled:
                print("User Cancelled")
                Utilities.showWarningAlert(message: "User cancelled the payment".localiz())
                
            case .failed(_):
                print("Failed")
                Utilities.showWarningAlert(message: "Payment failed.Please try later".localiz())
            }
        }
    }
    
    
}

extension SellerBookingDetailsVC:willDoLaterProtocol{
    func updateWillDoLater() {
        self.isClickWillDoLater = true
    }
}
extension SellerBookingDetailsVC {
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
extension SellerBookingDetailsVC:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        //Coordinator.goTThankYouPage(controller: self,vcType: "paid",invoiceId: self.myOrderData?.invoice_id ?? "",order_id: self.myOrderData?.order_id ?? "", isFromFoodStore: false,title: result.message ?? "")
        
        SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: self.orderID,isSeller: false, isThankYouPage: true, assignValue: self.assignValue)
    }
}
extension SellerBookingDetailsVC:PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {

    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        
    }
}

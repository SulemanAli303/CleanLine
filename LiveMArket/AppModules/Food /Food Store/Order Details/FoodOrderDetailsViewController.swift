//
//  FoodOrderDetailsViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 09/05/23.
//

import UIKit

import FloatRatingView
import Cosmos
import Stripe
import FittedSheets
import NVActivityIndicatorView
import FirebaseDatabase
import goSellSDK
class FoodOrderDetailsViewController: BaseViewController {

    var balanceAmount: WalletHistoryData? {
        didSet {

        }
    }
    var myTimer = Timer()

    deinit {
        myTimer.invalidate()
         }

    @IBOutlet weak var giveRatingLabel: UILabel!
    @IBOutlet weak var pScrollview: UIScrollView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var chatWithDelegateButton: UIButton!
    @IBOutlet weak var chatWithDelegateView: UIView!
    
    @IBOutlet weak var lblAddressLbl: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var dicountLabel: UILabel!
    @IBOutlet weak var profileHeadingLabel: UILabel!
    @IBOutlet weak var StoreDeliveryOtpView: UIStackView!
    @IBOutlet weak var userOtpTxt1: UITextField!
    @IBOutlet weak var userOtpTxt2: UITextField!
    @IBOutlet weak var userOtpTxt3: UITextField!
    
    @IBOutlet weak var taxView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var driverDetailsView: UIStackView!
    
    
    @IBOutlet weak var reviewButton: UIButton!
    var isOrderDeliverd:Bool = false
    
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var scheduleLbl: UILabel!

    
    var paymentSheet: PaymentSheet?
    var secretkey = ""
    var transID = ""
    var payment : StripePayment? {
        didSet {
            self.secretkey = payment?.ref_id ?? ""
            self.transID = payment?.invoice_id ?? ""
            self.launchStripePaymentSheet()
        }
    }
    
    @IBOutlet weak var rejectAcceptButtonStackView: UIStackView!
    @IBOutlet weak var orderCancelButtonStackView: UIStackView!
    
    @IBOutlet weak var rejectAcceptButtonView: UIView!
    @IBOutlet weak var readyForCollectionView: UIView!
    @IBOutlet weak var readyToPrepareView: UIView!
    @IBOutlet weak var orderCancelView: UIView!
    
    @IBOutlet weak var otpTxt1: UITextField!
    @IBOutlet weak var otpTxt2: UITextField!
    @IBOutlet weak var otpTxt3: UITextField!
    
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
  //  @IBOutlet weak var delegateIconImageView: UIImageView!
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
    
    @IBOutlet weak var trackOrderView: UIView!
    @IBOutlet weak var verificationView: UIStackView!
    @IBOutlet weak var profileView: UIStackView!
    @IBOutlet weak var lblchatCount: UILabel!
    
    var isFromNotification:Bool = false
    var VCtype :String?
    var order_ID:String = ""
    var productList:[Products] = []
    //var imageArray = [UIImage(named: "visaPayment"),UIImage(named: "madaPayment"),UIImage(named: "PayPal"),UIImage(named: "ApplePayment"),UIImage(named: "Stc_Payment"),UIImage(named: "tamaraPayment")]
    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var paymentService:PaymentViaTapPayService!
    var isFromSeller:Bool = false
    var isClickWillDoLater:Bool = false
    var isFromThankYouPage:Bool = false
    var orderID:String = ""
    var apiCallOnce:Bool = true
    var assignValue = ""
    var isFromChatDelegate: Bool = false
    var chatRoomId: String = ""
    var fireBaseKey: String = ""
    let refNotifications = Database.database().reference().child("Nottifications")
    var observceFirebaseValue = true


    var commonReviewData:ReviewData?{
        didSet{
            pScrollview.isHidden = false
            floatRatingView.rating = Double(commonReviewData?.rating ?? "0") ?? 0.0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        pScrollview.isHidden = true
        type = .backWithTop
        viewControllerTitle = ""
        scheduleView.isHidden = true
        self.trackOrderView.isHidden = true
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
                        if notificationType == "food_order_delivered" || notificationType == "food_driver_order_delivered" || notificationType == "store_order_dispatched" || notificationType == "food_store_driver_dispatched"
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
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.stopAlaram()
    }
    
    @objc func chatBadgeUpdate(_ notification: Notification) {
       
        self.updateChatBadge()
    }
    
    func updateChatBadge(){
        self.lblchatCount.isHidden = true
        let chatRoom = viewControllerTitle ?? ""
        if chatWithDelegateView.isHidden == false {
            Constants.shared.chatDelegateCountID[chatRoom] =  (Constants.shared.chatDelegateCountID[chatRoom] ?? 0) + 1
            if Constants.shared.chatDelegateCountID[chatRoom]! > 0 {
                self.lblchatCount.isHidden = false
                self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[chatRoom]!)"
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
    
    var myOrderData:MyOrderDetailsData?{
        didSet{
            pScrollview.isHidden = false
            self.trackOrderView.isHidden = true
            print(myOrderData?.address ?? "")
            viewControllerTitle = myOrderData?.invoice_id ?? ""
            orderIDLabel.text = myOrderData?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myOrderData?.booking_date ?? "")
            deliveryDateLabel.text = self.formatDate(date: myOrderData?.delivery_date ?? "")
            productCountLabel.text = ("\(myOrderData?.total_qty ?? "") \("Products".localiz())")
            amountLabel.text = (myOrderData?.currency_code ?? "") + " " + (myOrderData?.grand_total ?? "")
            statusLbl.text = myOrderData?.status_text ?? ""
            self.productList = myOrderData?.products ?? []
            self.tbl.reloadData()
            self.addressPrime = myOrderData?.address
            self.driverDetails = myOrderData?.driver
            
            if let scheduled_date = myOrderData?.scheduled_date_text, scheduled_date.count > 0{
                scheduleLbl.clipsToBounds = true
                scheduleLbl.layer.cornerRadius = 10
                scheduleView.isHidden = false
                scheduleLbl.text = "    " + scheduled_date
            }
            
            if isFromSeller{
                storeIconImageView.sd_setImage(with: URL(string: myOrderData?.customer?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                storeNameLabel.text = myOrderData?.customer?.name ?? ""
            }else{
                storeIconImageView.sd_setImage(with: URL(string: myOrderData?.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                storeNameLabel.text = myOrderData?.store?.name ?? ""
            }
            
            
            ///OTP handler
            let array = Array(myOrderData?.order_otp ?? "")
            if array.count>0{
                otpTxt1.text = "\(array[0])"
                otpTxt2.text = "\(array[1])"
                otpTxt3.text = "\(array[2])"
            }
            if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                delegateVehicleLabel.text = myOrderData?.deligate?.deligate_name ?? ""
            }else{
                delegateVehicleLabel.text = "Request a delegate".localiz()
            }

            ///Billing Details
            totalItemCountLabel.text = ("\("Item total".localiz()) x\(myOrderData?.total_qty ?? "")")
            totalItemPriceLabel.text = (myOrderData?.total ?? "") + " " + (myOrderData?.currency_code ?? "")
            dicountLabel.text = (myOrderData?.discount ?? "") + " " + (myOrderData?.currency_code ?? "")
            deliveryChargeLabel.text = (myOrderData?.shipping_charge ?? "") + " " + (myOrderData?.currency_code ?? "")
            taxLabel.text = (myOrderData?.vat ?? "") + " " + (myOrderData?.currency_code ?? "")
            grandTotalLabel.text = (myOrderData?.grand_total ?? "") + " " + (myOrderData?.currency_code ?? "")
            
            if myOrderData?.shipping_charge ?? "" == "0" || myOrderData?.shipping_charge ?? "" == "0.00" {
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
            
            if myOrderData?.payment_mode == "3"{
                self.paymentTypeLabel.text = "Wallet".localiz()
            } else if myOrderData?.payment_mode == "1"{
                self.paymentTypeLabel.text = "Card".localiz()
            }else{
                self.paymentTypeLabel.text = "Cash".localiz()
            }
            
            if myOrderData?.request_deligate != "2"
            {
                if  myOrderData?.status == "4" && isFromSeller 
                {
                    self.trackOrderView.isHidden = true
                }
                else if myOrderData?.status == "5" && !isFromSeller
                {
                    self.trackOrderView.isHidden = false
                }
                else
                {
                    self.trackOrderView.isHidden = true
                }
            }
            
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
         //   self.readyForCollectionButtnStackView.isHidden = true
            self.deliveryDetailView.isHidden     = true
            self.reviewStackView.isHidden        = true
            self.paymentMethodsView.isHidden     = true
            self.orderCancelView.isHidden        = true
            self.orderCancelButtonStackView.isHidden = true
            self.verificationView.isHidden       = true
            self.reviewButton.isHidden           = true
            self.readyToPrepareView.isHidden     = true
        //    self.readyForPrepareButtnStackView.isHidden = true
            self.driverDetailsView.isHidden      = true
            self.StoreDeliveryOtpView.isHidden   = true
            self.profileHeadingLabel.isHidden    = true
            self.chatWithDelegateView.isHidden   = true
            
            self.lblAddressLbl.text = "Delivery Address".localiz()
            if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                mapView.isHidden = false
                if !isFromSeller {
                    self.lblAddressLbl.text = "Store Address".localiz()
                    //self.lblAddressLbl.text = "Store address"
                    self.addressLabel.text = "\(myOrderData?.store?.location_data?.location_name ?? "")"
                    
                    let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(myOrderData?.store?.location_data?.lattitude ?? ""),\(myOrderData?.store?.location_data?.longitude ?? "")&\("zoom=15&size=\(510)x310")&sensor=true&key=\(Config.googleApiKey)"
                    
                    print(staticMapUrl)
                    let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    loadMapFromURL(url!,completion: { self.addressImg.image = $0 })
                } else {
                    mapView.isHidden = true
                }
            } else {
                mapView.isHidden = true
            }

            if isFromSeller{
                self.chatWithDelegateButton.setTitle("  Chat with Customer".localiz(), for: .normal)
                self.chatWithDelegateView.isHidden = true
                
                if myOrderData?.status == "0"{
                    self.rejectAcceptButtonView.isHidden = false
                    self.rejectAcceptButtonStackView.isHidden = false
                    statusColorCode(color: Color.StatusYellow.color())
                }else if myOrderData?.status == "1"{
                    statusColorCode(color: Color.StatusRed.color())
                }
                else if myOrderData?.status == "2" {
               //     self.readyToPrepareView.isHidden = false
              //      self.readyForPrepareButtnStackView.isHidden = false
                    statusColorCode(color: Color.StatusRed.color())
                }else if myOrderData?.status == "3"{
                    statusColorCode(color: Color.StatusRed.color())
                    if myOrderData?.request_deligate == "2"{
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.StoreDeliveryOtpView.isHidden   = false
                    }
                } else if myOrderData?.status == "4"{
                    self.profileHeadingLabel.isHidden    = false
                    self.paymentTypeView.isHidden = false
                    self.profileView.isHidden = false
                    self.verificationView.isHidden = false
                    self.driverDetailsView.isHidden = false
                    //self.customer = myOrderData?.customer
                    statusColorCode(color: Color.StatusBlue.color())
                    if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                        self.chatWithDelegateView.isHidden   = true
                    } else{
                        self.chatWithDelegateView.isHidden   = true
                    }
                }
                else if myOrderData?.status == "5"{
                    self.paymentTypeView.isHidden    = false
                    self.driverDetailsView.isHidden      = false
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

                } else if myOrderData?.status == "6" {
                    callToDriverButton.isHidden = true
                    if myOrderData?.request_deligate == "2" {
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.deliveryDetailView.isHidden = false
                        //self.chatWithDelegateView.isHidden   = false
                    } else {
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.deliveryDetailView.isHidden = false
                        self.reviewStackView.isHidden    = false
                        //statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                        if self.myOrderData?.driver_review != ""{
                            self.reviewButton.isHidden       = true
                        }else{
                            self.reviewButton.isHidden       = false
                        }
                    }
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    self.isOrderDeliverd = true
                    if isFromNotification{
                        isFromNotification = false
                        self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Order delivered successfully", confirmMessage: "", invoiceID: myOrderData?.invoice_id ?? "", viewcontroller: self)
                    }
                }
                else if myOrderData?.status == "10" || myOrderData?.status == "11" || myOrderData?.status == "12" {
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                }
            } else {
                
                if myOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                    self.chatWithDelegateView.isHidden   = true //9/03/24
                    self.chatWithDelegateButton.setTitle("  Chat with Store".localiz(), for: .normal)
                } else {
                    self.chatWithDelegateButton.setTitle("  Chat with Driver".localiz(), for: .normal)
                    if  myOrderData?.status == "5" ||  myOrderData?.status == "6"{
                        self.chatWithDelegateView.isHidden   = false //8/03/24
                    }
                }
                
                
                if myOrderData?.status == "0"{
               //     self.orderCancelView.isHidden = false
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
                    if myOrderData?.request_deligate == "2"{
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.verificationView.isHidden   = false
                    }
                }
                else if myOrderData?.status == "4"{
                    self.profileHeadingLabel.isHidden    = false
                    self.paymentTypeView.isHidden = false
                    self.profileView.isHidden = false
                    self.driverDetailsView.isHidden      = false
                    statusColorCode(color: Color.StatusBlue.color())

                    if myOrderData?.request_deligate != "2" {
                        self.reviewStackView.isHidden    = false
                        self.reviewButton.isHidden       = false
                        giveRatingLabel.isHidden = true
                        commonReviewAPI()
                    }
                }
                else if myOrderData?.status == "5"{ //onTheWay
                    self.profileView.isHidden = false
                    self.deliveryDetailView.isHidden = true
                    self.profileHeadingLabel.isHidden    = false
                    self.paymentTypeView.isHidden    = false
                    self.profileView.isHidden        = false
                    self.verificationView.isHidden   = false
                    self.driverDetailsView.isHidden  = false
                    trackOrderView.isHidden = false
                    statusColorCode(color: Color.StatusBlue.color())
                    if myOrderData?.request_deligate != "2" {
                        self.reviewStackView.isHidden    = false
                        self.reviewButton.isHidden       = false
                        giveRatingLabel.isHidden = true
                        commonReviewAPI()
                    }
                }
                else if myOrderData?.status == "6" {

                    if myOrderData?.request_deligate == "2"{
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                    }else{
                        self.profileHeadingLabel.isHidden    = false
                        self.paymentTypeView.isHidden    = false
                        self.profileView.isHidden        = false
                        self.deliveryDetailView.isHidden = false
                        self.driverDetailsView.isHidden = false
                        self.reviewStackView.isHidden    = false
                        giveRatingLabel.isHidden = false
                      //  statusColorCode(color: Color.StatusGreen.color(), indicatiorHide: true)
                        if self.myOrderData?.driver_review != ""{
                            self.reviewButton.isHidden       = true
                        }else{
                            self.reviewButton.isHidden       = false
                        }
                      
                    }
                    statusColorCode(color: Color.StatusGreen.color(), indicatiorHide: true)
                    self.isOrderDeliverd = true
                    if isFromNotification
                    {
                        isFromNotification = false
                        self.showCompletedPopup(titleMessage: "Order delivered successfully".localiz(), confirmMessage: "", invoiceID: myOrderData?.invoice_id ?? "", viewcontroller: self)
                    }
                    else{
                            if self.myOrderData?.store_review == "" &&  self.myOrderData?.driver_rating != ""
                            {
                                myTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.navigateRateStoreViewCode), userInfo: nil, repeats: false)
                            }
                        }
                }
                else if myOrderData?.status == "10" || myOrderData?.status == "11" || myOrderData?.status == "12" {
                    self.chatWithDelegateView.isHidden   = true //8/03/24
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                }
            }
            
            if isFromChatDelegate {
                isFromChatDelegate = false
                //Take user to Chat Screen
                pushDirectlyToChatController()
            }
            paymentService.invoiceId = myOrderData?.invoice_id ?? ""
            ///preparing and onthway=5A93FF
            ///delivrd - 02B24E
            ///
            ///
        }
    }
    
    
    @objc func navigateRateViewCode() 
    {
        self.myTimer.invalidate()
        if self.isClickWillDoLater == false {
            if self.myOrderData?.driver_review == ""
            {
                let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
                VC.myOrderData = self.myOrderData
                VC.isFromOrder = true
                VC.isFromStore = false
                VC.delegate = self
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    @objc func showRating(){
      
        if myOrderData?.driver?.id != "0"
        {
            self.navigateRateViewCode()
        }
        else{
            self.navigateRateStoreViewCode()
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

    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            guard let textToCopy = orderIDLabel.text else {
                return
            }
            UIPasteboard.general.string = textToCopy
            Utilities.showSuccessAlert(message: "Invoice no. copied".localiz())
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
    @IBAction func openMap(_ sender: Any) {
            // Create an alert controller
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
                        self.openGoogleMapsDirections(fromLat:SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
                    }else {
                        let latt = addressPrime?.latitude ?? ""
                        let lngg = addressPrime?.longitude ?? ""
                        self.openGoogleMapsDirections(fromLat:SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
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
            pScrollview.isHidden = false
            driverNameLabel.text = myOrderData?.driver?.name ?? ""
            driverPhoneLabel.text = myOrderData?.driver?.phone ?? ""
            driverProfileImageView.sd_setImage(with: URL(string: myOrderData?.driver?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            driverVehicleImageView.sd_setImage(with: URL(string: myOrderData?.deligate?.deligate_icon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            
            floatRatingView.rating = Double(myOrderData?.driver_rating ?? "0") ?? 0
        }
    }
    
    var customer:Customer?{
        didSet{
            pScrollview.isHidden = false
            driverNameLabel.text = customer?.name ?? ""
            driverPhoneLabel.text = customer?.phone ?? ""
            driverProfileImageView.sd_setImage(with: URL(string: customer?.profile_url ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            driverVehicleImageView.sd_setImage(with: URL(string: myOrderData?.deligate?.deligate_icon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            floatRatingView.rating = Double(myOrderData?.driver_rating ?? "0") ?? 0
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //resetChatBadge()
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
    func resetChatBadge(){
        let chatRoom = viewControllerTitle ?? ""
        if chatWithDelegateView.isHidden == false {
            Constants.shared.chatDelegateCountID[chatRoom] = 0
            self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[chatRoom]!)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myTimer.invalidate()
        self.observiceFirebaseValuesForOrderStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "chatDelegate"), object: nil)
        
    }
    func otpTextFieldSetup(){
        if #available(iOS 12.0, *) {
            
            userOtpTxt1.isUserInteractionEnabled = true
            userOtpTxt2.isUserInteractionEnabled = true
            userOtpTxt3.isUserInteractionEnabled = true
            
            userOtpTxt1.textContentType = .oneTimeCode
            userOtpTxt2.textContentType = .oneTimeCode
            userOtpTxt3.textContentType = .oneTimeCode
            
            userOtpTxt1.keyboardType = .numberPad
            userOtpTxt2.keyboardType = .numberPad
            userOtpTxt3.keyboardType = .numberPad
            
        } else {
            // Fallback on earlier versions
        }
        userOtpTxt1.delegate = self
        userOtpTxt2.delegate = self
        userOtpTxt3.delegate = self
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
            case userOtpTxt1:
                userOtpTxt2.becomeFirstResponder()
            case userOtpTxt2:
                userOtpTxt3.becomeFirstResponder()
            case userOtpTxt3:
                userOtpTxt3.resignFirstResponder()
            default:
                print("default")
            }
        }
        
    }
    
    //MARK: - @IBAction
    
    override func ChatAction() {
        resetChatBadge()
        Coordinator.goToChatDetails(delegate: self,user_id: myOrderData?.store_id ?? "",user_name: myOrderData?.store?.name,userImgae: myOrderData?.store?.user_image ?? "", firebaseUserKey: myOrderData?.store?.firebase_user_key ?? "")
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
    


    @IBAction func calltoDriverAction(_ sender: UIButton) {
        var phoneNumer = ""
       if  myOrderData?.request_deligate != "2" {
           phoneNumer =  "+\((myOrderData?.driver?.dial_code ?? "").replacingOccurrences(of: "+", with: ""))\(myOrderData?.driver?.phone ?? "")"
       } else {
           phoneNumer = "+\(( customer?.dial_code ?? "").replacingOccurrences(of: "+", with: ""))\(customer?.phone ?? "")"
       }
        let url = URL(string: "TEL://\(phoneNumer)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)

    }
    @IBOutlet weak var callToDriverButton: UIButton!

    override func backButtonAction(){
        if isFromThankYouPage == true {
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "My Orders")
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func reviewPressed(_ sender: UIButton) {
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
        }
    }
    @IBAction func payNow(_ sender: UIButton) {
        //paymentCompletedAPI()
        paymentService.invoiceId = self.myOrderData?.invoice_id ?? ""
        if selectedIndex == 0 {
            selectedPaymentType = "1"
            let grandTotalAmount = self.myOrderData?.grand_total ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            paymentService.startPaymentViaSellSDK(amount: Decimal.init(string: grandTotal) ?? 0.0)
                // self.payNow()
        } else if selectedIndex == 1 {
            selectedPaymentType = "4"
            let grandTotalAmount = self.myOrderData?.grand_total ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            paymentService.startApplePaymentViaSellSDK(amount: Double(grandTotal) ?? 0.0)
        } else if selectedIndex == 2 {
            selectedPaymentType = "3"
            let grandTotalAmount = myOrderData?.grand_total ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            
            if ((Float(grandTotal) ?? 0.0) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0)){
                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    Coordinator.gotoRecharge(controller: self)
                }
            }else {
                self.paymentCompletedAPI()
            }
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
    @IBAction func readyForCollectionAction(_ sender: UIButton) {
        self.orderReadyForDeliveryAPI()
    }
    @IBAction func startToPrepareAction(_ sender: UIButton) {
        self.orderStartToPrepareAPI()
    }
    @IBAction func storeOrderDeliveredAction(_ sender: UIButton) {
        storeDeliverOrderAPI()
    }
    
    @IBAction func chatWithDelegateAction(_ sender: UIButton) {
        goToChatDetailsScreen()
    }
    
    func goToChatDetailsScreen() {
        resetChatBadge()

        if isFromSeller {
            Coordinator.goToChatDetails(delegate: self,user_id: myOrderData?.customer?.id ?? "",user_name: myOrderData?.customer?.name ?? "",userImgae: myOrderData?.customer?.user_image ?? "",firebaseUserKey: myOrderData?.customer?.firebase_user_key ?? "",isFromDelegate: true,isDeliverd: self.isOrderDeliverd,orderID: myOrderData?.invoice_id ?? "", isSeller: true,
                                        parentController: ParentController.FoodOrderDetail.rawValue,
                                        myOrderId: myOrderData?.invoice_id ?? "")
        }else{
            if myOrderData?.request_deligate == "2"{
                Coordinator.goToChatDetails(delegate: self,user_id: myOrderData?.store?.id ?? "",user_name: myOrderData?.store?.name ?? "",userImgae: myOrderData?.store?.user_image ?? "",firebaseUserKey: myOrderData?.store?.firebase_user_key ?? "",isFromDelegate: true,isDeliverd: self.isOrderDeliverd,orderID: myOrderData?.invoice_id ?? "",isSeller: false, parentController: ParentController.FoodOrderDetail.rawValue,myOrderId: myOrderData?.order_id ?? "")
            } else {
                Coordinator.goToChatDetails(delegate: self,user_id: myOrderData?.driver?.id ?? "",user_name: myOrderData?.driver?.name ?? "",userImgae: myOrderData?.driver?.user_image ?? "",firebaseUserKey: myOrderData?.driver?.firebase_user_key ?? "",isFromDelegate: true,isDeliverd: self.isOrderDeliverd,orderID: myOrderData?.invoice_id ?? "", isSeller: false, parentController: ParentController.FoodOrderDetail.rawValue,myOrderId: myOrderData?.order_id ?? "")
            }

        }
    }
    
    func setData() {
        self.tbl.delegate = self
        self.tbl.dataSource = self
        self.tbl.separatorStyle = .none
        self.tbl.register(FoodItemsCartTableViewCell.nib, forCellReuseIdentifier: FoodItemsCartTableViewCell.identifier)
        tbl.reloadData()
        self.tbl.layoutIfNeeded()
    }
    
    //MARK: - Date Convertion
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
            "invoice_id" : order_ID,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        FoodAPIManager.myOrdersDetailsAPI(parameters: parameters) { result in
            self.apiCallOnce = true
            DispatchQueue.main.async {
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
        FoodAPIManager.receivedOrdersDetailsAPI(parameters: parameters) { result in
            DispatchQueue.main.async {
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
//        let parameters:[String:String] = [
//            "access_token" : SessionManager.getAccessToken() ?? "",
//            "invoice_id" : self.myOrderData?.invoice_id ?? "",
//            "payment_type" : self.selectedPaymentType
//        ]
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : self.myOrderData?.invoice_id ?? "",
            "status" : "success",
            "payment_type" : self.selectedPaymentType
        ]
        print(parameters)
        StoreAPIManager.foodPaymentCompletedAPI(parameters: parameters) { result in
            DispatchQueue.main.async {
                switch result.status {
                    case "1":
                            //                Coordinator.goTThankYouPage(controller: self,vcType: "paid",invoiceId: self.myOrderData?.invoice_id ?? "",order_id: self.myOrderData?.order_id ?? "",isFromFoodStore: true)

                        self.orderID = self.myOrderData?.invoice_id ?? ""

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
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : self.myOrderData?.invoice_id ?? "",
            "address_id" : self.myOrderData?.address_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.paymentWithCompleteAPI(parameters: parameters) { result in
            DispatchQueue.main.async {
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
            "invoice_id" : myOrderData?.invoice_id ?? ""
        ]
        print(parameters)
        FoodAPIManager.ordersAcceptedAPI(parameters: parameters) { result in
            DispatchQueue.main.async {
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
            "invoice_id" : myOrderData?.invoice_id ?? ""
        ]
        print(parameters)
        FoodAPIManager.ordersRejectedAPI(parameters: parameters) { result in
            DispatchQueue.main.async {
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
            "invoice_id" : myOrderData?.invoice_id ?? ""
        ]
        print(parameters)
        FoodAPIManager.ordersCanceledAPI(parameters: parameters) { result in
            DispatchQueue.main.async {
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
            "invoice_id" : myOrderData?.invoice_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.ordersDreadyForDeliveryAPI(parameters: parameters) { result in
            DispatchQueue.main.async {
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
    
    func orderStartToPrepareAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : myOrderData?.invoice_id ?? ""
        ]
        print(parameters)
        FoodAPIManager.ordersPreparedAPI(parameters: parameters) { result in
            DispatchQueue.main.async {
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
        
        let otpString =  "\(userOtpTxt1.text ?? "")\(userOtpTxt2.text ?? "")\(userOtpTxt3.text ?? "")"
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? "",
            "otp":otpString
        ]
        print(parameters)
        FoodAPIManager.foodStoreOrderDeliveryAPI(parameters: parameters) { result in
            DispatchQueue.main.async {
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
    
    @IBAction func trackingPressed(_ sender: Any) {
        if isFromSeller {
            Coordinator.goToTrackOrder(controller: self,trackType: "1" , Orderid: self.myOrderData?.order_id)
        }else {
            Coordinator.goToTrackOrder(controller: self,trackType: "2" , Orderid: self.myOrderData?.order_id)
        }
    }
}
// MARK: - TableviewDelegate
extension FoodOrderDetailsViewController : UITableViewDelegate ,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tbl.dequeueReusableCell(withIdentifier: FoodItemsCartTableViewCell.identifier) as! FoodItemsCartTableViewCell
        cell.cellType = .orderDetail
        cell.orderDetail = self.productList[indexPath.row]
        cell.setdate()
        cell.baseVc = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let addOnsListCount = self.productList[indexPath.row].product_combo.count
        let headerHeight = addOnsListCount == 0 ? 0 : 30
        return CGFloat(120 + headerHeight + (addOnsListCount * 35))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionView DataSource And Delegates
extension FoodOrderDetailsViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
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
        self.payCollection.reloadData()
    }
}
extension FoodOrderDetailsViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = ""
        if textField.text == "" {
            print("Backspace has been pressed")
        }
        
        if string == ""
        {
            print("Backspace was pressed")
            switch textField {
            case userOtpTxt2:
                userOtpTxt1.becomeFirstResponder()
            case userOtpTxt3:
                userOtpTxt2.becomeFirstResponder()
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
extension FoodOrderDetailsViewController {
    
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

extension FoodOrderDetailsViewController:willDoLaterProtocol{
    func updateWillDoLater() {
        self.isClickWillDoLater = true
    }
}

extension FoodOrderDetailsViewController {
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
extension FoodOrderDetailsViewController:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        //SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: orderID, isSeller: false,isThankYouPage: true,assignValue: self.assignValue)
    }
}

extension FoodOrderDetailsViewController: PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {

    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        
    }
}

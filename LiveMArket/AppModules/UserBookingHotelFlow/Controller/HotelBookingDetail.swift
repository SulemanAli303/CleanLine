//
//  ServiceRequestDetails.swift
//  LiveMArket
//
//  Created by Zain on 28/01/2023.
//

import UIKit
import FloatRatingView
import SDWebImage
import DPOTPView
import Stripe
import FittedSheets
import NVActivityIndicatorView
import FirebaseDatabase
import goSellSDK

class HotelBookingDetail : BaseViewController {
    
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var aminitiesView: UIView!
    @IBOutlet weak var facilityCollectionView: UICollectionView!
    
    @IBOutlet weak var sellerOTPView: DPOTPView!
    @IBOutlet weak var verificationCodeSellerView: UIStackView!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var paymentTypeTextLabel: UILabel!
    @IBOutlet weak var paymentTypeImageView: UIImageView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!

    
    @IBOutlet weak var groundImageView: UIImageView!
    @IBOutlet weak var groundContactLabel: UILabel!
    @IBOutlet weak var groundNameLabel: UILabel!
    
    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var deliveryDetailsView: UIStackView!
    @IBOutlet weak var verificationCodeView: UIStackView!
    
    
    @IBOutlet weak var deliveryDateLabel: UILabel!
    
    @IBOutlet weak var bookingSubHeadingLabel: UILabel!
    
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minitLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    
    
    @IBOutlet weak var orderCancelStackView: UIStackView!
    @IBOutlet weak var rejectAcceptButtonStackView: UIStackView!
    @IBOutlet weak var orderCancelView: UIView!
    @IBOutlet weak var rejectAcceptButtonView: UIView!
    @IBOutlet weak var bookingConfirmtButtonView: UIView!
    
    @IBOutlet weak var adultsCountLabel: UILabel!
    @IBOutlet weak var roomCountLabel: UILabel!
    @IBOutlet weak var childAboveCountLabel: UILabel!
    @IBOutlet weak var childBelowCountLabel: UILabel!
    
    @IBOutlet weak var bookingAmountLabel: UILabel!
    @IBOutlet weak var roomNamelabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var invoiceLabel: UILabel!
    @IBOutlet weak var timedateLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var couponDiscountLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    
    @IBOutlet weak var scheduleSlotLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    
    @IBOutlet weak var statusBgView: UIView!
    @IBOutlet weak var indicatorBgView: UIImageView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
    
    @IBOutlet var floatRatingView: FloatRatingView!
  //  @IBOutlet var tbl: IntrinsicallySizedTableView!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    
    @IBOutlet weak var paymentTypeView: UIView!
    @IBOutlet weak var paymentMethodsView: UIView!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var bookingVerficationView: UIView!
    @IBOutlet weak var profileView: UIStackView!
    
    @IBOutlet weak var scroller: UIScrollView!

    var isFromNotification:Bool = false
    var balanceAmount: WalletHistoryData? {
        didSet {
            self.scroller.isHidden = false
        }
    }
    
    //var imageArray = [UIImage(named: "visaPayment"),UIImage(named: "madaPayment"),UIImage(named: "PayPal"),UIImage(named: "ApplePayment"),UIImage(named: "Stc_Payment"),UIImage(named: "tamaraPayment")]
    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var paymentService:PaymentViaTapPayService!

    
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var sec: UILabel!
    @IBOutlet weak var timerView: UIStackView!
    
    var isFromReceivedBooking:Bool = false
    var bookingID:String = ""
    var isFromThankYouPage:Bool = false
    var paymentSheet: PaymentSheet?
    var secretkey = ""
    var transID = ""
    var facilityArray:[Facilities] = []
    let refNotifications = Database.database().reference().child("Nottifications")
    var observceFirebaseValue = true
    var futureDate:Date = Date()
    var timer2:Timer?

    var countdown: DateComponents {
        return Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: futureDate)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .backWithTop
        viewControllerTitle = ""
        self.scroller.isHidden = true
        orderCancelView.isHidden = true
        //        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        //        floatRatingView.type = .halfRatings
        //setData()
        setPayCollectionCell()
        //runCountdown()
        facilityCollectionView.delegate = self
        facilityCollectionView.dataSource = self
        
        facilityCollectionView.register(UINib.init(nibName: "FacilityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FacilityCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = CGSize(width: 70, height: 60)
        self.facilityCollectionView.collectionViewLayout = layout
        self.facilityCollectionView.reloadData()
        self.facilityCollectionView.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        
        
    }
    
    func observiceFirebaseValuesForOrderStatus(){
        
        print(self.bookingID)
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
                        if invoiceId == self.bookingID
                        {
                            orderNotifications.append(n)
                        }
                    }
                    if let orderId = n.orderId
                    {
                        if orderId == self.bookingID
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
                        if notificationType == "completed_hotel_booking"
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
                    if self.isFromReceivedBooking
                    {
                        self.myReceivedBookingDetailsAPI()
                    }
                    else
                    {
                        self.myBookingDetailsAPI()
                    }
                   
                }
            }
        }
    }
    
    @objc func setupNotificationObserver() {
        isFromNotification = true
        if isFromReceivedBooking{
            myReceivedBookingDetailsAPI()
        }else{
            myBookingDetailsAPI()
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        
        if isFromReceivedBooking{
            myReceivedBookingDetailsAPI()
        }else{
            myBookingDetailsAPI()
        }
        getBalance()
        self.observiceFirebaseValuesForOrderStatus()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        if let userId = SessionManager.getUserData()?.firebase_user_key{
            self.refNotifications.child(userId).removeAllObservers()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    func convertDate(dateString:String){
        let dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        if let date = dateFormatter.date(from: dateString) {
            // `date` is the parsed Date object
            print("Parsed Date: \(date)")
            futureDate = date
            runCountdown()
        } else {
            print("Error parsing date.")
        }
    }

    var paymentData:GroundPaymentInitData?{
        didSet{
            self.scroller.isHidden = false
            self.secretkey = paymentData?.payment_ref?.payment_ref ?? ""
            self.transID = paymentData?.invoice_number ?? ""
            if self.selectedPaymentType == "2" {
                self.launchStripePaymentSheet()
            }else  {
                self.paymentWithCompletedAPI()
            }
        }
    }
    
    var myBookingDetails:HotelBookingDetailsData?{
        didSet{
            
            self.scroller.isHidden = false
            viewControllerTitle = myBookingDetails?.booking?.invoice_id ?? ""
            invoiceLabel.text = myBookingDetails?.booking?.invoice_id ?? ""
            timedateLabel.text = self.formatDate(date: myBookingDetails?.booking?.created_at ?? "")
            
            priceLabel.text = "\(myBookingDetails?.room?.currency_code ?? "") \(myBookingDetails?.total_amount ?? "")"
            statusLabel.text = myBookingDetails?.booking?.booking_status_text ?? ""
            
            subTotalLabel.text = "\(myBookingDetails?.room?.currency_code ?? "") \(myBookingDetails?.subtotal ?? "")"
            serviceChargeLabel.text = "\(myBookingDetails?.room?.currency_code ?? "") \(myBookingDetails?.service_charges ?? "")"
            taxLabel.text = "\(myBookingDetails?.room?.currency_code ?? "") \(myBookingDetails?.tax_charges ?? "")"
            grandTotalLabel.text = "\(myBookingDetails?.room?.currency_code ?? "") \(myBookingDetails?.total_amount ?? "")"
            
            if myBookingDetails?.booking?.end_date ?? "" == ""{
                scheduleDateLabel.text = myBookingDetails?.booking?.start_date ?? ""
            }else{
                scheduleDateLabel.text = (myBookingDetails?.booking?.start_date ?? "") + " - " + (myBookingDetails?.booking?.end_date ?? "")
            }
            
            
           // scheduleSlotLabel.text = myBookingDetails?.booking?.slot_value ?? ""
            self.convertDate(dateString: myBookingDetails?.booking?.start_date ?? "")
            facilityArray = myBookingDetails?.room?.facilities ?? []
            if isFromReceivedBooking{
                storeNameLabel.text = myBookingDetails?.booking?.user?.name ?? ""
                storeImageView.sd_setImage(with: URL(string: myBookingDetails?.booking?.user?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                
                self.groundNameLabel.text = myBookingDetails?.booking?.user?.name ?? ""
                var phone = "\(myBookingDetails?.booking?.user?.dial_code ?? "")\(myBookingDetails?.booking?.user?.phone ?? "")"
                phone = phone.replacingOccurrences(of: "+", with: "")
                self.groundContactLabel.text = "+\(phone)"
                groundImageView.sd_setImage(with: URL(string: myBookingDetails?.booking?.user?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                self.bookingSubHeadingLabel.text = "CUSTOMER DETAILS".localiz()
                
            }else{
                storeNameLabel.text = myBookingDetails?.booking?.vendor?.name ?? ""
                storeImageView.sd_setImage(with: URL(string: myBookingDetails?.booking?.vendor?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                
                self.groundNameLabel.text = myBookingDetails?.booking?.vendor?.name ?? ""
                var phone = "\(myBookingDetails?.booking?.vendor?.dial_code ?? "")\(myBookingDetails?.booking?.vendor?.phone ?? "")"
                phone = phone.replacingOccurrences(of: "+", with: "")
                
                self.groundContactLabel.text = "+\(phone)"
                groundImageView.sd_setImage(with: URL(string: myBookingDetails?.booking?.vendor?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                self.bookingSubHeadingLabel.text = "HOTEL DETAILS".localiz()
            }
            
            //self.otpView.text = myBookingDetails?.booking?.user_code ?? ""
            
            daysLabel.text = myBookingDetails?.remaining?.d ?? ""
            hourLabel.text = myBookingDetails?.remaining?.h ?? ""
            minitLabel.text = myBookingDetails?.remaining?.m ?? ""
            secondLabel.text = myBookingDetails?.remaining?.s ?? ""
            paymentTypeTextLabel.text = myBookingDetails?.booking?.payment_mode_text  ?? ""
            otpView.text = myBookingDetails?.booking?.user_code ?? ""
            deliveryDateLabel.text = self.formatDate(date: myBookingDetails?.booking?.completed_on ?? "")
            
            
            roomNamelabel.text = myBookingDetails?.room?.room_name ?? ""
            bookingAmountLabel.text = (myBookingDetails?.room?.room_price ?? "") + "/\("Per Day".localiz())"
            currencyLabel.text = myBookingDetails?.room?.currency_code ?? ""
            adultsCountLabel.text = myBookingDetails?.room?.adults ?? ""
            roomCountLabel.text = myBookingDetails?.room?.room_count ?? ""
            childAboveCountLabel.text = myBookingDetails?.room?.children_above_two ?? ""
            childBelowCountLabel.text = myBookingDetails?.room?.children_below_two ?? ""
            
            
            if myBookingDetails?.coupon_applied == "1"{
                self.couponView.isHidden = false
                self.couponDiscountLabel.text = myBookingDetails?.discount ?? ""
            }else{
                self.couponView.isHidden = true
                self.couponDiscountLabel.text =  "0"
            }
            
            
            self.address()
            
            
            self.rejectAcceptButtonView.isHidden    = true
            rejectAcceptButtonStackView.isHidden = true
            self.orderCancelView.isHidden           = true
            orderCancelStackView.isHidden = true
            //self.bookingConfirmtButtonView.isHidden = true
            self.paymentMethodsView.isHidden        = true
            self.timerView.isHidden                 = true
            self.bookingVerficationView.isHidden    = true
            self.mapView.isHidden                   = true
            self.paymentTypeView.isHidden           = true
            self.verificationCodeSellerView.isHidden = true
            self.verificationCodeView.isHidden = true
            self.deliveryDetailsView.isHidden = true
            self.ratingView.isHidden = true
            self.aminitiesView.isHidden = true
            self.facilityCollectionView.reloadData()
            
            if myBookingDetails?.booking?.payment_mode_text != "" && myBookingDetails?.booking?.payment_mode_text != "N/A" {
                self.paymentTypeView.isHidden = false
            }else{
                self.paymentTypeView.isHidden = true
            }
            
            if let reviewData = myBookingDetails?.review_data {
                self.floatRatingView.rating = Double(reviewData.ratings ?? "0.0") ?? 0.0
            }
            
            if myBookingDetails?.booking?.booking_status == "4" || myBookingDetails?.booking?.booking_status == "5" || myBookingDetails?.booking?.booking_status == "6"{
                self.indicator.stopAnimating()
            }else{
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }
            
            if isFromReceivedBooking{
                if myBookingDetails?.booking?.booking_status == "0"{
                    self.rejectAcceptButtonView.isHidden = false
                    rejectAcceptButtonStackView.isHidden = false
                    statusColorCode(color: Color.StatusYellow.color())
                }else if myBookingDetails?.booking?.booking_status == "1"{
                    statusColorCode(color: Color.StatusRed.color())
                }
                else if myBookingDetails?.booking?.booking_status == "2" {
                    //self.readyForCollectionView.isHidden = false
                    statusColorCode(color: Color.StatusRed.color())
                }else if myBookingDetails?.booking?.booking_status == "3"{
                    self.bookingVerficationView.isHidden = false
                    self.timerView.isHidden = false
                    self.verificationCodeSellerView.isHidden = false
                    statusColorCode(color: Color.StatusBlue.color())
                }
                else if myBookingDetails?.booking?.booking_status == "4"{
                    //self.profileHeadingLabel.isHidden    = true
                    //self.paymentTypeView.isHidden = false
                    //self.profileView.isHidden = false
                    //self.verificationView.isHidden = false
                    //self.driverDetailsView.isHidden  = false
                    //self.customer = myOrderData?.customer
                    
                    self.deliveryDetailsView.isHidden = false
                    self.bookingVerficationView.isHidden = false
                    statusColorCode(color: Color.StatusGreen.color())
                    if isFromNotification{
                        isFromNotification = false
                        self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Booking completed".localiz(), confirmMessage: "", invoiceID: myBookingDetails?.booking?.invoice_id ?? "", viewcontroller: self)
                    }
                }
                else if myBookingDetails?.booking?.booking_status == "5"{
                    //self.paymentTypeView.isHidden    = false
                    statusColorCode(color: Color.StatusBlue.color())
                }else if myBookingDetails?.booking?.booking_status == "6" {

                    statusColorCode(color: Color.StatusRed.color())
                }
                else if myBookingDetails?.booking?.booking_status == "10" || myBookingDetails?.booking?.booking_status == "11" || myBookingDetails?.booking?.booking_status == "12" {
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                }
            }else{
                if myBookingDetails?.booking?.booking_status == "0"{
                  //  self.orderCancelView.isHidden = false
                 //   orderCancelStackView.isHidden = false
                    self.aminitiesView.isHidden = false
                    statusColorCode(color: Color.StatusYellow.color())
                    
                }else if myBookingDetails?.booking?.booking_status == "1"{
                    self.paymentMethodsView.isHidden = false
                    self.aminitiesView.isHidden = false
                    statusColorCode(color: Color.StatusRed.color())
                }
                else if myBookingDetails?.booking?.booking_status == "2"{
                   // self.paymentTypeView.isHidden = false
                    self.aminitiesView.isHidden = false
                    statusColorCode(color: Color.StatusRed.color())
                }
                else if myBookingDetails?.booking?.booking_status == "3"{
                    self.aminitiesView.isHidden = false
                    self.timerView.isHidden = false
                    self.bookingVerficationView.isHidden = false
                    self.verificationCodeView.isHidden = false
                    self.mapView.isHidden = false
                    self.paymentTypeView.isHidden = false
                    statusColorCode(color: Color.StatusBlue.color())
                    //if myOrderData?.request_deligate == "2"{
                    //    self.paymentTypeView.isHidden    = false
                     //   self.profileView.isHidden        = false
                      //  self.verificationView.isHidden   = false
                    //}
                }
                else if myBookingDetails?.booking?.booking_status == "4"{
                    //self.profileHeadingLabel.isHidden    = false
                   // self.paymentTypeView.isHidden = false
                   // self.profileView.isHidden = false
                   // self.driverDetailsView.isHidden = false
                    self.groundContactLabel.isHidden = true
                    self.ratingView.isHidden = false
                    self.bookingVerficationView.isHidden = false
                    self.deliveryDetailsView.isHidden = false
                    self.aminitiesView.isHidden = false
                    statusColorCode(color: Color.StatusGreen.color())
                    if isFromNotification{
                        isFromNotification = false
                        self.showCompletedPopup(titleMessage: "Booking completed".localiz(), confirmMessage: "", invoiceID: myBookingDetails?.booking?.invoice_id ?? "", viewcontroller: self)
                    }
                }
                else if myBookingDetails?.booking?.booking_status == "5"{
                    //self.profileHeadingLabel.isHidden    = false
                    //self.paymentTypeView.isHidden    = false
                    //self.profileView.isHidden        = false
                    //self.verificationView.isHidden   = false
                    statusColorCode(color: Color.StatusBlue.color())
                }
                else if myBookingDetails?.booking?.booking_status == "6" {
                    statusColorCode(color: Color.StatusRed.color())
                    
//                    if myOrderData?.request_deligate == "2"{
//                        self.paymentTypeView.isHidden    = false
//                        self.profileView.isHidden        = false
//                        //self.deliveryDetailView.isHidden = false
//                        //self.driverDetailsView.isHidden  = false
//                       // self.reviewStackView.isHidden    = false
//                    }else{
//                        self.profileHeadingLabel.isHidden = false
//                        self.paymentTypeView.isHidden    = false
//                        self.profileView.isHidden        = false
//                        self.deliveryDetailView.isHidden = false
//                        self.driverDetailsView.isHidden  = false
//                        self.reviewStackView.isHidden    = false
//                        self.reviewButton.isHidden       = false
//                        myTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.navigateRateViewCode), userInfo: nil, repeats: false)
//
//                    }
                }
                else if myBookingDetails?.booking?.booking_status == "10" || myBookingDetails?.booking?.booking_status == "11" || myBookingDetails?.booking?.booking_status == "12" {
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                }
            }
//            DispatchQueue.main.async {
//                self.tbl.reloadData()
//            }
        }
    }
    
    func address(){
        self.addressLabel.text = myBookingDetails?.room?.address ?? ""
        
        let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(myBookingDetails?.booking?.vendor?.user_location?.lattitude ?? ""),\(myBookingDetails?.booking?.vendor?.user_location?.longitude ?? "")&\("zoom=15&size=\(510)x310")&sensor=true&key=\(Config.googleApiKey)"
        
        print(staticMapUrl)
        
        let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        loadMapFromURL(url!,completion: { self.mapImageView.image = $0 })
    }
    
    func runCountdown() {
        timer2 =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(_ timer:Timer) {
        let countdown = self.countdown //only compute once per call
        let days = countdown.day!
        let hours = countdown.hour!
        let minutes = countdown.minute!
        let seconds = countdown.second!
        print(String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds))
        
        daysLabel.text = "\(String(format: "%02d",days))".replacingOccurrences(of: "-", with: "")
        hourLabel.text = "\(String(format: "%02d",hours))".replacingOccurrences(of: "-", with: "")
        minitLabel.text = "\(String(format: "%02d",minutes))".replacingOccurrences(of: "-", with: "")
        secondLabel.text = "\(String(format: "%02d",seconds))".replacingOccurrences(of: "-", with: "")

        if days  <= 0 {
            daysLabel.text = "00"
        }

        if hours <= 0 {
            hourLabel.text = "00"
        }

        if minutes <= 0 {
            minitLabel.text = "00"
        }

        if  seconds <= 0 {
            secondLabel.text = "00"
        }


        if (days <= 0) && (hours <= 0) && (minutes <= 0) && (seconds <= 0) {
                //self.timerStackview.isHidden = true
            timer.invalidate()
            timer2?.invalidate()
            timer2 = nil
        }
//        minute.text! = "\(String(format: "%02d",minutes))"
//        sec.text! = "\(String(format: "%02d",seconds))"
    }
    override func backButtonAction(){
        if isFromThankYouPage {
                // Coordinator.updateRootVCToTab()
                //Coordinator.gotoRespectiveOrdersList(fromController: self, category: "s")
            let  VC = AppStoryboard.BookingHotel.instance.instantiateViewController(withIdentifier: "HotelBookingListViewController") as! HotelBookingListViewController
            VC.isFromDriver = false
            VC.isPopRoot = true
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func ChatAction() {
        //Coordinator.goToChatDetails(delegate: self,user_id: myBookingDetails?.booking?.vendor?.id ?? "",user_name: myBookingDetails?.booking?.vendor?.name ?? "",userImgae: myBookingDetails?.booking?.vendor?.user_image ?? "", firebaseUserKey:"")
    }
    @IBAction func reviewPressed(_ sender: UIButton) {
        
        ShopCoordinator.goToRateVC(controller: self)
    }
    @IBAction func payNow(_ sender: UIButton) {
        paymentService.invoiceId = "\(myBookingDetails?.booking?.invoice_id)"
        if selectedIndex == 0 {
            selectedPaymentType = "1"
            let grandTotalAmount = myBookingDetails?.total_amount ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            paymentService.startPaymentViaSellSDK(amount: Decimal.init(string: grandTotal) ?? 0.0)
                // self.payNow()
        } else if selectedIndex == 1 {
            selectedPaymentType = "4"
            let grandTotalAmount = myBookingDetails?.total_amount ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            paymentService.startApplePaymentViaSellSDK(amount: Double(grandTotal) ?? 0.0)
        } else if selectedIndex == 2 {
            selectedPaymentType = "3"
            let grandTotalAmount = myBookingDetails?.total_amount ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            if ((Float(grandTotal) ?? 0.0) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0)){
                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    Coordinator.gotoRecharge(controller: self)
                }
            }else {
                self.initPaymentAPI()
            }
        }
    }
    
    @IBAction func mapBtnAction(_ sender: UIButton) {
        
        self.showMapOptions(latitude: myBookingDetails?.booking?.vendor?.user_location?.lattitude ?? "", longitude: myBookingDetails?.booking?.vendor?.user_location?.longitude ?? "", name: myBookingDetails?.booking?.vendor?.name ?? "")
    }
    
//    func setData() {
//        self.tbl.delegate = self
//        self.tbl.dataSource = self
//        self.tbl.separatorStyle = .none
//        self.tbl.register(PGBookingProductCell.nib, forCellReuseIdentifier: PGBookingProductCell.identifier)
//        tbl.reloadData()
//        self.tbl.layoutIfNeeded()
//    }
    func setPayCollectionCell() {
        payCollection.delegate = self
        payCollection.dataSource = self
        payCollection.register(UINib.init(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width-80
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = CGSize(width: screenWidth/2, height: 70)
        self.payCollection.collectionViewLayout = layout
        
    }
    
    /// Status Color change
    /// - Parameters:
    ///   - color: UIColor
    ///   - isHide: hide indicator and background
    func statusColorCode(color:UIColor,indicatiorHide isHide:Bool = false)  {
       // statusBgView.backgroundColor = color
       // indicatorBgView.backgroundColor  = color
        statusLabel.textColor = color
        if isHide{
            //indicator.isHidden       = true
            //indicatorBgView.isHidden = true
        }else{
            //indicatorBgView.isHidden = false
            //indicator.isHidden       = false
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.bookingCancelAPI()
    }
    @IBAction func rejectAction(_ sender: UIButton) {
        self.orderRejectedAPI()
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        self.orderAcceptedAPI()
    }
    @IBAction func bookingConfirmAction(_ sender: UIButton) {
    }
    
    @IBAction func enterTotheHotelAction(_ sender: UIButton) {
        if sellerOTPView.text != ""{
            self.isFromNotification = true
            verificationCodeSubmitAPI()
        }else{
            Utilities.showWarningAlert(message:  "Please enter verification code.".localiz()) {
                
            }
        }
        
    }
    
    @IBAction func rateButtonAction(_ sender: UIButton) {
        if (!isFromReceivedBooking){
            if let status = myBookingDetails?.booking?.booking_status , status == "4" {
                if let isRATED = myBookingDetails?.isRated , isRATED == "0" {
                    let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
                    VC.myBookingDetails = self.myBookingDetails
                    VC.isFromOrder = true
                    VC.isFromStore = true
                    VC.isFromHotelBooking = true
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
            
        }
    }
    
    @objc func showRating()
    {
        if let status = myBookingDetails?.booking?.booking_status , status == "4" {
            if let isRATED = myBookingDetails?.isRated , isRATED == "0" {
                let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
                VC.myBookingDetails = self.myBookingDetails
                VC.isFromOrder = true
                VC.isFromStore = true
                VC.isFromHotelBooking = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    //MARK: - Date Convertion
    func formatDate(date: String) -> String {
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        inputFormatter.locale = Locale.current
//        let showDate = inputFormatter.date(from: date)
//        inputFormatter.dateFormat = "d MMM yyyy h:mma"
//        let resultString = inputFormatter.string(from: showDate ?? Date())
//        print(resultString)
//        return resultString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let dateFromString = dateFormatter.date(from: date) {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "d MMM yyyy h:mma"
            let dateString = formatter.string(from: dateFromString)
            return dateString
        }
        return ""
    }
    
}


extension HotelBookingDetail{
    
    //MARK: - API Calls
    
    func myBookingDetailsAPI() {
        //myReceiveBookingDetailsAPI
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : bookingID,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        StoreAPIManager.userBookingDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myBookingDetails = result.oData
                
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func myReceivedBookingDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : bookingID,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        StoreAPIManager.sellerBookingDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myBookingDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    
    func orderAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" :  myBookingDetails?.booking?.booking_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.sellerBookingAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myReceivedBookingDetailsAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    

    
   
    func orderRejectedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" :  myBookingDetails?.booking?.booking_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.sellerBookingRejectAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                print("")
                self.myReceivedBookingDetailsAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func bookingCancelAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myBookingDetails?.booking?.booking_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.userBookingCancelAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myBookingDetailsAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func initPaymentAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myBookingDetails?.booking?.booking_id ?? "",
            "payment_type" : self.selectedPaymentType
        ]
        print(parameters)
        StoreAPIManager.hotelPaymentWithInitAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.paymentData = result.oData
                
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func paymentWithCompletedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myBookingDetails?.booking?.booking_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.hotelPaymentWithCompleteAPI(parameters: parameters) { result in
            switch result.status {
            case 1 :
                //self.paymentData = result.oData
               // Coordinator.goTThankYouPage(controller: self, vcType: "", invoiceId: self.myBookingDetails?.booking?.invoice_id ?? "", order_id: result.oData?.booking_id ?? "", isFromFoodStore: false,isFromPlayGround: true,isFromPGDetail: true)
              
                self.bookingID = result.oData?.booking_id ?? ""
                DispatchQueue.main.async {
                    let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                    controller.delegate = self
                    controller.heading = "Payment made successfully".localiz()
                    controller.confirmationText = ""
                    controller.invoiceNumber = result.oData?.invoice_number ?? ""
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
    
    func verificationCodeSubmitAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myBookingDetails?.booking?.booking_id ?? "",
            "code" : sellerOTPView.text ?? ""
        ]
        print(parameters)
        StoreAPIManager.hotelVerificationCodeSubmitAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myReceivedBookingDetailsAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
  
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
                self.paymentWithCompletedAPI()
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

extension HotelBookingDetail:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == payCollection{
            return self.imageArray.count
        }else{
            return self.facilityArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == payCollection{
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
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCollectionViewCell", for: indexPath) as? FacilityCollectionViewCell else { return UICollectionViewCell() }
            cell.iconImageView.sd_setImage(with: URL(string: facilityArray[indexPath.row].icon ?? ""), placeholderImage:UIImage(named: "placeholder_profile"))
            cell.nameLabel.text = facilityArray[indexPath.row].name ?? ""
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == payCollection{
            self.selectedIndex = indexPath.row
            self.payCollection.reloadData()
        }else{
            
        }
    }

}
extension HotelBookingDetail {
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
extension HotelBookingDetail:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: false,booking_ID: self.bookingID,isFromThankYou: true)
    }
}
extension HotelBookingDetail: PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {

    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        
    }
}

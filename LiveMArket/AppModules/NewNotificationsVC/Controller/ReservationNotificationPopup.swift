//
//  ReservationNotificationPopup.swift
//  LiveMArket
//
//  Created by Zain on 22/09/2023.
//

import UIKit
import Lottie


protocol ReservationNotificationPopupProtocol{
    func viewDetails(notiyType:String,orderId:String)
}

class ReservationNotificationPopup: UIViewController {
    @IBOutlet weak var packageHading: UILabel!
    @IBOutlet weak var rejectView: UIView!
    @IBOutlet weak var notificationType: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var kmLbl: UILabel!
    @IBOutlet weak var minLbl: UILabel!
    @IBOutlet weak var minStack: UIStackView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var pickAddressView: UIStackView!
    @IBOutlet weak var pickAddressLbl: UILabel!
    @IBOutlet weak var dropAddressView: UIStackView!
    @IBOutlet weak var dropAddressheading: UILabel!
    @IBOutlet weak var dropAddressLbl: UILabel!
    
    @IBOutlet weak var packagesView: UIStackView!
    @IBOutlet weak var packagesAddress: UILabel!
    @IBOutlet weak var packagesDate: UILabel!
    @IBOutlet weak var packagesDays: UILabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var stckView: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bookingCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var lottieAnimation: LottieAnimationView!
    @IBOutlet weak var pickDashImg: UIImageView!
    
    var delegate:ReservationNotificationPopupProtocol?
    
    var notiType = ""
    var orderId = ""

    deinit {
        timer.invalidate()
    }

    var myEcommerceOrderData:MyOrderDetailsData?{
        didSet{
            self.setTimer()
            self.mainView.isHidden = false
            self.userView.isHidden = true
            self.distanceView.isHidden = true
            self.packagesView.isHidden = true
            self.pickAddressView.isHidden = true
            self.dropAddressView.isHidden = false
            self.minStack.isHidden = true
            self.notificationType.text = myEcommerceOrderData?.store?.activity_type?.name ?? ""
            self.orderNo.text = myEcommerceOrderData?.invoice_id ?? ""
            self.priceLbl.text = "\(myEcommerceOrderData?.currency_code ?? "") \(myEcommerceOrderData?.grand_total ?? "")"
            if myEcommerceOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                self.dropAddressheading.text = "Pick-Up Address".localiz()
                self.dropAddressLbl.text = myEcommerceOrderData?.store?.location_data?.location_name ?? ""
            }else {
                self.dropAddressLbl.text = "\(myEcommerceOrderData?.address?.building_name ?? ""), \(myEcommerceOrderData?.address?.flat_no ?? ""), \(myEcommerceOrderData?.address?.address ?? "")"
            }
            
        }
        
    }
    var myFoodOrderData:MyOrderDetailsData?{
        didSet{
            self.setTimer()
            self.mainView.isHidden = false
            self.userView.isHidden = true
            self.distanceView.isHidden = true
            self.packagesView.isHidden = true
            self.pickAddressView.isHidden = true
            self.dropAddressView.isHidden = false
            self.minStack.isHidden = true
            self.dropAddressView.isHidden = false
            self.notificationType.text =  myFoodOrderData?.store?.activity_type?.name ?? ""
            self.orderNo.text = myFoodOrderData?.invoice_id ?? ""
            self.priceLbl.text = "\(myFoodOrderData?.currency_code ?? "") \(myFoodOrderData?.grand_total ?? "")"
            if myFoodOrderData?.deligate?.deligate_name ?? "" == "Own Pick-Up"{
                self.dropAddressheading.text = "Pick-Up Address".localiz()
                self.dropAddressLbl.text = myFoodOrderData?.store?.location_data?.location_name ?? ""
            }else {
                //self.dropAddressheading.text = "Delivery Address"
                self.dropAddressLbl.text = "\(myFoodOrderData?.address?.building_name ?? ""), \(myFoodOrderData?.address?.flat_no ?? ""), \(myFoodOrderData?.address?.address ?? "")"
            }
        }
        
    }
    var myDriverOrderData:DriverOrderDetailsData?{
        didSet{
            self.setTimer()
            self.mainView.isHidden = false
            self.userView.isHidden = true
            self.userView.isHidden = true
            self.packagesView.isHidden = true
            self.dropAddressView.isHidden = false
            self.pickAddressView.isHidden = false
            self.notificationType.text = myDriverOrderData?.store?.activity_type?.name ?? ""
            self.orderNo.text = myDriverOrderData?.invoice_id ?? ""
            self.priceLbl.text = "\(myDriverOrderData?.currency_code ?? "") \(myDriverOrderData?.grand_total ?? "")"
            self.pickAddressLbl.text = myDriverOrderData?.store?.location_data?.location_name ?? ""
            self.dropAddressLbl.text =  "\(myDriverOrderData?.address?.building_name ?? ""), \(myDriverOrderData?.address?.flat_no ?? ""), \(myDriverOrderData?.address?.address ?? "")"
            self.kmLbl.text = String(myDriverOrderData?.total_distance?.distance ?? "").replacingOccurrences(of: " km", with: "")
            self.minLbl.text = String(myDriverOrderData?.total_distance?.time ?? "").replacingOccurrences(of: " mins", with: "")
            
        }
    }
    var servicesDetails : DelegateDetailsServicesData? {
        didSet {
            self.setTimer()
            self.mainView.isHidden = false
            self.userView.isHidden = true
            self.packagesView.isHidden = true
            self.dropAddressView.isHidden = false
            self.pickAddressView.isHidden = false
            //self.priceLbl.text = "\(servicesDetails?.currencyCode ?? "") \(Double(servicesDetails?.data?.grandTotal ?? "") ?? 0.0)"
            self.notificationType.text = servicesDetails?.data?.deligateService?.serviceName ?? ""
            self.orderNo.text = servicesDetails?.data?.serviceInvoiceID ?? ""
            
            self.pickAddressLbl.text = servicesDetails?.data?.pickupLocation ?? ""
            self.dropAddressLbl.text =  servicesDetails?.data?.dropoffLocation ?? ""
            self.kmLbl.text = String(self.servicesDetails?.data?.totalDistance?.distance ?? "").replacingOccurrences(of: " km", with: "")
            self.minLbl.text = String(self.servicesDetails?.data?.totalDistance?.time ?? "").replacingOccurrences(of: " mins", with: "")
        }
        
    }
    var serviceData : ServiceData? {
        didSet {
            self.setTimer()
            self.mainView.isHidden = false
            self.packagesView.isHidden = true
            self.dropAddressView.isHidden = false
            self.pickAddressView.isHidden = true
            self.userView.isHidden = false
            self.minStack.isHidden = false
            self.distanceView.isHidden = false
            self.notificationType.text = "Service Booking".localiz()
            self.orderNo.text = serviceData?.service_invoice_id ?? ""
            self.userName.text = serviceData?.user?.name ?? ""
            self.dropAddressheading.text = "Address".localiz()
            self.kmLbl.text = String(self.serviceData?.distance?.distance ?? "").replacingOccurrences(of: " km", with: "")
            self.minLbl.text = String(self.serviceData?.distance?.time ?? "").replacingOccurrences(of: " mins", with: "")
            self.userImg.sd_setImage(with: URL(string:serviceData?.user?.user_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            self.dropAddressLbl.text = self.serviceData?.location_name ?? ""
            // self.pickAddressView.isHidden = false
        }
        
    }
    var myBookingDetails:GroundBookingDetailsData?{
        didSet{
            self.setTimer()
            bookingCollectionView.isHidden = false
            bookingCollectionView.reloadData()
            self.mainView.isHidden = false
            self.packagesView.isHidden = true
            self.pickAddressView.isHidden = true
            self.dropAddressView.isHidden = false
            self.minStack.isHidden = true
            self.userView.isHidden = false
            self.distanceView.isHidden = true
            self.notificationType.text = "Play Ground Booking".localiz()
            self.orderNo.text = myBookingDetails?.booking?.invoice_id ?? ""
            self.userName.text = myBookingDetails?.booking?.user?.name ?? ""
            self.userImg.sd_setImage(with: URL(string: myBookingDetails?.booking?.user?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            self.priceLbl.text = "\(myBookingDetails?.ground?.currency_code ?? "") \(Double(myBookingDetails?.total_amount ?? "") ?? 0.0)"
            self.dropAddressView.isHidden = true
            self.packagesView.isHidden = false
            self.packagesAddress.text = myBookingDetails?.ground?.ground_name ?? ""
            self.packagesDays.text = ""
            self.packagesDate.text = (myBookingDetails?.booking?.start_date_time ?? "").changeDateToFormat(frmFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd MMM yyyy")
            self.packageHading.text = "Booking Details"
            
        }
        
    }
    var RequestData :  ChaletsBookingDetailsData? {
        didSet {
            self.setTimer()
            self.mainView.isHidden = false
            self.packagesView.isHidden = true
            self.pickAddressView.isHidden = true
            self.dropAddressView.isHidden = false
            self.minStack.isHidden = true
            self.userView.isHidden = false
            self.distanceView.isHidden = true
            self.notificationType.text = "Chalet Booking".localiz()
            self.orderNo.text = RequestData?.booking?.bookingID ?? ""
            self.userName.text = RequestData?.booking?.user_name ?? ""
            self.userImg.sd_setImage(with: URL(string: RequestData?.booking?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            self.priceLbl.text = "\(RequestData?.product?.currency_code ?? "") \(Double(RequestData?.booking?.totalAmount ?? "") ?? 0.0)"
            self.dropAddressView.isHidden = true
            self.packagesView.isHidden = false
            self.packagesAddress.text = RequestData?.product?.product_name ?? ""
            self.packagesDate.text = (self.RequestData?.booking?.schedule ?? "")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var startdate = dateFormatter.date(from:self.RequestData?.booking?.startDateTime ?? "") ?? Date()
            var endDate = dateFormatter.date(from:self.RequestData?.booking?.endDateTime ?? "") ?? Date()
            if self.daysBetweenDates(startDate: startdate, endDate: endDate) > 1 {
                //  self.packagesDays.text = "\(self.daysBetweenDates(startDate: startdate, endDate: endDate)) Days"
            }else if self.daysBetweenDates(startDate: startdate, endDate: endDate) == 1 {
                //  self.packagesDays.text = "\(self.daysBetweenDates(startDate: startdate, endDate: endDate)) Day"
            }else {
                //  self.packagesDays.text = "\(1) Day"
            }
            self.packageHading.text = "Booking Details".localiz()
            
        }
    }
    var myHotelBookingDetails:HotelBookingDetailsData?{
        didSet{
            self.setTimer()
            self.mainView.isHidden = false
            self.packagesView.isHidden = true
            self.pickAddressView.isHidden = true
            self.dropAddressView.isHidden = false
            self.minStack.isHidden = true
            self.userView.isHidden = false
            self.distanceView.isHidden = true
            self.notificationType.text = "Hotel Booking".localiz()
            self.orderNo.text = myHotelBookingDetails?.booking?.invoice_id ?? ""
            self.userName.text = myHotelBookingDetails?.booking?.user?.name ?? ""
            self.userImg.sd_setImage(with: URL(string:  myHotelBookingDetails?.booking?.user?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            self.priceLbl.text = "\(myHotelBookingDetails?.room?.currency_code ?? "") \(myHotelBookingDetails?.total_amount ?? "")"
            self.dropAddressView.isHidden = true
            self.packagesView.isHidden = false
            self.packagesAddress.text = myHotelBookingDetails?.room?.room_name ?? ""
            self.packageHading.text = "Booking Details".localiz()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var startdate = dateFormatter.date(from:"\((self.myHotelBookingDetails?.booking?.start_date ?? "")) 00:00:00") ?? Date()
            var endDate = dateFormatter.date(from:"\((self.myHotelBookingDetails?.booking?.end_date ?? "")) 00:00:00") ?? Date()
            
            self.packagesDate.text = "\(self.formatDate(date: "\((self.myHotelBookingDetails?.booking?.start_date ?? "")) 00:00:00")) - \(self.formatDate(date: "\((self.myHotelBookingDetails?.booking?.end_date ?? "")) 00:00:00"))"
            if self.daysBetweenDates(startDate: startdate, endDate: endDate) > 1 {
                //   self.packagesDays.text = "\(self.daysBetweenDates(startDate: startdate, endDate: endDate)) Days"
            }else if self.daysBetweenDates(startDate: startdate, endDate: endDate) == 1 {
                // self.packagesDays.text = "\(self.daysBetweenDates(startDate: startdate, endDate: endDate)) Day"
            }else {
                // self.packagesDays.text = "\(1) Day"
            }
        }
    }
    
    var subscriptionGymDetails:SubscriptionDetailsData?{
        didSet{
            self.setTimer()
            self.mainView.isHidden = false
            self.packagesView.isHidden = true
            self.pickAddressView.isHidden = true
            self.dropAddressView.isHidden = false
            self.minStack.isHidden = true
            self.userView.isHidden = false
            self.distanceView.isHidden = true
            self.notificationType.text = "Gym Subscription".localiz()
            self.orderNo.text = subscriptionGymDetails?.subscription_invoice_id ?? ""
            self.userName.text = subscriptionGymDetails?.full_name ?? ""
            self.userImg.sd_setImage(with: URL(string:  subscriptionGymDetails?.user?.image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            self.priceLbl.text = (subscriptionGymDetails?.currency_code ?? "") + " " + (subscriptionGymDetails?.grand_total ?? "")
            self.dropAddressView.isHidden = true
            self.packagesView.isHidden = false
            self.packagesAddress.text = subscriptionGymDetails?.subscription_title ?? ""
            
            //self.packagesDays.text = "\(subscriptionGymDetails?.subscription_no_of_days ?? "") Days"
            
            self.packagesDate.text = "\(self.formatDate(date: "\((subscriptionGymDetails?.booking_date ?? ""))")) - \(self.formatDate(date: "\((subscriptionGymDetails?.subscription_end_date ?? "")) 00:00:00"))"
            
        }
    }
    var bookingData:TableBookDetailsData?{
        didSet{
            self.setTimer()
            self.mainView.isHidden = false
            self.packagesView.isHidden = true
            self.pickAddressView.isHidden = true
            self.dropAddressView.isHidden = false
            self.minStack.isHidden = true
            self.userView.isHidden = false
            self.distanceView.isHidden = true
            self.notificationType.text = "Table Booking".localiz()
            self.orderNo.text = bookingData?.invoice_id ?? ""
            self.userName.text = bookingData?.user?.name ?? ""
            self.userImg.sd_setImage(with: URL(string:  bookingData?.user?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
         //   self.priceLbl.text = "SAR" + " " + (bookingData?.grand_total ?? "")
            self.dropAddressView.isHidden = true
            self.packagesView.isHidden = false
            self.packageHading.text = "Booking Details".localiz()
            self.packagesAddress.text = "\(bookingData?.no_of_persons ?? "") \("Person".localiz())"
            
            self.packagesDays.text = "\(bookingData?.booking_from ?? "") - \(bookingData?.booking_to ?? "")"
            
            self.packagesDate.text = bookingData?.booking_date ?? ""
        }
        
    }
    
    var timer = Timer()
    var counter = 20.00
    var i = 1.0
    var isCallingAPI = false
    override func viewDidLoad() {
        super.viewDidLoad()
        bookingCollectionView.register(UINib.init(nibName: "OptionsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "OptionsCollectionCell")
        bookingCollectionView.isHidden = true
        bookingCollectionView.delegate = self
        bookingCollectionView.dataSource = self
        (UIApplication.shared.delegate as? AppDelegate)?.playBeep()
        self.mainView.isHidden = true
        progressView.progress = 0.0
        progressView.layer.cornerRadius = 20
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 0
        progressView.subviews[1].clipsToBounds = true
        progressView.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        progressView.progressViewStyle = .bar
        
        
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor(hex: "FC612A").cgColor
        lineLayer.lineWidth = 2
        lineLayer.lineDashPattern = [4,4]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: pickDashImg.frame.origin.x + 15, y: 0),
                                CGPoint(x: pickDashImg.frame.origin.x + 15, y: pickDashImg.frame.size.height)])
        lineLayer.path = path
        self.pickDashImg.layer.addSublayer(lineLayer)
        self.lottieAnimation?.contentMode = .scaleAspectFit
        self.lottieAnimation?.animationSpeed = 1
        playAnimation()
        if notiType.lowercased() == "new_order" {
            self.receivedEcommerceOrdesDetailsAPI()
        }else  if notiType.lowercased() == "food_new_order" {
            self.receivedFoodOrdesDetailsAPI()
        }else  if notiType.lowercased() == "driver_new_order" {
            self.rejectView.isHidden = true
            self.driverOrdesDetailsAPI()
        }else  if notiType.lowercased() == "food_driver_new_order" {
            self.rejectView.isHidden = true
            self.DriverFoodOrderDetails()
        }else  if notiType.lowercased() == "deligate_new_order_driver" {
            self.rejectView.isHidden = true
            self.DriverDelegateOrderDetails()
        }else  if notiType.lowercased() == "new_service_request" {
            self.getNewServiceDetails()
        }else  if notiType.lowercased() == "new_playground_booking" {
            self.myGroundBookingDetailsAPI()
        }else if  notiType.lowercased() == "new_chalet_booking" {
            self.getRequestDetails()
        }else if  notiType.lowercased() == "new_hotel_booking" {
            self.myReceivedBookingDetailsAPI()
        }else if  notiType.lowercased() == "new_gym_subscription" {
            self.rejectView.isHidden = true
            self.myReceivedSubscriptionDetailsAPI()
        }else if  notiType.lowercased() == "new_table_booking_placed_store" {
            self.myTableReceivedBookingDetaisAPI()
        }
        
        
    }
    func setTimer() {
        progressView.progress = 0.0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ReservationNotificationPopup.updateProgressView), userInfo: nil, repeats: true)
    }
    func playAnimation() {
        self.lottieAnimation?.play(completion: { played in
            if played == true {
                self.playAnimation()
            }else {
                self.playAnimation()
            }
        })
    }
    @objc func updateProgressView(){
        progressView.progress += 0.02
        progressView.setProgress(progressView.progress, animated: true)
        if(progressView.progress == 1.0)
        {
            timer.invalidate()
            if  self.isCallingAPI == false {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.stopAlaram()
                self.dismiss(animated: false)
            }
            
        }
    }
    @IBAction func viewDetails(_ sender: UIButton) {
        Constants.shared.isCommingFromOrderPopup = true
        NotificationCenter.default.post(name: NSNotification.Name("PIPDismiss"), object: nil)
        if notiType.lowercased() == "food_driver_new_order" {
            self.dismiss(animated: false) {
                let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
            }
        } else {
            self.dismiss(animated: false) {
                let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                
            }
        }
    }
    @IBAction func viewReject(_ sender: UIButton) {
        Constants.shared.isCommingFromOrderPopup = true
        NotificationCenter.default.post(name: NSNotification.Name("PIPDismiss"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        self.isCallingAPI = true
        if notiType.lowercased() == "new_order" {
            self.orderRejectedEcomerceAPI()
        }else  if notiType.lowercased() == "food_new_order" {
            self.orderRejectedFoodAPI()
        }else  if notiType.lowercased() == "driver_new_order" {
            self.dismiss(animated: false)
        }else  if notiType.lowercased() == "food_driver_new_order" {
            self.dismiss(animated: false)
        }else  if notiType.lowercased() == "deligate_new_order_driver" {
            self.dismiss(animated: false)
        }else  if notiType.lowercased() == "new_service_request" {
            self.rejectAPI()
        }else if notiType.lowercased() == "new_playground_booking" {
            self.orderRejectedPlayGroundAPI()
        }else if notiType.lowercased() == "new_chalet_booking" {
            self.chaledRejectAPI()
        }else if  notiType.lowercased() == "new_hotel_booking" {
            self.orderRejectedHotelAPI()
        }else if  notiType.lowercased() == "new_gym_subscription" {
            self.orderRejectedGymAPI()
        }else if  notiType.lowercased() == "new_table_booking_placed_store" {
            self.myTableBookingRejectAPI()
        }
    }
    @IBAction func viewAccept(_ sender: UIButton) {
        Constants.shared.isCommingFromOrderPopup = true
        NotificationCenter.default.post(name: NSNotification.Name("PIPDismiss"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        self.isCallingAPI = true
        if notiType.lowercased() == "new_order" {
            self.orderAcceptedEcomerceAPI()
        }else  if notiType.lowercased() == "food_new_order" {
            self.orderAcceptedFoodAPI()
        }else  if notiType.lowercased() == "driver_new_order" {
            self.orderDriverAcceptedAPI()
        }else  if notiType.lowercased() == "food_driver_new_order" {
            self.orderFoodDriverAcceptedAPI()
        }else  if notiType.lowercased() == "deligate_new_order_driver" {
            self.acceptDelegateQuoatAPI()
        }else  if notiType.lowercased() == "new_service_request" {
            self.serviceAcceptAPI(service_request_id: serviceData?.id ?? "")
        }else if notiType.lowercased() == "new_playground_booking" {
            self.orderPlayAcceptedAPI()
        }else if notiType.lowercased() == "new_chalet_booking" {
            self.chaledAcceptedAPI()
        }else if  notiType.lowercased() == "new_hotel_booking" {
            self.orderHotelAcceptedAPI()
        }else if  notiType.lowercased() == "new_gym_subscription" {
            
            self.acceptGymManagmentOffer(subscriptionID: subscriptionGymDetails?.id ?? "")

        }else if  notiType.lowercased() == "new_table_booking_placed_store" {
            self.myTableBookingAcceptedAPI()
        }
        
    }
    
    func serviceAcceptAPI(service_request_id:String) {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : service_request_id,
            "amount" : "",
            "service_charges" : "",
            "accept_note" : ""
        ]
        print(parameters)
        ServiceAPIManager.Accept_ProviderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: true)
                {
                    let deleg = UIApplication.shared.delegate as? AppDelegate
                    if let rootVC = deleg?.window?.rootViewController as? UINavigationController
                    {
                    Constants.shared.isCommingFromOrderPopup = true
                    Coordinator.goToServicProviderDetail(controller: rootVC.topViewController, step: "", serviceId: service_request_id, isFromThank: true)
                    }
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    
    func acceptGymManagmentOffer(subscriptionID:String){
           
        let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "subscription_id" : subscriptionID,
                "subscription_no": "",
                "accept_note": ""
            ]
            print(parameters)
            GymAPIManager.acceptSubscriptionAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    
                    self.dismiss(animated: true) 
                    {
                        let deleg = UIApplication.shared.delegate as? AppDelegate
                        if let rootVC = deleg?.window?.rootViewController as? UINavigationController
                        {
                        Constants.shared.isCommingFromOrderPopup = true
                            Coordinator.goToGymRequestDetails(controller: rootVC.topViewController, subscriptionID: subscriptionID, isFromReceived: true)
                        }
                    }
   
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
        }
    }
}

extension ReservationNotificationPopup {
    
    
    func acceptDelegateQuoatAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_id" : self.orderId
        ]
        DelegateServiceAPIManager.driverAcceptServiceAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    //  self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func orderAcceptedEcomerceAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : self.orderId
        ]
        StoreAPIManager.ordersAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    // self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func orderRejectedEcomerceAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : self.orderId
        ]
        print(parameters)
        StoreAPIManager.ordersRejectedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    //  self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func orderAcceptedFoodAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" :  myFoodOrderData?.invoice_id ?? ""
        ]
        FoodAPIManager.ordersAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    // self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func receivedEcommerceOrdesDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : self.orderId,
            "timezone" : localTimeZoneIdentifier
        ]
        StoreAPIManager.receivedOrdersDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myEcommerceOrderData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func receivedFoodOrdesDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : self.orderId,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        FoodAPIManager.receivedOrdersDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myFoodOrderData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func driverOrdesDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : self.orderId,
            "timezone" : localTimeZoneIdentifier,
            "lattitude": SessionManager.getLat() ,
            "longitude":SessionManager.getLng()
        ]
        StoreAPIManager.driverOrdersDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myDriverOrderData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func orderDriverAcceptedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : self.orderId
        ]
        StoreAPIManager.driverAcceptedOrderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    // self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func orderFoodDriverAcceptedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : self.orderId
        ]
        print(parameters)
        FoodAPIManager.driverAcceptedOrderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    func DriverFoodOrderDetails() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : self.orderId,
            "timezone" : localTimeZoneIdentifier,
            "lattitude": SessionManager.getLat() ,
            "longitude":SessionManager.getLng()
        ]
        StoreAPIManager.driverFoodOrdersDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myDriverOrderData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func DriverDelegateOrderDetails() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_id" : self.orderId,
            "lattitude" : SessionManager.getLat(),
            "longitude" : SessionManager.getLng()
            
        ]
        DelegateServiceAPIManager.getDriverRequestDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.servicesDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    func getNewServiceDetails() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_request_id" : self.orderId,
            "lattitude": SessionManager.getLat(),
            "longitude" : SessionManager.getLng(),
        ]
        ServiceAPIManager.providerServiceAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.serviceData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func myGroundBookingDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.orderId,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        StoreAPIManager.myReceiveBookingDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myBookingDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func orderPlayAcceptedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" :  self.orderId
        ]
        print(parameters)
        StoreAPIManager.myPGBookingAcceptAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    // self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func chaledAcceptedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.orderId,
            "status" : "1"
        ]
        print(parameters)
        CharletAPIManager.charletManagmentBookingYesNOAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    // self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func getRequestDetails() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "id" :self.orderId
        ]
        CharletAPIManager.charletManagementBookingDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.RequestData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func orderHotelAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" :  self.orderId
        ]
        print(parameters)
        StoreAPIManager.sellerBookingAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    // self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    func myReceivedBookingDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.orderId,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        StoreAPIManager.sellerBookingDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myHotelBookingDetails = result.oData
                
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    func myReceivedSubscriptionDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "subscription_id": self.orderId
        ]
        print(parameters)
        GymAPIManager.myReceivedSubscriptionDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.subscriptionGymDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.dismiss(animated: true)
                }
            }
        }
        
    }
    func orderRejectedFoodAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : myFoodOrderData?.invoice_id ?? ""
        ]
        print(parameters)
        FoodAPIManager.ordersRejectedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    //  self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func rejectQuoatAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.orderId
        ]
        ServiceAPIManager.reject_quoteAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    //  self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func rejectAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.orderId
        ]
        ServiceAPIManager.reject_ProviderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    //    self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    func orderRejectedPlayGroundAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" :  self.orderId
        ]
        print(parameters)
        StoreAPIManager.myPGBookingRejectAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    // self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    func chaledRejectAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.orderId,
            "status" : "5"
        ]
        CharletAPIManager.charletManagmentBookingYesNOAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    //  self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func orderRejectedHotelAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" :  self.orderId
        ]
        print(parameters)
        StoreAPIManager.sellerBookingRejectAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    // self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func orderRejectedGymAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "subscription_id" :  subscriptionGymDetails?.id ?? ""
        ]
        print(parameters)
        GymAPIManager.rejectGymSubscriptionAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func myTableReceivedBookingDetaisAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.orderId
        ]
        print(parameters)
        StoreAPIManager.receivedTabelBookingdetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.bookingData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    func myTableBookingAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.orderId
        ]
        print(parameters)
        StoreAPIManager.tableBookingAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                    let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                    // self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func myTableBookingRejectAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.orderId
        ]
        print(parameters)
        StoreAPIManager.tableBookingRejectedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.dismiss(animated: false) {
                    self.isCallingAPI = false
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.isCallingAPI = false
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
extension ReservationNotificationPopup {
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale.current
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "d MMM yyyy"
        let resultString = inputFormatter.string(from: showDate ?? Date())
        print(resultString)
        return resultString
    }
}
extension ReservationNotificationPopup:StatusUpdateProtocol{
    func refreshment() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: true) {
                self.isCallingAPI = false
                let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                //self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
            }
        }
    }
}
extension ReservationNotificationPopup:AcceptRequestVCProtocol{
    func refreshmentData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: false) {
                self.isCallingAPI = false
                let DataDict:[String: String] = ["orderId": self.orderId, "type": self.notiType]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDialogNotificationDetails"), object: nil, userInfo: DataDict)
                //  self.delegate?.viewDetails(notiyType: self.notiType, orderId: self.orderId)
            }
        }
    }
}
extension ReservationNotificationPopup: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.myBookingDetails?.slots_list?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCollectionCell", for: indexPath) as? OptionsCollectionCell else { return UICollectionViewCell() }
            cell.isUserInteractionEnabled = false
            cell.timeSlotValue = self.myBookingDetails?.slots_list?[indexPath.row].slot_value_text ?? ""
            cell.namelbl.textColor = UIColor.white
            cell.baseView.backgroundColor = UIColor(hex: "#DA591F")
            cell.baseView.layer.cornerRadius = 14
            cell.baseView.clipsToBounds = true
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let screenSize: CGRect = mainView.bounds
            let screenWidth = screenSize.width-30
            return CGSize(width: screenWidth/3, height:30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

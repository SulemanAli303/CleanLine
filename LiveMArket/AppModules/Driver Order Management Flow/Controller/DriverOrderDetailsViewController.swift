//
//  DriverOrderDetailsViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 27/04/23.
//

import UIKit
import FloatRatingView
import DPOTPView
import NVActivityIndicatorView

class DriverOrderDetailsViewController: BaseViewController {
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var chatWithDelegateView: UIView!
    
    @IBOutlet weak var pScrollView: UIScrollView!
    @IBOutlet weak var userVerificationCodeVoew: UIStackView!
    @IBOutlet weak var orderDeliveryView: UIStackView!
    
    @IBOutlet weak var deliveryChargeView: UIView!
    /// Customer
    @IBOutlet weak var customerImageView: UIImageView!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerPhoneLabel: UILabel!
    @IBOutlet weak var paymentTypeLBL: UILabel!
    
    
    @IBOutlet weak var sellerTxt1: UITextField!
    @IBOutlet weak var sellerTxt2: UITextField!
    @IBOutlet weak var sellerTxt3: UITextField!
    
    
    @IBOutlet weak var userTxt1: UITextField!
    @IBOutlet weak var userTxt2: UITextField!
    @IBOutlet weak var userTxt3: UITextField!
    
    @IBOutlet weak var customerProfileView: UIStackView!
    @IBOutlet weak var sellerVerificationCodeView: UIStackView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var callToCustomerButton: UIButton!
    /// Time and Locations
    @IBOutlet weak var deliveryLoactionLabel: UILabel!
    
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var pickupDistanceLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    
    @IBOutlet weak var yourTimeLabel: UILabel!
    @IBOutlet weak var yourDistanceLabel: UILabel!
    @IBOutlet weak var yourAddressLabel: UILabel!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var driverMapView: UIView!
    
    ///Map View
    @IBOutlet weak var addressImg: UIImageView!
    
    //Billing Details
    @IBOutlet weak var totalItemCountLabel: UILabel!
    @IBOutlet weak var totalItemPriceLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    
    ///Order details
    @IBOutlet weak var rejectAcceptButtonStackView: UIStackView!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var rejectAcceptButtonView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeIconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var clearOrderButton: UIButton!
    @IBOutlet weak var clearOrderHolder: UIView!

    
    @IBOutlet var clearButton: UIButton!
    
    
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var tbl: IntrinsicallySizedTableView!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    
    @IBOutlet weak var paymentTypeView: UIView!
    @IBOutlet weak var paymentMethodsView: UIView!
    @IBOutlet weak var deliveryDetailView: UIStackView!
    
    @IBOutlet weak var mapView: UIView!


    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    
    @IBOutlet weak var verificationView: UIStackView!
    @IBOutlet weak var profileView: UIStackView!
    @IBOutlet weak var lblchatCount: UILabel!
    
    
    
    var VCtype :String?
    var order_ID:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var driverAddress:String = ""
    var isFromFoodOrder:Bool = false
    var isFromThankYou:Bool = false
    var isOrderDeliverd:Bool = false
    var isFromChatDelegate:Bool = false
    var parentController: String = ""
    var isFromNotification:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        // viewControllerTitle = "#LM-501248596038"
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        pScrollView.isHidden = true
        setData()
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)

    }
    @objc func setupNotificationObserver()
    {
        self.driverOrdesDetailsAPI()
        setGradientBackground()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    
    @objc func chatBadgeUpdate(_ notification: Notification) {
       
        self.updateChatBadge()
    }

    @IBOutlet weak var callToDriverButton: UIButton!
    
    @IBAction func callToDriverAction(_ sender: UIButton) {

    }
    @IBAction func calltoCustomerAction(_ sender: UIButton) {
        var phoneNumer = ""
        if  myOrderData?.request_deligate != "2" {
            phoneNumer =  "+\((myOrderData?.driver?.dial_code ?? "").replacingOccurrences(of: "+", with: ""))\(myOrderData?.driver?.phone ?? "")"
        } else {
            phoneNumer = "+\(( myOrderData?.customer?.dial_code ?? "").replacingOccurrences(of: "+", with: ""))\(myOrderData?.customer?.phone ?? "")"
        }
        let url = URL(string: "TEL://\(phoneNumer)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)

    }

    @IBAction func didClickOnMapView(_ sender: UIView) {
        let alertController = UIAlertController(title: "Select Map".localiz(), message: "", preferredStyle: .alert)

            // Add an action (button) to the alert
        let appleAction = UIAlertAction(title: "Apple Map".localiz(), style: .default) { [self] (action) in
                // Handle the "OK" button tap if needed
            if self.myOrderData?.status == "4" {
                let latt = self.myOrderData?.store?.location_data?.lattitude ?? ""
                let lngg = self.myOrderData?.store?.location_data?.longitude ?? ""
                self.openAppleMapsWithDriving(fromLat: SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
            } else {
                let latt = addressPrime?.latitude ?? ""
                let lngg = addressPrime?.longitude ?? ""
                self.openAppleMapsWithDriving(fromLat: SessionManager.getLat(), fromLng: SessionManager.getLng(), toLat: latt, toLng: lngg)
            }
        }

        alertController.addAction(appleAction)
        let googleAction = UIAlertAction(title: "Google Map".localiz(), style: .default) { [self] (action) in
            if myOrderData?.status == "4" {
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
    
    @IBAction func clearOrderBtnTapped(_ sender: Any) {
        let type = myOrderData?.type == "2" ? "2" : "1"
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? "",
            "type": type
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
    

    @IBAction func didClickOnClearOrder(_ sender: UIButton) {



    }

    override func backButtonAction(){

        if Constants.shared.isCommingFromOrderPopup {
            Constants.shared.isDeliveryOrder = false
        }
        
        if isFromThankYou {
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "Delivery Requests")
        } else{

            let navsArr = self.navigationController?.viewControllers
            if navsArr?.count == 3 && ((navsArr?[1].isKind(of: UserServicesList.self)) != nil)
            {
            self.navigationController?.popViewController(animated: true)
            return
            }
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "Delivery Services")

        }

    }

    func updateChatBadge(){
        self.lblchatCount.isHidden = true
        let charRoomID = viewControllerTitle ?? ""
        if chatWithDelegateView.isHidden == false {
            Constants.shared.chatDelegateCountID[charRoomID] = (Constants.shared.chatDelegateCountID[charRoomID] ?? 0) + 1
            if Constants.shared.chatDelegateCountID[charRoomID]! > 0 {
                self.lblchatCount.isHidden = false
                self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[charRoomID]!)"
            }else {
                self.lblchatCount.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.chatBadgeUpdate(_:)), name: Notification.Name("chatDelegate"), object: nil)
        type = .backWithTop
        self.navigationController?.navigationBar.isHidden = false
        //viewControllerTitle = "#LM-501248596038"
        self.topStackView.isHidden = true
        self.clearOrderHolder.isHidden = true

        let tabbar = tabBarController as? TabbarController
        if (VCtype == "8"){
            tabbar?.showTabBar()
        }else {
            tabbar?.hideTabBar()
        }
        
        self.driverOrdesDetailsAPI()
        setGradientBackground()
        //        let tabbar = tabBarController as? TabbarController
        //        tabbar?.showTabBar()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "chatDelegate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // resetChatBadge()
        let charRoomID = viewControllerTitle ?? ""
        if Constants.shared.chatDelegateCountID[charRoomID] == nil {
            Constants.shared.chatDelegateCountID[charRoomID] = 0
        }
        if Constants.shared.chatDelegateCountID[charRoomID]! > 0 {
            self.lblchatCount.isHidden = false
            self.lblchatCount.text = "\(Constants.shared.chatDelegateCountID[charRoomID]!)"
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
    
    var myOrderData:DriverOrderDetailsData? {
        didSet {
            self.topStackView.isHidden = false
            self.pScrollView.isHidden = false
            productArray = myOrderData?.products ?? []
            viewControllerTitle = myOrderData?.invoice_id ?? ""
            storeIconImageView.sd_setImage(with: URL(string: myOrderData?.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            storeNameLabel.text = myOrderData?.store?.name ?? ""
            orderIDLabel.text = myOrderData?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myOrderData?.booking_date ?? "")
            productCountLabel.text = ("\(myOrderData?.total_qty ?? "") \("Products".localiz())")
            amountLabel.text = (myOrderData?.currency_code ?? "") + " " + (myOrderData?.grand_total ?? "")

            self.addressPrime = myOrderData?.address
            self.driverStoreDistance = myOrderData?.driver_store_distance
            self.totalDistance = myOrderData?.total_distance
            self.userStoreDistance = myOrderData?.user_store_distance
            self.customerData = myOrderData?.customer

            if myOrderData?.payment_mode == "1" {
                self.paymentTypeLBL.text = "CARD".localiz()
            } else if myOrderData?.payment_mode == "3" {
                self.paymentTypeLBL.text = "WALLET".localiz()
            } else {
                self.paymentTypeLBL.text = ""
            }
                //  self.paymentTypeLBL.text = myOrderData?.payment_mode ?? ""

                ///Billing Details
            totalItemCountLabel.text = ("\("Item total".localiz()) x\(myOrderData?.total_qty ?? "")")
            totalItemPriceLabel.text = (myOrderData?.currency_code ?? "") + " " + (myOrderData?.total ?? "")
            deliveryChargeLabel.text = (myOrderData?.currency_code ?? "") + " " + (myOrderData?.shipping_charge ?? "")
            taxLabel.text = (myOrderData?.currency_code ?? "") + " " + (myOrderData?.vat ?? "")
            grandTotalLabel.text = (myOrderData?.currency_code ?? "") + " " + (myOrderData?.grand_total ?? "")

            if myOrderData?.shipping_charge ?? "" == "0" || myOrderData?.shipping_charge ?? "" == "0.00" {
                deliveryChargeView.isHidden = true
            } else {
                deliveryChargeView.isHidden = false
            }

            self.rejectAcceptButtonView.isHidden = true
            rejectAcceptButtonStackView.isHidden = true
            self.sellerVerificationCodeView.isHidden = true
            self.chatWithDelegateView.isHidden = true

            self.mapView.isHidden = true
            self.customerProfileView.isHidden = true
            self.userVerificationCodeVoew.isHidden = true
            self.driverMapView.isHidden = true
            
            let statusText = myOrderData?.status_text ?? ""
            statusLbl.text = statusText
            if statusText == "Pending" || statusText == "Waiting for confirmation" || statusText == "Cancelled" || statusText == "Rejected" || statusText == "Auto rejected" || statusText == "Completed" || statusText == "Delivered" || statusText == "Order Delivered" || statusText == "Accepted" {
                clearButton.isHidden = true
            }else {
                clearButton.isHidden = false
            }


            if myOrderData?.status == "6" {
                self.indicator.stopAnimating()
            } else {
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }

            if myOrderData?.status == "3" {
                self.rejectAcceptButtonView.isHidden = false
                rejectAcceptButtonStackView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            } else if myOrderData?.status == "4"{
                self.driverMapView.isHidden = false
                self.mapView.isHidden = false
                self.sellerVerificationCodeView.isHidden = false
                statusColorCode(color: Color.StatusRed.color())
            } else if myOrderData?.status == "5" {
                self.driverMapView.isHidden = false
                self.mapView.isHidden = false
                self.customerProfileView.isHidden = false
                self.userVerificationCodeVoew.isHidden = false
                self.chatWithDelegateView.isHidden = false
                statusColorCode(color: Color.StatusBlue.color())
            } else if myOrderData?.status == "6" {
                callToCustomerButton.isHidden  = true
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                self.chatWithDelegateView.isHidden = false
                self.isOrderDeliverd = true

                if isFromNotification {
                    isFromNotification = false
                    self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Delivered Successfully".localiz(), confirmMessage: "", invoiceID: self.myOrderData?.invoice_id ?? "", viewcontroller: self)
                }
            }
            if isFromChatDelegate {
                isFromChatDelegate = false
                goToChatDetailsScreen()
            }
        }
    }
    
    var customerData:Customer?{
        didSet{
            ///Customer Details
            customerNameLabel.text = customerData?.name ?? ""
            customerPhoneLabel.text = customerData?.phone ?? ""
            customerImageView.sd_setImage(with: URL(string: customerData?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        }
    }
    
    var driverStoreDistance:Driver_store_distance?{
        didSet{
            yourTimeLabel.text = driverStoreDistance?.time ?? ""
            yourDistanceLabel.text = driverStoreDistance?.distance ?? ""
            yourAddressLabel.text = driverAddress
        }
    }
    
    var userStoreDistance:User_store_distance?{
        didSet{
            pickupTimeLabel.text = userStoreDistance?.time ?? ""
            pickupDistanceLabel.text = userStoreDistance?.distance ?? ""
            pickupAddressLabel.text = myOrderData?.store?.location_data?.location_name ?? ""
        }
    }
    var totalDistance:Total_distance?{
        didSet{
            deliveryTimeLabel.text = totalDistance?.time ?? ""
            distanceLabel.text = totalDistance?.distance ?? ""
        }
    }
    
    var addressPrime : Address? {
        didSet {
            self.deliveryLoactionLabel.text = "\(addressPrime?.building_name ?? ""), \(addressPrime?.flat_no ?? ""), \(addressPrime?.address ?? "")"
            
            let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(addressPrime?.latitude ?? ""),\(addressPrime?.longitude ?? "")&\("zoom=15&size=\(510)x310")&sensor=true&key=\(Config.googleApiKey)"
            
            print(staticMapUrl)
            
         
            let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            loadMapFromURL(url!,completion: { self.addressImg.image = $0 })
        }
    }
    
    var productArray:[Products]?{
        didSet{
            print(productArray)
            self.tbl.reloadData()
        }
    }
    
    
    /// Status Color change
    /// - Parameters:
    ///   - color: UIColor
    ///   - isHide: hide indicator and background
    func statusColorCode(color:UIColor,indicatiorHide isHide:Bool = false)  {

        statusLbl.textColor = color
        if isHide{
        } else {
        }
    }
    
    @IBAction func statusPressed(_ sender: Any) {
        if VCtype == "1"
        {
            Coordinator.goToCarbookingDetail(controller: self, step: "2")
        } else if VCtype == "2"
        {
            Coordinator.goToCarbookingDetail(controller: self, step: "8")
        }
    }
    @IBAction func viewMapBtn(_ sender: Any) {
        didClickOnMapView(sender as! UIButton)
//        if isFromFoodOrder {
//            Coordinator.goToTrackOrder(controller: self, trackType: "3",Orderid: self.order_ID)
//        }else {
//            Coordinator.goToTrackOrder(controller: self, trackType: "4",Orderid: self.order_ID)
//        }
    }
    @IBAction func reviewPressed(_ sender: UIButton) {
        
        SellerOrderCoordinator.goToSellerBookingStatus(controller: self, status: "delivery")
    }
    @IBAction func collectedAction(_ sender: UIButton) {
        self.orderCollectedAPI()
    }
    @IBAction func deleveredAction(_ sender: UIButton) {
        
        self.orderDeliveredAPI()
    }
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        
        self.orderAcceptedAPI()
    }
    @IBAction func payNow(_ sender: UIButton) {
        
        Coordinator.goTThankYouPage(controller: self,vcType: "paid", invoiceId: "",order_id:"",isFromFoodStore: false)
    }
    
    @IBAction func chatWithDelegateAction(_ sender: UIButton) {
        goToChatDetailsScreen()
    }
    
    func goToChatDetailsScreen() {
        resetChatBadge()
        var requiredOrderId = myOrderData?.invoice_id ?? ""
        if isFromFoodOrder {
            self.parentController = ParentController.FoodOrderDetail.rawValue
        } else {
            requiredOrderId = self.order_ID
            self.parentController = ParentController.SellerBookingDetail.rawValue
        }
        
        Coordinator.goToChatDetails(delegate: self,
                                    user_id: myOrderData?.customer?.id ?? "",
                                    user_name: myOrderData?.customer?.name ?? "",
                                    userImgae: myOrderData?.customer?.user_image ?? "",
                                    firebaseUserKey: myOrderData?.customer?.firebase_user_key ?? "",
                                    isFromDelegate: true,
                                    isDeliverd: self.isOrderDeliverd,
                                    orderID: myOrderData?.invoice_id ?? "",
                                    isDriver: true,
                                    parentController: self.parentController,
                                    myOrderId: requiredOrderId)
    }
    
    func otpTextFieldSetup(){
        if #available(iOS 12.0, *) {
            
            sellerTxt1.isUserInteractionEnabled = true
            sellerTxt2.isUserInteractionEnabled = true
            sellerTxt3.isUserInteractionEnabled = true
            
            sellerTxt1.textContentType = .oneTimeCode
            sellerTxt2.textContentType = .oneTimeCode
            sellerTxt3.textContentType = .oneTimeCode
            
            sellerTxt1.keyboardType = .numberPad
            sellerTxt2.keyboardType = .numberPad
            sellerTxt3.keyboardType = .numberPad
            
            userTxt1.isUserInteractionEnabled = true
            userTxt2.isUserInteractionEnabled = true
            userTxt3.isUserInteractionEnabled = true
            
            userTxt1.textContentType = .oneTimeCode
            userTxt2.textContentType = .oneTimeCode
            userTxt3.textContentType = .oneTimeCode
            
            userTxt1.keyboardType = .numberPad
            userTxt2.keyboardType = .numberPad
            userTxt3.keyboardType = .numberPad
            
        } else {
            // Fallback on earlier versions
        }
        sellerTxt1.delegate = self
        sellerTxt2.delegate = self
        sellerTxt3.delegate = self
        
        userTxt1.delegate = self
        userTxt2.delegate = self
        userTxt3.delegate = self
    }
    @IBAction func textEditDidBegin(_ sender: UITextField) {
        print("textEditDidBegin has been pressed")
        
        if !(sender.text?.isEmpty)!{
            sender.selectAll(self)
            //buttonUnSelected()
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
            case sellerTxt1:
                sellerTxt2.becomeFirstResponder()
            case sellerTxt2:
                sellerTxt3.becomeFirstResponder()
            case sellerTxt3:
                sellerTxt3.resignFirstResponder()
            case userTxt1:
                userTxt2.becomeFirstResponder()
            case userTxt2:
                userTxt3.becomeFirstResponder()
            case userTxt3:
                userTxt3.resignFirstResponder()
            default:
                print("default")
            }
        }
        
    }
    
    func setData() {
        self.tbl.delegate = self
        self.tbl.dataSource = self
        self.tbl.separatorStyle = .none
        self.tbl.register(FoodItemsCartTableViewCell.nib, forCellReuseIdentifier: FoodItemsCartTableViewCell.identifier)
        self.tbl.register(CarBookingCell.nib, forCellReuseIdentifier: CarBookingCell.identifier)
        self.tbl.register(ProductComboCellTableViewCell.nib, forCellReuseIdentifier: ProductComboCellTableViewCell.identifier)
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
    
    func orderCollectedAPI() {
        let otpString =  "\(sellerTxt1.text ?? "")\(sellerTxt2.text ?? "")\(sellerTxt3.text ?? "")"
        guard otpString != "" else {
            Utilities.showWarningAlert(message: "Please eneter OTP".localiz()) {
                
            }
            return
        }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? "",
            "otp":otpString
        ]
        print(parameters)
        if myOrderData?.type == "1"{
            
            FoodAPIManager.driverCollectedOrderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.driverOrdesDetailsAPI()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            StoreAPIManager.driverCollectedOrderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.driverOrdesDetailsAPI()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
        
    }
    
    func orderDeliveredAPI() {
        let otpString =  "\(userTxt1.text ?? "")\(userTxt2.text ?? "")\(userTxt3.text ?? "")"
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? "",
            "otp":otpString
        ]
        print(parameters)
        
        if myOrderData?.type == "1"{
            FoodAPIManager.driverDeliveredOrderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.isFromNotification = true
                    self.driverOrdesDetailsAPI()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            StoreAPIManager.driverDeliveredOrderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.isFromNotification = true
                    self.driverOrdesDetailsAPI()
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
        
        if myOrderData?.type == "1"{
            FoodAPIManager.driverAcceptedOrderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.driverOrdesDetailsAPI()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            StoreAPIManager.driverAcceptedOrderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.driverOrdesDetailsAPI()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
    func driverOrdesDetailsAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : order_ID,
            "timezone" : localTimeZoneIdentifier,
            "lattitude": SessionManager.getLat(),
            "longitude":SessionManager.getLng()
        ]
        print(parameters)
        
        if isFromFoodOrder{
            StoreAPIManager.driverFoodOrdersDetailsAPI(parameters: parameters) { result in

                switch result.status {
                case "1":
                    self.myOrderData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else{
            StoreAPIManager.driverOrdersDetailsAPI(parameters: parameters) { result in

                switch result.status {
                case "1":
                    self.myOrderData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        self.navigationController?.popViewController(animated: true)
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
extension DriverOrderDetailsViewController : UITableViewDelegate ,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrderData?.products?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tbl.dequeueReusableCell(withIdentifier: FoodItemsCartTableViewCell.identifier) as! FoodItemsCartTableViewCell
        cell.cellType = .driverOrderDetail
        cell.orderDetail = myOrderData?.products?[indexPath.row]
        cell.setdate()
        cell.baseVc = self
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let addOnsListCount = self.myOrderData!.products![indexPath.section].product_combo.count
        let headerHeight = addOnsListCount == 0 ? 0 : 30
        return CGFloat(120 + headerHeight + (addOnsListCount * 35))
    }
 
}
extension DriverOrderDetailsViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = ""
        if textField.text == "" {
            print("Backspace has been pressed")
        }
        
        if string == ""
        {
            print("Backspace was pressed")
            switch textField {
            case sellerTxt2:
                sellerTxt1.becomeFirstResponder()
            case sellerTxt3:
                sellerTxt2.becomeFirstResponder()
            case userTxt2:
                userTxt1.becomeFirstResponder()
            case userTxt3:
                userTxt2.becomeFirstResponder()
            default:
                print("default")
            }
            textField.text = ""
            return false
        }
        
        return true
    }
}

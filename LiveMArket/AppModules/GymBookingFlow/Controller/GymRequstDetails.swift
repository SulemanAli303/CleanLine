//
//  GymRequstDetails.swift
//  LiveMArket
//
//  Created by Zain on 30/01/2023.
//

import UIKit
import NVActivityIndicatorView
import FloatRatingView
class GymRequstDetails: BaseViewController {
    
    @IBOutlet weak var floatRt: UIStackView!
    @IBOutlet var floatRatingView: FloatRatingView!
    
    
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var addSubscriptionButtonStackView: UIStackView!
    @IBOutlet weak var addSubscriptionNumberView: UIView!
    @IBOutlet weak var statusIndicator: NVActivityIndicatorView!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var customerDetailsTitle: UILabel!
    @IBOutlet weak var storeIconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
   // @IBOutlet weak var indicator: UIImageView!
   // @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var subscriptionHeadLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
     @IBOutlet weak var endateLabel: UILabel!
    
    @IBOutlet weak var pPhoneLbl: UILabel!
    ///Billing
    @IBOutlet weak var taxView: UIView!
    @IBOutlet weak var serviceChargeView: UIView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var taxChargeLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var pNameLabel: UILabel!
    @IBOutlet weak var gymImage: UIImageView!
    @IBOutlet weak var locICon: UILabel!
    @IBOutlet weak var mapImage: UIImageView!
    
    
    @IBOutlet weak var paymentTypeView: UIView!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    var subscriptionID:String = ""
    var isFromReceivedSubscription:Bool = false
    var isFrommThankuPage:Bool = false
    var isFromNotification:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        scroller.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        if isFromReceivedSubscription{
            myReceivedSubscriptionDetailsAPI()
        }else{
            mySubscriptionDetailsAPI()
        }
//        DispatchQueue.main.async {
//            if self.statusIndicator != nil {
//                self.statusIndicator.type = NVActivityIndicatorType.lineSpinFadeLoader
//                self.statusIndicator.color = .white
//                self.statusIndicator.startAnimating()
//            }
//        }
        setGradientBackground()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    @objc func setupNotificationObserver()
    {
        isFromNotification = true
        if isFromReceivedSubscription {
            myReceivedSubscriptionDetailsAPI()
        } else {
            mySubscriptionDetailsAPI()
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    
    var subscriptionDetails:SubscriptionDetailsData?{
        
        didSet{
            
            self.scroller.isHidden = false

            viewControllerTitle = subscriptionDetails?.subscription_invoice_id ?? ""
            orderIDLabel.text = subscriptionDetails?.subscription_invoice_id ?? ""
            
            dateLabel.text = self.formatDate(date: subscriptionDetails?.booking_date ?? "")
            amountLabel.text = (subscriptionDetails?.currency_code ?? "") + " " + (subscriptionDetails?.grand_total ?? "")
            statusLbl.text = subscriptionDetails?.status_text ?? ""
            
            subscriptionHeadLabel.text = subscriptionDetails?.subscription_title ?? ""
            currencyLabel.text = subscriptionDetails?.currency_code ?? ""
            priceLabel.text = subscriptionDetails?.sub_total ?? ""
            
            nameTextField.text = subscriptionDetails?.full_name ?? ""
            ageTextField.text = subscriptionDetails?.age ?? ""
            genderTextField.text = subscriptionDetails?.gender ?? ""
            emailTextField.text = subscriptionDetails?.email ?? ""
            phoneTextField.text = "+" + ((subscriptionDetails?.dial_code ?? "").replacingOccurrences(of: "+", with: "")) + " " + (subscriptionDetails?.phone ?? "")
            endateLabel.text = "\("End Date".localiz()) : \(subscriptionDetails?.subscription_end_date ?? "")"
            customerDetailsTitle.text = "Gym Details".localiz()
            self.pNameLabel.text = subscriptionDetails?.store?.name
            if let phone = subscriptionDetails?.store?.phone{
                pPhoneLbl.isHidden = false
                pPhoneLbl.text = "+" + phone.replacingOccurrences(of: "+", with: "")
            }
            
            if let url = URL(string: subscriptionDetails?.store?.user_image ?? ""){
                gymImage.sd_setImage(with: url)
            }
            
            if let locationData = subscriptionDetails?.store?.location_data{
                let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(locationData.lattitude ?? ""),\(locationData.longitude ?? "")&\("zoom=15&size=\(340)x130")&sensor=true&key=\(Config.googleApiKey)"
                
                let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                self.mapImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_profile"))
                
                locICon.text = locationData.location_name
            }

            
            if subscriptionDetails?.service_charge ?? "" == "0"{
                serviceChargeView.isHidden = true
            }else{
                serviceChargeView.isHidden = false
            }
            
            if subscriptionDetails?.tax ?? "" == "0"{
                taxView.isHidden = true
            }else{
                taxView.isHidden = false
            }
        
            ///Billing
            subTotalLabel.text = (subscriptionDetails?.currency_code ?? "") + " " + (subscriptionDetails?.sub_total ?? "")
            taxChargeLabel.text = (subscriptionDetails?.currency_code ?? "") + " " + (subscriptionDetails?.tax ?? "")
            grandTotalLabel.text = (subscriptionDetails?.currency_code ?? "") + " " + (subscriptionDetails?.grand_total ?? "")
            serviceChargeLabel.text = (subscriptionDetails?.currency_code ?? "") + " " + (subscriptionDetails?.service_charge ?? "")
            
            addSubscriptionNumberView.isHidden = true
            addSubscriptionButtonStackView.isHidden = true
         
            floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
            floatRatingView.type = .halfRatings
            floatRatingView.rating = Double(self.subscriptionDetails?.ratings ?? "") ?? 0
            if self.subscriptionDetails?.ratings ?? "" == "" {

            }
            self.floatRt.isHidden = true
            
            if subscriptionDetails?.subscription_status == "1" || subscriptionDetails?.subscription_status == "11" || subscriptionDetails?.subscription_status == "10"{
                self.statusIndicator.stopAnimating()
            }else{
                self.statusIndicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.statusIndicator.color = .white
                self.statusIndicator.startAnimating()
            }
            
            if isFromReceivedSubscription {

                if let paymentType = subscriptionDetails?.payment_type_text , paymentType != "" {
                    paymentTypeView.isHidden = false
                    paymentTypeLabel.text = paymentType
                }
                
                storeIconImageView.sd_setImage(with: URL(string: subscriptionDetails?.user?.image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                storeNameLabel.text = subscriptionDetails?.user?.user_name ?? ""
                
                if subscriptionDetails?.subscription_status == "0"{
                    addSubscriptionNumberView.isHidden = false
                    addSubscriptionButtonStackView.isHidden = false
                    statusColorCode(color: Color.StatusYellow.color())
                }else if subscriptionDetails?.subscription_status == "1"{
                   
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    if isFromNotification{
                        isFromNotification = false
                        self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Subscription Confirmed".localiz(), confirmMessage: "", invoiceID: subscriptionDetails?.subscription_invoice_id ?? "", viewcontroller: self)
                    }
                }else if subscriptionDetails?.subscription_status == "2"{
                    statusColorCode(color: Color.StatusRed.color())
                }else if subscriptionDetails?.subscription_status == "5"{
                    statusColorCode(color: Color.StatusBlue.color())
                }else if subscriptionDetails?.subscription_status == "6"{
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
//                    self.floatRt.isHidden = false
                    
                }else if subscriptionDetails?.subscription_status == "10" || subscriptionDetails?.subscription_status == "12"{
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                }else{
                    statusColorCode(color: Color.StatusRed.color())
                }
            } else {

                if let paymentType = subscriptionDetails?.payment_type , paymentType != "" {
                    paymentTypeView.isHidden = false
                    paymentTypeLabel.text = paymentType
                }
                
                storeIconImageView.sd_setImage(with: URL(string: subscriptionDetails?.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                storeNameLabel.text = subscriptionDetails?.store?.name ?? ""
                
                if subscriptionDetails?.subscription_status == "0"{
                    statusColorCode(color: Color.StatusYellow.color())
                }else if subscriptionDetails?.subscription_status == "1"{
                    self.floatRt.isHidden = false
                    
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: false)
                    if isFromNotification{
                        isFromNotification = false
                        self.showCompletedPopup(titleMessage: "Subscription Confirmed".localiz(), confirmMessage: "", invoiceID: subscriptionDetails?.subscription_invoice_id ?? "", viewcontroller: self)
                    }
                }else if subscriptionDetails?.subscription_status == "2"{
                    statusColorCode(color: Color.StatusRed.color())
                }else if subscriptionDetails?.subscription_status == "5"{
                    statusColorCode(color: Color.StatusBlue.color())
                }else if subscriptionDetails?.subscription_status == "6"{
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    
                    
                }else if subscriptionDetails?.subscription_status == "10" || subscriptionDetails?.subscription_status == "12"{
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                }else{
                    statusColorCode(color: Color.StatusRed.color())
                }
            }
            
            
            
        }
    }
    
    @IBAction func rateButtonAction(_ sender: UIButton) {
//        let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
//        VC.myTableBookingData = bookingData
//        VC.isFromTableBooking = true
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func FloatAction(_ sender: UIButton) {
        if let isRated = self.subscriptionDetails?.is_rated , isRated == "0" {
            let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
            VC.subscriptionDetails = self.subscriptionDetails
//            VC.isFromOrder = true
//            VC.isFromStore = true
            VC.isFromGymScreen = true
//            VC.isFromHotelBooking = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        
    }
    @objc func showRating()
    {
        let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
        VC.subscriptionDetails = self.subscriptionDetails
        VC.isFromOrder = true
        VC.isFromStore = true
        VC.isFromGymScreen = true
        VC.isFromHotelBooking = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func addSubscriptionAction(_ sender: UIButton) {
        self.acceptSubscriptionAPI()
    }
    @IBAction func locationTapped(_ sender: Any) {
        
        if let locationData = subscriptionDetails?.store?.location_data{
            self.showMapOptions(latitude: locationData.lattitude ?? "", longitude: locationData.longitude ?? "", name: locationData.location_name ?? "")
        }
    }
    
    func acceptSubscriptionAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "subscription_id" : self.subscriptionID,
            "subscription_no": "",
            "accept_note": ""
        ]
        print(parameters)
        self.isFromNotification = true
        GymAPIManager.acceptSubscriptionAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myReceivedSubscriptionDetailsAPI()
                
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
        
    }
    
    override func backButtonAction() {
        if isFrommThankuPage{
           // Coordinator.updateRootVCToTab()
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "Subscriptions")
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: - Methods
    
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "d MMM yyyy h:mma"
        let resultString = inputFormatter.string(from: showDate ?? Date())
        print(resultString)
        return resultString
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
    
    //MARK: - API Calls
    
    func mySubscriptionDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "subscription_id": subscriptionID
        ]
        print(parameters)
        GymAPIManager.mySubscriptionDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                print(result.oData)
                self.subscriptionDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
        
    }
    
    func myReceivedSubscriptionDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "subscription_id": subscriptionID
        ]
        print(parameters)
        GymAPIManager.myReceivedSubscriptionDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.subscriptionDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
        
    }
   
    
    /// Status Color change
    /// - Parameters:
    ///   - color: UIColor
    ///   - isHide: hide indicator and background
    func statusColorCode(color:UIColor,indicatiorHide isHide:Bool = false)  {
        //statusView.backgroundColor = color
        //indicator.backgroundColor  = color
        statusLbl.textColor = color
        if isHide{
            //statusIndicator.isHidden       = true
            //statusIndicator.isHidden = true
        }else{
            //statusIndicator.isHidden       = false
            //statusIndicator.isHidden = false
        }
    }
}
extension GymRequstDetails:StatusUpdateProtocol{
    func refreshment() {
        DispatchQueue.main.async {
            if self.isFromReceivedSubscription{
                self.myReceivedSubscriptionDetailsAPI()
            }else{
                self.mySubscriptionDetailsAPI()
            }
        }
        
    }
}

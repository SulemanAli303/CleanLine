//
//  RateVC.swift
//  LiveMArket
//
//  Created by Zain on 17/01/2023.
//

import UIKit
import STRatingControl
import KMPlaceholderTextView
import Cosmos

protocol willDoLaterProtocol{
    func updateWillDoLater()
}

class RateVC: UIViewController {
    
    @IBOutlet weak var writeReviewLabel: UILabel!
    @IBOutlet weak var howExperienceLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var willLaterButton: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var dateHeadingLbl: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var deliveryView: UIStackView!
    @IBOutlet weak var rateView: CosmosView!{
        didSet{
            rateView.settings.fillMode = .half
            rateView.settings.starMargin = 10
            rateView.settings.starSize = 30
            rateView.settings.minTouchRating = 0
        }
    }
    @IBOutlet weak var reviewTextView: KMPlaceholderTextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var vehicleImageview: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    var myTableBookingData:TableBookDetailsData?
    var myOrderData:MyOrderDetailsData?
    var myOrderDetails:GroundBookingDetailsData?
    var myBookingDetails:HotelBookingDetailsData?
    var isFromOrder:Bool = false
    var isFromServices = false
    var isFromStore = false
    var isFromTableBooking = false
    var isFromGroundBooking = false
    var isFromHotelBooking = false
    var isFromGymScreen = false
    var shouldRateStore = false
    var userServicesDelegateDetails : DelegateDetailsServicesData?
    var delegate:willDoLaterProtocol?
    var serviceData : ServiceData?
    var userData:User?
    var subscriptionDetails:SubscriptionDetailsData?

    override func viewDidLoad() {
        super.viewDidLoad()
        configLanguage()
        userData = SessionManager.getUserData()
    }
    //MARK: - Actions
    @IBAction func Latter(_ sender: Any) {
        self.delegate?.updateWillDoLater()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submit(_ sender: Any) {
        
        guard reviewTextView.text != "" else {
            Utilities.showWarningAlert(message: "Please type your review.".localiz()) {
                
            }
            return
        }
        guard rateView.rating != 0 else {
            Utilities.showWarningAlert(message: "Please select rating star".localiz()) {
                
            }
            return
        }
        
        if isFromGymScreen == true{
            self.rateGymAPI()
        }
        else if userServicesDelegateDetails != nil
        {
            self.rateServicesDelegateAPI()
        }
        else if userData?.user_type_id == "1"
        {
            if userData?.activity_type_id == "12"
            {
                if shouldRateStore
                {
                    self.rateStoreAPI()
                }
                else if isFromStore
                {
                    rateFoodStoreAPI()
                }
                else
                {
                    rateDriverAPI()
                }
                
            }
            else
            {
                if isFromOrder
                {
                    rateDriverAPI()
                }
                else
                {
                    if isFromGroundBooking
                    {
                        rateGroundStoreAPI()
                    }
                    else if isFromHotelBooking
                    {
                        rateHotelAPI()
                    }
                    else if isFromTableBooking
                    {
                        rateTableBookingAPI()
                    }else
                    {
                        rateStoreAPI()
                    }
                }
            }
            
        }
        else if serviceData != nil
        {
            rateServicesAPI()
        }
        else
        {
            if isFromStore
            {
                if isFromGroundBooking
                {
                    rateGroundStoreAPI()
                }
                else if isFromHotelBooking
                {
                    rateHotelAPI()
                }
                else
                {
                    rateStoreAPI()
                }
               
            }
            else if isFromTableBooking
            {
                rateTableBookingAPI()
            }
            else
            {
                rateDriverAPI()
            }
            
        }
        
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        
        if let data = myOrderData{
            if isFromOrder{
                profileName.text = data.driver?.name ?? ""
                profileImageView.sd_setImage(with: URL(string: data.driver?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                vehicleImageview.sd_setImage(with: URL(string: data.deligate?.deligate_icon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                deliveryDateLabel.text = self.formatDate1(date:  data.delivery_date ?? "")
            }else{
                profileName.text = data.store?.name ?? ""
                profileImageView.sd_setImage(with: URL(string: data.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                vehicleImageview.isHidden = false
                vehicleImageview.image = UIImage(named: "storeIcon")
                deliveryDateLabel.text = self.formatDate1(date:  data.delivery_date ?? "")
            }
            
        }
        if let data = serviceData{
            profileName.text = data.store?.name ?? ""
            profileImageView.sd_setImage(with: URL(string: data.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            deliveryDateLabel.text = data.completed_on
            vehicleImageview.isHidden = true
            self.deliveryStatusLabel.text = "Completed".localiz()
            self.dateHeadingLbl.text = "COMPLETED ON".localiz()
        }
        if let data = myOrderDetails{
            profileName.text = data.booking?.vendor?.name ?? ""
            profileImageView.sd_setImage(with: URL(string: data.booking?.vendor?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
           deliveryDateLabel.text = ""
            vehicleImageview.isHidden = true
            deliveryDateLabel.text = data.booking?.end_date_time ?? ""
            self.deliveryStatusLabel.text = "Completed".localiz()
            self.dateHeadingLbl.text = "COMPLETED ON".localiz()
        }
        
        if let data = myTableBookingData{
            profileName.text = data.store?.name ?? ""
            profileImageView.sd_setImage(with: URL(string: data.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            deliveryDateLabel.text = ""
            vehicleImageview.isHidden = true
            deliveryDateLabel.text = data.completed_on ?? ""
            addressLabel.text = data.store?.location_data?.location_name ?? ""
            self.deliveryStatusLabel.text = "Completed".localiz()
            self.dateHeadingLbl.text = "COMPLETED ON".localiz()
            self.deliveryView.isHidden = false
        }
        
        if let data = myBookingDetails{
            profileName.text = data.booking?.vendor?.name ?? ""
            profileImageView.sd_setImage(with: URL(string: data.booking?.vendor?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
           deliveryDateLabel.text = ""
            vehicleImageview.isHidden = true
            deliveryDateLabel.text = self.formatDate(date: myBookingDetails?.booking?.completed_on ?? "")
            self.deliveryStatusLabel.text = "Completed".localiz()
            self.dateHeadingLbl.text = "COMPLETED ON".localiz()
        }
        if let data = userServicesDelegateDetails{
                profileName.text = data.data?.driver?.name ?? ""
                profileImageView.sd_setImage(with: URL(string: data.data?.driver?.userImage ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
               deliveryDateLabel.text = (data.data?.completedOn ?? "").changeTimeToFormat(frmFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd EEE yyyy hh:mm a")
          //  vehicleImageview.sd_setImage(with: URL(string: data.data?.deliveryType?.deligateIcon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            
            vehicleImageview.sd_setImage(with: URL(string: data.data?.deliveryType?.deligateIcon ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile")){ image, error, cache, url in
                self.vehicleImageview.image = image
                let tintColor = UIColor(hex: "F6B400")
                let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                self.vehicleImageview.tintColor = tintColor
                self.vehicleImageview.image = tintedImage
            }
            
                vehicleImageview.isHidden = false
        }
        
        if let data = subscriptionDetails{
            dateHeadingLbl.text = self.formatDate(date: subscriptionDetails?.booking_date ?? "")
            profileName.text = subscriptionDetails?.subscription_invoice_id ?? ""
            vehicleImageview.sd_setImage(with: URL(string: subscriptionDetails?.user?.image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            deliveryDateLabel.text = "\("End Date".localiz()) : \(subscriptionDetails?.subscription_end_date ?? "")"

        }
        if isFromOrder{
            deliveryView.isHidden = false
        }
        
        //self.rateDriverAPI()
        if isFromGymScreen == true{
            dateHeadingLbl.text = "COMPLETED ON:".localiz()
            self.vehicleImageview.isHidden = true
            if let url = URL(string: subscriptionDetails?.store?.user_image ?? ""){
                profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_profile"))
            }
            deliveryView.isHidden = false
            let timeText = (subscriptionDetails?.subscription_end_date ?? "").changeTimeToFormat(frmFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd EEE yyyy hh:mm a")
            deliveryDateLabel.text = timeText
            deliveryStatusLabel.text = "Completed".localiz()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    
    
    func configLanguage(){
        writeReviewLabel.text = "WRITE A REVIEW".localiz()
        howExperienceLabel.text = "HOW WAS YOUR EXPERIENCE?".localiz()
        submitButton.setTitle("Submit".localiz(), for: .normal)
        willLaterButton.setTitle("WILL DO IT LATER".localiz(), for: .normal)
    }
    
    //MARK: - API Calls
    
    func rateGymAPI(){
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "subscription_id" : subscriptionDetails?.id ?? "",
            "rating" : "\(rateView.rating)",
            "review":reviewTextView.text ?? ""
        ]
        print(parameters)
        StoreAPIManager.rateGymAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func rateDriverAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? "",
            "rating" : "\(rateView.rating)",
            "review":reviewTextView.text ?? ""
        ]
        print(parameters)
        StoreAPIManager.rateDriverAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func rateStoreAPI() {
        var id = ""
        if myOrderData != nil {
            id = myOrderData?.order_id ?? ""
        }else if serviceData != nil {
            id = serviceData?.id ?? ""
        }else if myTableBookingData != nil {
            id = myTableBookingData?.store_id ?? ""
        }
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : id,
            "rating" : "\(rateView.rating)",
            "review":reviewTextView.text ?? ""
        ]
        print(parameters)
        StoreAPIManager.rateStoreAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func rateTableBookingAPI() {
        var id = ""
        id = myTableBookingData?.id ?? ""
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : id,
            "rating" : "\(rateView.rating)",
            "review":reviewTextView.text ?? ""
        ]
        print(parameters)
        StoreAPIManager.rateTabelBookingAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func rateGroundStoreAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myOrderDetails?.booking?.booking_id ?? "",
            "ratings" : "\(rateView.rating)",
            "comment":reviewTextView.text ?? ""
        ]
        print(parameters)
        StoreAPIManager.rateGroundStoreAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func rateFoodStoreAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? "",
            "rating" : "\(rateView.rating)",
            "review":reviewTextView.text ?? ""
        ]
        print(parameters)
        FoodAPIManager.rateStoreAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func rateServicesDelegateAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_id" :self.userServicesDelegateDetails?.data?.id ?? "",
            "rating" : "\(rateView.rating)",
            "review":reviewTextView.text ?? ""
        ]
        print(parameters)
        DelegateServiceAPIManager.rateDelegateAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func rateFoodDriverAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrderData?.order_id ?? "",
            "rating" : "\(rateView.rating)",
            "review":reviewTextView.text ?? ""
        ]
        print(parameters)
        FoodAPIManager.rateDriverAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func rateServicesAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceData?.id ?? "",
            "rating" : "\(rateView.rating)",
            "review":reviewTextView.text ?? ""
        ]
        print(parameters)
        StoreAPIManager.rateServicesAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func rateHotelAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.myBookingDetails?.booking?.booking_id ?? "",
            "ratings" : "\(rateView.rating)",
            "comment":reviewTextView.text ?? ""
        ]
        print(parameters)
        StoreAPIManager.hotelRateAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    //MARK: - Date Convertion
    func formatDate(date: String) -> String {
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
    
    func formatDate1(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "d MMM yyyy h:mma"
        let resultString = inputFormatter.string(from: showDate ?? Date())
        print(resultString)
        return resultString
    }
    
    
}

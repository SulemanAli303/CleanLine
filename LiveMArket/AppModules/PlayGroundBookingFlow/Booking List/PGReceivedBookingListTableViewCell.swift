//
//  PGReceivedBookingListTableViewCell.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/08/23.
//

import UIKit

protocol GroundBookingDelegate:AnyObject{
    func refreshList()
}

class PGReceivedBookingListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startToPrepareView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var readyForCollectionView: UIView!
    @IBOutlet weak var statusIndicatorBgImageView: UIImageView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var orderAcceptView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bookingTextLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var invoiceIDLabel: UILabel!
    var parent :UIViewController!
    
    weak var delegate:GroundBookingDelegate?
    var userTypeID:String?
    var isFromHotel:Bool = false
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setGradientBackground()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    var isHotel:Bool?{
        didSet{
            isFromHotel = isHotel ?? false
        }
    }
    
    var myList : GroundReceivedBookingList?{
        
        didSet{
            amountLabel.text = myList?.total_amount ?? ""
            storeImageView.sd_setImage(with: URL(string: myList?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myList?.user?.name ?? ""
            invoiceIDLabel.text = myList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myList?.created_at ?? "")
            statusLabel.text = myList?.booking_status_text ?? ""
            bookingTextLabel.text = "Play Ground Booking".localiz()
            orderAcceptView.isHidden = true
            readyForCollectionView.isHidden = true
            startToPrepareView.isHidden = true
            
        }
    }
    var myHotelBookingList : HotelBookingList?{
        
        didSet{
            amountLabel.text = myHotelBookingList?.total_amount ?? ""
            storeImageView.sd_setImage(with: URL(string: myHotelBookingList?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myHotelBookingList?.user?.name ?? ""
            invoiceIDLabel.text = myHotelBookingList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myHotelBookingList?.created_at ?? "")
            statusLabel.text = myHotelBookingList?.booking_status_text ?? ""
            bookingTextLabel.text = "Hotel Booking".localiz()
            orderAcceptView.isHidden = true
            readyForCollectionView.isHidden = true
            startToPrepareView.isHidden = true
            //rejectAcceptButtonView.isHidden = true
            if myHotelBookingList?.booking_status == "0"{
                orderAcceptView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            }else if myHotelBookingList?.booking_status == "1" || myHotelBookingList?.booking_status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myHotelBookingList?.booking_status == "4"{
                statusColorCode(color: Color.StatusGreen.color())
            }else if myHotelBookingList?.booking_status == "5"{
                statusColorCode(color: Color.StatusBlue.color())
            }else if myHotelBookingList?.booking_status == "6"{
                statusColorCode(color: Color.StatusRed.color(),indicatiorHide: true)
            }else if myHotelBookingList?.booking_status == "10" || myHotelBookingList?.booking_status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }else{
                //statusColorCode(color: Color.StatusRed.color())
            }
            
        }
    }
    var currencyCode_Hotel:String?{
        didSet{
            
            if myList != nil {
                amountLabel.text = (currencyCode_Hotel ?? "") + " " + (myHotelBookingList?.total_amount ?? "")
            }
        }
    }
    
//    var servicesData : ServiceData? {
//        didSet {
//            storeImageView.sd_setImage(with: URL(string: servicesData?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
//            storeNameLabel.text = servicesData?.user?.name ?? ""
//            invoiceIDLabel.text = servicesData?.service_invoice_id ?? ""
//            dateLabel.text = self.formatDate(date: servicesData?.booking_date ?? "")
//            bookingTextLabel.text = "Service Request"
//            statusLabel.text = servicesData?.status_text ?? ""
//
//            self.indicator.isHidden = false
//            statusIndicatorBgImageView.isHidden = false
//            orderAcceptView.isHidden = true
//
//            if (self.servicesData?.status ?? "" == "0"){
//                self.statusBarView.backgroundColor = UIColor(hex: "FCB813")
//                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "FCB813")
//                orderAcceptView.isHidden = false
//
//            }else if (self.servicesData?.status ?? "" == "10" || self.servicesData?.status ?? "" == "11"){
//                self.statusBarView.backgroundColor = UIColor(hex: "F57070")
//                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "F57070")
//                self.indicator.isHidden = true
//                statusIndicatorBgImageView.isHidden = true
//            }
//
//        }
//    }
//    var myBookingOrder:CharletBookingList?{
//        didSet{
//
//            storeImageView.sd_setImage(with: URL(string: myBookingOrder?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
//            storeNameLabel.text = myBookingOrder?.user_name ?? ""
//            invoiceIDLabel.text = myBookingOrder?.booking_id ?? ""
//            dateLabel.text = self.myBookingOrder?.created_at_format ?? ""
//            bookingTextLabel.text = "Chalet Request"
//            statusLabel.text = myBookingOrder?.booking_status ?? ""
//            self.indicator.isHidden = false
//            statusIndicatorBgImageView.isHidden = false
//            orderAcceptView.isHidden = true
//
//            if (myBookingOrder?.booking_status_number ?? "" == "0"){
//                self.statusBarView.backgroundColor = UIColor(hex: "FCB813")
//                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "FCB813")
//                orderAcceptView.isHidden = false
//
//            }else if (myBookingOrder?.booking_status_number ?? "" == "5"){
//                self.statusBarView.backgroundColor = UIColor(hex: "F57070")
//                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "F57070")
//                self.indicator.isHidden = true
//                statusIndicatorBgImageView.isHidden = true
//            }else if (myBookingOrder?.booking_status_number ?? "" == "4"){
//                self.statusBarView.backgroundColor = UIColor(hex: "00B24D")
//                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "00B24D")
//                self.indicator.isHidden = true
//                statusIndicatorBgImageView.isHidden = true
//            }else if (myBookingOrder?.booking_status_number ?? "" == "2"){
//                self.statusBarView.backgroundColor = UIColor(hex: "F57070")
//                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "F57070")
//
//            }
//
//        }
//    }
    
    var currencyCode:String?{
        didSet{
            
            if myList != nil {
                amountLabel.text = (currencyCode ?? "") + " " + (myList?.total_amount ?? "")
            }
        }
    }
    var userData: User?{
        didSet{
            userTypeID = userData?.user_type_id ?? ""
            
            ///Type = 1 is Resturant Store
            if userTypeID == "1"{
                if userData?.activity_type_id == "10"{
                    if myList?.booking_status == "0"{
                        orderAcceptView.isHidden = false
                        statusColorCode(color: Color.StatusYellow.color())
                    }else if myList?.booking_status == "1"{
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.booking_status == "2"{
                      //  readyForCollectionView.isHidden = false
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.booking_status == "5"{
                        statusColorCode(color: Color.StatusBlue.color())
                    }else if myList?.booking_status == "6"{
                        statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    }else if myList?.booking_status == "10" || myList?.booking_status == "12"{
                        statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                    }else{
                        statusColorCode(color: Color.StatusRed.color())
                    }
                }else if userData?.activity_type_id == "12"{
                    if myList?.booking_status == "0"{
                        orderAcceptView.isHidden = false
                        statusColorCode(color: Color.StatusYellow.color())
                    }else if myList?.booking_status == "1"{
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.booking_status == "2"{
                        startToPrepareView.isHidden = false
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.booking_status == "5"{
                        statusColorCode(color: Color.StatusBlue.color())
                    }else if myList?.booking_status == "6"{
                        statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    }else if myList?.booking_status == "10" || myList?.booking_status == "12"{
                        statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                    }else{
                        statusColorCode(color: Color.StatusRed.color())
                    }
                    
                }else{
                    if myList?.booking_status == "0"{
                        orderAcceptView.isHidden = false
                        statusColorCode(color: Color.StatusYellow.color())
                    }else if myList?.booking_status == "1"{
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.booking_status == "2"{
                      //  readyForCollectionView.isHidden = false
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.booking_status == "5"{
                        statusColorCode(color: Color.StatusBlue.color())
                    }else if myList?.booking_status == "6"{
                        statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    }else if myList?.booking_status == "10" || myList?.booking_status == "12"{
                        statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                    }else{
                        statusColorCode(color: Color.StatusRed.color())
                    }
                }
                
            }else{
                if myList?.booking_status == "0"{
                    orderAcceptView.isHidden = false
                    statusColorCode(color: Color.StatusYellow.color())
                }else if myList?.booking_status == "1"{
                    statusColorCode(color: Color.StatusRed.color())
                }else if myList?.booking_status == "2"{
                   // readyForCollectionView.isHidden = false
                    statusColorCode(color: Color.StatusRed.color())
                }else if myList?.booking_status == "4"{
                    statusColorCode(color: Color.StatusGreen.color())
                }else if myList?.booking_status == "5"{
                    statusColorCode(color: Color.StatusBlue.color())
                }else if myList?.booking_status == "6"{
                    statusColorCode(color: Color.StatusRed.color(),indicatiorHide: true)
                }else if myList?.booking_status == "10" || myList?.booking_status == "12"{
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                }else{
                    statusColorCode(color: Color.StatusRed.color())
                }
            }
        }
    }
    
    
    /// Status Color change
    /// - Parameters:
    ///   - color: UIColor
    ///   - isHide: hide indicator and background
    func statusColorCode(color:UIColor,indicatiorHide isHide:Bool = false)  {
        statusBarView.backgroundColor = color
        statusIndicatorBgImageView.backgroundColor  = color
        if isHide{
            statusIndicatorBgImageView.isHidden       = true
            indicator.isHidden = true
        }else{
            statusIndicatorBgImageView.isHidden       = false
            indicator.isHidden = false
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
    
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: date) ?? Date()
        inputFormatter.dateFormat = "d MMM yyyy h:mma"
        let resultString = inputFormatter.string(from: showDate)
        print(resultString)
        return resultString
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        
//        if let dateFromString = dateFormatter.date(from: date) {
//            let formatter = DateFormatter()
//            formatter.timeZone = TimeZone.current
//            formatter.dateFormat = "d MMM yyyy h:mma"
//            let dateString = formatter.string(from: dateFromString)
//            return dateString
//        }
//        return ""
    }
    
    
    //MARK: - IBActions
    @IBAction func startToPrepareAction(_ sender: UIButton) {
        orderStartToPrepareAPI()
    }
    @IBAction func readyForCollectionAction(_ sender: UIButton) {
        orderReadyForDeliveryAPI()
    }
    @IBAction func rejectAction(_ sender: UIButton) {
        orderRejectedAPI()
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
        orderAcceptedAPI()
    }
    
    //MARK: - API Calls
    
    func orderAcceptedAPI() {
        
        
        if isFromHotel{
            
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "booking_id" : myHotelBookingList?.booking_id ?? ""
            ]
            print(parameters)
            
            StoreAPIManager.sellerBookingAcceptedAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.delegate?.refreshList()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }

        }else{
            
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "booking_id" : myList?.booking_id ?? ""
            ]
            print(parameters)
            
            StoreAPIManager.myPGBookingAcceptAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.delegate?.refreshList()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    

    
    func orderServicesAccepted() {
        //Coordinator.goToAcceptRequestVC(controller: parent, step: "",service_request_id: servicesData?.id,service_inVoice: servicesData?.service_invoice_id)
    }
    func orderRejectedAPI() {
        
        
        if isFromHotel{
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "booking_id" : myHotelBookingList?.booking_id ?? ""
            ]
            print(parameters)
            
            StoreAPIManager.sellerBookingRejectAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.delegate?.refreshList()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "booking_id" : myList?.booking_id ?? ""
            ]
            print(parameters)
            
            StoreAPIManager.myPGBookingRejectAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.delegate?.refreshList()
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
            "order_id" : myList?.booking_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.ordersDreadyForDeliveryAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.refreshList()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func orderStartToPrepareAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : myList?.booking_id ?? ""
        ]
        print(parameters)
        FoodAPIManager.ordersPreparedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.refreshList()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

//
//  ReceivedSubscriptionTableViewCell.swift
//  LiveMArket
//
//  Created by Greeniitc on 17/05/23.
//

import UIKit
import NVActivityIndicatorView


class ReceivedSubscriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var indicatorImageView: NVActivityIndicatorView!
    
    @IBOutlet weak var orderAceptButtonStacView: UIStackView!
    @IBOutlet weak var addBurron: UIButton!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var orderAcceptView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bookingTextLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var invoiceIDLabel: UILabel!
    
    var userTypeID:String?
    
    
    
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
    
    var myList : SubscriptionList?{
        
        didSet{
            
//            if self.indicatorImageView != nil {
//                self.indicatorImageView.type = NVActivityIndicatorType.lineSpinFadeLoader
//                self.indicatorImageView.color = .white
//                self.indicatorImageView.startAnimating()
//            }
            
            amountLabel.text = myList?.grand_total ?? ""
            storeImageView.sd_setImage(with: URL(string: myList?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myList?.user?.name ?? ""
            invoiceIDLabel.text = myList?.subscription_invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myList?.booking_date ?? "")
            statusLabel.text = myList?.status_text ?? ""
            bookingTextLabel.text = "Club Subscription".localiz()
            orderAcceptView.isHidden = true
            orderAceptButtonStacView.isHidden = true
            
            if myList?.subscription_status == "0"{
                orderAcceptView.isHidden = false
                orderAceptButtonStacView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color(),indicatiorHide: true)
            }else if myList?.subscription_status == "1"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myList?.subscription_status == "2"{
                statusColorCode(color: Color.StatusRed.color(),indicatiorHide: true)
            }else if myList?.subscription_status == "5"{
                statusColorCode(color: Color.StatusBlue.color(),indicatiorHide: true)
            }else if myList?.subscription_status == "6"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myList?.subscription_status == "10" || myList?.subscription_status == "12" || myList?.subscription_status == "11"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusRed.color(),indicatiorHide: true)
            }
            if isDateStringEqualToCurrentDate(myList?.subscription_end_date ?? ""){
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: false)
            }
            
            if myList?.subscription_status == "1" || myList?.subscription_status == "11" || myList?.subscription_status == "10"{
                self.indicatorImageView.stopAnimating()
            }else{
                self.indicatorImageView.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicatorImageView.color = .white
                self.indicatorImageView.startAnimating()
            }
            
        }
    }
    
    var servicesData : ServiceData? {
        didSet {
            storeImageView.sd_setImage(with: URL(string: servicesData?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = servicesData?.user?.name ?? ""
            invoiceIDLabel.text = servicesData?.service_invoice_id ?? ""
            dateLabel.text = self.formatDate(date: servicesData?.booking_date ?? "")
            bookingTextLabel.text = "Service Request".localiz()
            statusLabel.text = servicesData?.status_text ?? ""
            
            
            
        }
    }
    
    var currencyCode:String?{
        didSet{
            
            if myList != nil {
                amountLabel.text = (currencyCode ?? "") + " " + (myList?.grand_total ?? "")
            }
            else if servicesData != nil {
                if (servicesData?.total_amount ?? "") != "" {
                    amountLabel.text = (currencyCode ?? "") + " " + (servicesData?.total_amount ?? "")
                }else {
                    amountLabel.text = ""
                }
            }
        }
    }
//    var userData: User?{
//        didSet{
//            userTypeID = userData?.user_type_id ?? ""
//
//            if myList?.status == "0"{
//                orderAcceptView.isHidden = false
//                statusColorCode(color: Color.StatusYellow.color())
//            }else if myList?.status == "1"{
//                statusColorCode(color: Color.StatusRed.color())
//            }else if myList?.status == "2"{
//                readyForCollectionView.isHidden = false
//                statusColorCode(color: Color.StatusRed.color())
//            }else if myList?.status == "5"{
//                statusColorCode(color: Color.StatusBlue.color())
//            }else if myList?.status == "6"{
//                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
//            }else if myList?.status == "10" || myList?.status == "12"{
//                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
//            }else{
//                statusColorCode(color: Color.StatusRed.color())
//            }
//        }
//    }
    
    
    /// Status Color change
    /// - Parameters:
    ///   - color: UIColor
    ///   - isHide: hide indicator and background
    func statusColorCode(color:UIColor,indicatiorHide isHide:Bool = false)  {
//        statusBarView.backgroundColor = color
//        statusIndicatorBgImageView.backgroundColor  = color
        statusLabel.textColor = color
        if isHide{
            //statusIndicatorBgImageView.isHidden       = true
            indicatorImageView.isHidden = true
        }else{
            //statusIndicatorBgImageView.isHidden       = false
            indicatorImageView.isHidden = false
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
    }
    func isDateStringEqualToCurrentDate(_ dateString: String) -> Bool {
        // Create a DateFormatter to parse the date string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Convert the string to a Date object
        if let date = dateFormatter.date(from: dateString) {
            // Get the current date
            let currentDate = Date()

            // Compare the two Date objects
            if date == currentDate {
                return true
            }
        }

        return false
    }
    
    
    //MARK: - IBActions
   
    
    
    
    //MARK: - API Calls
    
//    func orderAcceptedAPI() {
//
//        let parameters:[String:String] = [
//            "access_token" : SessionManager.getAccessToken() ?? "",
//            "order_id" : myList?.id ?? ""
//        ]
//        print(parameters)
//        StoreAPIManager.ordersAcceptedAPI(parameters: parameters) { result in
//            switch result.status {
//            case "1":
//                self.delegate?.refreshList()
//            default:
//                Utilities.showWarningAlert(message: result.message ?? "") {
//
//                }
//            }
//        }
//    }
    
//    func orderRejectedAPI() {
//
//        let parameters:[String:String] = [
//            "access_token" : SessionManager.getAccessToken() ?? "",
//            "order_id" : myList?.order_id ?? ""
//        ]
//        print(parameters)
//        StoreAPIManager.ordersRejectedAPI(parameters: parameters) { result in
//            switch result.status {
//            case "1":
//                self.delegate?.refreshList()
//            default:
//                Utilities.showWarningAlert(message: result.message ?? "") {
//
//                }
//            }
//        }
//    }
    
//    func orderReadyForDeliveryAPI() {
//
//        let parameters:[String:String] = [
//            "access_token" : SessionManager.getAccessToken() ?? "",
//            "order_id" : myList?.order_id ?? ""
//        ]
//        print(parameters)
//        StoreAPIManager.ordersDreadyForDeliveryAPI(parameters: parameters) { result in
//            switch result.status {
//            case "1":
//                self.delegate?.refreshList()
//            default:
//                Utilities.showWarningAlert(message: result.message ?? "") {
//
//                }
//            }
//        }
//    }
    
//    func orderStartToPrepareAPI() {
//
//        let parameters:[String:String] = [
//            "access_token" : SessionManager.getAccessToken() ?? "",
//            "invoice_id" : myList?.invoice_id ?? ""
//        ]
//        print(parameters)
//        FoodAPIManager.ordersPreparedAPI(parameters: parameters) { result in
//            switch result.status {
//            case "1":
//                self.delegate?.refreshList()
//            default:
//                Utilities.showWarningAlert(message: result.message ?? "") {
//
//                }
//            }
//        }
//    }
}

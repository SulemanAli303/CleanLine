//
//  NotificationTableViewCell.swift
//  The Driver
//
//  Created by Murteza on 16/09/2022.
//

import UIKit
import SwiftGifOrigin
import NVActivityIndicatorView

protocol MyPGBookingPorocol{
    func refreshMyBookingList()
    func gotoDetailsForOrderId(orderId: String)
}

class NewOrderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cancelButtonStackView: UIStackView!
    @IBOutlet weak var cancelOrderView: UIView!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var rejectAcceptButtonView: UIStackView!
    @IBOutlet weak var rejectAcceptHeadView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeIconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    //@IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var rejectView: UIView!
    
    var delegate:MyPGBookingPorocol?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cancelOrderView.isHidden = true
        setGradientBackground()
        
    }
    
    var driverOrdersList:MyOrdersList?{
        didSet{
            DispatchQueue.main.async {
                if self.indicator != nil {
                    self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                    self.indicator.color = .white
                    self.indicator.startAnimating()
                    if self.driverOrdersList?.status == "12"{
                        self.indicator.isHidden = true
                    }
                }
            }
            rejectBtn.isHidden = true
            storeIconImageView.sd_setImage(with: URL(string: driverOrdersList?.store?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = driverOrdersList?.store?.name ?? ""
            orderIDLabel.text = driverOrdersList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: driverOrdersList?.booking_date ?? "")
            productCountLabel.text = ("\(driverOrdersList?.total_qty ?? "") \("Products".localiz())")
            amountLabel.text = driverOrdersList?.grand_total ?? ""
            statusLbl.text = driverOrdersList?.status_text ?? ""
            rejectAcceptButtonView.isHidden = true
            rejectAcceptHeadView.isHidden = true
            if driverOrdersList?.status == "3"{
                rejectAcceptButtonView.isHidden = false
                rejectAcceptHeadView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            }else if driverOrdersList?.status == "1" || myOrdersList?.status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if driverOrdersList?.status == "4"{
                statusColorCode(color: Color.StatusRed.color())
            }else if driverOrdersList?.status == "5"{
                statusColorCode(color: Color.StatusBlue.color())
            }else if driverOrdersList?.status == "6"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if driverOrdersList?.status == "10" || driverOrdersList?.status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusRed.color())
            }
        }
    }
    
    var driverDelegateRequest: DriverDelegateServiceRequestModel?{
        didSet {
            DispatchQueue.main.async {
                if self.indicator != nil {
                    self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                    self.indicator.color = .white
                    self.indicator.startAnimating()
                    if self.driverDelegateRequest?.serviceStatus ?? "" == "7" {
                        self.indicator.stopAnimating()
                    }
                }
            }

            storeIconImageView.sd_setImage(with: URL(string: driverDelegateRequest?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = driverDelegateRequest?.user?.name ?? ""
            orderIDLabel.text = driverDelegateRequest?.serviceInvoiceID ?? ""
            dateLabel.text = (driverDelegateRequest?.createdAt ?? "").changeTimeToFormat_new(frmFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", toFormat: "dd EEE yyyy hh:mm a")
            
            productCountLabel.text = driverDelegateRequest?.deligateService?.serviceName ?? ""
            amountLabel.text = driverDelegateRequest?.grandTotal ?? ""
            statusLbl.text = driverDelegateRequest?.serviceStatusText ?? ""
            rejectAcceptButtonView.isHidden = true
            rejectAcceptHeadView.isHidden = true
            rejectView.isHidden = true
            if driverDelegateRequest?.serviceStatus ?? "" == "0"{
                statusColorCode(color: Color.StatusYellow.color())
                rejectAcceptButtonView.isHidden = false
                rejectAcceptHeadView.isHidden = false
                self.amountLabel.isHidden = true
            } else if driverDelegateRequest?.serviceStatus ?? "" == "1"{
                statusColorCode(color: Color.StatusRed.color())
                self.amountLabel.isHidden = true
            } else if driverDelegateRequest?.serviceStatus ?? "" == "2"{
                statusColorCode(color: Color.StatusBlue.color())
                self.amountLabel.isHidden = false
            } else if driverDelegateRequest?.serviceStatus ?? "" == "3"{
                statusColorCode(color: Color.StatusBlue.color())
                self.amountLabel.isHidden = false
            } else if driverDelegateRequest?.serviceStatus ?? "" == "4"{
                statusColorCode(color: Color.StatusBlue.color())
                self.amountLabel.isHidden = false
            } else if driverDelegateRequest?.serviceStatus ?? "" == "5" {
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                self.amountLabel.isHidden = false
            } else {
                statusColorCode(color: Color.StatusRed.color())
                self.amountLabel.isHidden = false
            }
            
        }
    }
    
    var myHotelBookingList:HotelBookingList?{
        didSet{
            
            DispatchQueue.main.async {
                if self.indicator != nil {
                    self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                    self.indicator.color = .white
                    self.indicator.startAnimating()
                }
            }
            
            storeIconImageView.sd_setImage(with: URL(string: myHotelBookingList?.product_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myHotelBookingList?.product_name ?? ""
            orderIDLabel.text = myHotelBookingList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myHotelBookingList?.created_at ?? "")
            productCountLabel.text = "Hotel Booking".localiz()
            amountLabel.text = myHotelBookingList?.total_amount ?? ""
            statusLbl.text = myHotelBookingList?.booking_status_text ?? ""
            cancelOrderView.isHidden = true
            cancelButtonStackView.isHidden = true
            if myHotelBookingList?.booking_status == "0"{
              //  cancelOrderView.isHidden = false
             //   cancelButtonStackView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            }else if myHotelBookingList?.booking_status == "1" || myHotelBookingList?.booking_status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myHotelBookingList?.booking_status == "4"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myHotelBookingList?.booking_status == "5"{
                statusColorCode(color: Color.StatusBlue.color(),indicatiorHide: true)
            }else if myHotelBookingList?.booking_status == "6"{
                statusColorCode(color: Color.StatusRed.color(),indicatiorHide: true)
            }else if myHotelBookingList?.booking_status == "10" || myHotelBookingList?.booking_status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusRed.color())
            }
        }
    }
    var myOrdersList:MyOrdersList?{
        didSet{
            DispatchQueue.main.async {
                if self.indicator != nil {
                    self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                    self.indicator.color = .white
                    self.indicator.startAnimating()
                }
            }
            rejectBtn.isHidden = true
            storeIconImageView.sd_setImage(with: URL(string: myOrdersList?.store?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myOrdersList?.store?.name ?? ""
            orderIDLabel.text = myOrdersList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myOrdersList?.booking_date ?? "")
            productCountLabel.text = ("\(myOrdersList?.total_qty ?? "") \("Products".localiz())")
            amountLabel.text = myOrdersList?.grand_total ?? ""
            statusLbl.text = myOrdersList?.status_text ?? ""
            rejectAcceptButtonView.isHidden = true
            rejectAcceptHeadView.isHidden = true
            if myOrdersList?.status == "0"{
                statusColorCode(color: Color.StatusYellow.color())
            }else if myOrdersList?.status == "1" || myOrdersList?.status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myOrdersList?.status == "3"{
                statusColorCode(color: Color.StatusYellow.color())
            }
            else if myOrdersList?.status == "5"{
                statusColorCode(color: Color.StatusBlue.color())
            }else if myOrdersList?.status == "6"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myOrdersList?.status == "10" || myOrdersList?.status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusRed.color())
            }
            //            DispatchQueue.main.async {
            //                self.indicator.image = UIImage.gif(name: "activityIndicator")
            //            }
        }
    }
    var myTableBookingList:MyTableBookingList?{
        didSet{
            
            DispatchQueue.main.async {
                if self.indicator != nil {
                    self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                    self.indicator.color = .white
                    self.indicator.startAnimating()
                }
            }
            storeIconImageView.sd_setImage(with: URL(string: myTableBookingList?.store?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myTableBookingList?.store?.name ?? ""
            orderIDLabel.text = myTableBookingList?.invoice_id ?? ""
            
            //            let numberValue = NSNumber(value: Int(self.myBookingOrder?.created_at ?? "") ?? 0)
            //            //senderCell.timeStampLabel.text = self.convertTimeStamp(createdAt: numberValue)
            //            dateLabel.text = self.convertTimeStamp(createdAt: numberValue)
            
            dateLabel.text = self.formatDate(date: myTableBookingList?.created_at ?? "")
            productCountLabel.text = ("\(myTableBookingList?.no_of_persons ?? "") \("Person".localiz())")
            ///amountLabel.text = myOrdersList?.grand_total ?? ""
            statusLbl.text = myTableBookingList?.booking_status_text ?? ""
            rejectAcceptButtonView.isHidden = true
            rejectAcceptHeadView.isHidden = true
            
            self.indicator.isHidden = true
            if myTableBookingList?.booking_status == "0"{
                statusColorCode(color: Color.StatusYellow.color())
            }else if myTableBookingList?.booking_status == "1" || myTableBookingList?.booking_status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myTableBookingList?.booking_status == "4"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myTableBookingList?.booking_status == "5"{
                statusColorCode(color: Color.StatusBlue.color())
            }else if myTableBookingList?.booking_status == "6"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myTableBookingList?.booking_status == "10" || myTableBookingList?.booking_status == "12" || myTableBookingList?.booking_status == "11"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }
        }
    }
    var myBookingOrder:CharletBookingList?{
        didSet{
            //            let inputFormatter = DateFormatter()
            //            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            //            if let date = inputFormatter.date(from: self.myBookingOrder?.created_at ?? "") {
            //                let outputFormatter = DateFormatter()
            //                outputFormatter.dateFormat = "dd MMM yyyy HH:mm a"
            //                outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            //                let formattedDate = outputFormatter.string(from: date)
            //                dateLabel.text = formattedDate
            //            } else {
            //                print("Invalid date format")
            //                dateLabel.text = self.myBookingOrder?.created_at_format ?? ""
            //            }
            
            if self.indicator != nil {
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }
            
            dateLabel.text = self.formatDate(date: self.myBookingOrder?.created_at ?? "") //self.myBookingOrder?.created_at ?? ""
            storeIconImageView.sd_setImage(with: URL(string: myBookingOrder?.product_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myBookingOrder?.product_name ?? ""
            orderIDLabel.text = myBookingOrder?.booking_id ?? ""
            //dateLabel.text = self.myBookingOrder?.created_at_format ?? ""
            productCountLabel.text = "Chalet Request".localiz()
            statusLbl.text = myBookingOrder?.booking_status ?? ""
            rejectAcceptButtonView.isHidden = true
            rejectAcceptHeadView.isHidden = true
            self.indicator.isHidden = false
            statusIndicator.isHidden = false
            if (self.myBookingOrder?.booking_status_number ?? "" == "5"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                statusLbl.textColor = UIColor(hex: "F57070")
                // indicator.backgroundColor  = UIColor(hex: "F57070")
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
            }else if (self.myBookingOrder?.booking_status_number ?? "" == "4"){
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
                statusLbl.textColor = UIColor(hex: "00B24D")
                self.statusView.backgroundColor = UIColor(hex: "00B24D")
                /// indicator.backgroundColor  = UIColor(hex: "00B24D")
            }else if (self.myBookingOrder?.booking_status_number ?? "" == "2"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
                statusLbl.textColor = UIColor(hex: "5795FF")
                // indicator.backgroundColor  = UIColor(hex: "5795FF")
            }else if (self.myBookingOrder?.booking_status_number ?? "" == "1"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                statusLbl.textColor = UIColor(hex: "F57070")
                //indicator.backgroundColor  = UIColor(hex: "F57070")
            }else if (self.myBookingOrder?.booking_status_number ?? "" == "0"){
                self.statusView.backgroundColor = UIColor(hex: "FCB813")
                statusLbl.textColor = UIColor(hex: "FCB813")
                // indicator.backgroundColor  = UIColor(hex: "FCB813")
            }
        }
    }
    
    var servicesData : ServiceData? {
        didSet {
            
            if self.indicator != nil {
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }
            
            storeIconImageView.sd_setImage(with: URL(string: servicesData?.store?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = servicesData?.store?.name ?? ""
            orderIDLabel.text = servicesData?.service_invoice_id ?? ""
            dateLabel.text = servicesData?.booking_date ?? ""
            productCountLabel.text = "Service Request".localiz()
            statusLbl.text = servicesData?.status_text ?? ""
            rejectAcceptButtonView.isHidden = true
            rejectAcceptHeadView.isHidden = true
            self.indicator.isHidden = false
            statusIndicator.isHidden = false
            if (self.servicesData?.status ?? "" == "0"){
                self.statusView.backgroundColor = UIColor(hex: "FCB813")
                //indicator.backgroundColor  = UIColor(hex: "FCB813")
                statusLbl.textColor = UIColor(hex: "FCB813")
                
            }else if (self.servicesData?.status ?? "" == "10" || self.servicesData?.status ?? "" == "11"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                //indicator.backgroundColor  = UIColor(hex: "F57070")
                statusLbl.textColor = UIColor(hex: "F57070")
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
            }else  if (self.servicesData?.status ?? "" == "1"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                //indicator.backgroundColor  = UIColor(hex: "F57070")
                statusLbl.textColor = UIColor(hex: "F57070")
                
            }else if (self.servicesData?.status ?? "" == "2"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                //indicator.backgroundColor  = UIColor(hex: "F57070")
                statusLbl.textColor = UIColor(hex: "F57070")
                
            }else if (self.servicesData?.status ?? "" == "4"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
                //indicator.backgroundColor  = UIColor(hex: "5795FF")
                statusLbl.textColor = UIColor(hex: "5795FF")
            }else if (self.servicesData?.status ?? "" == "5"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
                //indicator.backgroundColor  = UIColor(hex: "5795FF")
                statusLbl.textColor = UIColor(hex: "5795FF")
            }else if (self.servicesData?.status ?? "" == "6"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
                //indicator.backgroundColor  = UIColor(hex: "5795FF")
                statusLbl.textColor = UIColor(hex: "5795FF")
            }else if (self.servicesData?.status ?? "" == "7"){
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
                self.statusView.backgroundColor = UIColor(hex: "00B24D")
                //indicator.backgroundColor  = UIColor(hex: "00B24D")
                statusLbl.textColor = UIColor(hex: "00B24D")
            }else if (self.servicesData?.status ?? "" == "8"){
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
                self.statusView.backgroundColor = UIColor(hex: "00B24D")
                //indicator.backgroundColor  = UIColor(hex: "00B24D")
                statusLbl.textColor = UIColor(hex: "00B24D")
            }
            
        }
    }
    
    var myBookingList:PGBookingList?{
        didSet{
            
            DispatchQueue.main.async {
                if self.indicator != nil {
                    self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                    self.indicator.color = .white
                    self.indicator.startAnimating()
                }
            }
            
            storeIconImageView.sd_setImage(with: URL(string: myBookingList?.product_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myBookingList?.product_name ?? ""
            orderIDLabel.text = myBookingList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myBookingList?.created_at ?? "")
            productCountLabel.text = "Play ground Booking".localiz()
            amountLabel.text = myBookingList?.total_amount ?? ""
            statusLbl.text = myBookingList?.booking_status_text ?? ""
            
            rejectAcceptButtonView.isHidden = true
            cancelOrderView.isHidden = true
            cancelButtonStackView.isHidden = true
            if myBookingList?.booking_status == "0"{
             //   cancelOrderView.isHidden = false
             //   cancelButtonStackView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            }else if myBookingList?.booking_status == "1" || myBookingList?.booking_status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myBookingList?.booking_status == "4"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myBookingList?.booking_status == "5"{
                statusColorCode(color: Color.StatusBlue.color(), indicatiorHide: true)
            }else if myBookingList?.booking_status == "6"{
                statusColorCode(color: Color.StatusRed.color(), indicatiorHide: true)
            }else if myBookingList?.booking_status == "10" || myBookingList?.booking_status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color())
            }else{
                statusColorCode(color: Color.StatusRed.color())
            }
        }
    }
    
    func orderAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrdersList?.order_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.ordersAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
               // self.delegate?.refreshList()
                self.delegate?.gotoDetailsForOrderId(orderId: self.myOrdersList?.order_id ?? "")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    
    var currencyCode:String?{
        didSet{
            if myOrdersList != nil {
                amountLabel.text = (currencyCode ?? "") + " " + (myOrdersList?.grand_total ?? "")
            }else if servicesData != nil {
                if (servicesData?.total_amount ?? "") != "" {
                    amountLabel.text = (currencyCode ?? "") + " " + (servicesData?.total_amount ?? "")
                }else {
                    amountLabel.text = ""
                }
            }else if myBookingOrder != nil {
                if (myBookingOrder?.total_amount ?? "") != "" {
                    amountLabel.text = "\(currencyCode ?? "") \(Double(myBookingOrder?.total_amount ?? "") ?? 0.0)"
                }else {
                    amountLabel.text = ""
                }
            }else if myBookingList != nil {
                if (myBookingList?.total_amount ?? "") != "" {
                    amountLabel.text = "\(currencyCode ?? "") \(Double(myBookingList?.total_amount ?? "") ?? 0.0)"
                }else {
                    amountLabel.text = ""
                }
            }else if driverDelegateRequest != nil {
                if (driverDelegateRequest?.grandTotal ?? "") != "" {
                    amountLabel.text = "\(currencyCode ?? "") \(Double(driverDelegateRequest?.grandTotal ?? "") ?? 0.0)"
                }else {
                    amountLabel.text = ""
                }
            }else if driverOrdersList != nil {
                if (driverOrdersList?.grand_total ?? "") != "" {
                    amountLabel.text = "\(currencyCode ?? "") \(Double(driverOrdersList?.grand_total ?? "") ?? 0.0)"
                }else {
                    amountLabel.text = ""
                }
            }
        }
    }
    
    /// Status Color change
    /// - Parameters:
    ///   - color: UIColor
    ///   - isHide: hide indicator and background
    func statusColorCode(color:UIColor,indicatiorHide isHide:Bool = false)  {
        statusLbl.textColor = color
        DispatchQueue.main.async {
            if isHide{
                self.indicator.isHidden       = true
            }else{
                self.indicator.isHidden       = false
            }
        }
    }
    
    
    @IBAction func accept(_ sender: Any) {
        if driverDelegateRequest != nil{
            self.setAcceptDelegate()
        }else if driverOrdersList != nil{
            self.driverOrderAcceptedAPI()
        }
    }
    
    func hotelOrderAcceptedAPI() {
        
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myHotelBookingList?.booking_id ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.sellerBookingAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.gotoDetailsForOrderId(orderId:self.myHotelBookingList?.booking_id ?? "")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func pgOrderAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.driverDelegateRequest?.id ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.myPGBookingAcceptAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                print(result.message ?? "")
                self.delegate?.gotoDetailsForOrderId(orderId: self.driverDelegateRequest?.id ?? "")
                //self.delegate?.refreshList()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func myTableBookingAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myTableBookingList?.id ?? ""
        ]
        print(parameters)
        StoreAPIManager.tableBookingAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
               // self.delegate?.refreshList()
                self.delegate?.gotoDetailsForOrderId(orderId: self.myTableBookingList?.id ?? "")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func chaledAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myBookingOrder?.id ?? "",
            "status" : "1"
        ]
        print(parameters)
        CharletAPIManager.charletManagmentBookingYesNOAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
               // self.delegate?.refreshList()
                self.delegate?.gotoDetailsForOrderId(orderId:  self.myBookingOrder?.id ?? "")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func orderServicesAccepted() {
    //    Coordinator.goToAcceptRequestVC(controller: parent, step: "",service_request_id: servicesData?.id,service_inVoice: servicesData?.service_invoice_id)
        
            
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "service_request_id" : servicesData?.id ?? "",
                "amount" : "",
                "service_charges" : "",
                "accept_note" : ""
            ]
            print(parameters)
            ServiceAPIManager.Accept_ProviderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                  //  self.delegate?.refreshList()
                    self.delegate?.gotoDetailsForOrderId(orderId: self.servicesData?.id ?? "")
                    default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
    }
    @IBAction func cancel(_ sender: Any) {
        if myBookingList != nil{
            self.pgBookingCancelAPI()
        }else if myHotelBookingList != nil{
            self.hotelBookingCancelAPI()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
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
    
    func convertTimeStamp(createdAt: NSNumber?) -> String {
        guard let createdAt = createdAt else { return "a moment ago" }
        
        let converted = Date(timeIntervalSince1970: Double(truncating: createdAt) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        let dateString = dateFormatter.string(from: converted)
        
        let date = self.rfcDateFormatter.date(from: dateString)
        let localDate = self.localDateFormatter.string(from: date!)
        
        return localDate.changeTimeToFormat(frmFormat: "dd-MM-yyyy HH:mm:ss Z", toFormat: "hh:mm a")
        
    }
    var rfcDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }
    
    var localDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        return formatter
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
    
    func pgBookingCancelAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myBookingList?.booking_id ?? ""
        ]
        StoreAPIManager.myPGBookingCancelAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.refreshMyBookingList()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    func hotelBookingCancelAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myHotelBookingList?.booking_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.userBookingCancelAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.refreshMyBookingList()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func setAcceptDelegate() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_id" : driverDelegateRequest?.id ?? ""
        ]
        DelegateServiceAPIManager.driverAcceptServiceAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.gotoDetailsForOrderId(orderId: self.driverDelegateRequest?.id ?? "")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func driverOrderAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : driverOrdersList?.order_id ?? ""
        ]
        print(parameters)
        if driverOrdersList?.type == "1"{
            FoodAPIManager.driverAcceptedOrderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.delegate?.gotoDetailsForOrderId(orderId: self.driverOrdersList?.order_id ?? "")
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            StoreAPIManager.driverAcceptedOrderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.delegate?.gotoDetailsForOrderId(orderId: self.driverOrdersList?.order_id ?? "")
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
}

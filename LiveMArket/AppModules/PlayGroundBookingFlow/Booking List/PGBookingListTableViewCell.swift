//
//  PGBookingListTableViewCell.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/08/23.
//

import UIKit

protocol MyPgBookingPorocol{
    func refreshMyBookingList()
}

class PGBookingListTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var rejectAcceptButtonView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeIconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    var delegate:MyPGBookingPorocol?
    var isFromHotel:Bool = false
    
    @IBOutlet weak var rejectView: UIView!
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setGradientBackground()
    }
    
    var isHotel:Bool?{
        didSet{
            isFromHotel = isHotel ?? false
        }
    }
    
    var myBookingList:PGBookingList?{
        didSet{
            storeIconImageView.sd_setImage(with: URL(string: myBookingList?.product_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myBookingList?.product_name ?? ""
            orderIDLabel.text = myBookingList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myBookingList?.created_at ?? "")
            productCountLabel.text = "Play ground Booking".localiz()
            amountLabel.text = myBookingList?.total_amount ?? ""
            statusLbl.text = myBookingList?.booking_status_text ?? ""
            rejectAcceptButtonView.isHidden = true
            if myBookingList?.booking_status == "0"{
                rejectAcceptButtonView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            }else if myBookingList?.booking_status == "1" || myBookingList?.booking_status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myBookingList?.booking_status == "4"{
                statusColorCode(color: Color.StatusGreen.color())
            }else if myBookingList?.booking_status == "5"{
                statusColorCode(color: Color.StatusBlue.color())
            }else if myBookingList?.booking_status == "6"{
                statusColorCode(color: Color.StatusRed.color(),indicatiorHide: true)
            }else if myBookingList?.booking_status == "10" || myBookingList?.booking_status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusRed.color())
            }
        }
    }
    var myBookingOrder:CharletBookingList?{
        didSet{
            storeIconImageView.sd_setImage(with: URL(string: myBookingOrder?.product_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myBookingOrder?.product_name ?? ""
            orderIDLabel.text = myBookingOrder?.booking_id ?? ""
            dateLabel.text = self.myBookingOrder?.created_at_format ?? ""
            productCountLabel.text = "Chalet Request".localiz()
            statusLbl.text = myBookingOrder?.booking_status ?? ""
            rejectAcceptButtonView.isHidden = true
            self.indicator.isHidden = false
            statusIndicator.isHidden = false
            if (self.myBookingOrder?.booking_status_number ?? "" == "5"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                indicator.backgroundColor  = UIColor(hex: "F57070")
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
            }else if (self.myBookingOrder?.booking_status_number ?? "" == "4"){
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
                self.statusView.backgroundColor = UIColor(hex: "00B24D")
                indicator.backgroundColor  = UIColor(hex: "00B24D")
            }else if (self.myBookingOrder?.booking_status_number ?? "" == "2"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
                indicator.backgroundColor  = UIColor(hex: "5795FF")
            }else if (self.myBookingOrder?.booking_status_number ?? "" == "1"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                indicator.backgroundColor  = UIColor(hex: "F57070")
            }else if (self.myBookingOrder?.booking_status_number ?? "" == "0"){
                self.statusView.backgroundColor = UIColor(hex: "FCB813")
                indicator.backgroundColor  = UIColor(hex: "FCB813")
            }
        }
    }
    
    var servicesData : ServiceData? {
        didSet {
            storeIconImageView.sd_setImage(with: URL(string: servicesData?.store?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = servicesData?.store?.name ?? ""
            orderIDLabel.text = servicesData?.service_invoice_id ?? ""
            dateLabel.text = self.formatDate(date: servicesData?.booking_date ?? "")
            productCountLabel.text = "Service Request".localiz()
            statusLbl.text = servicesData?.status_text ?? ""
            rejectAcceptButtonView.isHidden = true
            self.indicator.isHidden = false
            statusIndicator.isHidden = false
            if (self.servicesData?.status ?? "" == "0"){
                self.statusView.backgroundColor = UIColor(hex: "FCB813")
                indicator.backgroundColor  = UIColor(hex: "FCB813")
                
            }else if (self.servicesData?.status ?? "" == "10" || self.servicesData?.status ?? "" == "11"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                indicator.backgroundColor  = UIColor(hex: "F57070")
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
            }else  if (self.servicesData?.status ?? "" == "1"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                indicator.backgroundColor  = UIColor(hex: "F57070")
                
            }else if (self.servicesData?.status ?? "" == "2"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                indicator.backgroundColor  = UIColor(hex: "F57070")
                
            }else if (self.servicesData?.status ?? "" == "4"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
                indicator.backgroundColor  = UIColor(hex: "5795FF")
            }else if (self.servicesData?.status ?? "" == "5"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
                indicator.backgroundColor  = UIColor(hex: "5795FF")
            }else if (self.servicesData?.status ?? "" == "6"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
                indicator.backgroundColor  = UIColor(hex: "5795FF")
            }else if (self.servicesData?.status ?? "" == "7"){
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
                self.statusView.backgroundColor = UIColor(hex: "00B24D")
                indicator.backgroundColor  = UIColor(hex: "00B24D")
            }else if (self.servicesData?.status ?? "" == "8"){
                self.indicator.isHidden = true
                statusIndicator.isHidden = true
                self.statusView.backgroundColor = UIColor(hex: "00B24D")
                indicator.backgroundColor  = UIColor(hex: "00B24D")
            }
            
        }
    }
    var myHotelBookingList:HotelBookingList?{
        didSet{
            storeIconImageView.sd_setImage(with: URL(string: myHotelBookingList?.product_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myHotelBookingList?.product_name ?? ""
            orderIDLabel.text = myHotelBookingList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myHotelBookingList?.created_at ?? "")
            productCountLabel.text = "Hotel Booking".localiz()
            amountLabel.text = myHotelBookingList?.total_amount ?? ""
            statusLbl.text = myHotelBookingList?.booking_status_text ?? ""
            rejectAcceptButtonView.isHidden = true
            if myHotelBookingList?.booking_status == "0"{
                rejectAcceptButtonView.isHidden = false
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
                statusColorCode(color: Color.StatusRed.color())
            }
        }
    }
    
    var currencyCode:String?{
        didSet{
            if myBookingList != nil {
                amountLabel.text = (currencyCode ?? "") + " " + (myBookingList?.total_amount ?? "")
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
            }
        }
    }
    
    /// Status Color change
    /// - Parameters:
    ///   - color: UIColor
    ///   - isHide: hide indicator and background
    func statusColorCode(color:UIColor,indicatiorHide isHide:Bool = false)  {
        statusView.backgroundColor = color
        indicator.backgroundColor  = color
        if isHide{
            indicator.isHidden       = true
            statusIndicator.isHidden = true
        }else{
            indicator.isHidden       = false
            statusIndicator.isHidden = false
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.bookingCancelAPI()
    }
    
    @IBAction func accept(_ sender: Any) {
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "d MMM yyyy h:mma"
        let resultString = inputFormatter.string(from: showDate!)
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
    
    func bookingCancelAPI() {
        
        if isFromHotel{
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
        }else{
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
    }
}

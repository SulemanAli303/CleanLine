//
//  NotificationTableViewCell.swift
//  The Driver
//
//  Created by Murteza on 16/09/2022.
//

import UIKit
import NVActivityIndicatorView

protocol MyBookingDelegate:AnyObject{
    func refreshList()
    func gotoDetailsForOrderId (orderId:String)
}


class BookingCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var readyForCollectionButtonView: UIStackView!
    @IBOutlet weak var startToPrepareButtonStatckView: UIStackView!
    @IBOutlet weak var orderAcceptButtonStackView: UIStackView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameViewPrice: UIView!
    @IBOutlet weak var startToPrepareView: UIView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var readyForCollectionView: UIView!
    //@IBOutlet weak var statusIndicatorBgImageView: UIImageView!
    // @IBOutlet weak var statusBarView: UIView!
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
    
    weak var delegate:MyBookingDelegate?
    
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
    
    var myHotelBookingList : HotelBookingList?{
        
        didSet{
            if self.indicator != nil {
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }
            
            amountLabel.text = myHotelBookingList?.total_amount ?? ""
            storeImageView.sd_setImage(with: URL(string: myHotelBookingList?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myHotelBookingList?.user?.name ?? ""
            invoiceIDLabel.text = myHotelBookingList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myHotelBookingList?.created_at ?? "")
            statusLabel.text = myHotelBookingList?.booking_status_text ?? ""
            bookingTextLabel.text = "Hotel Booking".localiz()
            orderAcceptView.isHidden = true
            orderAcceptButtonStackView.isHidden = true
            readyForCollectionView.isHidden = true
            startToPrepareView.isHidden = true
            //rejectAcceptButtonView.isHidden = true
            if myHotelBookingList?.booking_status == "0"{
                orderAcceptView.isHidden = false
                orderAcceptButtonStackView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            }else if myHotelBookingList?.booking_status == "1" || myHotelBookingList?.booking_status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myHotelBookingList?.booking_status == "4"{
                statusColorCode(color: Color.StatusGreen.color(), indicatiorHide: true)
            }else if myHotelBookingList?.booking_status == "5"{
                statusColorCode(color: Color.StatusBlue.color(), indicatiorHide: true)
            }else if myHotelBookingList?.booking_status == "6"{
                statusColorCode(color: Color.StatusRed.color(),indicatiorHide: true)
            }else if myHotelBookingList?.booking_status == "10" || myHotelBookingList?.booking_status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusRed.color())
            }
            
        }
    }
    
    var myPGBookingList : GroundReceivedBookingList?{
        
        didSet{
            DispatchQueue.main.async {
                if self.indicator != nil {
                    self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                    self.indicator.color = .white
                    self.indicator.startAnimating()
                }
            }
            
            amountLabel.text = myPGBookingList?.total_amount ?? ""
            storeImageView.sd_setImage(with: URL(string: myPGBookingList?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myPGBookingList?.user?.name ?? ""
            invoiceIDLabel.text = myPGBookingList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myPGBookingList?.created_at ?? "")
            statusLabel.text = myPGBookingList?.booking_status_text ?? ""
            bookingTextLabel.text = "Play Ground Booking".localiz()
            orderAcceptView.isHidden = true
            orderAcceptButtonStackView.isHidden = true
            readyForCollectionView.isHidden = true
            startToPrepareView.isHidden = true
            if myPGBookingList?.booking_status == "0"{
                orderAcceptView.isHidden = false
                orderAcceptButtonStackView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            }else if myPGBookingList?.booking_status == "1"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myPGBookingList?.booking_status == "2"{
              //  readyForCollectionView.isHidden = false
                statusColorCode(color: Color.StatusRed.color())
            }else if myPGBookingList?.booking_status == "4"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myPGBookingList?.booking_status == "5"{
                statusColorCode(color: Color.StatusBlue.color(), indicatiorHide: true)
            }else if myPGBookingList?.booking_status == "6"{
                statusColorCode(color: Color.StatusRed.color(), indicatiorHide: true)
            }else if myPGBookingList?.booking_status == "10" || myPGBookingList?.booking_status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color())
            }else{
                statusColorCode(color: Color.StatusRed.color())
            }
            
        }
    }
    
    var myList : MyReceiveOrdersList?{
        
        didSet{
            DispatchQueue.main.async {
                if self.indicator != nil {
                    self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                    self.indicator.color = .white
                    self.indicator.startAnimating()
                }
            }
            
            amountLabel.text = myList?.grand_total ?? ""
            storeImageView.sd_setImage(with: URL(string: myList?.customer?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myList?.customer?.name ?? ""
            invoiceIDLabel.text = myList?.invoice_id ?? ""
            dateLabel.text = self.convertLocatTime(date: myList?.booking_date ?? "")
            statusLabel.text = myList?.status_text ?? ""
            bookingTextLabel.text = ("\(myList?.total_qty ?? "") \("Products".localiz())")
            orderAcceptView.isHidden = true
            orderAcceptButtonStackView.isHidden = true
            readyForCollectionView.isHidden = true
            readyForCollectionButtonView.isHidden = true
            startToPrepareView.isHidden = true
            startToPrepareButtonStatckView.isHidden = true
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
            
            amountLabel.text = ""
            storeImageView.sd_setImage(with: URL(string: myTableBookingList?.user?.image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myTableBookingList?.user?.name ?? ""
            invoiceIDLabel.text = myTableBookingList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myTableBookingList?.booking_date ?? "")
            statusLabel.text = myTableBookingList?.booking_status_text ?? ""
            bookingTextLabel.text = ("\(myTableBookingList?.no_of_persons ?? "") \("Person".localiz())")
            orderAcceptView.isHidden = true
            orderAcceptButtonStackView.isHidden = true
            readyForCollectionView.isHidden = true
            readyForCollectionButtonView.isHidden = true
            startToPrepareView.isHidden = true
            startToPrepareButtonStatckView.isHidden = true
            if myTableBookingList?.booking_status == "0"{
                orderAcceptView.isHidden = false
                orderAcceptButtonStackView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            }else if myTableBookingList?.booking_status == "1" || myTableBookingList?.booking_status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myTableBookingList?.booking_status == "4"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myTableBookingList?.booking_status == "5"{
                statusColorCode(color: Color.StatusBlue.color())
            }else if myTableBookingList?.booking_status == "6"{
                statusColorCode(color: Color.StatusGreen.color())
            }else if myTableBookingList?.booking_status == "10" || myTableBookingList?.booking_status == "12" || myTableBookingList?.booking_status == "11"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }
            
            //            DispatchQueue.main.async {
            //                self.indicator.image = UIImage.gif(name: "activityIndicator")
            //            }
        }
    }
    
    var servicesData : ServiceData? {
        didSet {
//            
//            DispatchQueue.main.async {
//                if self.indicator != nil {
//                    self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
//                    self.indicator.color = .white
//                    self.indicator.startAnimating()
//                }
//            }
//            
            storeImageView.sd_setImage(with: URL(string: servicesData?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = servicesData?.user?.name ?? ""
            invoiceIDLabel.text = servicesData?.service_invoice_id ?? ""
            dateLabel.text = servicesData?.booking_date ?? ""
            bookingTextLabel.text = "Service Request".localiz()
            statusLabel.text = servicesData?.status_text ?? ""
            
            //self.indicator.isHidden = false
            // statusIndicatorBgImageView.isHidden = false
            orderAcceptView.isHidden = true
            orderAcceptButtonStackView.isHidden = true
            
            if self.servicesData?.status == "6" || self.servicesData?.status == "8" || self.servicesData?.status == "10" || self.servicesData?.status == "11"{
                self.indicator.stopAnimating()
            }else{
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }
            
            if (self.servicesData?.status ?? "" == "0"){
                //self.statusBarView.backgroundColor = UIColor(hex: "FCB813")
                //self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "FCB813")
                orderAcceptView.isHidden = false
                orderAcceptButtonStackView.isHidden = false
                statusLabel.textColor = UIColor(hex: "FCB813")
                
            }else if (self.servicesData?.status ?? "" == "10" || self.servicesData?.status ?? "" == "11"){
                //self.statusBarView.backgroundColor = UIColor(hex: "F57070")
                // self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "F57070")
                //self.indicator.isHidden = true
                //statusIndicatorBgImageView.isHidden = true
                statusLabel.textColor = UIColor(hex: "F57070")
            }
            //            DispatchQueue.main.async {
            //                self.indicator.image = UIImage.gif(name: "activityIndicator")
            //            }
            
        }
    }
    var myBookingOrder:CharletBookingList?{
        didSet{
            
            storeImageView.sd_setImage(with: URL(string: myBookingOrder?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myBookingOrder?.user_name ?? ""
            invoiceIDLabel.text = myBookingOrder?.booking_id ?? ""
            // dateLabel.text = self.myBookingOrder?.created_at_format ?? ""
            
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
            dateLabel.text = self.convertLocatTime(date: self.myBookingOrder?.created_at ?? "") //self.myBookingOrder?.created_at ?? ""
            
            bookingTextLabel.text = "Chalet Request".localiz()
            statusLabel.text = myBookingOrder?.booking_status ?? ""
            self.indicator.isHidden = false
            // statusIndicatorBgImageView.isHidden = false
            orderAcceptView.isHidden = true
            orderAcceptButtonStackView.isHidden = true
            if myBookingOrder?.booking_status_number == "4" || myBookingOrder?.booking_status_number == "5" || myBookingOrder?.booking_status_number == "6"{
                self.indicator.stopAnimating()
            }else{
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }
            
            if (myBookingOrder?.booking_status_number ?? "" == "0"){
                // self.statusBarView.backgroundColor = UIColor(hex: "FCB813")
                //  self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "FCB813")
                orderAcceptView.isHidden = false
                orderAcceptButtonStackView.isHidden = false
                statusLabel.textColor = UIColor(hex: "FCB813")
                
            }else if (myBookingOrder?.booking_status_number ?? "" == "5"){
                //self.statusBarView.backgroundColor = UIColor(hex: "F57070")
                //  self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "F57070")
                statusLabel.textColor = UIColor(hex: "F57070")
                //self.indicator.isHidden = true
                // statusIndicatorBgImageView.isHidden = true
            }else if (myBookingOrder?.booking_status_number ?? "" == "4"){
                // self.statusBarView.backgroundColor = UIColor(hex: "00B24D")
                // self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "00B24D")
                statusLabel.textColor = UIColor(hex: "00B24D")
                //self.indicator.isHidden = true
                // statusIndicatorBgImageView.isHidden = true
            }else if (myBookingOrder?.booking_status_number ?? "" == "2"){
                statusLabel.textColor = UIColor(hex: "F57070")
                // self.statusBarView.backgroundColor = UIColor(hex: "F57070")
                // self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "F57070")
                
            }
            //            DispatchQueue.main.async {
            //                self.indicator.image = UIImage.gif(name: "activityIndicator")
            //            }
        }
        
    }
    
    var myDelegateServicesList:DataClass?{
        didSet {
            
            if self.indicator != nil {
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }
            
            invoiceIDLabel.text = myDelegateServicesList?.serviceInvoiceID ?? ""
            dateLabel.text = (myDelegateServicesList?.createdAt ?? "").changeTimeToFormat_new(frmFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", toFormat: "dd EEE yyyy hh:mm a")
            bookingTextLabel.text = myDelegateServicesList?.deligateService?.serviceName ?? ""
            statusLabel.text = myDelegateServicesList?.serviceStatusText ?? ""
            storeNameLabel.text = myDelegateServicesList?.deliveryType?.deligateName ?? ""
            storeImageView.sd_setImage(with: URL(string:myDelegateServicesList?.deliveryType?.deligateIcon ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            self.indicator.isHidden = false
            //statusIndicatorBgImageView.isHidden = false
            if ( myDelegateServicesList?.serviceStatus == "0"){
                //self.statusBarView.backgroundColor = UIColor(hex: "FCB813")
                //self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "FCB813")
                statusLabel.textColor = UIColor(hex: "FCB813")
                self.nameView.isHidden  = true
                self.nameViewPrice.isHidden  = true
            }else  if (myDelegateServicesList?.serviceStatus == "1"){
                
                storeNameLabel.text = myDelegateServicesList?.driver?.name ?? ""
                storeImageView.sd_setImage(with: URL(string:myDelegateServicesList?.driver?.userImage ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
                statusLabel.textColor = UIColor(hex: "F57070")
                //                self.statusBarView.backgroundColor = UIColor(hex: "F57070")
                //                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "F57070")
                self.nameViewPrice.isHidden  = true
                self.nameView.isHidden  = false
            }else if (myDelegateServicesList?.serviceStatus  == "2"){
                storeNameLabel.text = myDelegateServicesList?.driver?.name ?? ""
                storeImageView.sd_setImage(with: URL(string:myDelegateServicesList?.driver?.userImage ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
                statusLabel.textColor = UIColor(hex: "F57070")
                //                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "F57070")
                self.nameViewPrice.isHidden  = false
                self.nameView.isHidden  = false
            }else if ( myDelegateServicesList?.serviceStatus == "3"){
                storeNameLabel.text = myDelegateServicesList?.driver?.name ?? ""
                storeImageView.sd_setImage(with: URL(string:myDelegateServicesList?.driver?.userImage ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
                statusLabel.textColor = UIColor(hex: "5795FF")
                //                self.statusBarView.backgroundColor = UIColor(hex: "5795FF")
                //                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "5795FF")
                self.nameViewPrice.isHidden  = false
                self.nameView.isHidden  = false
            }else if ( myDelegateServicesList?.serviceStatus == "4"){
                storeNameLabel.text = myDelegateServicesList?.driver?.name ?? ""
                storeImageView.sd_setImage(with: URL(string:myDelegateServicesList?.driver?.userImage ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
                statusLabel.textColor = UIColor(hex: "5795FF")
                //                self.statusBarView.backgroundColor = UIColor(hex: "5795FF")
                //                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "5795FF")
                self.nameViewPrice.isHidden  = false
                self.nameView.isHidden  = false
            }else if ( myDelegateServicesList?.serviceStatus == "5"){
                storeNameLabel.text = myDelegateServicesList?.driver?.name ?? ""
                storeImageView.sd_setImage(with: URL(string:myDelegateServicesList?.driver?.userImage ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
                self.indicator.isHidden = true
                //statusIndicatorBgImageView.isHidden = true
                statusLabel.textColor = UIColor(hex: "00B24D")
                //                self.statusBarView.backgroundColor = UIColor(hex: "00B24D")
                //                self.statusIndicatorBgImageView.backgroundColor = UIColor(hex: "00B24D")
                self.nameViewPrice.isHidden  = false
                self.nameView.isHidden  = false
            } else if (myDelegateServicesList?.serviceStatus ?? "" == "11" || myDelegateServicesList?.serviceStatus ?? "" == "7"){
                statusLabel.textColor = UIColor(hex: "F57070")
                self.indicator.isHidden = true
            }
        }
    }
    
    var currencyCode:String?{
        didSet{
            
            if myDelegateServicesList != nil {
                amountLabel.text = (currencyCode ?? "") + " " + (myDelegateServicesList?.grandTotal ?? "")
            }
            else if myList != nil {
                amountLabel.text = (currencyCode ?? "") + " " + (myList?.grand_total ?? "")
            }
            else if servicesData != nil {
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
            }else if myPGBookingList != nil {
                amountLabel.text = (currencyCode ?? "") + " " + (myPGBookingList?.total_amount ?? "")
            }
        }
    }
    var userData: User?{
        didSet{
            userTypeID = userData?.user_type_id ?? ""
            
            ///Type = 1 is Resturant Store
            if userTypeID == "1"{
                if userData?.activity_type_id == "10"{
                    if myList?.status == "0"{
                        orderAcceptView.isHidden = false
                        orderAcceptButtonStackView.isHidden = false
                        statusColorCode(color: Color.StatusYellow.color())
                    }else if myList?.status == "1"{
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.status == "2"{
                     //   readyForCollectionView.isHidden = false
                    //    readyForCollectionButtonView.isHidden = false
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.status == "5"{
                        statusColorCode(color: Color.StatusBlue.color())
                    }else if myList?.status == "6"{
                        statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    }else if myList?.status == "10" || myList?.status == "12"{
                        statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                    }else{
                        statusColorCode(color: Color.StatusRed.color())
                    }
                }else if userData?.activity_type_id == "12"{
                    if myList?.status == "0"{
                        orderAcceptView.isHidden = false
                        orderAcceptButtonStackView.isHidden = false
                        statusColorCode(color: Color.StatusYellow.color())
                    }else if myList?.status == "1"{
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.status == "2"{
                      //  startToPrepareView.isHidden = false
                       // startToPrepareButtonStatckView.isHidden = false
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.status == "5"{
                        statusColorCode(color: Color.StatusBlue.color(),indicatiorHide: true)
                    }else if myList?.status == "6"{
                        statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    }else if myList?.status == "10" || myList?.status == "12"{
                        statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                    }else{
                        statusColorCode(color: Color.StatusRed.color())
                    }
                    
                }else{
                    if myList?.status == "0"{
                        orderAcceptView.isHidden = false
                        orderAcceptButtonStackView.isHidden = false
                        statusColorCode(color: Color.StatusYellow.color())
                    }else if myList?.status == "1"{
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.status == "2"{
                     //   readyForCollectionView.isHidden = false
                      //  readyForCollectionButtonView.isHidden = false
                        statusColorCode(color: Color.StatusRed.color())
                    }else if myList?.status == "5"{
                        statusColorCode(color: Color.StatusBlue.color(),indicatiorHide: true)
                    }else if myList?.status == "6"{
                        statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                    }else if myList?.status == "10" || myList?.status == "12"{
                        statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                    }else{
                        statusColorCode(color: Color.StatusRed.color())
                    }
                }
            }else{
                if myList?.status == "0"{
                    orderAcceptView.isHidden = false
                    orderAcceptButtonStackView.isHidden = false
                    statusColorCode(color: Color.StatusYellow.color())
                }else if myList?.status == "1"{
                    statusColorCode(color: Color.StatusRed.color())
                }else if myList?.status == "2"{
                 //   readyForCollectionView.isHidden = false
                    readyForCollectionButtonView.isHidden = false
                    statusColorCode(color: Color.StatusRed.color())
                }else if myList?.status == "5"{
                    statusColorCode(color: Color.StatusBlue.color())
                }else if myList?.status == "6"{
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                }else if myList?.status == "10" || myList?.status == "12"{
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
        //        statusBarView.backgroundColor = color
        //        statusIndicatorBgImageView.backgroundColor  = color
        statusLabel.textColor = color
        
        DispatchQueue.main.async {
            if isHide{
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
            }else{
                self.indicator.isHidden = false
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
    
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: date) ?? Date()
        inputFormatter.dateFormat = "d MMM yyyy h:mma"
        let resultString = inputFormatter.string(from: showDate)
        print(resultString)
        return resultString
    }
    
    func convertLocatTime(date: String) -> String{
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
    
    
    //MARK: - IBActions
    @IBAction func startToPrepareAction(_ sender: UIButton) {
        orderStartToPrepareAPI()
    }
    @IBAction func readyForCollectionAction(_ sender: UIButton) {
        orderReadyForDeliveryAPI()
    }
    @IBAction func rejectAction(_ sender: UIButton) {
        if myList != nil {
            orderRejectedAPI()
        }else if servicesData != nil {
            self.serviceRejectedAPI()
        }else if myBookingOrder != nil {
            self.chaledRejectAPI()
        }else if myTableBookingList != nil {
            self.myTableBookingRejectAPI()
        }else if myPGBookingList != nil {
            self.pgOrderRejectedAPI()
        }else if myHotelBookingList != nil{
            self.hotelOrderRejectedAPI()
        }
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
        if myList != nil {
            orderAcceptedAPI()
        }else if servicesData != nil {
            self.orderServicesAccepted()
        }else if myBookingOrder != nil {
            self.chaledAcceptedAPI()
        }else if myTableBookingList != nil {
            self.myTableBookingAcceptedAPI()
        }else if myPGBookingList != nil {
            self.pgOrderAcceptedAPI()
        }else if myHotelBookingList != nil{
            self.hotelOrderAcceptedAPI()
        }
        
    }
    
    //MARK: - API Calls
    
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
    
    func myTableBookingRejectAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myTableBookingList?.id ?? ""
        ]
        print(parameters)
        StoreAPIManager.tableBookingRejectedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.refreshList()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func orderAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myList?.order_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.ordersAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
               // self.delegate?.refreshList()
                self.delegate?.gotoDetailsForOrderId(orderId: self.myList?.order_id ?? "")
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
    func serviceRejectedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : servicesData?.id ?? ""
        ]
        print(parameters)
        ServiceAPIManager.reject_ProviderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.refreshList()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func orderRejectedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myList?.order_id ?? ""
        ]
        print(parameters)
        StoreAPIManager.ordersRejectedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.refreshList()
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
    
    func chaledRejectAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myBookingOrder?.id ?? "",
            "status" : "5"
        ]
        print(parameters)
        CharletAPIManager.charletManagmentBookingYesNOAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.refreshList()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func orderReadyForDeliveryAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myList?.order_id ?? ""
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
            "invoice_id" : myList?.invoice_id ?? ""
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
    
    func pgOrderAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myPGBookingList?.booking_id ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.myPGBookingAcceptAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                print(result.message ?? "")
                //self.delegate?.refreshList()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func pgOrderRejectedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myPGBookingList?.booking_id ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.myPGBookingRejectAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                //self.delegate?.refreshList()
                print(result.message ?? "")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func hotelOrderRejectedAPI() {
        
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : myHotelBookingList?.booking_id ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.sellerBookingRejectAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                print(result.message ?? "")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
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
                print(result.message ?? "")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

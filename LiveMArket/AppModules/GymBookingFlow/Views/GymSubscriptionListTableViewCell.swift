//
//  GymSubscriptionListTableViewCell.swift
//  LiveMArket
//
//  Created by Greeniitc on 17/05/23.
//

import UIKit
import NVActivityIndicatorView

class GymSubscriptionListTableViewCell: UITableViewCell {

    
    
    //@IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var rejectAcceptButtonStackView: UIStackView!
    @IBOutlet weak var rejectAcceptButtonView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeIconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
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
    var mySubscriptionList:SubscriptionList?{
        didSet{
//            if self.indicator != nil {
//                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
//                self.indicator.color = .white
//                self.indicator.startAnimating()
//            }
            storeIconImageView.sd_setImage(with: URL(string: mySubscriptionList?.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            storeNameLabel.text = mySubscriptionList?.store?.name ?? ""
            orderIDLabel.text = mySubscriptionList?.subscription_invoice_id ?? ""
            dateLabel.text = self.formatDate(date: mySubscriptionList?.booking_date ?? "")
            productCountLabel.text = "Club Subscription".localiz()
            amountLabel.text = mySubscriptionList?.grand_total ?? ""
            statusLbl.text = mySubscriptionList?.status_text ?? ""
            rejectAcceptButtonView.isHidden = true
            
             
            if mySubscriptionList?.subscription_status == "0"{
                statusColorCode(color: Color.StatusYellow.color(),indicatiorHide: true)
            }else if mySubscriptionList?.subscription_status == "1"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if  mySubscriptionList?.subscription_status == "2"{
                statusColorCode(color: Color.StatusRed.color(),indicatiorHide: true)
            }else if mySubscriptionList?.subscription_status == "5"{
                statusColorCode(color: Color.StatusBlue.color(),indicatiorHide: true)
            }else if mySubscriptionList?.subscription_status == "6"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if mySubscriptionList?.subscription_status == "10" || mySubscriptionList?.subscription_status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusRed.color(),indicatiorHide: true)
            }
            if isDateStringEqualToCurrentDate(mySubscriptionList?.subscription_end_date ?? ""){
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: false)
            }
            
            if mySubscriptionList?.subscription_status == "1" || mySubscriptionList?.subscription_status == "11" || mySubscriptionList?.subscription_status == "10"{
                self.indicator.stopAnimating()
            }else{
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
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
            //statusIndicator.isHidden = false
            if (self.servicesData?.status ?? "" == "0"){
                self.statusView.backgroundColor = UIColor(hex: "FCB813")
            }else if (self.servicesData?.status ?? "" == "10" || self.servicesData?.status ?? "" == "11"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                self.indicator.isHidden = true
               // statusIndicator.isHidden = true
            }else  if (self.servicesData?.status ?? "" == "1"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                
            }else if (self.servicesData?.status ?? "" == "2"){
                self.statusView.backgroundColor = UIColor(hex: "F57070")
                
            }else if (self.servicesData?.status ?? "" == "4"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
            }else if (self.servicesData?.status ?? "" == "5"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
            }else if (self.servicesData?.status ?? "" == "6"){
                self.statusView.backgroundColor = UIColor(hex: "5795FF")
            }else if (self.servicesData?.status ?? "" == "7"){
                self.indicator.isHidden = true
               // statusIndicator.isHidden = true
                self.statusView.backgroundColor = UIColor(hex: "00B24D")
            }else if (self.servicesData?.status ?? "" == "8"){
                self.indicator.isHidden = true
                //statusIndicator.isHidden = true
                self.statusView.backgroundColor = UIColor(hex: "00B24D")
            }
            
        }
    }
    
    var currencyCode:String?{
        didSet{
            if mySubscriptionList != nil {
                amountLabel.text = (currencyCode ?? "") + " " + (mySubscriptionList?.grand_total ?? "")
            }else if servicesData != nil {
                if (servicesData?.total_amount ?? "") != "" {
                    amountLabel.text = (currencyCode ?? "") + " " + (servicesData?.total_amount ?? "")
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
//        statusView.backgroundColor = color
//        indicator.backgroundColor  = color
        statusLbl.textColor = color
        if isHide{
            indicator.isHidden       = true
           // statusIndicator.isHidden = true
        }else{
            indicator.isHidden       = false
            //statusIndicator.isHidden = false
        }
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
}

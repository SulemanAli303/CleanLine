//
//  DriverOrderListTableViewCell.swift
//  LiveMArket
//
//  Created by Greeniitc on 27/04/23.
//

import UIKit

protocol DriverOrderDelegate:AnyObject{
    func refreshList()
}

class DriverOrderListTableViewCell: UITableViewCell {

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
    
    @IBOutlet weak var rejectView: UIView!
    weak var delegate:DriverOrderDelegate?
    
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
    var myOrdersList:MyOrdersList?{
        didSet{
            storeIconImageView.sd_setImage(with: URL(string: myOrdersList?.store?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = myOrdersList?.store?.name ?? ""
            orderIDLabel.text = myOrdersList?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: myOrdersList?.booking_date ?? "")
            productCountLabel.text = ("\(myOrdersList?.total_qty ?? "") Products")
            amountLabel.text = myOrdersList?.grand_total ?? ""
            statusLbl.text = myOrdersList?.status_text ?? ""
            rejectAcceptButtonView.isHidden = true
            if myOrdersList?.status == "3"{
                rejectAcceptButtonView.isHidden = false
                statusColorCode(color: Color.StatusYellow.color())
            }else if myOrdersList?.status == "1" || myOrdersList?.status == "2"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myOrdersList?.status == "4"{
                statusColorCode(color: Color.StatusRed.color())
            }else if myOrdersList?.status == "5"{
                statusColorCode(color: Color.StatusBlue.color())
            }else if myOrdersList?.status == "6"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
            }else if myOrdersList?.status == "10" || myOrdersList?.status == "12"{
                statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
            }else{
                statusColorCode(color: Color.StatusRed.color())
            }
        }
    }
    var currencyCode:String?{
        didSet{
            amountLabel.text = (currencyCode ?? "") + " " + (myOrdersList?.grand_total ?? "")
        }
    }
    
    var delegateCurrencyCode:String?{
        didSet{
            amountLabel.text = (delegateCurrencyCode ?? "") + " " + (driverDelegateRequest?.grandTotal ?? "")
        }
    }

    
    var driverDelegateRequest: DriverDelegateServiceRequestModel?{
        didSet{
            storeIconImageView.sd_setImage(with: URL(string: driverDelegateRequest?.user?.user_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            storeNameLabel.text = driverDelegateRequest?.user?.name ?? ""
            orderIDLabel.text = driverDelegateRequest?.serviceInvoiceID ?? ""
            dateLabel.text = (driverDelegateRequest?.createdAt ?? "").changeTimeToFormat_new(frmFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", toFormat: "dd EEE yyyy hh:mm a")
            
            productCountLabel.text = driverDelegateRequest?.deligateService?.serviceName ?? ""
            amountLabel.text = driverDelegateRequest?.grandTotal ?? ""
            statusLbl.text = driverDelegateRequest?.serviceStatusText ?? ""
            rejectAcceptButtonView.isHidden = true
            if driverDelegateRequest?.serviceStatus ?? "" == "0"{
                statusColorCode(color: Color.StatusYellow.color())
                rejectAcceptButtonView.isHidden = false
                self.amountLabel.isHidden = true
            }else if driverDelegateRequest?.serviceStatus ?? "" == "1"{
                statusColorCode(color: Color.StatusRed.color())
                self.amountLabel.isHidden = true
            }else if driverDelegateRequest?.serviceStatus ?? "" == "2"{
                statusColorCode(color: Color.StatusBlue.color())
                self.amountLabel.isHidden = false
            }else if driverDelegateRequest?.serviceStatus ?? "" == "3"{
                statusColorCode(color: Color.StatusBlue.color())
                self.amountLabel.isHidden = false
            }else if driverDelegateRequest?.serviceStatus ?? "" == "4"{
                statusColorCode(color: Color.StatusBlue.color())
                self.amountLabel.isHidden = false
            }else if driverDelegateRequest?.serviceStatus ?? "" == "5"{
                statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                self.amountLabel.isHidden = false
            }else {
                statusColorCode(color: Color.StatusRed.color())
                self.amountLabel.isHidden = false
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
    
 
    @IBAction func accept(_ sender: Any) {
        if driverDelegateRequest != nil {
            self.setAcceptDelegate()
        }else {
            self.orderAcceptedAPI()
        }
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
    
    //MARK: - API Calls
    
    func orderAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : myOrdersList?.order_id ?? ""
        ]
        print(parameters)
        if myOrdersList?.type == "1"{
            FoodAPIManager.driverAcceptedOrderAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.delegate?.refreshList()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            StoreAPIManager.driverAcceptedOrderAPI(parameters: parameters) { result in
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
    func setAcceptDelegate() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_id" : driverDelegateRequest?.id ?? ""
        ]
        DelegateServiceAPIManager.driverAcceptServiceAPI(parameters: parameters) { result in
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

//
//  RateVC.swift
//  LiveMArket
//
//  Created by Zain on 17/01/2023.
//

import UIKit
import Cosmos
import STRatingControl
import KMPlaceholderTextView
import Cosmos

class ServiceRateVC: UIViewController {

    var RequestData :  ChaletsBookingDetailsData?
    var VCtype : String?
    var isFromChaletBooking : Bool = false

    @IBOutlet var deliveryStatusStackView: UIStackView!
    @IBOutlet var locIconView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var des: KMPlaceholderTextView!
    
    @IBOutlet var deliveryDateLabel: UILabel!
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet weak var reviewView: CosmosView! {
        didSet{
            reviewView.settings.fillMode = .half
            reviewView.settings.starMargin = 10
            reviewView.settings.starSize = 30
            reviewView.settings.minTouchRating = 0
        }
    }
    @IBOutlet weak var loc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text =  RequestData?.product?.product_name ?? ""
        loc.text = RequestData?.product?.address ?? ""
        profile.sd_setImage(with: URL(string: RequestData?.product?.primary_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        if isFromChaletBooking{
            locIconView.isHidden = true
            loc.isHidden = true
            deliveryStatusStackView.isHidden = false
            deliveryDateLabel.text = self.formatDate(date: RequestData?.booking?.completed_on ?? "")
            statusLabel.text = RequestData?.booking?.bookingStatus
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
    
    //MARK: - Actions
    @IBAction func Latter(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        guard des.text != "" else {
            Utilities.showWarningAlert(message: "Please type your review.".localiz()) {
                
            }
            return
        }
        guard reviewView.rating != 0 else {
            Utilities.showWarningAlert(message: "Please select rating star".localiz()) {
                
            }
            return
        }
        self.rateChaletAPI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
}
extension ServiceRateVC {
    func rateChaletAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.RequestData?.booking?.id ?? "",
            "ratings" : "\(reviewView.rating)",
            "comment":des.text ?? ""
        ]
        CharletAPIManager.setChaletReviewAPI(parameters: parameters) { result in
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
}

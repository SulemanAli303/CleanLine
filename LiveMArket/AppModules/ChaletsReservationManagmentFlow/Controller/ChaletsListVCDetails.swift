//
//  RoomListVC.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit
import FloatRatingView

class ChaletsListVCDetails: BaseViewController {
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var chaletName: UILabel!
    @IBOutlet weak var loc: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var myView: UIView!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var tableView: IntrinsicallySizedTableView!
    var chaledId = ""
    
    var myOrdersData:ChaletsManagmentProduct?{
        didSet{
            
            floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
            floatRatingView.type = .halfRatings
            viewControllerTitle = myOrdersData?.name ?? ""
            myImage.sd_setImage(with: URL(string:  myOrdersData?.coverImage ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            chaletName.text = myOrdersData?.name ?? ""
            loc.text =  myOrdersData?.address ?? ""
            des.text = myOrdersData?.description ?? ""
            rate.text = "\(myOrdersData?.ratings ?? "") \("Star Ratings".localiz())"
            floatRatingView.rating = Double(myOrdersData?.ratings ?? "") ?? 0.0
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        
        myImage.layer.cornerRadius = 165
        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        myOrdesListAPI()
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    func setData() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ChaletsBookingListCell", bundle: nil), forCellReuseIdentifier: "ChaletsBookingListCell")
        tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
}

// MARK: - TableviewDelegate
extension ChaletsListVCDetails : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChaletsBookingListCell", for: indexPath) as! ChaletsBookingListCell
        cell.base  = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
extension ChaletsListVCDetails {
    func myOrdesListAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "id" : chaledId
        ]
        
        
        CharletAPIManager.getCharletManagementListProductAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myOrdersData = result.oData?.product
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

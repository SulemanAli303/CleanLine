//
//  RoomListVC.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit
import STRatingControl
import Cosmos

class GymPackegesList: BaseViewController {
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView! {
        didSet {
            ratingView.settings.fillMode = .half
            ratingView.settings.starMargin = 10
            ratingView.settings.starSize = 15
            ratingView.settings.minTouchRating = 0
        }
    }
    
    @IBOutlet weak var addressView: UIView!
    
    
    
    @IBOutlet weak var tableView: IntrinsicallySizedTableView!
    var sellerID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        viewControllerTitle = "Gold's Gym".localiz()
        myImage.layer.cornerRadius = 165
        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.gymDetailsAPI()
        setData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    @IBAction func proceedAction(_ sender: UIButton) {
        if SessionManager.isLoggedIn() {
            Coordinator.goToGymSelectPackage(controller: self,store_id: self.gymData?.seller_data?.id ?? "")
        }else {
            Coordinator.presentLogin(viewController: self)
        }
    }
    @IBAction func reviewPageNavigation(_ sender: UIButton) {
   
        SellerOrderCoordinator.goToMyReviews(controller: self,store_id: sellerID,isFromProfile: false)
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    func setData() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "GymBookingListCell", bundle: nil), forCellReuseIdentifier: "GymBookingListCell")
        tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    
    var gymData:GymDetailsOData?{
        didSet{
            packageList = gymData?.packages_list ?? []
            nameLabel.text = gymData?.seller_data?.name ?? ""
            ratingView.rating = Double(gymData?.seller_data?.rating ?? "") ?? 0.0
            ratingLabel.text = "\(gymData?.seller_data?.rating ?? "") \("star ratings".localiz())"
            aboutLabel.text = gymData?.seller_data?.about_me ?? ""
            myImage.sd_setImage(with: URL(string: gymData?.seller_data?.banner_image ?? ""), placeholderImage: UIImage(named: "placeholder_banner"))
            viewControllerTitle = gymData?.seller_data?.name ?? ""
            addressLabel.text = gymData?.seller_data?.user_location?.location_name ?? ""
            self.addressView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    var packageList:[Packages_list]?{
        didSet{
            
        }
    }
    
    
    func gymDetailsAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "seller_user_id" : sellerID
        ]
        print(parameters)
        
        GymAPIManager.gymDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.gymData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

// MARK: - TableviewDelegate
extension GymPackegesList : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GymBookingListCell", for: indexPath) as! GymBookingListCell
        cell.base  = self
        cell.packageData = packageList?[indexPath.row]
        cell.currency = gymData?.currency_code ?? ""
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

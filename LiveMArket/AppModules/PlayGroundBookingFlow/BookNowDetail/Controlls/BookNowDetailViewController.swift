//
//  ShopProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit
import Cosmos

class BookNowDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: IntrinsicallySizedTableView!
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var subNameLbl: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var rateStarView: CosmosView!{
        didSet{
            rateStarView.settings.fillMode = .half
        }
    }
    @IBOutlet weak var favImg: UIImageView!
    
    
    var optionsArray = [String]()
    var selectedIndex:Int = 0
    var selectedCategory  = 0
    var storeID:String = ""
    var groundListArray:[Grounds] = []
    var page:Int = 1
    var limit:Int = 10
    var hasFetchAll:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllerTitle = ""
        
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        myImage.layer.cornerRadius = 165
        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        setup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        type = .transperantBack
        playGroundDetailsAPI()
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    var groundData : GroundListData? {
        didSet {
            scroller.isHidden = false
            scroller.delegate = self
            let count = groundData?.grounds?.count ?? 0
            if count < self.limit{
                hasFetchAll = true
            }
            
            groundListArray = groundData?.grounds ?? []
            viewControllerTitle = groundData?.vendor?.name ?? ""
            nameLbl.text = groundData?.vendor?.name ?? ""
            about.text = groundData?.vendor?.about_me ?? ""
            locLbl.text = groundData?.vendor?.user_location?.location_name ?? ""
            star.text = "\(groundData?.vendor?.rating ?? "") \("Star Ratings".localiz())"
            myImage.sd_setImage(with: URL(string: groundData?.vendor?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            rateStarView.rating = Double(groundData?.vendor?.rating ?? "0") ?? 0
            ///Favorite code
//            if groundData?.vendor?.is_liked == "1"{
//                favImg.image = UIImage(named: "liked")
//            }else{
//                favImg.image = UIImage(named: "unliked")
//            }
            
            if let isFav = groundData?.vendor?.isFav , isFav == "1" {
                self.favImg.image = UIImage(named: "liked")
            }else{
                self.favImg.image = UIImage(named: "unliked")
            }
            
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    func setup() {
        // MARK: - TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(BookNowDetailCell.nib, forCellReuseIdentifier: BookNowDetailCell.identifier)
        self.tableView.tableFooterView = UIView()
    }
    @IBAction func favoriteAction(_ sender: UIButton) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: self)
        }else {
            self.AddTOFav()
        }
    }
    
    func AddTOFav() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "store_id" : storeID,
        ]
        StoreAPIManager.storeFavAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.playGroundDetailsAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
}

extension BookNowDetailViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groundListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: BookNowDetailCell.identifier, for: indexPath) as! BookNowDetailCell
        Cell.selectionStyle = .none
        Cell.groundData = self.groundListArray[indexPath.row]
        Cell.currency = self.groundData?.currency_code ?? ""
        Cell.bookNow.tag = indexPath.row
        Cell.bookNow.addTarget(self, action: #selector(accept(sender: )), for: .touchUpInside)
        
        return Cell
    }
   @objc func accept(sender: UIButton)
    {
        PlayGroundCoordinator.goToDateTime(controller: self,groundID: groundListArray[sender.tag].id ?? "",storeID: storeID)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else{return}
        if hasFetchAll{return}
        page += 1
        playGroundDetailsAPI()
        
    }
}

extension BookNowDetailViewController {
    func playGroundDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "vendor_id" : storeID,
            "limit":"",
            "page":page.description
        ]
        StoreAPIManager.playGroundListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.groundData = result.oData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
}

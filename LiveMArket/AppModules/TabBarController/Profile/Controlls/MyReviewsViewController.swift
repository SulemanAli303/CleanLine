//
//  MyReviewsViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 23/01/2023.
//

import UIKit
import STRatingControl
import Cosmos

class MyReviewsViewController: BaseViewController {

    
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var reviewView: CosmosView!{
        didSet{
            reviewView.settings.fillMode = .half
            reviewView.settings.starMargin = 5
            reviewView.settings.starSize = 25
            reviewView.settings.minTouchRating = 0
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewSummy: UIView!
    
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var isFromDriver:Bool = true
    var driverReviewList:[DriverReviewList] = []
    var commonReviewList:[ReviewList] = []
    var storeID:String = ""
    var isFromMyProfile:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        type = .backWithTop
        reviewsLabel.text = "Reviews and Rattings".localiz()
        if isFromMyProfile{
            viewControllerTitle = "My Reviews".localiz()
        }else{
            if isFromDriver{
                viewControllerTitle = "My Reviews".localiz()
            }else{
                viewControllerTitle = "Reviews & Ratings".localiz()
            }
        }
        
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        resetPage()
        if isFromDriver{
            driverReviewAPI()
        }else{
            commonReviewAPI()
        }
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func resetPage(){
        pageCount = 1
        driverReviewList.removeAll()
        commonReviewList.removeAll()
    }
    
    var reviewBase:DriverBaseData?{
        didSet{
            print(reviewBase?.pagination)
        }
    }
    
    var reviewData:DriverReviewData?{
        didSet{
            ratingCountLabel.text = reviewData?.rated_users ?? "0"
            reviewCountLabel.text = "\(Double(reviewData?.rating ?? "0") ?? 0.0)"
            reviewView.rating = Double(reviewData?.rating ?? "0") ?? 0.0
             
            let count = Int(reviewData?.list?.count ?? 0)
            if count < self.pageLimit{
                hasFetchedAll = true
            }
            driverReviewList.append(contentsOf: reviewData?.list ?? [DriverReviewList]())
            self.tableView.reloadData()
            
        }
    }
    
    var commonReviewData:ReviewData?{
        didSet{
            ratingCountLabel.text = commonReviewData?.rated_users ?? "0"
            reviewCountLabel.text = "\(Double(commonReviewData?.rating ?? "0") ?? 0.0)"
            reviewView.rating = Double(commonReviewData?.rating ?? "0") ?? 0.0
             
            let count = Int(commonReviewData?.list?.count ?? 0)
            if count < self.pageLimit{
                hasFetchedAll = true
            }
            commonReviewList.append(contentsOf: commonReviewData?.list ?? [ReviewList]())
            self.tableView.reloadData()
            
        }
    }
    
    

    func setup() {
        // MARK: - TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(ReviewsTableViewCell.nib, forCellReuseIdentifier: ReviewsTableViewCell.identifier)
        //self.tableView.tableFooterView = UIView()
    }
    //MARK: - API Calls
    
    func driverReviewAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "page":pageCount.description,
            "limit":pageLimit.description,
            "store_id":storeID
        ]
        print(parameters)
        StoreAPIManager.myReviewAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.reviewBase = result.oData
                self.reviewData = result.oData?.data
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func commonReviewAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "page":pageCount.description,
            "limit":pageLimit.description,
            "store_id":storeID
        ]
        print(parameters)
        StoreAPIManager.commonReviewAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.commonReviewData = result.oData?.data
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    

}
extension MyReviewsViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFromDriver{
            guard driverReviewList.count != 0 else {
                tableView.setEmptyView(title: "", message: "No Reviews Found!".localiz(), image: UIImage(named: "undraw_reviews_lp8w 1"))
                reviewSummy.isHidden = true
                return 0
            }
            tableView.backgroundView = nil
            reviewSummy.isHidden = false
            return self.driverReviewList.count
        }else{
            guard commonReviewList.count != 0 else {
                tableView.setEmptyView(title: "", message: "No Reviews Found!".localiz(), image: UIImage(named: "undraw_reviews_lp8w 1"))
                reviewSummy.isHidden = true
                return 0
            }
            tableView.backgroundView = nil
            reviewSummy.isHidden = false
            return self.commonReviewList.count
        }
         
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFromDriver{
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: ReviewsTableViewCell.identifier, for: indexPath) as! ReviewsTableViewCell
             Cell.selectionStyle = .none
            Cell.review = driverReviewList[indexPath.row]
            return Cell
        }else{
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: ReviewsTableViewCell.identifier, for: indexPath) as! ReviewsTableViewCell
             Cell.selectionStyle = .none
            Cell.commonReview = commonReviewList[indexPath.row]
            return Cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else {return}
        if hasFetchedAll{return}
        pageCount += 1
        if isFromDriver{
            driverReviewAPI()
        }else{
            commonReviewAPI()
        }
        
    }
}

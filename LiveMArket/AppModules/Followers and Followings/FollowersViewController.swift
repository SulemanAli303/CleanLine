//
//  FollowersViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 04/07/23.
//

import UIKit

class FollowersViewController: BaseViewController {

    @IBOutlet weak var followersTableview: UITableView!
    
    var followersListArray:[FollowList] = []
    var postUserID:String = ""
    
        override func viewDidLoad() {
            super.viewDidLoad()
            type = .backWithTop
            viewControllerTitle = "Followers"
            setData()
        }
        func setData() {
            followersTableview.delegate = self
            followersTableview.dataSource = self
            followersTableview.reloadData()
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            getFollowersListAPI()
        }
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
        }
    
    var followData: FollowData?{
        didSet{
            followersListArray = followData?.list ?? []
            self.followersTableview.reloadData()
        }
    }
    
    
     
    }

    // MARK: - UITableView Implemetation
    extension FollowersViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            guard followersListArray.count != 0 else {
                tableView.setEmptyView(title: "", message: "No Followers Found", image: UIImage(named: "followerEmpty"))
                
                return 0
            }
            tableView.backgroundView = nil
            return self.followersListArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersTableViewCell", for: indexPath) as? FollowersTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.userID = postUserID
            cell.data = followersListArray[indexPath.row]
            cell.delegate = self
            
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            
        }
    }

extension FollowersViewController {
    
    func getFollowersListAPI() {
        
        var userIDString:String = "0"
        
        if postUserID == SessionManager.getUserData()?.id ?? ""{
            userIDString = SessionManager.getUserData()?.id ?? ""
        }else{
            userIDString = postUserID
        }
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "page" : "1",
            "limit" : "20",
            "user_id" : userIDString,
            "search_key" : ""
        ]
        print(parameters)
        StoreAPIManager.followersListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.followData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func removeFollowerAPI(follow_ID:String) {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "follow_id" : follow_ID
        ]
        print(parameters)
        StoreAPIManager.removefollowersListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getFollowersListAPI()
                // self.SellerData = result.oData?.sellerData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {

                }
            }
        }
    }
    
    func addFollowerAPI(user_ID:String) {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "follow_user_id" : user_ID
        ]
        print(parameters)
        StoreAPIManager.AddfollowersListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getFollowersListAPI()
                // self.SellerData = result.oData?.sellerData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {

                }
            }
        }
    }
}


extension FollowersViewController:FollowerProtocol{
    func addFollower(userID: String) {
        addFollowerAPI(user_ID: userID)
    }
    
    func remove(followID: String) {
        Utilities.showQuestionAlert(message: "Are you sure want to remove this follower?"){
            self.removeFollowerAPI(follow_ID: followID)
        }
    }
    
    
}

//
//  FollowingsViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 04/07/23.
//

import UIKit

class FollowingsViewController: BaseViewController {
    
    @IBOutlet weak var followingsTableview: UITableView!
    
    var followingsListArray:[FollowList] = []
    var postUserID:String = ""
    
        override func viewDidLoad() {
            super.viewDidLoad()
            type = .backWithTop
            viewControllerTitle = "Followings"
            setData()
        }
        func setData() {
            followingsTableview.delegate = self
            followingsTableview.dataSource = self
            followingsTableview.reloadData()
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            getFollowingsListAPI()
        }
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
        }
    
    var followingsData: FollowData?{
        didSet{
            followingsListArray = followingsData?.list ?? []
            self.followingsTableview.reloadData()
        }
    }
    }
// MARK: - UITableView Implemetation
extension FollowingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard followingsListArray.count != 0 else {
            tableView.setEmptyView(title: "", message: "User Not Following Anyone", image: UIImage(named: "followingEmpty"))
            
            return 0
        }
        tableView.backgroundView = nil
        return followingsListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingsTableViewCell", for: indexPath) as? FollowingsTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.userID = postUserID
        cell.data = followingsListArray[indexPath.row]
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
extension FollowingsViewController {
    
    func getFollowingsListAPI() {
        
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
        StoreAPIManager.followingListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.followingsData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    func unFollowerAPI(user_ID:String) {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "follow_user_id" : user_ID
        ]
        print(parameters)
        StoreAPIManager.AddfollowersListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getFollowingsListAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {

                }
            }
        }
    }
}

extension FollowingsViewController : FollowingProtocol{
    func unFollowing(userID: String) {
        
        Utilities.showQuestionAlert(message: "Are you sure want to un follow this user?"){
            self.unFollowerAPI(user_ID: userID)
        }
    }
    
    
}

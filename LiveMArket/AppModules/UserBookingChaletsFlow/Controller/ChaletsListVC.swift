//
//  ChaletsListVC.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit

class ChaletsListVC: BaseViewController,Refreshable {
    var page = 1
    var isLoadMore = true
    var isFecthing = false
    var store_id:String = ""
    
    var productChaletArray = [ChaletsList]()
    
    var chaletProduct : ProductChaletsBase? {
        didSet {
            if (self.page == 1){
                self.productChaletArray.removeAll()
                self.productChaletArray = chaletProduct?.list ?? []
                if ( chaletProduct?.list?.count ?? 0 < 10){
                    self.isLoadMore = false
                }
            }else {
                self.productChaletArray.append(contentsOf: chaletProduct?.list ?? [])
                if ( chaletProduct?.list?.count ?? 0 < 10){
                    self.isLoadMore = false
                }
            }
            tableView.reloadData()
        }
    }
    var refreshControl: UIRefreshControl?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "Select Chalets"
        setData()
    }
    func setData() {
        tableView.register(UINib(nibName: "ChaletsListCell", bundle: nil), forCellReuseIdentifier: "ChaletsListCell")
        tableView.delegate = self
        tableView.dataSource = self
        installRefreshControl()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        resetData()
    }
    func resetData() {
        isLoadMore = true
        isFecthing = false
        page = 1
        self.getChaletListAPI()
    }
}
extension ChaletsListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (productChaletArray.count ) != 0 else {
            tableView.setEmptyView(title: "", message: "No Data Found!", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
            
            return 0
        }
        tableView.backgroundView = nil
        return self.chaletProduct?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChaletsListCell", for: indexPath) as! ChaletsListCell
        let data = productChaletArray[indexPath.row]
        cell.base  = self
        cell.productData = data
        cell.currencyTxt = self.chaletProduct?.currency_code ?? ""
        cell.bookNowView.isHidden = false
        if SessionManager.getUserData()?.id ?? "" == store_id {
            cell.bookNowView.isHidden = true
        }
        cell.setData()
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChaletsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Coordinator.goToCharletsRoom(controller: self,chaletID: productChaletArray[indexPath.row].id ?? "")
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
        if(self.isLoadMore == true && self.isFecthing == false){
            self.page =  self.page + 1
            self.getChaletListAPI()
        }else {
            return
        }
        
    }
}

extension ChaletsListVC {
    // MARK: - Refresh controll added
    func handleRefresh(_ sender: UITableView) {
        refreshControl?.endRefreshing()
        page = 1
        isLoadMore = true
        isFecthing = false
        self.getChaletListAPI()
    }
    func getChaletListAPI() {
        self.isFecthing = false
        if SessionManager.getUserData()?.user_type_id ?? "" == "2" && store_id == SessionManager.getUserData()?.id  {
            if SessionManager.getUserData()?.activity_type_id ?? "" == "6" {
                let parameters:[String:String] = [
                    "access_token" : SessionManager.getAccessToken() ?? "",
                    "limit" : "10",
                    "page" : String(page)
                ]
                print(parameters)
                CharletAPIManager.getCharletManagementListAPI(parameters: parameters) { result in
                    switch result.status {
                    case "1":
                        self.isFecthing = false
                        self.chaletProduct = result.oData
                    default:
                        self.isFecthing = false
                        Utilities.showWarningAlert(message: result.message ?? "") {
                            
                        }
                    }
                }
            }else{
                getChaletFromStore()
            }
        } else {
            getChaletFromStore()
        }
    }
    
    func getChaletFromStore(){
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "limit" : "10",
            "page" : String(page),
            "vendor_id":store_id
        ]
        CharletAPIManager.getCharletListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.isFecthing = false
                self.chaletProduct = result.oData
            default:
                self.isFecthing = false
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

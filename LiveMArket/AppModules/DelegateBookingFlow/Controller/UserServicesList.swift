//
//  UserServicesList.swift
//  LiveMArket
//
//  Created by Zain on 29/08/2023.
//

import UIKit

class UserServicesList: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var myServciesList = [DataClass]()
    var myDelegateServicesData:UserRequestDelegatesData?{
        didSet{
            if pageCount == 1 {
            self.myServciesList.removeAll()
            }
            let count = Int(myDelegateServicesData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            self.myServciesList.append(contentsOf: myDelegateServicesData?.list ?? [DataClass]())
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        viewControllerTitle = "Delegate Services".localiz()
        type = .backWithTop
        super.viewDidLoad()
        self.setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.solidBackNav()
        self.setBackWithBar()
        super.viewDidAppear(animated)
        self.solidBackNav()
        self.setBackWithBar()
    }
    @objc func setupNotificationObserver()
    {
        self.resetPage()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        viewControllerTitle = "Delegate Services".localiz()
        type = .backWithTop
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.resetPage()
    }
    @IBAction func chooseNewService(_ sender: UIButton) {
        Coordinator.goToChooseDelegate(controller: self)
    }
    func resetPage() {
        self.hasFetchedAll = false
        pageCount = 1
        myServciesList.removeAll()
        self.getDelegatesList()
    }
    func setup() {
        // MARK: - TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(BookingCellTableViewCell.nib, forCellReuseIdentifier: BookingCellTableViewCell.identifier)
        
    }
}
extension UserServicesList {
    func getDelegatesList() {
        let parameters:[String:String] = [
            "access_token": SessionManager.getUserData()?.accessToken ?? "",
            "page" : String(pageCount),
            "limit" : "10"
        ]
        DelegateServiceAPIManager.getUserRequestListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.solidBackNav()
                self.setBackWithBar()
                self.myDelegateServicesData = result.oData
            default:
                break
//                Utilities.showWarningAlert(message: result.message ?? "") {
//
//                }
            }
        }
    }
}
extension UserServicesList : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard myServciesList.count != 0 else {
            tableView.setEmptyView(title: "", message: "You have no service requests".localiz(), image: UIImage(named: "undraw_personal_file_re_5joy 1"))
            
            return 0
        }
        tableView.backgroundView = nil
        return self.myServciesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: BookingCellTableViewCell.identifier, for: indexPath) as! BookingCellTableViewCell
        Cell.selectionStyle = .none
        if  myServciesList.count > indexPath.row  {
            Cell.myDelegateServicesList = myServciesList[indexPath.row]
            Cell.currencyCode = myDelegateServicesData?.currencyCode ?? ""
        }
        return Cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID:  myServciesList[indexPath.row].id)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
        if  hasFetchedAll { return }
        pageCount += 1
        self.getDelegatesList()
        
    }
}

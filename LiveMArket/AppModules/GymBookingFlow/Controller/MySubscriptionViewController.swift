//
//  MySubscriptionViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 16/05/23.
//

import UIKit



class MySubscriptionViewController: BaseViewController {

    @IBOutlet weak var topButtonStackView: UIStackView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var myOrdersButton: UIButton!
    @IBOutlet weak var receivedOrdersButton: UIButton!
    
    @IBOutlet weak var tableView: IntrinsicallySizedTableView!
    
    enum DeviceType {
        case safeArea
        case nonSafeArea
    }
    var VCtype = ""
    var isMyOrderListClicked:Bool = true
    var isFromThankUPage:Bool = false
    var isFromDriver:Bool = false
    var isFromResturant:Bool = false
    var mySubscriptionList:[SubscriptionList] = []
    var receivedSubscriptionList:[SubscriptionList?] = []
    var isFromProfileNewOrder:Bool = false
    var isFromProfileOrderProcess:Bool = false
    
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var userData: User?
    
    var mySubscriptionData:SubscriptionData?{
        didSet{
            print(mySubscriptionData?.currency_code ?? "")
            let count = Int(mySubscriptionData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            self.mySubscriptionList.append(contentsOf: mySubscriptionData?.list ?? [SubscriptionList]())
            self.tableView.reloadData()
        }
    }
    var myReceivedSubscriptionData:SubscriptionData?{
        didSet{
            let count = Int(myReceivedSubscriptionData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            
            
            if isFromProfileNewOrder{
                self.receivedSubscriptionList.removeAll()
                for index in 0..<(myReceivedSubscriptionData?.list?.count ?? 0) {
                    if myReceivedSubscriptionData?.list?[index].subscription_status == "0"{
                        self.receivedSubscriptionList.append(myReceivedSubscriptionData?.list?[index])
                    }
                }
            }else if isFromProfileOrderProcess{
                self.receivedSubscriptionList.removeAll()
//                for index in 0..<(myReceivedSubscriptionData?.list?.count ?? 0) {
//                    if myReceivedSubscriptionData?.list?[index].subscription_status == "1" || myReceivedSubscriptionData?.list?[index].subscription_status == "2" || myReceivedSubscriptionData?.list?[index].subscription_status == "3" || myReceivedSubscriptionData?.list?[index].subscription_status == "4" ||
//                        myReceivedSubscriptionData?.list?[index].subscription_status == "5" {
//                        self.receivedSubscriptionList.append(myReceivedSubscriptionData?.list?[index])
//                    }
//                }
            }else{
                self.receivedSubscriptionList.append(contentsOf: myReceivedSubscriptionData?.list ?? [SubscriptionList]())
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        userData = SessionManager.getUserData()
        type = .backWithNotifications
        viewControllerTitle = "My Subscriptions"
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        setup()
        
    }
    @objc func setupNotificationObserver()
    {
        
        self.resetPage()
        DispatchQueue.main.async {
            if self.isMyOrderListClicked{
                self.mySubscriptionAPI()
            }else{
                self.myReceivedSubscribrsAPI()
            }
        }
        
        if isFromDriver{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
        }else{
            
            if view.safeAreaInsets.bottom >= 0 {
                topView.isHidden = false
                topViewHeightConstraint.constant = 180
            } else {
                topView.isHidden = false
                topViewHeightConstraint.constant = 150
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        type = .backWithNotifications
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        
        if isFromDriver{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
        }else{
            if view.safeAreaInsets.bottom >= 0 {
                topView.isHidden = false
                topViewHeightConstraint.constant = 180
            } else {
                topView.isHidden = false
                topViewHeightConstraint.constant = 150
            }
        }
        
        //check logged user is Playgroud Store
        if userData?.user_type_id == "2"{
            if userData?.activity_type_id == "16"{
                topButtonStackView.isHidden = false
                if view.safeAreaInsets.bottom >= 0 {
                    topView.isHidden = false
                    topViewHeightConstraint.constant = 180
                } else {
                    topView.isHidden = false
                    topViewHeightConstraint.constant = 150
                }

                    if self.isMyOrderListClicked{
                            self.resetPage()
                            self.mySubscriptionAPI()
                            self.myOrdersButton.backgroundColor = .white
                            self.receivedOrdersButton.backgroundColor = .clear
                            self.myOrdersButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
                            self.receivedOrdersButton.setTitleColor(UIColor.white, for: .normal)

                    }else{
                        self.myReceivedSubscribrsAPI()
                    }
            }else{
                loadingDefalut()
            }
        }else{
            loadingDefalut()
        }
        
        if isFromProfileNewOrder{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
            viewControllerTitle = "New Orders"
        }
        if isFromProfileOrderProcess{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
            viewControllerTitle = "Orders on Process"
        }

        if Constants.shared.isCommingFromOrderPopup {
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
        }
    }
    
    func loadingDefalut(){
        self.resetPage()
        self.mySubscriptionAPI()
        topView.isHidden = false
        topButtonStackView.isHidden = true
        
        let deviceType = getDeviceType()
        switch deviceType {
        case .safeArea:
            topView.isHidden = false
            topViewHeightConstraint.constant = 100
        case .nonSafeArea:
            topView.isHidden = false
            topViewHeightConstraint.constant = 100
        }
        
    }
    func getDeviceType() -> DeviceType {
        if #available(iOS 11.0, *) {
            if UIApplication.shared.windows.first?.safeAreaInsets != UIEdgeInsets.zero {
                return .safeArea
            }
        }
        return .nonSafeArea
    }
    
    func resetPage() {
        pageCount = 1
        mySubscriptionList.removeAll()
        receivedSubscriptionList.removeAll()
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    func setup() {
        // MARK: - TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(GymSubscriptionListTableViewCell.nib, forCellReuseIdentifier: GymSubscriptionListTableViewCell.identifier)
        self.tableView.register(ReceivedSubscriptionTableViewCell.nib, forCellReuseIdentifier: ReceivedSubscriptionTableViewCell.identifier)
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func notificationBtnAction() {
        Coordinator.goToNotifications(controller: self)
    }
    
    @IBAction func myOrdwersAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.isMyOrderListClicked = true
            self.resetPage()
            self.mySubscriptionAPI()
            self.myOrdersButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
            self.receivedOrdersButton.setTitleColor(UIColor.white, for: .normal)
            self.myOrdersButton.backgroundColor = .white
            self.receivedOrdersButton.backgroundColor = .clear
        }
    }
    @IBAction func receivedOrdwersAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.isMyOrderListClicked = false
            self.resetPage()
            self.myReceivedSubscribrsAPI()
            self.myOrdersButton.setTitleColor(UIColor.white, for: .normal)
            self.receivedOrdersButton.setTitleColor(UIColor(hexString: "#F1B943"), for: .normal)
            self.myOrdersButton.backgroundColor = .clear
            self.receivedOrdersButton.backgroundColor = .white
        }
    }
    
    //MARK: - API Calls
    
    func mySubscriptionAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "page":pageCount.description,
            "limit":pageLimit.description
        ]
        print(parameters)
        GymAPIManager.mySubscriptionAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.mySubscriptionData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
        
    }
    
    func myReceivedSubscribrsAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
//            "page":pageCount.description,
//            "limit":pageLimit.description
//
            "page":"1",
            "limit":"100"
        ]
        print(parameters)
        
        GymAPIManager.myReceivedSubscriptionAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myReceivedSubscriptionData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }

}


extension MySubscriptionViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isMyOrderListClicked{
            guard mySubscriptionList.count != 0 else {
                tableView.setEmptyView(title: "", message: "You have no subscription", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                
                return 0
            }
            tableView.backgroundView = nil
            return self.mySubscriptionList.count
        }else{
            guard receivedSubscriptionList.count != 0 else {
                tableView.setEmptyView(title: "", message: "You have'nt received any subscription", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                
                return 0
            }
            tableView.backgroundView = nil
            return self.receivedSubscriptionList.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isMyOrderListClicked{
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: GymSubscriptionListTableViewCell.identifier, for: indexPath) as! GymSubscriptionListTableViewCell
            Cell.selectionStyle = .none
            Cell.mySubscriptionList = self.mySubscriptionList[indexPath.row]
            Cell.currencyCode = self.mySubscriptionData?.currency_code ?? ""
            
            Cell.acceptBtn.tag = indexPath.row
            Cell.acceptBtn.addTarget(self, action: #selector(accept(_:)), for: .touchUpInside)
            return Cell
        }else{
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: ReceivedSubscriptionTableViewCell.identifier, for: indexPath) as! ReceivedSubscriptionTableViewCell
           // Cell.selectionStyle = .none
            Cell.myList = receivedSubscriptionList[indexPath.row]
            Cell.currencyCode = self.myReceivedSubscriptionData?.currency_code ?? ""
            Cell.addBurron.tag = indexPath.row
            Cell.addBurron.addTarget(self, action: #selector(addNumber(_:)), for: .touchUpInside)
            
            return Cell
        }
    }
    @objc func addNumber(_ sender: UIButton)
    {
        self.acceptSubscriptionAPI(subId: receivedSubscriptionList[sender.tag]?.id ?? "")
    }
    @objc func accept(_ sender: UIButton)
    {
        if VCtype == "true"
        {
            SellerOrderCoordinator.goToSellerBookingStatus(controller: self, status: "ready")
        }else
        {
           // SellerOrderCoordinator.goToSellerBookingDetail(controller: self, orderId: self.mySubscriptionList[sender.tag].order_id ?? "", isSeller: false)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
        
        if isMyOrderListClicked{
            VC.subscriptionID = mySubscriptionList[indexPath.row].id ?? ""
            VC.isFromReceivedSubscription = false
        }else{
            VC.subscriptionID = receivedSubscriptionList[indexPath.row]?.id ?? ""
            VC.isFromReceivedSubscription = true
        }
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isMyOrderListClicked{
            guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
            if  hasFetchedAll { return }
            pageCount += 1
            mySubscriptionAPI()
        }else{
//            guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
//            if  hasFetchedAll { return }
//            pageCount += 1
//            myReceivedSubscribrsAPI()
        }
    }
}

extension MySubscriptionViewController:StatusUpdateProtocol{
    func refreshment() {
        DispatchQueue.main.async {
            self.myReceivedSubscribrsAPI()
        }
        
    }
    func acceptSubscriptionAPI(subId:String) {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "subscription_id" : subId,
            "subscription_no": "",
            "accept_note": ""
        ]
        print(parameters)
        GymAPIManager.acceptSubscriptionAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myReceivedSubscribrsAPI()
                
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
        
    }
}

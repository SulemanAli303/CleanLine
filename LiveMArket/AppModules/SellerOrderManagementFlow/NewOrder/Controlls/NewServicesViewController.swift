//
//  NewOrderViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 21/01/2023.
//

import UIKit

class NewServicesViewController: BaseViewController {
    enum DeviceType {
        case safeArea
        case nonSafeArea
    }
    @IBOutlet weak var topButtonStackView: UIStackView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var myOrdersButton: UIButton!
    @IBOutlet weak var receivedOrdersButton: UIButton!
    
    @IBOutlet weak var tableView: IntrinsicallySizedTableView!
    
    var VCtype = ""
    var isMyOrderListClicked:Bool = true
    var isFromThankUPage:Bool = false
    var isFromDriver:Bool = false
    var isFromResturant:Bool = false
    var myOrdersList:[ServiceData] = []
    var receivedOrdersList:[ServiceData?] = []
    var isFromNewOrdersFromProfile:Bool = false
    var isFromNewProcessOrdersFromProfile:Bool = false
    
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var userData: User?
    
    var myOrdersData:MyServicesData?{
        didSet{
            print(myOrdersData?.currency_code ?? "")
            let count = Int(myOrdersData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            self.myOrdersList.append(contentsOf: myOrdersData?.list ?? [ServiceData]())
            self.tableView.reloadData()
        }
    }
    var myReceivedOrdersData:MyServicesData?{
        didSet{
            let count = Int(myReceivedOrdersData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            
            
            if isFromNewOrdersFromProfile {
                self.receivedOrdersList.removeAll()
                for index in 0..<(myReceivedOrdersData?.list?.count ?? 0) {
                    if myReceivedOrdersData?.list?[index].status == "0"{
                        self.receivedOrdersList.append(myReceivedOrdersData?.list?[index])
                    }
                }
            } else if isFromNewProcessOrdersFromProfile {
                self.receivedOrdersList.removeAll()
                for index in 0..<(myReceivedOrdersData?.list?.count ?? 0) {
                    if myReceivedOrdersData?.list?[index].status == "1" || myReceivedOrdersData?.list?[index].status == "2" || myReceivedOrdersData?.list?[index].status == "3" || myReceivedOrdersData?.list?[index].status == "4" ||
                        myReceivedOrdersData?.list?[index].status == "5" {
                        self.receivedOrdersList.append(myReceivedOrdersData?.list?[index])
                    }
                }
            } else {
                self.receivedOrdersList.append(contentsOf: myReceivedOrdersData?.list ?? [ServiceData]())
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
        viewControllerTitle = "Service Bookings".localiz()
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        setup()
        
    }
    @objc func setupNotificationObserver()
    {
        
        self.resetPage()
        DispatchQueue.main.async {
            if self.isMyOrderListClicked {
                self.myOrdesListAPI()
            }else{
                self.myReceivedOrdersAPI()
            }
        }
        
        if isFromDriver{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
        }else{
            topView.isHidden = false
            topViewHeightConstraint.constant = 180
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    override func viewWillAppear(_ animated: Bool) {
        type = .backWithNotifications
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.resetPage()
        
        if isFromDriver{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
        }else{
            topView.isHidden = false
            topViewHeightConstraint.constant = 180
        }
        
//        if self.isFromNewProcessOrdersFromProfile{
//            topView.isHidden = false
//            topViewHeightConstraint.constant = 180
//            self.myOrdersButton.setTitle("Orders", for: .normal)
//            self.receivedOrdersButton.setTitle("Delegate", for: .normal)
//        }
        if userData?.user_type_id == "4" {
           /// if userData?.activity_type_id == "4"{
                topButtonStackView.isHidden = false
                if view.safeAreaInsets.bottom >= 0 {
                    topView.isHidden = false
                    topViewHeightConstraint.constant = 180
                } else {
                    topView.isHidden = false
                    topViewHeightConstraint.constant = 150
                }
                if self.isMyOrderListClicked  && !Constants.shared.isCommingFromOrderPopup{
                        self.resetPage()
                        self.myOrdesListAPI()
                        self.myOrdersButton.backgroundColor = .white
                        self.receivedOrdersButton.backgroundColor = .clear
                        self.myOrdersButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
                        self.receivedOrdersButton.setTitleColor(UIColor.white, for: .normal)
                } else {
                        self.myReceivedOrdersAPI()
                    }
        } else {
            if !Constants.shared.isCommingFromOrderPopup {
                loadingDefalut()
            }
        }
        
        if isFromNewOrdersFromProfile {
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
            viewControllerTitle = "New Orders"
        }
        if isFromNewProcessOrdersFromProfile {
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
            viewControllerTitle = "Orders on Process"
        }

        if Constants.shared.isCommingFromOrderPopup {
            Constants.shared.isCommingFromOrderPopup = false
            receivedOrdwersAction(UIButton())
        }

    }
    
    func resetPage() {
        pageCount = 1
        myOrdersList.removeAll()
        receivedOrdersList.removeAll()
        self.tableView.reloadData()
    }
    func getDeviceType() -> DeviceType {
        if #available(iOS 11.0, *) {
            if UIApplication.shared.windows.first?.safeAreaInsets != UIEdgeInsets.zero {
                return .safeArea
            }
        }
        return .nonSafeArea
    }
    
    func loadingDefalut(){
        self.resetPage()
        self.myOrdesListAPI()
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
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
        self.tableView.register(NewOrderTableViewCell.nib, forCellReuseIdentifier: NewOrderTableViewCell.identifier)
        self.tableView.register(BookingCellTableViewCell.nib, forCellReuseIdentifier: BookingCellTableViewCell.identifier)
        self.tableView.tableFooterView = UIView()
        
    }
    
    @IBAction func myOrdwersAction(_ sender: UIButton) {
            self.isMyOrderListClicked = true
            self.resetPage()
            self.myOrdesListAPI()
            self.myOrdersButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
            self.receivedOrdersButton.setTitleColor(UIColor.white, for: .normal)
            self.myOrdersButton.backgroundColor = .white
            self.receivedOrdersButton.backgroundColor = .clear
    }
    @IBAction func receivedOrdwersAction(_ sender: UIButton) {
            self.isMyOrderListClicked = false
            self.resetPage()
            self.myReceivedOrdersAPI()
            self.myOrdersButton.setTitleColor(UIColor.white, for: .normal)
            self.receivedOrdersButton.setTitleColor(UIColor(hexString: "#F1B943"), for: .normal)
            self.myOrdersButton.backgroundColor = .clear
            self.receivedOrdersButton.backgroundColor = .white
    }
    
    //MARK: - API Calls
    
    func myOrdesListAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "page":pageCount.description,
            "limit":pageLimit.description
        ]
        print(parameters)
        if isFromResturant{
            ServiceAPIManager.my_ServiceAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            ServiceAPIManager.my_ServiceAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
    func myReceivedOrdersAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
//            "page":pageCount.description,
//            "limit":pageLimit.description
            
            "page":"1",
            "limit":"10000"
        ]
        print(parameters)
        
        if isFromResturant {
            ServiceAPIManager.provider_serviceAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myReceivedOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        } else {
            ServiceAPIManager.provider_serviceAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myReceivedOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
    override func notificationBtnAction() {
        Coordinator.goToNotifications(controller: self)
    }
    
}


extension NewServicesViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isMyOrderListClicked{
            guard myOrdersList.count != 0 else {
                tableView.setEmptyView(title: "", message: "You have no request", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                
                return 0
            }
            tableView.backgroundView = nil
            return self.myOrdersList.count
        }else{
            
            guard receivedOrdersList.count != 0 else {
                tableView.setEmptyView(title: "", message: "You have'nt received any request", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                
                return 0
            }
            tableView.backgroundView = nil
            return self.receivedOrdersList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isMyOrderListClicked{
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: NewOrderTableViewCell.identifier, for: indexPath) as! NewOrderTableViewCell
            Cell.selectionStyle = .none
            Cell.servicesData = self.myOrdersList[indexPath.row]
            Cell.currencyCode = self.myOrdersData?.currency_code ?? ""
            Cell.acceptBtn.tag = indexPath.row
            Cell.acceptBtn.addTarget(self, action: #selector(accept(_:)), for: .touchUpInside)
            return Cell
        }else{
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: BookingCellTableViewCell.identifier, for: indexPath) as! BookingCellTableViewCell
            Cell.selectionStyle = .none
            Cell.servicesData = self.receivedOrdersList[indexPath.row]
            Cell.currencyCode = self.myReceivedOrdersData?.currency_code ?? ""
            Cell.acceptButton.tag = indexPath.row
            Cell.rejectButton.tag = indexPath.row
            Cell.delegate = self
            Cell.parent = self
            return Cell
        }
    }
    @objc func accept(_ sender: UIButton)
    {
        if VCtype == "true"
        {
            //    SellerOrderCoordinator.goToSellerBookingStatus(controller: self, status: "ready")
        }else
        {
            //    SellerOrderCoordinator.goToSellerBookingDetail(controller: self, orderId: self.myOrdersList[sender.tag].order_id ?? "", isSeller: false)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if isMyOrderListClicked {
            Coordinator.goToServiceRequestDetails(controller: self,serviceID:self.myOrdersList[indexPath.row].id ?? "" )
        }else{
            Coordinator.goToServicProviderDetail(controller: self, step: "", serviceId: self.receivedOrdersList[indexPath.row]?.id ?? "", isFromThank: false)
        }
        
        //        if userData?.user_type_id == "1"{
        //            if isMyOrderListClicked{
        //               // SellerOrderCoordinator.goToFoodOrderDetail(controller: self,orderId: self.myOrdersList[indexPath.row].invoice_id ?? "",isSeller: false)
        //            }else{
        //              //  SellerOrderCoordinator.goToFoodOrderDetail(controller: self,orderId: self.receivedOrdersList[indexPath.row].invoice_id ?? "",isSeller: true)
        //            }
        //        }else {
        //            if isMyOrderListClicked{
        //                if VCtype == "true"
        //                {
        //                 //   SellerOrderCoordinator.goToSellerBookingStatus(controller: self, status: "ready")
        //                }else
        //                {
        //                 //   SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: self.myOrdersList[indexPath.row].order_id ?? "",isSeller: false)
        //                }
        //            }else{
        //               // SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: self.receivedOrdersList[indexPath.row].order_id ?? "",isSeller: true)
        //            }
        //        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isMyOrderListClicked {
            guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
            if  hasFetchedAll { return }
            pageCount += 1
            myOrdesListAPI()
        } else {
//            guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
//            if  hasFetchedAll { return }
//            pageCount += 1
//            myReceivedOrdersAPI()
        }
    }
}
extension NewServicesViewController:MyBookingDelegate{
    func gotoDetailsForOrderId(orderId: String) {
        guard let index = self.receivedOrdersList.firstIndex(where: { $0?.id == orderId }) else {
            return
        }
        Coordinator.goToServicProviderDetail(controller: self, step: "", serviceId: self.receivedOrdersList[index]?.id ?? "", isFromThank: false)

    }
    
    
    func refreshList() {
        resetPage()
        if self.isMyOrderListClicked{
            self.myOrdesListAPI()
        }else{
            self.myReceivedOrdersAPI()
        }
    }
    
    
}

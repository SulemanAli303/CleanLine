//
//  NewOrderViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 21/01/2023.
//

import UIKit

class NewOrderViewController: BaseViewController {
    
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
    var isFromNewOrdersFromProfile:Bool = false
    var isFromNewProcessOrdersFromProfile:Bool = false
    var myOrdersList:[MyOrdersList] = []
    var receivedOrdersList:[MyReceiveOrdersList?] = []
    var isPopRoot = false
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var userData: User?
    
    var myOrdersData:MyOrdersData?{
        didSet{
            print(myOrdersData?.currency_code ?? "")
            let count = Int(myOrdersData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            self.myOrdersList.append(contentsOf: myOrdersData?.list ?? [MyOrdersList]())
            DispatchQueue.main.async {

                self.tableView.reloadData()
            }
        }
    }
    var myReceivedOrdersData:MyReceiveOrdersData?{
        didSet{
            
            let count = Int(myReceivedOrdersData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            
            if isFromNewOrdersFromProfile{
                self.receivedOrdersList.removeAll()
                for index in 0..<(myReceivedOrdersData?.list?.count ?? 0) {
                    if myReceivedOrdersData?.list?[index].status == "0"{
                        self.receivedOrdersList.append(myReceivedOrdersData?.list?[index])
                    }
                }
            }else if isFromNewProcessOrdersFromProfile {
                self.receivedOrdersList.removeAll()
                for index in 0..<(myReceivedOrdersData?.list?.count ?? 0) {
                    if myReceivedOrdersData?.list?[index].status == "1" || myReceivedOrdersData?.list?[index].status == "2" || myReceivedOrdersData?.list?[index].status == "3" || myReceivedOrdersData?.list?[index].status == "4" ||
                        myReceivedOrdersData?.list?[index].status == "5"{
                        self.receivedOrdersList.append(myReceivedOrdersData?.list?[index])
                    }
                }
            }else{
                self.receivedOrdersList.append(contentsOf: myReceivedOrdersData?.list ?? [MyReceiveOrdersList]())
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
  
    override func backButtonAction() {
        if isPopRoot {
            Coordinator.updateRootVCToTab(selectedIndex: 4)
                //self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userData = SessionManager.getUserData()
        type = .backWithNotifications

        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        setup()
    }

    @objc func setupNotificationObserver() {

        self.resetPage()
        if self.isMyOrderListClicked{
            self.myOrdesListAPI()
        } else {
            self.myReceivedOrdersAPI()
        }
        if isFromDriver{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
        } else {

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
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        viewControllerTitle = "My Orders".localiz()

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
        
        
        if userData?.user_type_id == "1"{
                //if userData?.activity_type_id == "12" || userData?.activity_type_id == "10"{
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
                self.myOrdesListAPI()
                self.myOrdersButton.backgroundColor = .white
                self.receivedOrdersButton.backgroundColor = .clear
                self.myOrdersButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
                self.receivedOrdersButton.setTitleColor(UIColor.white, for: .normal)

            }else{
                    //self.myReceivedOrdersAPI()
                Constants.shared.isCommingFromOrderPopup = false
                self.receivedOrdwersAction(UIButton())
            }


                //            }else{
                //                loadingDefalut()
                //            }
        } else {
            loadingDefalut()
        }

        if isFromNewOrdersFromProfile{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
            viewControllerTitle = "New Orders"
        }
        if isFromNewProcessOrdersFromProfile{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
            viewControllerTitle = "Orders on Process"
        }
        
        if Constants.shared.isCommingFromOrderPopup {
            if view.safeAreaInsets.bottom >= 0 {
                topView.isHidden = false
                topViewHeightConstraint.constant = 180
            } else {
                topView.isHidden = false
                topViewHeightConstraint.constant = 150
            }
            Constants.shared.isCommingFromOrderPopup = false
            receivedOrdwersAction(UIButton())
        }

    }
    
    func resetPage() {
        pageCount = 1
        myOrdersList.removeAll()
        receivedOrdersList.removeAll()
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
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    
    @IBAction func myOrdwersAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.isMyOrderListClicked = true
            self.resetPage()
            self.myOrdesListAPI()
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
            self.myReceivedOrdersAPI()
            self.myOrdersButton.setTitleColor(UIColor.white, for: .normal)
            self.receivedOrdersButton.setTitleColor(UIColor(hexString: "#F1B943"), for: .normal)
            self.myOrdersButton.backgroundColor = .clear
            self.receivedOrdersButton.backgroundColor = .white
        }
    }
    
    //MARK: - API Calls
    
    func myOrdesListAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        
        var parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "page":pageCount.description,
            "limit":pageLimit.description
        ]
    
//        if self.isFromNewProcessOrdersFromProfile{
//            parameters["order_status"] = "1,2,3,4"
//        }
        print(parameters)
        if isFromResturant{
            StoreAPIManager.myOrdersListAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            StoreAPIManager.myOrdersListAPI(parameters: parameters) { result in
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
        var parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
//            "page":pageCount.description,
//            "limit":pageLimit.description
            "page":pageCount.description,
            "limit":pageLimit.description
        ]
        if self.isFromNewOrdersFromProfile{
            parameters["order_status"] = "0"
        }
        else if self.isFromNewProcessOrdersFromProfile{
            parameters["order_status"] = "1,2,3,4"
        }
        else
        {
            parameters["order_status"] = "0,1,2,3,4,5,6,10,11,12"
        }
    
        print(parameters)
        
        if isFromResturant{
            FoodAPIManager.myReceivedOrdersAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myReceivedOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            StoreAPIManager.myReceivedOrdersAPI(parameters: parameters) { result in
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
    
}


extension NewOrderViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if isMyOrderListClicked{
//            return self.myOrdersList.count
//        }else{
//            return self.receivedOrdersList.count ?? 0
//        }
        
        if isMyOrderListClicked{
            guard myOrdersList.count != 0 else {
                tableView.setEmptyView(title: "", message: "My Orders Not Found!", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                
                return 0
            }
            tableView.backgroundView = nil
            return self.myOrdersList.count
        }else{
            
            guard receivedOrdersList.count != 0 else {
                tableView.setEmptyView(title: "", message: "Received Orders Not Found!", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                
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
            if self.myOrdersList.count > 0{
                Cell.myOrdersList = self.myOrdersList[indexPath.row]
                Cell.currencyCode = self.myOrdersData?.currency_code ?? ""
                Cell.acceptBtn.tag = indexPath.row
                Cell.acceptBtn.addTarget(self, action: #selector(accept(_:)), for: .touchUpInside)
            }
            return Cell
        }else{
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: BookingCellTableViewCell.identifier, for: indexPath) as! BookingCellTableViewCell
            Cell.selectionStyle = .none
            if self.receivedOrdersList.count > 0{
                Cell.myList = receivedOrdersList[indexPath.row]
                Cell.currencyCode = self.myReceivedOrdersData?.currency_code ?? ""
                Cell.userData = userData
                Cell.acceptButton.tag = indexPath.row
                Cell.rejectButton.tag = indexPath.row
            }
            Cell.delegate = self
            return Cell
        }
    }
    @objc func accept(_ sender: UIButton)
    {
        if VCtype == "true"
        {
            SellerOrderCoordinator.goToSellerBookingStatus(controller: self, status: "ready")
        }else
        {
            SellerOrderCoordinator.goToSellerBookingDetail(controller: self, orderId: self.myOrdersList[sender.tag].order_id ?? "", isSeller: false, isThankYouPage: false)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isMyOrderListClicked{
            if self.myOrdersList[indexPath.row].type == "1"{
                
                if isMyOrderListClicked{
                    SellerOrderCoordinator.goToFoodOrderDetail(controller: self,orderId: self.myOrdersList[indexPath.row].invoice_id ?? "", isSeller: false, isThankYouPage: false)
                }else{
                    SellerOrderCoordinator.goToFoodOrderDetail(controller: self,orderId: self.receivedOrdersList[indexPath.row]?.order_id ?? "", isSeller: true, isThankYouPage: false)
                }
                
            }else{
                if isMyOrderListClicked{
                     SellerOrderCoordinator.goToSellerBookingDetail(controller: self, orderId: self.myOrdersList[indexPath.row].order_id ?? "", isSeller: false,  isThankYouPage: false)
                }else{
                    SellerOrderCoordinator.goToSellerBookingDetail(controller: self, orderId: self.receivedOrdersList[indexPath.row]?.order_id ?? "", isSeller: true, isThankYouPage: false)
                }
            }
        }else{
            self.gotoDetailsForIndex(index: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isMyOrderListClicked{
            guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
            if  hasFetchedAll { return }
            pageCount += 1
            myOrdesListAPI()
        }else{
            guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
            if  hasFetchedAll { return }
            pageCount += 1
            myReceivedOrdersAPI()
        }
    }
    
    func gotoDetailsForIndex(index:Int){
      
        if self.receivedOrdersList[index]?.type == "1"{
            
            if isMyOrderListClicked{
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self,orderId: self.myOrdersList[index].invoice_id ?? "",isSeller: false,isThankYouPage: false)
            }else{
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self,orderId: self.receivedOrdersList[index]?.order_id ?? "",isSeller: true,isThankYouPage: false)
            }
            
        }else{
            if isMyOrderListClicked{
                 SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: self.myOrdersList[index].order_id ?? "",isSeller: false, isThankYouPage: false)
            }else{
                SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: self.receivedOrdersList[index]?.order_id ?? "",isSeller: true, isThankYouPage: false)
            }
        }

    }
}
extension NewOrderViewController:MyBookingDelegate{
    
    func refreshList() {
        resetPage()
        self.myReceivedOrdersAPI()
    }
    
    func gotoDetailsForOrderId (orderId:String)
    {
        guard let index = self.receivedOrdersList.firstIndex(where: { $0?.order_id == orderId }) else {
            return 
        }
        self.gotoDetailsForIndex(index: index)
    }
}

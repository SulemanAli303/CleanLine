//
//  NewOrderViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 21/01/2023.
//

import UIKit

class NewBookingViewController: BaseViewController {
    
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
    var myOrdersList:[CharletBookingList] = []
    var receivedOrdersList:[CharletBookingList?] = []
    
    var isFromNewOrdersFromProfile:Bool = false
    var isFromNewProcessOrdersFromProfile:Bool = false
    
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var userData: User?

    var myOrdersData:CharletBookingListData?{
        didSet{
            let count = myOrdersData?.list?.count ?? 0
                self.hasFetchedAll = count < (self.pageLimit)
            self.myOrdersList.append(contentsOf: myOrdersData?.list ?? [CharletBookingList]())
            self.tableView.reloadData()
        }
    }
    var myReceivedOrdersData:CharletBookingListData?{
        didSet{
            let count = myReceivedOrdersData?.list?.count ?? 0
            self.hasFetchedAll = count < self.pageLimit
            if isFromNewOrdersFromProfile {
                for index in 0..<(myReceivedOrdersData?.list?.count ?? 0) {
                    print(myReceivedOrdersData?.list?[index].booking_status_number ?? "")
                    if myReceivedOrdersData?.list?[index].booking_status_number == "0"{
                        self.receivedOrdersList.append(myReceivedOrdersData?.list?[index])
                    }
                }
            } else if isFromNewProcessOrdersFromProfile {
                for index in 0..<(myReceivedOrdersData?.list?.count ?? 0) {
                    if myReceivedOrdersData?.list?[index].booking_status_number == "1" || myReceivedOrdersData?.list?[index].booking_status_number == "2" || myReceivedOrdersData?.list?[index].booking_status_number == "3" {
                        self.receivedOrdersList.append(myReceivedOrdersData?.list?[index])
                    }
                }
            } else {
                self.receivedOrdersList.append(contentsOf: myReceivedOrdersData?.list ?? [CharletBookingList]())
            }
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = SessionManager.getUserData()
        type = .backWithNotifications
        viewControllerTitle = "My Bookings"
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        setup()
        
    }
    @objc func setupNotificationObserver() {

        self.resetPage()
        if self.isMyOrderListClicked {
            self.myOrdesListAPI()
        }else{
            self.myReceivedOrdersAPI()
        }

//        if isFromDriver {
//            topView.isHidden = true
//            topViewHeightConstraint.constant = 0
//        }else{
//            topView.isHidden = false
//            topViewHeightConstraint.constant = 180
//        }

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

        if userData?.user_type_id == "2" {
            if userData?.activity_type_id == "6" {
                topButtonStackView.isHidden = false
                if view.safeAreaInsets.bottom >= 0 {
                    topView.isHidden = false
                    topViewHeightConstraint.constant = 180
                } else {
                    topView.isHidden = false
                    topViewHeightConstraint.constant = 150
                }
                if self.isMyOrderListClicked && !self.isFromNewOrdersFromProfile && !self.isFromNewProcessOrdersFromProfile{
                    self.myOrdesListAPI()
                    self.myOrdersButton.backgroundColor = .white
                    self.receivedOrdersButton.backgroundColor = .clear
                    self.myOrdersButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
                    self.receivedOrdersButton.setTitleColor(UIColor.white, for: .normal)
                }else{
                    self.myReceivedOrdersAPI()
                }
            } else {
                loadingDefalut()
            }
        } else {
            loadingDefalut()
        }
        
        if isFromNewOrdersFromProfile {
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            viewControllerTitle = "New Orders"
            self.isMyOrderListClicked = false
            self.myOrdersButton.setTitleColor(UIColor.white, for: .normal)
            self.receivedOrdersButton.setTitleColor(UIColor(hexString: "#F1B943"), for: .normal)
            self.myOrdersButton.backgroundColor = .clear
            self.receivedOrdersButton.backgroundColor = .white

        }
        if isFromNewProcessOrdersFromProfile {
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            viewControllerTitle = "Orders on Process"
            self.isMyOrderListClicked = false
            self.myOrdersButton.setTitleColor(UIColor.white, for: .normal)
            self.receivedOrdersButton.setTitleColor(UIColor(hexString: "#F1B943"), for: .normal)
            self.myOrdersButton.backgroundColor = .clear
            self.receivedOrdersButton.backgroundColor = .white
        }

        if Constants.shared.isCommingFromOrderPopup {
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
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
        CharletAPIManager.charletBookingListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                    DispatchQueue.main.async {
                        self.myOrdersData = result.oData
                    }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func myReceivedOrdersAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        var parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "page":pageCount.description,
            "limit":pageLimit.description
        ]

        if isFromNewProcessOrdersFromProfile {
            parameters[ "order_status"] = "1,2,3"
        }
        print(parameters)
        CharletAPIManager.charletManagmentBookingListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                    DispatchQueue.main.async{
                        self.myReceivedOrdersData = result.oData
                    }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    override func notificationBtnAction() {
        Coordinator.goToNotifications(controller: self)
    }
    
}


extension NewBookingViewController : UITableViewDelegate ,UITableViewDataSource{
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
            if indexPath.row <= (self.myOrdersList.count - 1) {
                Cell.myBookingOrder = self.myOrdersList[indexPath.row]
                Cell.currencyCode = self.myOrdersData?.currency_code ?? ""
            }
            Cell.acceptBtn.tag = indexPath.row
            Cell.acceptBtn.addTarget(self, action: #selector(accept(_:)), for: .touchUpInside)
            return Cell
        }else{
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: BookingCellTableViewCell.identifier, for: indexPath) as! BookingCellTableViewCell
            Cell.selectionStyle = .none
            if indexPath.row <= (self.receivedOrdersList.count - 1) {
            Cell.myBookingOrder = self.receivedOrdersList[indexPath.row]
            Cell.currencyCode = self.myReceivedOrdersData?.currency_code ?? ""
            }
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
        
        if isMyOrderListClicked{
            Coordinator.goToChaletRequestDetails(controller: self,step:"",chaletID: self.myOrdersList[indexPath.row].id ?? "" )
        }else{
            Coordinator.goToChaletsReservationRequest(controller: self, VCtype: "",chaletID: self.receivedOrdersList[indexPath.row]?.id ?? "")
        }
        
    
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isMyOrderListClicked {
            guard indexPath.row == myOrdersList.count - 1 else { return }
            if  hasFetchedAll { return }
            pageCount += 1
            myOrdesListAPI()
        } else {
            guard indexPath.row == receivedOrdersList.count - 2 else { return }
            if  hasFetchedAll { return }
            pageCount += 1
            myReceivedOrdersAPI()
        }
    }
}
extension NewBookingViewController:MyBookingDelegate{
    func gotoDetailsForOrderId(orderId: String) {
        guard let index = self.receivedOrdersList.firstIndex(where: { $0?.id == orderId }) else {
            return
        }
        Coordinator.goToChaletsReservationRequest(controller: self, VCtype: "",chaletID: self.receivedOrdersList[index]?.id ?? "")
    }
    func refreshList() {
        resetPage()
        self.myReceivedOrdersAPI()
    }
}

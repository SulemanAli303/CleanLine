//
//  HotelBookingListViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 09/08/23.
//

import UIKit

class HotelBookingListViewController: BaseViewController {

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
    var isPopRoot:Bool = false
    var isFromResturant:Bool = false
    var myBookingList:[HotelBookingList] = []
    var receivedOrdersList:[HotelBookingList?] = []
    var isFromNewOrdersFromProfile:Bool = false
    var isFromNewProcessOrdersFromProfile:Bool = false
    
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var userData: User?
    
    enum DeviceType {
        case safeArea
        case nonSafeArea
    }
    
    var myBookingData:HotelBookingListData?{
        didSet{
            print(myBookingData?.currency_code ?? "")
            let count = Int(myBookingData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            self.myBookingList.append(contentsOf: myBookingData?.list ?? [HotelBookingList]())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    var myReceivedBookingData:HotelBookingListData?{
        didSet{
            let count = Int(myReceivedBookingData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            
            if isFromNewOrdersFromProfile{
                self.receivedOrdersList.removeAll()
                for index in 0..<(myReceivedBookingData?.list?.count ?? 0) {
                    if myReceivedBookingData?.list?[index].booking_status == "0"{
                        self.receivedOrdersList.append(myReceivedBookingData?.list?[index])
                    }
                }
            }else if isFromNewProcessOrdersFromProfile{
                self.receivedOrdersList.removeAll()
                for index in 0..<(myReceivedBookingData?.list?.count ?? 0) {
                    if myReceivedBookingData?.list?[index].booking_status == "1" || myReceivedBookingData?.list?[index].booking_status == "2" || myReceivedBookingData?.list?[index].booking_status == "3" {
                        self.receivedOrdersList.append(myReceivedBookingData?.list?[index])
                    }
                }
            }else{
                self.receivedOrdersList.append(contentsOf: myReceivedBookingData?.list ?? [HotelBookingList]())
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
        viewControllerTitle = "My Bookings".localiz()
        receivedOrdersButton.setTitle("Received Orders".localiz(), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        setup()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.stopAlaram()
    }
    @objc func setupNotificationObserver()
    {
        
        self.resetPage()
        DispatchQueue.main.async {
            if self.isMyOrderListClicked{
                self.myOrdesListAPI()
            }else{
                self.myReceivedOrdersAPI()
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
        
        //check logged user is Playgroud Store
        if userData?.user_type_id == "2"{
            if userData?.activity_type_id == "4"{
                topButtonStackView.isHidden = false
                if view.safeAreaInsets.bottom >= 0 {
                    topView.isHidden = false
                    topViewHeightConstraint.constant = 180
                } else {
                    topView.isHidden = false
                    topViewHeightConstraint.constant = 150
                }
                if self.isMyOrderListClicked {
                            self.resetPage()
                            self.myOrdesListAPI()
                            self.myOrdersButton.backgroundColor = .white
                            self.receivedOrdersButton.backgroundColor = .clear
                            self.myOrdersButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
                            self.receivedOrdersButton.setTitleColor(UIColor.white, for: .normal)

                    } else {
                        //self.myReceivedOrdersAPI()
                        Constants.shared.isCommingFromOrderPopup = false
                        self.receivedOrdwersAction(UIButton())
                    }
            }else{
                loadingDefalut()
            }
        }else{
            loadingDefalut()
        }
        
        if isFromNewOrdersFromProfile{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
            viewControllerTitle = "New Orders".localiz()
        }
        if isFromNewProcessOrdersFromProfile{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
            viewControllerTitle = "Orders on Process".localiz()
        }
        if Constants.shared.isCommingFromOrderPopup {
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
        }
    }
    
    func resetPage() {
        pageCount = 1
        myBookingList.removeAll()
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
//        let tabbar = tabBarController as? TabbarController
//        tabbar?.showTabBar()
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

    override func backButtonAction() {
        if isPopRoot {
            Coordinator.updateRootVCToTab(selectedIndex: 4)
        } else {
            navigationController?.popViewController(animated: true)
        }
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
        StoreAPIManager.userBookingListAPI(parameters: parameters) { result in
            switch result.status {
            case "0":
                if let data = result.oData{
                    self.myBookingData = data
                }else{
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
                
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
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
        StoreAPIManager.sellerBookingListAPI(parameters: parameters) { result in
            switch result.status {
            case "0":
                print(result.message ?? "")
                self.myReceivedBookingData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
}


extension HotelBookingListViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if isMyOrderListClicked{
//            return self.myBookingList.count
//        }else{
//            return self.receivedOrdersList.count ?? 0
//        }
        
        if isMyOrderListClicked{
            guard myBookingList.count != 0 else {
                tableView.setEmptyView(title: "", message: "My Orders Not Found!", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                
                return 0
            }
            tableView.backgroundView = nil
            return self.myBookingList.count
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
            //Cell.isHotel = true
            if  self.myBookingList.count > indexPath.row {
                Cell.myHotelBookingList = self.myBookingList[indexPath.row]
                Cell.currencyCode = self.myBookingData?.currency_code ?? ""
            }
            Cell.delegate = self
            Cell.cancelButton.tag = indexPath.row
            //Cell.acceptBtn.addTarget(self, action: #selector(accept(_:)), for: .touchUpInside)
            return Cell
        }else{
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: BookingCellTableViewCell.identifier, for: indexPath) as! BookingCellTableViewCell
            Cell.selectionStyle = .none
            //Cell.isHotel = true
            if  self.receivedOrdersList.count > indexPath.row {
                Cell.myHotelBookingList = receivedOrdersList[indexPath.row]
                Cell.currencyCode = self.myReceivedBookingData?.currency_code ?? ""
                Cell.userData = userData
            }
            Cell.acceptButton.tag = indexPath.row
            Cell.rejectButton.tag = indexPath.row
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
            SellerOrderCoordinator.goToSellerBookingDetail(controller: self, orderId: self.myBookingList[sender.tag].booking_id ?? "", isSeller: false, isThankYouPage: false)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isMyOrderListClicked{
            
            Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: false,booking_ID: myBookingList[indexPath.row].booking_id ?? "")
        }else{
            Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: true,booking_ID: receivedOrdersList[indexPath.row]?.booking_id ?? "")
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
        if  hasFetchedAll { return }
        pageCount += 1
        myOrdesListAPI()
        
//        if isMyOrderListClicked{
//            guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
//            if  hasFetchedAll { return }
//            pageCount += 1
//            myOrdesListAPI()
//        }else{
//            guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
//            if  hasFetchedAll { return }
//            pageCount += 1
//            myReceivedOrdersAPI()
//        }
    }
}
extension HotelBookingListViewController:MyBookingDelegate{
 
    func gotoDetailsForOrderId(orderId: String) {
        guard let index = self.receivedOrdersList.firstIndex(where: { $0?.booking_id == orderId }) else {
            return
        }
        Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: true,booking_ID: receivedOrdersList[index]?.booking_id ?? "")
    }
    
    
    func refreshList() {
        resetPage()
        self.myReceivedOrdersAPI()
    }
}

extension HotelBookingListViewController:MyPGBookingPorocol{
    
    
    func refreshMyBookingList() {
        resetPage()
        self.myOrdesListAPI()
    }
}


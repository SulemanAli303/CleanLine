//
//  DriverOrderListViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 27/04/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

enum DriverOrderType { case delivery, delegate }

class DriverOrderListViewController: BaseViewController {
    
    @IBOutlet weak var pStackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var muteAllButton: UIButton!
    @IBOutlet weak var accepetdButton: UIButton!
    @IBOutlet weak var deliverdButton: UIButton!
    @IBOutlet weak var pendingButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet private var topButtons: [UIButton]!
    @IBOutlet weak private var bottomContainer: UIView!
    @IBOutlet weak private var topViewHeight: NSLayoutConstraint!
    
    var delegatePageCount = 1
    var delegatePageLimit = 10
    var fetchedAllDelegateRequests = false
    var delegateRequests: [DriverDelegateServiceRequestModel] = []
    
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var myOrdersList:[MyOrdersList] = []
    var selectedtype = ""
    var driverVerified:String = ""
    
    @IBOutlet weak var tableView: IntrinsicallySizedTableView!
    
    var selectedCategory: DriverOrderType = .delivery
    var singleOrderMode = false
    
    var VCtype = ""
    var isFromThankUPage:Bool = false
    var selectedStatus:String = "0"
    var locationManager = CLLocationManager()
    var driverCurrentLocation:String = ""
    
    var myOrdersData:MyOrdersData?{
        didSet{
            print(myOrdersData?.currency_code ?? "")
            
            let count = Int(myOrdersData?.list?.count ?? 0)
            if count < (self.pageLimit){
               hasFetchedAll = true
            }
            self.myOrdersList.append(contentsOf: myOrdersData?.list ?? [MyOrdersList]())
            if self.selectedtype == "2" {
                self.myOrdersList = self.myOrdersList.filter { $0.status == "4" || $0.status == "5"}
            }
            self.tableView.reloadData()
        }
    }
    
    var delegateData: DriverDelegateServiceRequests?{
        didSet{
            print(delegateData?.currency_code ?? "")
            
            let count = Int(delegateData?.list?.count ?? 0)
            if count < (self.delegatePageLimit) { fetchedAllDelegateRequests = true }
            self.delegateRequests.append(contentsOf: delegateData?.list ?? [DriverDelegateServiceRequestModel]())
            if self.selectedtype == "1" {
                self.delegateRequests = self.delegateRequests.filter { $0.serviceStatus == "0"}
            } else if self.selectedtype == "2" {
                self.delegateRequests = self.delegateRequests.filter { $0.serviceStatus == "1" || $0.serviceStatus == "2" || $0.serviceStatus == "3" || $0.serviceStatus == "4"}
            }
            self.tableView.reloadData()
        }
    }
    
    var locationCoordinates: CLLocation? {
        didSet {
        }
    }
    
    var currentLocation: CLLocation? {
        didSet {
            self.getAddress(loc: currentLocation)
            if let coordinate = currentLocation?.coordinate {
                //let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
               // self.mapContainerView?.animate(to: camera)
                //mapContainerView.delegate = self
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .backWithTop //.backWithSearchButton
        if self.selectedtype == "" {
            viewControllerTitle = "Delivery Requests"
        }else if self.selectedtype == "1" {
            viewControllerTitle = "New Orders"
        }else if self.selectedtype == "2" {
            viewControllerTitle = "Orders on process"
        }
        
        
        pStackView.isHidden = singleOrderMode

        
        
    }
    
    
    @objc func setupNotificationObserver()
    {
        switch selectedCategory {
        case .delivery:
            self.resetPage()
            self.deliveryRequestsAPI(status:self.selectedStatus)
        case .delegate:
            self.resetPage()
            self.delegateRequestsAPI()
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)

        self.setUpLocation()
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        ///self.myOrdesListAPI()
        ///
        ///
        if( self.selectedtype) == "1" {
            topViewHeight.constant = 160//95
            topStackView.isHidden = false//true
            self.selectedStatus = "3"
            self.bottomContainer.isHidden = true
        }else if( self.selectedtype) == "2" {
            topViewHeight.constant = 160//95
            self.selectedStatus = "4,5"
            self.bottomContainer.isHidden = true
            topStackView.isHidden = false//true
        }
        else{
            var constant = 180
            if hasTopNotch{
                constant += 40
            }
            topViewHeight.constant = CGFloat(constant)
            if selectedCategory == .delivery {
                topViewHeight.constant = 220
            }else {
                topViewHeight.constant = 180
            }
        }
        
        if singleOrderMode {
            topViewHeight.constant = 75
        }
        setup()
        resetPage()
        if Constants.shared.isCommingFromOrderPopup {
            Constants.shared.isCommingFromOrderPopup  = false
            selectedCategory = Constants.shared.isDeliveryOrder ? .delegate : .delivery
            self.changeTopButtons()
            Constants.shared.isDeliveryOrder = false
        }
        switch selectedCategory {
        case .delivery:
            self.resetPage()
            self.deliveryRequestsAPI(status:self.selectedStatus)
        case .delegate:
            self.resetPage()
            self.delegateRequestsAPI()
        }
    }

    func changeTopButtons() {
        let tag =   selectedCategory == .delivery ? 0 : 1
        if self.selectedtype == "" {
            UIView.transition(with: bottomContainer, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.bottomContainer.isHidden = tag == 1
            })
        }
        if self.selectedtype == "" {
            topViewHeight.constant = tag == 0 ? 220 : 180
        }
        topButtons.forEach {
            $0.backgroundColor = .clear
            $0.setTitleColor(UIColor.white, for: .normal)
        }

        topButtons[tag ].backgroundColor = .white
        topButtons[tag].setTitleColor(Color.theme.color(), for: .normal)
        if( self.selectedtype) == "1" || (self.selectedtype) == "2" {
            topViewHeight.constant = 160
            self.bottomContainer.isHidden = true
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
    
    //MARK: - Methods
    func setUpLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    func resetPage() {
        switch selectedCategory {
        case .delivery:
            pageCount = 1
            myOrdersList.removeAll()
        case .delegate:
            delegatePageCount = 1
            delegateRequests.removeAll()
        }
    }
    
    func getAddress(loc:CLLocation?) {
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: loc?.coordinate.latitude ?? 25.2048, longitude:loc?.coordinate.longitude ?? 55.2708)) { (places, error) in
                if error == nil{
                    if let place = places?.first{
                        print(place)
                        //let place = placemarks[0]
                        var addressString : String = ""
                        if place.thoroughfare != nil {
                            addressString = addressString + place.thoroughfare! + ", "
                        }
                        if place.subThoroughfare != nil {
                            addressString = addressString + place.subThoroughfare! + ", "
                        }
                        if place.locality != nil {
                            addressString = addressString + place.locality! + ", "
                        }
                        if place.postalCode != nil {
                            addressString = addressString + place.postalCode! + ", "
                        }
                        if place.subAdministrativeArea != nil {
                            addressString = addressString + place.subAdministrativeArea! + ", "
                        }
                        if place.country != nil {
                            addressString = addressString + place.country!
                        }
                        
                        print( addressString)
                        self.driverCurrentLocation = addressString
                    }
                }
            }
    }
    
    func setup() {
        // MARK: - TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(NewOrderTableViewCell.nib, forCellReuseIdentifier: NewOrderTableViewCell.identifier)
        self.tableView.tableFooterView = UIView()
        DispatchQueue.main.async {
            //self.myOrdesListAPI()
            self.statusButtonBorderAndBgColor()
            self.allButton.setTitleColor(Color.darkOrange.color(), for: .normal)
            self.allButton.backgroundColor = .white
            
        }
    }
    
    @IBAction func muteAllAction(_ sender: UIButton) {
    }
    
    
    @IBAction func statusButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.statusButtonBorderAndBgColor()
            if sender.tag == 11{
                self.allButton.setTitleColor(Color.darkOrange.color(), for: .normal)
                self.allButton.backgroundColor = .white
                self.resetPage()
                self.selectedStatus = "0"
                self.deliveryRequestsAPI(status:"0")
            }else if sender.tag == 12{
                self.pendingButton.setTitleColor(Color.darkOrange.color(), for: .normal)
                self.pendingButton.backgroundColor = .white
                self.resetPage()
                self.deliveryRequestsAPI(status:"3")
                self.selectedStatus = "3"
            }else if sender.tag == 13{
                self.deliverdButton.setTitleColor(Color.darkOrange.color(), for: .normal)
                self.deliverdButton.backgroundColor = .white
                self.resetPage()
                self.deliveryRequestsAPI(status:"6")
                self.selectedStatus = "6"
            }else if sender.tag == 14{
                self.accepetdButton.setTitleColor(Color.darkOrange.color(), for: .normal)
                self.accepetdButton.backgroundColor = .white
                self.resetPage()
                self.deliveryRequestsAPI(status:"4")
                self.selectedStatus = "4"
            }else{
                
            }
        }
    }
    
    //MARK: IBActions
    @IBAction private func actionTopButtonSelected(_ sender: UIButton) {
       
        
        if self.selectedtype == "" {
            UIView.transition(with: bottomContainer, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.bottomContainer.isHidden = sender.tag == 1
            })
        }
        selectedCategory = sender.tag == 0 ? .delivery : .delegate
        if self.selectedtype == "" {
            topViewHeight.constant = sender.tag == 0 ? 220 : 180
        }
        topButtons.forEach {
            $0.backgroundColor = .clear
            $0.setTitleColor(UIColor.white, for: .normal)
        }
        
        topButtons[sender.tag].backgroundColor = .white
        topButtons[sender.tag].setTitleColor(Color.theme.color(), for: .normal)
        
        if( self.selectedtype) == "1" || (self.selectedtype) == "2" {
            topViewHeight.constant = 160
            self.bottomContainer.isHidden = true
        }
        
        switch selectedCategory {
        case .delivery:
            self.resetPage()
            if(self.selectedtype) == "1" {
                self.selectedStatus = "3"
            }else if(self.selectedtype) == "2" {
                self.selectedStatus = "0"
            }
            self.deliveryRequestsAPI(status:self.selectedStatus)
        case .delegate:
            self.resetPage()
            self.delegateRequestsAPI()
        }
       
        //else { DispatchQueue.main.async { self.tableView.reloadData() } }
    }
    
    func statusButtonBorderAndBgColor(){
        self.allButton.backgroundColor = UIColor.clear
        self.pendingButton.backgroundColor = UIColor.clear
        self.deliverdButton.backgroundColor = UIColor.clear
        self.accepetdButton.backgroundColor = UIColor.clear
        
        self.allButton.setTitleColor(.white, for: .normal)
        self.pendingButton.setTitleColor(.white, for: .normal)
        self.deliverdButton.setTitleColor(.white, for: .normal)
        self.accepetdButton.setTitleColor(.white, for: .normal)
        
    }
    
    
    
//    @IBAction func receivedOrdwersAction(_ sender: UIButton) {
//        DispatchQueue.main.async {
//            self.isMyOrderListClicked = false
//            //self.myReceivedOrdersAPI()
//            //self.driverReceivedOrdersAPI()
//            self.myOrdersButton.setTitleColor(UIColor.white, for: .normal)
//            self.receivedOrdersButton.setTitleColor(UIColor(hexString: "#F1B943"), for: .normal)
//            self.myOrdersButton.backgroundColor = .clear
//            self.receivedOrdersButton.backgroundColor = .white
//        }
//    }
    
    //MARK: - API Calls
    
    func deliveryRequestsAPI(status:String){
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        if self.selectedtype == "2" {
            pageCount = 1
            pageLimit = 10000
        }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "lattitude":"\(currentLocation?.coordinate.latitude ?? 25.2048)",
            "longitude":"\(currentLocation?.coordinate.longitude ?? 55.2708)",
            "order_status":status,
            "page":pageCount.description,
            "limit":pageLimit.description
        ]
        print(parameters)
        
        StoreAPIManager.driverReceivedOrdersAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myOrdersData = result.oData
                if self.singleOrderMode && self.myOrdersData?.list?.count ?? 0 == 0
                {
                    self.selectedCategory = .delegate
                    self.delegateRequestsAPI()
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func delegateRequestsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "page": "1",
            "limit": "1000",
            "order_status":"0",
//            "page": delegatePageCount.description,
//            "limit": delegatePageLimit.description
        ]
        
        
        print(parameters)
        
        StoreAPIManager.driverDelegateServiceRequests(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegateData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func muteAllRequestsAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.driverAllOrdersMuteAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}


extension DriverOrderListViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selectedCategory {
        case .delivery:
            if driverVerified == "1"{
                guard self.myOrdersList.count != 0 else {
                    
                    tableView.setEmptyView(title: "", message: "No delivery request Found!", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                    
                    return 0
                }
                tableView.backgroundView = nil
                return self.myOrdersList.count
            }else{
                tableView.setEmptyView(title: "", message: "Account not verified", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                return 0
            }
            
        case .delegate:
            if driverVerified == "1"{
                guard delegateRequests.count != 0 else {
                    var emptyMessage = "No delegate request Found!"
                    if singleOrderMode{
                        emptyMessage = "No delivery or deligate request Found!"
                    }
                    tableView.setEmptyView(title: "", message: emptyMessage , image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                    
                    return 0
                }
                tableView.backgroundView = nil
                return delegateRequests.count
            }else{
                tableView.setEmptyView(title: "", message: "Account not verified", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
                return 0
            }
            
        }
      
       // return selectedCategory == .delivery ? self.myOrdersList.count : delegateRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch selectedCategory {
        case .delivery:
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: NewOrderTableViewCell.identifier, for: indexPath) as! NewOrderTableViewCell
            Cell.selectionStyle = .none
            Cell.delegate = self
            Cell.driverOrdersList = self.myOrdersList[indexPath.row]
            Cell.currencyCode = self.myOrdersData?.currency_code ?? ""
            return Cell
            
        case .delegate:
            let Cell = self.tableView.dequeueReusableCell(withIdentifier: NewOrderTableViewCell.identifier, for: indexPath) as! NewOrderTableViewCell
            Cell.delegate = self
            Cell.selectionStyle = .none
            if self.delegateRequests.count > indexPath.row {
                Cell.driverDelegateRequest = self.delegateRequests[indexPath.row]
                Cell.currencyCode = self.delegateData?.currency_code ?? ""
            }
            return Cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch selectedCategory {
        case .delivery:
            let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
            VC.order_ID = myOrdersList[indexPath.row].order_id ?? ""
            VC.latitude = "\(currentLocation?.coordinate.latitude ?? 25.2048)"
            VC.longitude = "\(currentLocation?.coordinate.longitude ?? 55.2708)"
            VC.driverAddress = self.driverCurrentLocation
            if myOrdersList[indexPath.row].type == "1"{
                VC.isFromFoodOrder = true
            }else{
                VC.isFromFoodOrder = false
            }
            self.navigationController?.pushViewController(VC, animated: true)

        case .delegate:
            if (self.delegateRequests.count) > indexPath.row {
                Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: self.delegateRequests[indexPath.row].id, isDriver: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else {return}
        
        switch selectedCategory {
        case .delivery:
            if self.selectedtype == "" {
                if hasFetchedAll{return}
                pageCount += 1
                self.deliveryRequestsAPI(status:self.selectedStatus)
            }else {
                break
            }
        case .delegate:
            break
//            if fetchedAllDelegateRequests { return }
//            delegatePageCount += 1
//            self.delegateRequestsAPI()
        }
    }
}
extension DriverOrderListViewController:MyPGBookingPorocol{
    func gotoDetailsForOrderId(orderId: String) {
        
        switch selectedCategory {
        case .delivery:
            guard let index = self.myOrdersList.firstIndex(where: { $0.order_id == orderId }) else {
                return
            }
            let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
            VC.order_ID = myOrdersList[index].order_id ?? ""
            VC.latitude = "\(currentLocation?.coordinate.latitude ?? 25.2048)"
            VC.longitude = "\(currentLocation?.coordinate.longitude ?? 55.2708)"
            VC.driverAddress = self.driverCurrentLocation
            if myOrdersList[index].type == "1"{
                VC.isFromFoodOrder = true
            }else{
                VC.isFromFoodOrder = false
            }
            self.navigationController?.pushViewController(VC, animated: true)
        case .delegate:
            guard let index = self.delegateRequests.firstIndex(where: { $0.id == orderId }) else {
                return
            }
            Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: self.delegateRequests[index].id, isDriver: true)
        }
    }
    
    func refreshMyBookingList() {
        switch selectedCategory {
        case .delivery:
            self.resetPage()
            self.deliveryRequestsAPI(status:self.selectedStatus)
        case .delegate:
            self.resetPage()
            self.delegateRequestsAPI()
        }
    }
    
}
extension DriverOrderListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationCoordinates = currentLocation
        self.locationManager.stopUpdatingLocation()
    }
}

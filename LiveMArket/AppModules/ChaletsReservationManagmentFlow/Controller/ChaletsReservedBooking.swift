//
//  HotelReservedBooking.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit

class ChaletsReservedBooking: BaseViewController {
    
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var myOrdersList:[CharletBookingList] = []
    @IBOutlet weak var tableView: UITableView!
    var myOrdersData:CharletBookingListData?{
        didSet{
            self.myOrdersList.removeAll()
            self.myOrdersList.append(contentsOf: myOrdersData?.list ?? [CharletBookingList]())
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithSearchButton
        viewControllerTitle = "Reserved Bookings"
        setData()
        self.myOrdesListAPI()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    func setData() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "BookingCellTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingCellTableViewCell")
        tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
}
// MARK: - TableviewDelegate
extension ChaletsReservedBooking : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard myOrdersList.count != 0 else {
            tableView.setEmptyView(title: "", message: "You have no reserved booking", image: UIImage(named: "undraw_personal_file_re_5joy 1"))
            
            return 0
        }
        tableView.backgroundView = nil
        return self.myOrdersList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: BookingCellTableViewCell.identifier, for: indexPath) as! BookingCellTableViewCell
        Cell.selectionStyle = .none
        if indexPath.row <= (self.myOrdersList.count - 1) {
            Cell.myBookingOrder = self.myOrdersList[indexPath.row]
            Cell.currencyCode = self.myOrdersData?.currency_code ?? ""
        }
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    Coordinator.goToChaletRequestDetails(controller: self,step:"",chaletID: self.myOrdersList[indexPath.row].id ?? "" )
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
extension ChaletsReservedBooking {
    func myOrdesListAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "booking_status" : "2"
        ]
        
        
        CharletAPIManager.charletManagmentBookingListAPI(parameters: parameters) { result in
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

//
//  MyReviewsViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 23/01/2023.
//

import UIKit

class MyBookingsVC: BaseViewController {

    
    @IBOutlet weak var tableView: IntrinsicallySizedTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        type = .backWithTop
        viewControllerTitle = "My Bookings"
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        //self.myReceivedOrdersAPI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    
//    var myOrdersList:[MyReceiveOrdersList]?{
//        didSet{
//            print(myOrdersList ?? [])
//            self.tableView.reloadData()
//        }
//    }

    func setup() {
        // MARK: - TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(BookingCellTableViewCell.nib, forCellReuseIdentifier: BookingCellTableViewCell.identifier)
        self.tableView.tableFooterView = UIView()
    }
    //MARK: - API Calls
    
//    func myReceivedOrdersAPI() {
//
//        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
//        let parameters:[String:String] = [
//            "access_token" : SessionManager.getAccessToken() ?? "",
//            "timezone" : localTimeZoneIdentifier
//        ]
//        print(parameters)
//
//        StoreAPIManager.myReceivedOrdersAPI(parameters: parameters) { result in
//            switch result.status {
//            case "1":
//               / self.myOrdersList = result.oData?.list ?? []
//            default:
//                Utilities.showWarningAlert(message: result.message ?? "") {
//
//                }
//            }
//        }
//    }
    

}
extension MyBookingsVC : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: BookingCellTableViewCell.identifier, for: indexPath) as! BookingCellTableViewCell
         Cell.selectionStyle = .none
//        Cell.myList = myOrdersList?[indexPath.row]
//        Cell.acceptButton.tag = indexPath.row
//        Cell.rejectButton.tag = indexPath.row
//        Cell.delegate = self
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension MyBookingsVC:MyBookingDelegate{
    func gotoDetailsForOrderId(orderId: String) {
//        guard let index = self.receivedOrdersList.firstIndex(where: { $0?.booking_id == orderId }) else {
//            return
//        }
    }
    
   
    func refreshList() {
        //self.myReceivedOrdersAPI()
    }
    
    
}

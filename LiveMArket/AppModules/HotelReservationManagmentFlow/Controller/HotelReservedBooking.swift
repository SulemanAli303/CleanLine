//
//  HotelReservedBooking.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit

class HotelReservedBooking: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithSearchButton
        viewControllerTitle = "Reserved Bookings"
        setData()
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
        tableView.register(UINib(nibName: "HotelBookingCell", bundle: nil), forCellReuseIdentifier: "HotelBookingCell")
        tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
}
// MARK: - TableviewDelegate
extension HotelReservedBooking : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingCell", for: indexPath) as! HotelBookingCell
        cell.base  = self
        cell.acceptView.isHidden = true
        cell.StatusView.backgroundColor = UIColor(hex: "F57070")
        cell.StatusImg.backgroundColor = UIColor(hex: "F57070")
        cell.Statuslbl.text = " Reserved   ".localiz()
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Coordinator.goToHotelReservationRequest(controller: self, VCtype: "1")
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

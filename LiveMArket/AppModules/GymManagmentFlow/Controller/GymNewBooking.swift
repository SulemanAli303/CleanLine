//
//  HotelNewBooking.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit

class GymNewBooking: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithSearchButton
        viewControllerTitle = "New Bookings".localiz()
        setData()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
extension GymNewBooking : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingCell", for: indexPath) as! HotelBookingCell
        cell.base  = self
        cell.selectionStyle = .none
        cell.typeLbl.text = "Club Subscription".localiz()
        cell.nameLbl.text = "Olivia Stanford".localiz()
        cell.type = "Gym".localiz()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

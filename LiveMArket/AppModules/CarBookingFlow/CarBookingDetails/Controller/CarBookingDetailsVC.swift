//
//  BookingDetailsVC.swift
//  LiveMArket
//
//  Created by Zain on 17/01/2023.
//

import UIKit
import FloatRatingView


class CarBookingDetailsVC: BaseViewController {
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var tbl: IntrinsicallySizedTableView!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!

    @IBOutlet weak var paymentTypeView: UIView!
    @IBOutlet weak var paymentMethodsView: UIView!
    @IBOutlet weak var deliveryDetailView: UIStackView!
    
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var rejectView: UIView!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusColor: UIView!
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderStausView: UIView!
    
    @IBOutlet weak var verificationView: UIStackView!
    @IBOutlet weak var profileView: UIStackView!
    
    
    
    var VCtype :String?


    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "#LM-501248596038"
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        setData()
    }
    override func viewWillAppear(_ animated: Bool) {
        type = .backWithTop
        viewControllerTitle = "#LM-501248596038"
        
        let tabbar = tabBarController as? TabbarController
        if (VCtype == "8"){
            tabbar?.showTabBar()
        }else {
            tabbar?.hideTabBar()
        }

        
        super.viewWillAppear(animated)
//        let tabbar = tabBarController as? TabbarController
//        tabbar?.showTabBar()
        
        if VCtype == "1"
        {
            rejectButton.isHidden = true
            rejectView.isHidden = true
            acceptButton.setTitle("Accept".localiz(), for: .normal)
            statusLbl.text = "pending  ".localiz()
            statusColor.backgroundColor = UIColor(hex: "#FCB813")
            indicator.backgroundColor = UIColor(hex: "#FCB813")
            orderStatus.text = "Accept this Order?".localiz()
        }else if VCtype == "2"
        {
            rejectButton.isHidden = true
            rejectView.isHidden = true
            acceptButton.setTitle("On the Way", for: .normal)
            statusLbl.text = "Ready For Collection".localiz()
            statusColor.backgroundColor = UIColor(hex: "#F57070")
            indicator.backgroundColor = UIColor(hex: "#F57070")
            orderStatus.text = "Ready To Pickup?"
            mapView.isHidden = false
        }else if VCtype == "3"
        {
            orderStausView.isHidden = true
            statusLbl.text = "On The Way to collection".localiz()
            statusColor.backgroundColor = UIColor(hex: "#5795FF")
            indicator.backgroundColor = UIColor(hex: "#5795FF")
            verificationView.isHidden = false
            profileView.isHidden = false
        }
        else if VCtype == "8"
        {
            orderStausView.isHidden = true
            statusLbl.text = "On The Way".localiz()
            statusColor.backgroundColor = UIColor(hex: "#5795FF")
            indicator.backgroundColor = UIColor(hex: "#5795FF")
            verificationView.isHidden = false
            profileView.isHidden = false
        }
//        else if VCtype == "delivery"
//        {
//            rejectButton.isHidden = true
//            acceptButton.setTitle("Order Delivered", for: .normal)
//            statusColor.backgroundColor = UIColor(hex: "##00B24D")
//            statusLbl.text = "Order Delivered"
//            orderStausView.isHidden = true
//            profileView.isHidden = false
//            verificationView.isHidden = true
//            indicator.isHidden = true
//            deliveryDetailView.isHidden = false
//            mapView.isHidden = false
//
//
//        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
  

    @IBAction func statusPressed(_ sender: Any) {
        if VCtype == "1"
        {
            Coordinator.goToCarbookingDetail(controller: self, step: "2")
        } else if VCtype == "2"
        {
            Coordinator.goToCarbookingDetail(controller: self, step: "8")
        }
    }
    @IBAction func reviewPressed(_ sender: UIButton) {
        
        SellerOrderCoordinator.goToSellerBookingStatus(controller: self, status: "delivery")
    }
    @IBAction func payNow(_ sender: UIButton) {
        
        Coordinator.goTThankYouPage(controller: self,vcType: "paid", invoiceId: "",order_id: "",isFromFoodStore: false)
    }
    func setData() {
        self.tbl.delegate = self
        self.tbl.dataSource = self
        self.tbl.separatorStyle = .none
        self.tbl.register(CarBookingCell.nib, forCellReuseIdentifier: CarBookingCell.identifier)
        tbl.reloadData()
        self.tbl.layoutIfNeeded()
    }
    

}
// MARK: - TableviewDelegate
extension CarBookingDetailsVC : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tbl.dequeueReusableCell(withIdentifier: CarBookingCell.identifier, for: indexPath) as! CarBookingCell
        
        
        cell.selectionStyle = .none
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

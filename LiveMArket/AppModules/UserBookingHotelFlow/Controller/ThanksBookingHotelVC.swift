//
//  ThanksChaletsVC.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//


import UIKit

class ThanksBookingHotelVC: UIViewController {

    var vcType:String?
    var invoiceID:String = ""
    var bookingID:String = ""
    var isPaymentSuccess = false
    
    @IBOutlet weak var messageLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isPaymentSuccess){
            messageLbl.text = "Your payment has been done successfully!".localiz()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    @IBAction func OrderDetailPressed(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: false,booking_ID: bookingID,isFromThankYou: true)
    }
    @IBAction func backToHome(_ sender: UIButton) {
        Coordinator.updateRootVCToTab()
    }
}

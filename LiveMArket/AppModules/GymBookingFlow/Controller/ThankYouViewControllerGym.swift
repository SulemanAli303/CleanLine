//
//  ThankYouViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit

class ThankYouViewControllerGym: UIViewController {

    @IBOutlet weak var invoiceLabel: UILabel!
    var vcType:String?
    var invoiceID:String = ""
    var subscriptionID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        invoiceLabel.text = invoiceID
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
        //Coordinator.goToGymRequestDetails(controller: self)
        //Coordinator.updateRootVCToTab()
        let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
        VC.subscriptionID = subscriptionID
        VC.isFromReceivedSubscription = false
        VC.isFrommThankuPage = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func backToHome(_ sender: UIButton) {
        Coordinator.updateRootVCToTab()
    }
}

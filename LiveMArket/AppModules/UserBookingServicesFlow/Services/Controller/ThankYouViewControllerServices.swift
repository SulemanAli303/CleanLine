//
//  ThankYouViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit

class ThankYouViewControllerServices: UIViewController {

    var invoiceId:String?
    var vcType:String?
    var serviceId:String?
    var isPaymentSuccess = false
    @IBOutlet weak var invoiceIdLbl: UILabel!
    
    @IBOutlet weak var messageLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invoiceIdLbl.text = "\(invoiceId ?? "")"
        
        if(isPaymentSuccess){
            messageLbl.text = "Payment has been done successfully!".localiz()
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
        if (vcType == "1"){
            Coordinator.goToServiceRequestDetails(controller: self,step: "1",serviceID: self.serviceId)
        }else {
            Coordinator.goToServiceRequestDetails(controller: self,step: "8")
        }
    }
    @IBAction func backToHome(_ sender: UIButton) {
        Coordinator.updateRootVCToTab()
    }
    
}

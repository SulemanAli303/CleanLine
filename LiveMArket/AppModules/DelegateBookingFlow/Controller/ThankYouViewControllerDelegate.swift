//
//  ThankYouViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit

class ThankYouViewControllerDelegate: UIViewController {

    var invoiceId:String?
    var vcType:String?
    var serviceId:String?
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var invoiceIdLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invoiceIdLbl.text = "\(invoiceId ?? "")"
        if vcType == "1" {
            topLbl.text = "Your request has been placed successfully! please wait for confirmation".localiz()
        }else if vcType == "2" {
            topLbl.text = "Your payment successfully proceed! please wait for confirmation".localiz()
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
            Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: self.serviceId)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func backToHome(_ sender: UIButton) {
        Coordinator.updateRootVCToTab()
    }
    
}

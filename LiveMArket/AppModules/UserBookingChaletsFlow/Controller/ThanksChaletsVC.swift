//
//  ThanksChaletsVC.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//


import UIKit

class ThanksChaletsVC: UIViewController {

    var chaletID = ""
    var invoice = ""
    var vcType:String?
    var isPaymentAction = false
    
    @IBOutlet weak var invoiceLlb: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invoiceLlb.text = invoice
        if(isPaymentAction){
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
        Coordinator.goToChaletRequestDetails(controller: self,step: vcType ?? "1",chaletID: self.chaletID)
    }
    @IBAction func backToHome(_ sender: UIButton) {
        Coordinator.updateRootVCToTab()
    }
}

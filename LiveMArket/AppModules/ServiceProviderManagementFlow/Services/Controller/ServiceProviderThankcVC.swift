//
//  ThankYouViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit

class ServiceProviderThankcVC: UIViewController {

    @IBOutlet weak var inoviceNum: UILabel!
    var vcType:String?
    var service_inVoice = ""
    var service_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inoviceNum.text = self.service_inVoice

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
        
    }
    @IBAction func OrderDetailPressed(_ sender: UIButton) {
        
        Coordinator.goToServicProviderDetail(controller: self,step: "1",serviceId: self.service_id, isFromThank: true)
//        if (vcType == "1"){
//            Coordinator.goToServicProviderDetail(controller: self,step: "1")
//        }else if (vcType == "2"){
//            Coordinator.goToServicProviderDetail(controller: self,step: "2")
//        }
//        else {
//            Coordinator.goToServicProviderDetail(controller: self,step: "8")
//        }
    }
    @IBAction func backToHome(_ sender: UIButton) {
        Coordinator.updateRootVCToTab(selectedIndex: 4)
    }
    
}


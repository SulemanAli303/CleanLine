//
//  LMRegisterSuccessViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit

class LMRegisterSuccessViewController: BaseViewController {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: CreateAccountProgress! {
        didSet {
            progressView.backgroundColor  = .clear
        }
    }
    @IBOutlet weak var homeButton: UIButton!
    
    var mmodule : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        navigationItem.hidesBackButton = true
        if SessionManager.getUserType() ?? "" == "3" {
            self.lbl.text = "YOUR ACCOUNT HAS BEEN SUCCESSFULLY REGISTERED".localiz()
        }else {
            self.lbl.text = "YOUR ACCOUNT HAS BEEN REGISTERED, WAIT FOR ACTIVATION AND AUTHENTICATION.".localiz()
        }
        setInterface()
        
        
        let userFile:[String:[UIImage?]] = ["user_image" :[]]
        let parameters:[String:String] = [
            "temp_user_id" : String(SessionManager.getUserData()?.id ?? ""),
            "user_id" : String(SessionManager.getUserData()?.id ?? ""),

        ]
        print(parameters)
        AuthenticationAPIManager.signupAPIConfirmRegister(images: userFile, parameters: parameters) { result in
            switch result.status {
            case "1":
                print(result)
            default :
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        mmodule = UserDefaults.standard.integer(forKey: "flow")
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    
    @IBAction func proceed(_ sender: UIButton) {
        
        
        NotificationCenter.default.post(name: Notification.Name("loginStatusChanged"), object: nil)
        if SessionManager.getUserType() ?? "" == "3" {
            SessionManager.setLoggedIn()
        }
        if (SessionManager.getSkip()) {
            Coordinator.updateRootVCToTab()
        }else {
            Coordinator.updateRootVCToTab()
        }
       
    }
    //MARK: - Methode
    func setInterface() {
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
        progressView.selectedTab = 3
    }
}

//
//  LMRegisterSuccessViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit

class DMStep6ViewController: BaseViewController {

    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: DRAccountProgress! {
        didSet {
            progressView.backgroundColor  = .clear
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        navigationItem.hidesBackButton = true
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
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    
    @IBAction func proceed(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("loginStatusChanged"), object: nil)
//        SessionManager.setSocialLogin(isSocialLogin: false)
//        SessionManager.setLoggedIn()
        Coordinator.updateRootVCToTab()
    }
    //MARK: - Methode
    func setInterface() {
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
        progressView.selectedTab = 5
    }
}

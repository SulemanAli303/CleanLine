//
//  LMRegisterSuccessViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit

class ProfileSubmit: BaseViewController {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var yourAccountDetailsLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var progressView: CreateAccountProgress! {
        didSet {
            progressView.backgroundColor  = .clear
        }
    }
    
    var mmodule : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        navigationItem.hidesBackButton = true
        configureLanguage()
        setInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        mmodule = UserDefaults.standard.integer(forKey: "flow")
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
    
    func configureLanguage(){
        yourAccountDetailsLabel.text = "YOUR ACCOUNT DETAILS HAS BEEN UPDATED SUCCESSFULLY ".localiz()
        submitButton.setTitle("Submit".localiz(), for: .normal)
    }
    
    @IBAction func proceed(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ProfileViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    //MARK: - Methode
    func setInterface() {
        if UIDevice.current.hasNotch {
         //   topViewHeight.constant = 140
        } else {
          //  topViewHeight.constant = 100
        }
     //   progressView.selectedTab = 3
    }
}

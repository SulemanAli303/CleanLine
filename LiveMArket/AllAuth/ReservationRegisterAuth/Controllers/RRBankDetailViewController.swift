//
//  RRBankDetailViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 26/01/2023.
//

import UIKit

class RRBankDetailViewController: BaseViewController {
    
    
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var txtBank: UITextField!
    @IBOutlet weak var txtIbnCode: UITextField!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: CreateAccountProgress!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        setInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    
    //MARK: - Methode
    func setInterface() {
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
        progressView.selectedTab = 1
    }
    //MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    //MARK: - Actions
    @IBAction func nextAction(_ sender: Any) {
        if isValidIndividual() {
            let parameters:[String:String] = [
                "account_no" : txtAccount.text ?? "",
                "bank_name" : txtBank.text ?? "",
                "iban_code" : txtIbnCode.text ?? "",
              //  "user_id" : String(SessionManager.getUserData()?.id ?? 0),
                "user_id" : String(SessionManager.getUserData()?.id ?? ""),
            ]
            
            AuthenticationAPIManager.bankAccountAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    Coordinator.goToAddLocationPage(controller: self)
                    
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
        
    }
    func isValidIndividual() -> Bool {
        if txtAccount.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter account number".localiz()) {
                
            }
            return false
        }
        if txtBank.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter bank name".localiz()) {
                
            }
            return false
        }
        if txtIbnCode.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter iban code".localiz()) {
                
            }
            return false
        }
        return true
    }
}

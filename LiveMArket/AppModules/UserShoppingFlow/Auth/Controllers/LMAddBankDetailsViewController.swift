//
//  LMAddBankDetailsViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 03/01/23.
//

import UIKit

class LMAddBankDetailsViewController: BaseViewController {
    
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var txtBank: UITextField!
    @IBOutlet weak var txtIbnCode: UITextField!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: CreateAccountProgress!
    
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var fillBasicInfoLabel: UILabel!
    @IBOutlet weak var bankAccountLabel: UILabel!
    @IBOutlet weak var skipThisButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        setInterface()
        configueLanguage()
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
    
    func configueLanguage(){
        createAccountLabel.text = "Create an Account".localiz()
        fillBasicInfoLabel.text = "Fill your basic info".localiz()
        bankAccountLabel.text = "Bank account Details".localiz()
        txtAccount.placeholder = "ACCOUNT NO".localiz()
        txtBank.placeholder = "BANK NAME".localiz()
        txtIbnCode.text = "IBAN CODE".localiz()
        
        skipThisButton.setTitle("Skip This".localiz(), for: .normal)
        backButton.setTitle("Back".localiz(), for: .normal)
        continueButton.setTitle("Continue".localiz(), for: .normal)
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
                "temp_user_id" : String(SessionManager.getUserData()?.id ?? ""),

            ]
            
            AuthenticationAPIManager.bankAccountAPIV2(parameters: parameters) { result in
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
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func skipAction(_ sender: Any) {
        Coordinator.goToAddLocationPage(controller: self)
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

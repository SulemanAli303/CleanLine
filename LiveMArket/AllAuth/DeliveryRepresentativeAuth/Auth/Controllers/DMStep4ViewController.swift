//
//  DMStep4ViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 25/01/2023.
//

import UIKit

class DMStep4ViewController: BaseViewController {

    
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var txtBank: UITextField!
    @IBOutlet weak var txtIbnCode: UITextField!
    
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: DRAccountProgress!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        setInterface()
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
               // "user_id" : String(SessionManager.getUserData()?.id ?? 0),
                "user_id" : String(SessionManager.getUserData()?.id ?? ""),
                "temp_user_id" : String(SessionManager.getUserData()?.id ?? ""),

            ]
            
            AuthenticationAPIManager.bankAccountAPIV2(parameters: parameters) { result in
                switch result.status {
                case "1":
                    WholeSellerAuthCoordinator.goToDRStep5(controller: self)
                    
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

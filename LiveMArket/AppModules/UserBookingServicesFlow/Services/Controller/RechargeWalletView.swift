//
//  RechargeWalletView.swift
//  LiveMArket
//
//  Created by Zain on 14/07/2023.
//

import UIKit
import Stripe
import goSellSDK

class RechargeWalletView: BaseViewController {
    @IBOutlet weak var amount: UITextField!
    
    var paymentSheet: PaymentSheet?
    var secretkey = ""
    var transID = ""
    var cardToken:String?
    var paymentService:PaymentViaTapPayService!
    var walletData: PaymentResponse? {
        didSet {
            self.secretkey = walletData?.payment_ref ?? ""
            self.transID = walletData?.invoice_id ?? ""
            paymentService.paymentResponse = walletData?.oTabTransaction
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        paymentService.invoiceId = "Recharge_\(Date().debugDescription)"
        viewControllerTitle = "Balance".localiz()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    @IBAction func recharge(_ sender: UIButton) {
        if isValidForm() {
            self.paymentService.startPaymentViaSellSDK(amount: Decimal.init(string: amount.text ?? "0.0") ?? 0.0)
        }
    }
}
extension RechargeWalletView {
    
    func isValidForm() -> Bool {
        if amount.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter amount".localiz()) {
                
            }
            return false
        }
        if (Int(amount.text ?? "") ?? 0) < 1 || ((Int(amount.text ?? "") ?? 0) > 200000) {
            Utilities.showWarningAlert(message: "Recharge wallet amount must be greater then 1 and less than 200000".localiz()) {
                
            }
            return false
        }
        return true
    }
    func RechargeAction() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "amount" : self.amount.text ?? "",
            "payment_type" : "1",
            "token_id": cardToken  ?? ""
        ]
        AuthenticationAPIManager.rechargeWalletAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                    self.walletData = result.oData
            default:
                    Utilities.showWarningAlert(message: result.message ?? "" ) {

                }
            }
        }
    }
}
// MARK: - Stripe Integration
extension RechargeWalletView {
    func paymentCompletedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : self.walletData?.invoice_id ?? ""
        ]
        AuthenticationAPIManager.completeWalletAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        self.navigationController?.popViewController(animated: true)
                    }
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {

                    }
            }
        }
    }

}
extension RechargeWalletView:PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        self.RechargeAction()
    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        if isSuccess {
            self.paymentCompletedAPI()
        }
    }
}

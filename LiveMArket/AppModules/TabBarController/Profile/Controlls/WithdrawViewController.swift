//
//  WithdrawViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 07/10/23.
//

import UIKit

protocol UpdateRequestProtocol{
    func updateValue()
}

class WithdrawViewController: BaseViewController {

    
    @IBOutlet weak var balanceEarningLabel: UILabel!
    @IBOutlet weak var youCanLabel: UILabel!
    @IBOutlet weak var withdrawEarningLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var willDoLaterLabel: UIButton!
    
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var uptoAmountlabel: UILabel!
    @IBOutlet weak var balanceAmount: UILabel!
    var walletData:WalletEarningsData?
    var delegate:UpdateRequestProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        if let data = walletData{
            balanceAmount.text = "\(data.currenct_code ?? "") \(data.earning_balance ?? "")"
            uptoAmountlabel.text = "\(data.currenct_code ?? "") \(data.earning_balance ?? "")"
        }
    }
    
    func configureLanguage(){
        balanceEarningLabel.text = "Balance Earnings".localiz()
        youCanLabel.text = "You can ernings up to".localiz()
        withdrawEarningLabel.text = "WITHDRAW ERNINGS".localiz()
        submitButton.setTitle("Submit".localiz(), for: .normal)
        willDoLaterLabel.setTitle("WILL DO IT LATER".localiz(), for: .normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func submitAction(_ sender: UIButton) {
        guard self.amountTextField.text ?? "" != "" else{
            Utilities.showWarningAlert(message: "please enter your amount.".localiz())
            return
        }
        walletWithdrawAPI()
    }
    
    @IBAction func withdrawAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
extension WithdrawViewController{
    func walletWithdrawAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "amount" : self.amountTextField.text ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.walletWithdrawAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.delegate?.updateValue()
                    self.dismiss(animated: true)
                    
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension WithdrawViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

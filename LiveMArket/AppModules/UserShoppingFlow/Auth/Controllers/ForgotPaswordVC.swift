//
//  ForgotPaswordVC.swift
//  LiveMArket
//
//  Created by Zain on 16/06/2023.
//

import UIKit

class ForgotPaswordVC: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var toResetYourPasswordLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    func configureLanguage(){
        forgotPasswordLabel.text = "Forgot Password".localiz()
        toResetYourPasswordLabel.text = "To reset your password, enter your email id to receive OTP".localiz()
        txtEmail.placeholder = "EMAIL ADDRESS".localiz()
        submitButton.setTitle("Submit".localiz(), for: .normal)
        backButton.setTitle("Back".localiz(), for: .normal)
    }
    func isValidForm() -> Bool {
        if txtEmail.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter email address".localiz()) {
                
            }
            return false
        }
        if !(txtEmail.text?.isValidEmail ?? false) {
            Utilities.showWarningAlert(message: "Please enter valid email address".localiz()) {
                
            }
            return false
        }
        return true
    }
    @IBAction func loginAction(_ sender: Any) {
        
      //  Coordinator.goToVerifyOTP(controller: self)
        if isValidForm() {
            let parameters:[String:String] = [
                "email" : txtEmail.text ?? ""
            ]
            AuthenticationAPIManager.forgotAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    Coordinator.goToVerifyOTP(controller: self,email: self.txtEmail.text)
                    break
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    @IBAction func skipAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

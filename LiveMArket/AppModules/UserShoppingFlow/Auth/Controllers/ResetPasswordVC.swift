//
//  ResetPasswordVC.swift
//  LiveMArket
//
//  Created by Zain on 16/06/2023.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    var emailID = ""
    @IBOutlet weak var resetPasswordLAbel: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
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
        resetPasswordLAbel.text = "Reset Password".localiz()
        txtPassword.placeholder = "NEW PASSWORD".localiz()
        txtConfirmPassword.placeholder = "Re Enter New Password".localiz()
        submitButton.setTitle("Submit".localiz(), for: .normal)
        backButton.setTitle("Back".localiz(), for: .normal)
    }
    @IBAction func viewPwdBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 1001:
            sender.isSelected = !sender.isSelected
            txtPassword.isSecureTextEntry = !sender.isSelected
        default:
            sender.isSelected = !sender.isSelected
            txtConfirmPassword.isSecureTextEntry = !sender.isSelected
        }
    }
    @IBAction func loginAction(_ sender: Any) {
        if isValidForm() {
            let parameters:[String:String] = [
                "email" : self.emailID,
                "new_password" : txtConfirmPassword.text ?? ""
            ]
            AuthenticationAPIManager.resetOTPAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    Utilities.showSuccessAlert(message: result.message ?? "") {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: LMLoginViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                    break
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    func isValidForm() -> Bool {
        if txtPassword.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter password".localiz()) {
                
            }
            return false
        }
        if txtConfirmPassword.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter confirm password".localiz()) {
                
            }
            return false
        }
        if txtPassword.text != txtConfirmPassword.text {
            Utilities.showWarningAlert(message: "Password and confirm password does not match".localiz()){
                
            }
            return false
        }
        return true
    }
    
    @IBAction func skipAction(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LMLoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}

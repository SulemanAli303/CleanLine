//
//  ChangePasswordVC.swift
//  LiveMArket
//
//  Created by Apple on 13/02/2023.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    
    @IBOutlet weak var oldPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .backWithTop
        viewControllerTitle = "Change Password".localiz()
        configLanguage()

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
    func configLanguage(){
        oldPass.placeholder = "Old Password".localiz()
        newPass.placeholder = "New Password".localiz()
        confirmPass.placeholder = "Confirm Password".localiz()
        submitButton.setTitle("Submit".localiz(), for: .normal)
    }
    
    @IBAction func showOldPasswordAction(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            oldPass.isSecureTextEntry = true
        }else{
            sender.isSelected = true
            oldPass.isSecureTextEntry = false
        }
    }
    
    @IBAction func showNewPasswordAction(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            newPass.isSecureTextEntry = true
        }else{
            sender.isSelected = true
            newPass.isSecureTextEntry = false
        }
    }
    @IBAction func showConfirmPasswordAction(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            confirmPass.isSecureTextEntry = true
        }else{
            sender.isSelected = true
            confirmPass.isSecureTextEntry = false
        }
    }
    
    //MARK: - Methods
    func isFormValid() -> Bool {
        if oldPass.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Enter old password".localiz()) {
                
            }
            return false
        }
        if  Utilities.isValidPassword(password: newPass.text?.trimmingCharacters(in: .whitespaces)) == false {
            Utilities.showWarningAlert(message: "Your password must be at least 8 characters. It must include an upper and lowercase letter and a number. It can also include special characters -_?!$%^()@".localiz()) {
                
            }
            return false
        }
        if confirmPass.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Enter confirm password".localiz()){
                
            }
            return false
        }
        if confirmPass.text?.count ?? 0 < 8 {
            Utilities.showWarningAlert(message: "The confirm password must be at least 8 characters.".localiz()) {
                
            }
            return false
        }
        if newPass.text != confirmPass.text {
            Utilities.showWarningAlert(message: "Password and confirm password does not match".localiz()){
                
            }
            return false
        }
        return true
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        if isFormValid() {
            let parameters:[String:String] = [
                "access_token": SessionManager.getUserData()?.accessToken ?? "",
                "old_password" : oldPass.text ?? "",
                "new_password" : newPass.text ?? ""
            ]
            
            AuthenticationAPIManager.changePasswordAPI(parameters: parameters) { response in
                switch response.status {
                case "1":
                    Utilities.showSuccessAlert(message: response.message ?? "") {
                        self.navigationController?.popViewController(animated: true)
                    }
                default :
                    Utilities.showWarningAlert(message: response.message ?? ""){
                        
                    }
                }
            }
        }
    }
}

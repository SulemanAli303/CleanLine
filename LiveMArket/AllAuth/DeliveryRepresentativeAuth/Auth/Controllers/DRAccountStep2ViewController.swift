//
//  DRAccountStep2ViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 25/01/2023.
//

import UIKit
import CountryPickerView

class DRAccountStep2ViewController: BaseViewController {
    
    
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var ReferralCodeView: UIView!
    var deliveryRepresentative  =  DeliveryRepresentative()
    let cpvInternal = CountryPickerView()
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var txtMobile: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var tickImg: UIButton!
    @IBOutlet weak var Passwordview: UIView!
    @IBOutlet weak var cPasswordview: UIView!
    @IBOutlet weak var btnPasswod: UIButton!
    @IBOutlet weak var btncPasswod: UIButton!
    
    var isAccepted = false
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: DRAccountProgress!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        if SessionManager.isSocialLogin() {
            self.txtEmail.text = SessionManager.getSocialEmail()
            self.txtEmail.isUserInteractionEnabled = false
            self.Passwordview.isHidden = true
            self.cPasswordview.isHidden = true
        }else {
            self.txtEmail.isUserInteractionEnabled = true
            self.Passwordview.isHidden = false
            self.cPasswordview.isHidden = false
        }
        setInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.referralCodeTextField.text = Constants.shared.sharedReferralCode
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
    @IBAction func nextAction(_ sender: Any) {
        
        if isValidIndividual() {
            self.callIndividual()
        }
        
    }
    
    func callIndividual() {
        var loginType = "normal"
        if SessionManager.isSocialLogin() {
            loginType = "social"
        }
        let parameters:[String:String] = [
            "name" : self.deliveryRepresentative.driverName ?? "",
            "res_dial_code" : (codeLbl.text ?? "").replacingOccurrences(of: "+", with: ""),
            "res_phone" : txtMobile.text ?? "",
            "dial_code" : (codeLbl.text ?? "").replacingOccurrences(of: "+", with: ""),
            "phone" : txtMobile.text ?? "",
            "dob" : self.deliveryRepresentative.dob ?? "",
            "country_id" : "3",
            "email" : txtEmail.text ?? "",
            "password" : txtPassword.text ?? "",
            "user_type_id" : SessionManager.getUserType() ?? "",
            "activity_type_id" : SessionManager.getActivityType() ?? "",
            "business_type_id" : SessionManager.getBusinessType() ?? "",
            "user_device_type" : Constants.deviceType,
            "user_device_token" : SessionManager.getFCMToken() ?? "",
            "login_type" : loginType,
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "referal_code" : self.referralCodeTextField.text ?? ""
        ]
        let userFile:[String:[UIImage?]] = ["user_image" :[self.deliveryRepresentative.userImg?.image]]
        AuthenticationAPIManager.signupDeliveryAPI(images:userFile, parameters: parameters) { response in
            switch response.status {
            case "1":
                WholeSellerAuthCoordinator.goToDRStep3(controller: self)
            default :
                Utilities.showWarningAlert(message: response.message ?? "") {
                    
                }
            }
        }
    }
    
    @IBAction func termsAction(_ sender: Any) {
        Coordinator.goToCMSPage(controller: self)
    }
    @IBAction func viewPwdBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 1001:
            txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
            if  txtPassword.isSecureTextEntry == false {
                btnPasswod.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            }else {
                btnPasswod.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
            
        default:
            txtConfirmPassword.isSecureTextEntry = !txtConfirmPassword.isSecureTextEntry
            if  txtConfirmPassword.isSecureTextEntry == false {
                btncPasswod.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            }else {
                btncPasswod.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
        }
    }
    @IBAction func acceptedAction(_ sender: UIButton) {
        isAccepted = !isAccepted
        if(isAccepted){
            tickImg.setImage(UIImage(named: "checked"), for: .normal)
        }else {
            tickImg.setImage(UIImage(named: "icn_uncheck"), for: .normal)
        }
        
    }
    @IBAction func countryCodeAction(_ sender: Any) {
        cpvInternal.delegate = self
        cpvInternal.showCountriesList(from: self)
    }
    
    func isValidIndividual() -> Bool {
        if codeLbl.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please choose country code".localiz()) {
                
            }
            return false
        }
        if txtMobile.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter mobile number".localiz()) {
                
            }
            return false
        }
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
        if !SessionManager.isSocialLogin() {
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
        }
        if !isAccepted {
            Utilities.showWarningAlert(message: "Please accept terms and conditions".localiz()){
                
            }
            return false
        }
        return true
    }
}

extension DRAccountStep2ViewController:UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 12
    }
}
extension DRAccountStep2ViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
        self.codeLbl.text = country.phoneCode
        
    }
}

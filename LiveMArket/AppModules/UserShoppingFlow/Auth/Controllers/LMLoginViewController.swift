//
//  LMLoginViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class LMLoginViewController: UIViewController {
    
    
    var isFromOptions = false
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnPasswod: UIButton!
    
    @IBOutlet weak var loginAndContinueLabel: UILabel!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontAccountLabel: UILabel!
    @IBOutlet weak var loginWithLabel: UILabel!
    @IBOutlet weak var continueGoogleLabel: UILabel!
    @IBOutlet weak var continueAppleLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    
    
    
    
    
    var isOpen = true
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
//        txtEmail.text = "r1@mailinator.com"
//        txtPassword.text = "@Hello123"
        
        txtEmail.text = "devikasr1995@gmail.com"
        txtPassword.text = "Hello@123"
        #endif

        configueLanguage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        googleButton.tintColor = .clear
        appleButton.tintColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func configueLanguage(){
        loginAndContinueLabel.text = "Login and Continue".localiz()
        helloLabel.text = "Hello, how are you?".localiz()
        txtEmail.placeholder = "EMAIL ADDRESS".localiz()
        txtPassword.placeholder = "PASSWORD".localiz()
        forgotButton.setTitle("Forgot Password?".localiz(), for: .normal)
        loginButton.setTitle("Login".localiz(), for: .normal)
        dontAccountLabel.text = "Don\'t have an account?".localiz()
        loginWithLabel.text = "Login With".localiz()
        continueGoogleLabel.text = "Continue with Google".localiz()
        continueAppleLabel.text = "Continue with Apple".localiz()
        skipButton.setTitle("Skip This".localiz(), for: .normal)
    }
    
    
    //MARK: - Actions
    @IBAction func loginAction(_ sender: Any) {
        if isValidForm() {
            let parameters:[String:String] = [
                "email" : txtEmail.text ?? "",
                "password" : txtPassword.text ?? "",
                "user_device_token" : SessionManager.getFCMToken() ?? "",
                "device_type" : Constants.deviceType,
                "device_cart_id" : SessionManager.getCartId() ?? ""
            ]
            print(parameters)
            AuthenticationAPIManager.loginAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    //Utilities.showSuccessAlert(message: result.message ?? "") {
                        NotificationCenter.default.post(name: Notification.Name("loginStatusChanged"), object: nil)
                        SessionManager.setSocialLogin(isSocialLogin: false)
                        SessionManager.setLoggedIn()
                       UserDefaults.standard.set(true, forKey: "isReload")
                    
                       let appDelegate = UIApplication.shared.delegate as? AppDelegate
                       appDelegate?.updateDeviceToken()
                    
                       Coordinator.updateRootVCToTab()
                       // if let _ = self.navigationController?.popViewController(animated: false) {} else {
//                            if(self.isFromOptions == true){
//                                Coordinator.updateRootVCToTab()
//                            }else {
//                                self.dismiss(animated: true, completion: nil)
//                            }
                       // }
                    //}
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
    @IBAction func signUPAction(_ sender: Any) {
        SessionManager.setSkipIn(isSkip: self.isFromOptions)
        SessionManager.setSocialLogin(isSocialLogin: false)
        Coordinator.goToLoginTypeChoosenPage(controller: self)
        
        
    }
    @IBAction func appleBtnAction(_ sender: Any) {
        AppleSignInManager.shared.handleAppleIdRequest()
        AppleSignInManager.shared.appleSignInDelegate = self

    }
    @IBAction func forgotAction(_ sender: Any) {
        Coordinator.goToForgotPassword(controller: self)
        //Coordinator.goToAddLocationPage(controller: self)
    }
    @IBAction func skipAction(_ sender: Any) {
        Constants.shared.sharedReferralCode = ""
        Coordinator.updateRootVCToTab()
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
            sender.isSelected = !sender.isSelected
            txtPassword.isSecureTextEntry = !sender.isSelected
        }
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
        if txtPassword.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter password".localiz()) {
                
            }
            return false
        }
        return true
    }
    func loginWithSocialMedia(parameters : [String:String]) {
        AuthenticationAPIManager.socialloginAPI(parameters: parameters) { response in
            switch response.status {
            case "1":
                SessionManager.setSocialLogin(isSocialLogin: true)
                if response.needRegistration == "1" {
                    SessionManager.setSkipIn(isSkip: self.isFromOptions)
                    Coordinator.goToLoginTypeChoosenPage(controller: self)
                }else {
                 //   Utilities.showSuccessAlert(message: response.message ?? "") {
                        NotificationCenter.default.post(name: Notification.Name("loginStatusChanged"), object: nil)
                        SessionManager.setSocialLogin(isSocialLogin: true)
                        SessionManager.setLoggedIn()
                        UserDefaults.standard.set(true, forKey: "isReload")
                        Coordinator.updateRootVCToTab()
//                        if let _ = self.navigationController?.popViewController(animated: true) {} else {
//                            if(self.isFromOptions == true){
//                                Coordinator.updateRootVCToTab()
//                            }else {
//                                self.dismiss(animated: true, completion: nil)
//                            }
//                        }
                   // }
                }
            default :
                Utilities.showWarningAlert(message: response.message ?? "")
            }
        }
    }
    @IBAction func googleAction(_ sender: Any) {
        let signInConfig = GIDConfiguration.init(clientID: Config.googleSignInClientID)
        GIDSignIn.sharedInstance.configuration = signInConfig
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { user, error in
            guard error == nil else { return }
            
            if let user = user?.user {
                let parameters:[String:String] = [
                    "email" : user.profile?.email ?? "",
                    "user_device_token" : SessionManager.getFCMToken() ?? "",
                    "user_device_type" : Constants.deviceType,
                    "device_cart_id" : SessionManager.getCartId() ?? ""
                ]
                SessionManager.setSocialEmail(currency: user.profile?.email ?? "")
                if let imageUrl = user.profile?.imageURL(withDimension: 100) {
                    let userImage = imageUrl.absoluteString
                    UserDefaults.standard.set(userImage, forKey: "googleImage")
                    NotificationCenter.default.post(name: Notification.Name("loginStatusChanged"), object: nil)

                }
                self.loginWithSocialMedia(parameters: parameters)
            }
        }
    }
}
extension LMLoginViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
        
    }
}


// MARK: - SignInWith Apple Delegate Implemetation
extension LMLoginViewController: AppleAuthorization {
    func didAuthorizedWithAppleSuccessfully(appleData: AppleSignInData) {
        let parameters:[String:String] = [
            "email" : appleData.email,
            "user_device_token" : SessionManager.getFCMToken() ?? "",
            "user_device_type" : Constants.deviceType
        ]
        SessionManager.setSocialEmail(currency:  appleData.email)
        self.loginWithSocialMedia(parameters: parameters)
    }
    
    func didFailToAuthorizeWithApple(errorString: String) {
        Utilities.showWarningAlert(message: "Unable to sign in please try again".localiz())
    }
}

//
//  HelpCenterVC.swift
//  LiveMArket
//
//  Created by Apple on 14/02/2023.
//

import UIKit
import KMPlaceholderTextView
import CountryPickerView

class HelpCenterVC: BaseViewController {

    @IBOutlet weak var messageTextView: KMPlaceholderTextView!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    private let cpvInternal = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .backWithTop
        viewControllerTitle = "Help Center".localiz()
        configLanguage()
        // Do any additional setup after loading the view.
        let user = SessionManager.getUserData()
        nameTextField.text = user?.name ?? ""
        emailTextField.text = user?.email ?? ""
        mobileTextField.text = user?.phone_number ?? ""
        
        var countryCode = user?.dial_code ?? "+971"
        countryCode = countryCode.replacingOccurrences(of: "+", with: "")
        countryCodeLbl.text = "+\(countryCode)"
        
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
        messageTextView.placeholderLabel.text = "your message...".localiz()
        nameTextField.placeholder = "Name".localiz()
        nameTextField.placeholder = "Email".localiz()
        nameTextField.placeholder = "MOBILE NUMBER".localiz()
//        messageTextView.placeholder = "messageTextView".localiz()
    }
    
    func isValidForm() -> Bool {
        if nameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter full name".localiz()) {
                
            }
            return false
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter email address".localiz()) {
                
            }
            return false
        }
        
        if !(emailTextField.text?.isValidEmail ?? false) {
            Utilities.showWarningAlert(message: "Please enter valid email address".localiz()) {
                
            }
            return false
        }
        
        if countryCodeLbl.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please choose country code".localiz()) {
                
            }
            return false
        }
        if mobileTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter mobile number".localiz()) {
                
            }
            return false
        }
        
        if messageTextView.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter your message".localiz()) {
                
            }
            return false
        }
        
        return true
    }
    
    @IBAction func whatsappBtnTapped(_ sender: Any) {
        
        let urlWhats = "whatsapp://send?phone=+916296230264"
           if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
               if let whatsappURL = URL(string: urlString) {
                   if UIApplication.shared.canOpenURL(whatsappURL){
                       if #available(iOS 10.0, *) {
                           UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                       } else {
                           UIApplication.shared.openURL(whatsappURL)
                       }
                   } else {
                       Utilities.showWarningAlert(message: "You do not have WhatsApp installed! \nPlease install first.".localiz()) {
                           
                       }
                   }
               }
           }
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if(isValidForm()){
            
            let parameters:[String:String] = [
                "name" : nameTextField.text ?? "",
                "email" : emailTextField.text ?? "",
                "mobile_number" : "\(countryCodeLbl.text ?? "")\(mobileTextField.text ?? "")",
                "message" : messageTextView.text ?? "",
            ]
            CMSAPIManager.helpCenterAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    Utilities.showSuccessAlert(message: result.message ?? "") {
                        self.navigationController?.popViewController(animated: true)
                    }
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    @IBAction func countryCodeAction(_ sender: Any) {
        cpvInternal.delegate = self
        cpvInternal.showCountriesList(from: self)
    }
    
}

extension HelpCenterVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.countryCodeLbl.text = country.phoneCode
    }
}

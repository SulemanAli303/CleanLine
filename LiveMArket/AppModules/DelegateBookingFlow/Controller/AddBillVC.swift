//
//  GymManagmentRate.swift
//  LiveMArket
//
//  Created by Zain on 08/02/2023.
//

import UIKit
import KMPlaceholderTextView

class AddBillVC: UIViewController {
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var charges: UITextField!
    @IBOutlet weak var notes: KMPlaceholderTextView!
    var step : String?
    var service_request_id  = ""
    var service_inVoice  = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

        
    }
    @IBAction func submit(_ sender: Any) {
       // Coordinator.goToServicProviderThank(controller: self, step: "2")
        if isValidForm() {
            serviceAcceptAPI()
        }
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func isValidForm() -> Bool {
        if price.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter price".localiz()) {
                
            }
            return false
        }
        return true
    }
    func serviceAcceptAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_id" : service_request_id,
            "bill_amount" : self.price.text ?? "",
        ]
        print(parameters)
        DelegateServiceAPIManager.addBillAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.navigationController?.popViewController(animated: true)
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}


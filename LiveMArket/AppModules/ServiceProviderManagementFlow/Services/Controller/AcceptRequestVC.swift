//
//  GymManagmentRate.swift
//  LiveMArket
//
//  Created by Zain on 08/02/2023.
//

import UIKit
import KMPlaceholderTextView
import FittedSheets

protocol AcceptRequestVCProtocol{
    func refreshmentData()
}
class AcceptRequestVC: UIViewController {
    @IBOutlet weak var price: UITextField!
    var delegate:AcceptRequestVCProtocol?
    @IBOutlet weak var charges: UITextField!
    @IBOutlet weak var notes: KMPlaceholderTextView!
    var step : String?
    var service_request_id  = ""
    var service_inVoice  = ""
    var isfromPopup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        price.placeholder = "your price".localiz()
        charges.placeholder = "Service charges".localiz()
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
        if self.isfromPopup == false {
            self.navigationController?.popViewController(animated: true)
        }else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    func isValidForm() -> Bool {
        if price.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter price".localiz()) {
                
            }
            return false
        }
        if charges.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter service charges".localiz()) {
                
            }
            return false
        }
        return true
    }
    func serviceAcceptAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : service_request_id,
            "amount" : self.price.text ?? "",
            "service_charges" : self.charges.text ?? "",
            "accept_note" : self.notes.text
        ]
        print(parameters)
        ServiceAPIManager.Accept_ProviderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                if self.isfromPopup == false {
                    //Coordinator.goToServicProviderThank(controller: self, step: "2",service_inVoice: self.service_inVoice,serviceId: self.service_request_id)
                    DispatchQueue.main.async {
                        let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                        controller.delegate = self
                        controller.heading = "Order Accepted successfully".localiz()
                        controller.confirmationText = ""
                        controller.invoiceNumber = self.service_inVoice
                        let sheet = SheetViewController(
                            controller: controller,
                            sizes: [.fullscreen],
                            options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
                        sheet.minimumSpaceAbovePullBar = 0
                        sheet.dismissOnOverlayTap = true
                        sheet.dismissOnPull = false
                        sheet.contentBackgroundColor = UIColor.black.withAlphaComponent(0.5)
                        self.present(sheet, animated: true, completion: nil)
                    }
                    
                }else {
                    self.delegate?.refreshmentData()
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension AcceptRequestVC:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        Coordinator.goToServicProviderDetail(controller: self,step: "1",serviceId: self.service_request_id,isFromThank: false)
    }
}

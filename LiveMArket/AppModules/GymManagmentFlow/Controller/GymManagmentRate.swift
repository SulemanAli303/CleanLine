//
//  GymManagmentRate.swift
//  LiveMArket
//
//  Created by Zain on 08/02/2023.
//

import UIKit
import KMPlaceholderTextView

protocol StatusUpdateProtocol{
    func refreshment()
}

class GymManagmentRate: UIViewController {

    @IBOutlet weak var notesTextView: KMPlaceholderTextView!
    @IBOutlet weak var subscriptionnumberLabel: UITextView!
    
    var subscriptionID:String = ""
    var delegate:StatusUpdateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notesTextView.placeholderLabel.text = "Enter the subscription no".localiz()
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
        
        guard self.subscriptionnumberLabel.text != "" else {
            Utilities.showWarningAlert(message: "Please enter subscription number.".localiz()) {}
            return
        }
        guard self.notesTextView.text != "" else {
            Utilities.showWarningAlert(message: "Please ADD your notes.".localiz()) {}
            return
        }
        acceptSubscriptionAPI()
        
    }
    
    func acceptSubscriptionAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "subscription_id" : subscriptionID,
            "subscription_no":self.subscriptionnumberLabel.text ?? "",
            "accept_note":self.notesTextView.text ?? ""
        ]
        print(parameters)
        GymAPIManager.acceptSubscriptionAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.refreshment()
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
                
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
        
    }
}

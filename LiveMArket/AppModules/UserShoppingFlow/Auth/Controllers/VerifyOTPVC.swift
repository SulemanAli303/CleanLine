//
//  VerifyOTPVC.swift
//  LiveMArket
//
//  Created by Zain on 16/06/2023.
//

import UIKit
import DPOTPView

class VerifyOTPVC: UIViewController {
    
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var toVerifyLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var resendView: UIView!
    @IBOutlet weak var lblTimerText: UILabel!
    var emailID = ""
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        resendView.isHidden = true
        runTimer()
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
        otpLabel.text = "OTP".localiz()
        toVerifyLabel.text = "To verify your email id, please enter the OTP that sent to your email ".localiz()
        submitButton.setTitle("Submit".localiz(), for: .normal)
        resendButton.setTitle("Resend".localiz(), for: .normal)
        backButton.setTitle("Back".localiz(), for: .normal)
    }
    @IBAction func loginAction(_ sender: Any) {
        if otpView.validate(){
            let parameters:[String:String] = [
                "email" : self.emailID,
                "otp" : otpView.text ?? ""
            ]
            AuthenticationAPIManager.validateOTPAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    Utilities.showSuccessAlert(message: result.message ?? "") {
                        Coordinator.goToResetPassword(controller: self,email: self.emailID)
                    }
                    break
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else {
            Utilities.showWarningAlert(message: "Enter valid OTP".localiz())
        }
            
    }

    deinit {
        timer.invalidate()
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        if seconds == 0
        {
            timer.invalidate()
            lblTimerText.isHidden = true
            resendView.isHidden = false
        }
        lblTimerText.text = "0:\(seconds) \("sec".localiz())"
    }
    @IBAction func skipAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resendBTn(_ sender: Any) {
        ResendOTP()
    }
    func ResendOTP () {
        
        let parameters:[String:String] = [
            "email" : self.emailID
        ]
        AuthenticationAPIManager.forgotAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showSuccessAlert(message: "Otp send to your email id".localiz()) {
                    self.seconds = 60
                    self.lblTimerText.isHidden = false
                    self.resendView.isHidden = true
                    self.runTimer()
                }
                break
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
        
    }
}

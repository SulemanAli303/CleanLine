//
//  LMAddBankDetailsViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 03/01/23.
//

import UIKit

class WSAddBankDetailsViewController: BaseViewController {
    
    
    @IBOutlet weak var txtCommercialLisence: UITextField!
    @IBOutlet weak var txtCommercialRegisterNo: UITextField!
    @IBOutlet weak var txtAssociatedLicense: UITextField!
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var txtBank: UITextField!
    @IBOutlet weak var txtIbnCode: UITextField!
    
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var basicInfoLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bankDetailsLabel: UILabel!
    
    
    
    var lisenceData: Data?
    var associatedlisenceData: Data?
    var fileType = ""
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: CreateAccountProgress!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        configueLanguage()
        setInterface()
    }
    
    //MARK: - Methode
    
    func configueLanguage(){
        createAccountLabel.text = "Create an Account".localiz()
        basicInfoLabel.text = "Fill your basic info".localiz()
        txtCommercialLisence.placeholder = "UPLOAD COMMERCIAL LISENCE".localiz()
        txtCommercialRegisterNo.placeholder = "COMMERCIAL REGISTRATION NO".localiz()
        txtAssociatedLicense.placeholder = "Upload associated License".localiz()
        bankDetailsLabel.text = "Bank account Details".localiz()
        txtAccount.placeholder = "ACCOUNT NO".localiz()
        txtBank.placeholder = "BANK NAME".localiz()
        txtIbnCode.placeholder = "IBAN CODE".localiz()
        continueButton.setTitle("Continue".localiz(), for: .normal)
        backButton.setTitle("Back".localiz(), for: .normal)
    }
    
    func setInterface() {
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
        progressView.selectedTab = 1
    }
    //MARK: - Actions
    
    @IBAction func cintinueAction(_ sender: Any) {
        if isValidIndividual() {
            var parameters:[String:String] = [
                "commercial_reg_no" : txtCommercialRegisterNo.text ?? "",
                "account_no" : txtAccount.text ?? "",
                "bank_name" : txtBank.text ?? "",
                "iban_code" : txtIbnCode.text ?? "",
               // "user_id" : String(SessionManager.getUserData()?.id ?? 0),
                "user_id" : String(SessionManager.getUserData()?.id ?? ""),
                "temp_user_id" : String(SessionManager.getUserData()?.id ?? ""),

            ]
            
            var fileDetails = [String:[Data]]()
            if lisenceData != nil {
                fileDetails["commercial_license"] = [lisenceData!]
            }else {
                fileDetails["commercial_license"] = []
            }
            if associatedlisenceData != nil {
                fileDetails["associated_license"] = [associatedlisenceData!]
            }else {
                fileDetails["associated_license"] = []
            }
            AuthenticationAPIManager.bankAndCommercialAPIV2(photos:[],documents: fileDetails, parameters: parameters) { [weak self] result in
                switch result?.status {
                case "1" :
                    Utilities.showSuccessAlert(message: result?.message ?? "") {
                        Coordinator.goToAddLocationPage(controller: self)
                    }
                default:
                    Utilities.showWarningAlert(message: result?.message ?? "")
                }
            }
            
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func lisenceAction(_ sender: Any) {
        self.fileType = "1"
        self.presentPickerOption()
    }
    @IBAction func associateAction(_ sender: Any) {
        self.fileType = "2"
        self.presentPickerOption()
    }
    
    func isValidIndividual() -> Bool {
        if txtCommercialLisence.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please upload commercial lisence".localiz()) {
                
            }
            return false
        }
        if txtCommercialRegisterNo.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter commercial registration no".localiz()) {
                
            }
            return false
        }
        if txtCommercialRegisterNo.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please upload associated lisence".localiz()) {
                
            }
            return false
        }
        if txtAccount.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter account number".localiz()) {
                
            }
            return false
        }
        if txtBank.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter bank name".localiz()) {
                
            }
            return false
        }
        if txtIbnCode.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter iban code".localiz()) {
                
            }
            return false
        }
        return true
    }
    
    func presentPickerOption() {
        let alert: UIAlertController = UIAlertController(title: "Choose Type".KSlocalized(),
                                                         message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Photos".KSlocalized(), style: UIAlertAction.Style.default) { UIAlertAction in
            self.photoChoosen()
        }
        let documentAction = UIAlertAction(title: "Document".KSlocalized(), style: UIAlertAction.Style.default) { UIAlertAction in
            self.documentChoosen()
        }
        let cancelAction = UIAlertAction(title: "cancel".KSlocalized(), style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(documentAction)
        alert.addAction(cancelAction)
        parent?.present(alert, animated: true, completion: nil)
    }
    func photoChoosen() {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: parent!, type: .photo)
        AttachmentHandler.shared.imagePickedBlock = { [weak self] (image, url) in
            let media = Media(mediaType: .photo, imageData: image)
            if self?.fileType == "1" {
                self?.lisenceData = image.pngData()
                self?.txtCommercialLisence.text = "File.png"
            }else {
                self?.txtAssociatedLicense.text = "File.png"
                self?.associatedlisenceData = image.pngData()
            }
        }
    }
    func documentChoosen() {
        AttachmentHandler.shared.documentPicker(vc: parent!)
        AttachmentHandler.shared.filePickedBlock = { [weak self] (url) in
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                if self?.fileType == "1" {
                    self?.lisenceData = data
                    self?.txtCommercialLisence.text = url.lastPathComponent
                }else {
                    self?.txtAssociatedLicense.text = url.lastPathComponent
                    self?.associatedlisenceData = data
                    
                }
                
            } catch  {
                
            }
        }
    }
}

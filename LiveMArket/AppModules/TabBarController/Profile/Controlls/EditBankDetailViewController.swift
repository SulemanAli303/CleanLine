//
//  EditBankDetailViewController.swift
//  LiveMArket
//
//  Created by Farhan on 12/08/2023.
//

import UIKit

class EditBankDetailViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak private var progressView: EditProfileProgressView!
    @IBOutlet weak private var driverProfileProgressView: EditDriverProfileProgressView!
    @IBOutlet weak private var commercialRegistrationDetailsView: UIView!
    @IBOutlet weak private var lblCommercialRegistrationNumber: UITextField!
    @IBOutlet weak private var txtCommercialLisence: UITextField!
    @IBOutlet weak private var txtAssociatedLicense: UITextField!
    @IBOutlet weak private var lblAccountNumber: UITextField!
    @IBOutlet weak private var lblBankname: UITextField!
    @IBOutlet weak private var lblIBANCode: UITextField!
    
    @IBOutlet weak var commertialTopLabel: UILabel!
    @IBOutlet weak var bankAccountLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    
    //MARK: Properties
    private var lisenceData: Data?
    private var associatedlisenceData: Data?
    private var fileType = ""
    var profileDetails: ProfileDetails?
    var userData: User?
    var commercialRegistrationDetails = false
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "Edit Bank Details".localiz()
        configLanguage()
        userData = SessionManager.getUserData()
        configureUI()
        driverProfileProgressView.selectedTab = 1
        progressView.selectedTab = 1
        if userData?.user_type_id == "6" { progressView.isHidden = true }
        else { driverProfileProgressView.isHidden = true }
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
    //MARK: Configuration Methods
    
    func configLanguage(){
        commertialTopLabel.text = "COMMERCIAL REGISTRATION DETAILS".localiz()
        txtCommercialLisence.placeholder = "UPLOAD COMMERCIAL LISENCE".localiz()
        lblCommercialRegistrationNumber.placeholder = "COMMERCIAL REGISTRATION NO".localiz()
        txtAssociatedLicense.placeholder = "Upload associated License".localiz()
        bankAccountLabel.text = "BANK ACCOUNT DETAILS".localiz()
        lblAccountNumber.placeholder = "Account No".localiz()
        lblBankname.placeholder = "Bank name".localiz()
        lblIBANCode.placeholder = "IBAN Code".localiz()
        updateButton.setTitle("Update".localiz(), for: .normal)
    }
    
    private func configureUI() {
        let userTypeId = SessionManager.getUserData()?.user_type_id ?? ""
        if userTypeId == "1" { commercialRegistrationDetails = true }
        commercialRegistrationDetailsView.isHidden = !commercialRegistrationDetails
        if commercialRegistrationDetails { lblCommercialRegistrationNumber.text = profileDetails?.commercial_reg_no }
        if let bankDetails = profileDetails?.bank_details {
            lblAccountNumber.text = bankDetails.account_no
            lblBankname.text = bankDetails.bank_name
            lblIBANCode.text = bankDetails.iban_code
        }
    }
    
    //MARK: IBActions
    @IBAction private func actionUpdateBankDetails(_ sender: UIButton) {
        commercialRegistrationDetails ? updateBankAndCompanyDetails() : updateBankDetails()
    }
    
    @IBAction private func lisenceAction(_ sender: UIButton) {
        self.fileType = "1"
        self.presentPickerOption()
    }
    @IBAction private func associateAction(_ sender: UIButton) {
        self.fileType = "2"
        self.presentPickerOption()
    }
    
    //MARK: Handle Media Upload
    private func presentPickerOption() {
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
    
    private func photoChoosen() {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: parent!, type: .photo)
        AttachmentHandler.shared.imagePickedBlock = { [weak self] (image, url) in
            guard let self else { return }
            let media = Media(mediaType: .photo, imageData: image)
            if self.fileType == "1" {
                self.lisenceData = image.pngData()
                self.txtCommercialLisence.text = "File.png"
            }else {
                self.txtAssociatedLicense.text = "File.png"
                self.associatedlisenceData = image.pngData()
            }
        }
    }
    
    private func documentChoosen() {
        AttachmentHandler.shared.documentPicker(vc: parent!)
        AttachmentHandler.shared.filePickedBlock = { [weak self] (url) in
            guard let self else { return }
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                if self.fileType == "1" {
                    self.lisenceData = data
                    self.txtCommercialLisence.text = url.lastPathComponent
                }else {
                    self.txtAssociatedLicense.text = url.lastPathComponent
                    self.associatedlisenceData = data
                }
                
            } catch  {
                
            }
        }
    }
}
//MARK: Validations
extension EditBankDetailViewController {
    func isvalidForm() -> Bool {
        if commercialRegistrationDetails {
            if lblCommercialRegistrationNumber.text?.trimmingCharacters(in: .whitespaces) == "" {
                Utilities.showWarningAlert(message: "Please enter commercial registration no".localiz()) {
                    
                }
                return false
            }
        }
        
        if lblAccountNumber.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter account number".localiz()) {
                
            }
            return false
        }
        if lblBankname.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter bank name".localiz()) {
                
            }
            return false
        }
        if lblIBANCode.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter iban code".localiz()) {
                
            }
            return false
        }
        return true
    }
    
}

//MARK: API Calls
extension EditBankDetailViewController {
    func updateBankAndCompanyDetails() {
        if isvalidForm() {
            let parameters:[String:String] = [
                "commercial_reg_no" : lblCommercialRegistrationNumber.text ?? "",
                "account_no" : lblAccountNumber.text ?? "",
                "bank_name" : lblBankname.text ?? "",
                "iban_code" : lblIBANCode.text ?? "",
                "user_id" : String(SessionManager.getUserData()?.id ?? ""),
            ]
            
            var fileDetails = [String:[Data]]()
            if lisenceData != nil {
                fileDetails["commercial_license"] = []
            }else {
                fileDetails["commercial_license"] = []
            }
            if associatedlisenceData != nil {
                fileDetails["associated_license"] = []
            }else {
                fileDetails["associated_license"] = []
            }
            
            AuthenticationAPIManager.bankAndCommercialAPI(photos:[],documents: fileDetails, parameters: parameters) { [weak self] result in
                guard let self else { return }
                switch result?.status {
                case "1" :
                    let nextVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "ProfileSubmit") as! ProfileSubmit
                    self.navigationController?.pushViewController(nextVC, animated: true)

                default:
                    Utilities.showWarningAlert(message: result?.message ?? "")
                }
            }
            
        }
    }
    
    private func updateBankDetails() {
        if isvalidForm() {
            let parameters:[String:String] = [
                "account_no" : lblAccountNumber.text ?? "",
                "bank_name" : lblBankname.text ?? "",
                "iban_code" : lblIBANCode.text ?? "",
                "user_id" : String(SessionManager.getUserData()?.id ?? "")
            ]
            
            AuthenticationAPIManager.bankAccountAPI(parameters: parameters) { [weak self] result in
                guard let self else { return }
                switch result.status {
                case "1":
                    let userTypeId = SessionManager.getUserData()?.user_type_id ?? ""
                    if userTypeId == "6" {
                        let nextVC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "EditVehicleDetailVC") as! EditVehicleDetailVC
                        nextVC.profileDetails = self.profileDetails
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }else {
                        let nextVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "ProfileSubmit") as! ProfileSubmit
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                    }
                }
            }
        }
    }
}

//
//  LMCreateAccountViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import UIKit
import DatePickerDialog
import CountryPickerView

class DMCreateAccountViewController: BaseViewController {
    let cpvInternal = CountryPickerView()
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtResidency: UITextField!
    @IBOutlet weak var txtNationality: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    var selectedImage: UIImage?
    var imagePicker: ImagePicker!
    var validImageSelected = false

    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    var flow : String?
    
    @IBOutlet weak var progressView: DRAccountProgress!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        setInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    //MARK: - Methode
    func setInterface() {
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
        progressView.selectedTab = 0
    }

    @IBAction func next(_ sender: Any) {
        if isValidIndividual() {
            var delivery = DeliveryRepresentative(userImg: self.userImg, driverName: self.txtName.text, residencyNo: self.txtResidency.text, dob: self.txtDob.text, nationality:self.txtNationality.text)
            WholeSellerAuthCoordinator.goToDRStep2(controller: self,data: delivery)
        }
       
    }
    @IBAction func dobAction(_ sender: UIButton) {
        DatePickerDialog().show("Select DOB".localiz(), doneButtonTitle: "Done".localiz(), cancelButtonTitle: "Cancel".localiz(), maximumDate: Date(), datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy" // change format as per your needs
                self.txtDob.text = formatter.string(from:dt)
            }
        }
        
    }
    
    func isValidIndividual() -> Bool {
        if txtName.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter full name".localiz()) {
                
            }
            return false
        }
        if txtResidency.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter residency no".localiz()) {
                
            }
            return false
        }
        if txtNationality.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter nationality".localiz()) {
                
            }
            return false
        }
        if txtDob.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter dob".localiz()) {
                
            }
            return false
        }
        if validImageSelected == false{
            Utilities.showWarningAlert(message: "Please Select a valid face image".localiz())
            return false
        }
//        
        return true
    }
    @IBAction func editImageAction(_ sender: Any) {
        self.imagePicker.present(from: self.view)
    }
    @IBAction func countryCodeAction(_ sender: Any) {
        cpvInternal.delegate = self
        cpvInternal.showCountriesList(from: self)
    }
}
extension DMCreateAccountViewController:ImagePickerDelegate {
    func didSelect(image: UIImage?, fileName: String, fileSize: String) {
        if(image != nil){
            self.selectedImage = image
            self.userImg.image = image
            self.validImageSelected = true
        }
    }
}
extension DMCreateAccountViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.txtNationality.text = country.name ?? ""

    }
}

//
//  AddNewAddressVC.swift
//  LiveMArket
//
//  Created by Apple on 14/02/2023.
//

import UIKit
import CountryPickerView
import CoreLocation

class AddNewAddressVC: BaseViewController {
    
    let cpvInternal = CountryPickerView()
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var building: UITextField!
    @IBOutlet weak var streetAdd: UITextField!
    @IBOutlet weak var streetLandmark: UITextField!
    @IBOutlet weak var streetBuildingName: UITextField!
    @IBOutlet weak var postcode: UITextField!
    @IBOutlet weak var tickImg: UIButton!
    @IBOutlet weak var setAsDefaultLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var isDefault = false
    var isUpdateAdd = false
    var selectedAddress : List?
    var lat = ""
    var log = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .backWithTop
        configLanguage()
        if isUpdateAdd == true {
            viewControllerTitle = "Edit Address".localiz()
            self.setdata()
        }else {
            print(SessionManager.getAccessToken() ?? "")
            self.txtName.text = SessionManager.getUserData()?.name ?? ""
            self.mobile.text = SessionManager.getUserData()?.phone_number ?? ""
            self.codeLbl.text = "+\(SessionManager.getUserData()?.dial_code ?? "")"
            viewControllerTitle = "Add New Address".localiz()
        }
    }
    func configLanguage(){
        txtName.placeholder = "Name".localiz()
        mobile.placeholder = "MOBILE NUMBER".localiz()
        building.placeholder = "Building Name".localiz()
        streetBuildingName.placeholder = "Flat No".localiz()
        streetAdd.placeholder = "Location On Map".localiz()
        streetLandmark.placeholder = "Landmark".localiz()
        postcode.placeholder = "Post code".localiz()
        setAsDefaultLabel.text = "Set as default address".localiz()
        saveButton.setTitle("Save Address".localiz(), for: .normal)
    }
    func setdata() {
        txtName.text = selectedAddress?.fullName ?? ""
        codeLbl.text = "+\(selectedAddress?.dialCode ?? "")"
        mobile.text = "\(selectedAddress?.phone ?? "")"
        building.text = "\(selectedAddress?.buildingName ?? "")"
        streetAdd.text = "\(selectedAddress?.address ?? "")"
        streetLandmark.text = "\(selectedAddress?.landMark ?? "")"
        postcode.text = "\(selectedAddress?.postcode ?? "")"
        streetBuildingName.text = "\(selectedAddress?.flatNo ?? "")"
        self.lat = "\(selectedAddress?.latitude ?? "")"
        self.log = "\(selectedAddress?.longitude ?? "")"
        
        isDefault = (selectedAddress?.isDefault ?? "" == "1" ? true : false)
        if(isDefault){
            tickImg.setImage(UIImage(named: "checked"), for: .normal)
        }else {
            tickImg.setImage(UIImage(named: "icn_uncheck"), for: .normal)
        }
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
    @IBAction func countryCodeAction(_ sender: Any) {
        cpvInternal.delegate = self
        cpvInternal.showCountriesList(from: self)
    }
    @IBAction func acceptedAction(_ sender: UIButton) {
        isDefault = !isDefault
        if(isDefault){
            tickImg.setImage(UIImage(named: "checked"), for: .normal)
        }else {
            tickImg.setImage(UIImage(named: "icn_uncheck"), for: .normal)
        }
        
    }
    @IBAction func saveAdd(_ sender: UIButton) {
        if isValidForm() {
            if isUpdateAdd {
                self.EditAdressAPI()
            }else {
                self.AddAdressAPI()
            }
        }
    }
    @IBAction func addLocation(_ sender: UIButton) {
        
        let placePickerVC = UIStoryboard(name: "PlacePicker", bundle: nil).instantiateViewController(withIdentifier: "ODAddressPickerViewController") as! ODAddressPickerViewController

        placePickerVC.delegate = self
        if isUpdateAdd == true {
            placePickerVC.isEditAddress = true
            placePickerVC.editLat = lat
            placePickerVC.editLong = log
            placePickerVC.editAddressTitle = "\(selectedAddress?.address ?? "")"
        }
        placePickerVC.titleString = "Select Location".localiz()
        let navVC = UINavigationController.init(rootViewController: placePickerVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
        
    }
    func isValidForm() -> Bool {
        if txtName.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter full name".localiz()) {
                
            }
            return false
        }
        if codeLbl.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please choose country code".localiz()) {
                
            }
            return false
        }
        if mobile.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter mobile number".localiz()) {
                
            }
            return false
        }
        if building.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter building name".localiz()) {
                
            }
            return false
        }
        if streetAdd.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter street address".localiz()) {
                
            }
            return false
        }
        if streetBuildingName.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter flat no".localiz()) {
                
            }
            return false
        }
        
//        if postcode.text?.trimmingCharacters(in: .whitespaces) == "" {
//            Utilities.showWarningAlert(message: "Please enter post code") {
//                
//            }
//            return false
//        }
        
        return true
    }
    
}
extension AddNewAddressVC:UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 12
    }
}
extension AddNewAddressVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.codeLbl.text = country.phoneCode
    }
}

extension AddNewAddressVC {
    func AddAdressAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "full_name" : txtName.text ?? "",
            "dial_code" : (codeLbl.text ?? "").replacingOccurrences(of: "+", with: ""),
            "phone" : mobile.text ?? "",
            "flat_no" : streetBuildingName.text ?? "",
            "building_name" : building.text ?? "",
            "address" : streetAdd.text ?? "",
            "is_default" : (self.isDefault == true ? "1" : "0"),
            "postcode" : self.postcode.text ?? "",
            "latitude" : lat,
            "longitude" : log,
            "land_mark" : self.streetLandmark.text ?? ""
        ]
        AddressAPIManager.addAddressAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func EditAdressAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "full_name" : txtName.text ?? "",
            "dial_code" : (codeLbl.text ?? "").replacingOccurrences(of: "+", with: ""),
            "phone" : mobile.text ?? "",
            "flat_no" : streetBuildingName.text ?? "",
            "building_name" : building.text ?? "",
            "address" : streetAdd.text ?? "",
            "is_default" : (self.isDefault == true ? "1" : "0"),
            "postcode" : self.postcode.text ?? "",
            "address_id" : String(selectedAddress?.id ?? ""),
            "latitude" : lat,
            "longitude" : log,
            "land_mark" : self.streetLandmark.text ?? ""
        ]
        AddressAPIManager.editAddressAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension AddNewAddressVC: PlacePickerDelegate {
    func placePicked(coordinate: CLLocationCoordinate2D, address: String) {
        self.streetAdd.text = address
        self.lat = String(coordinate.latitude)
        self.log = String(coordinate.longitude)
    }
}

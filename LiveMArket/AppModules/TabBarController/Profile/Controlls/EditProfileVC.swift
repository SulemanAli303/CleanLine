//
//  EditProfileVC.swift
//  LiveMArket
//
//  Created by Apple on 13/02/2023.
//

import UIKit
import CountryPickerView
import GoogleMaps

final class EditProfileVC: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak private var progressView: EditProfileProgressView!
    @IBOutlet weak private var lblCountryCode: UILabel!
    @IBOutlet weak private var lblLocation: UILabel!
    @IBOutlet weak private var fullNameTF: UITextField!
    @IBOutlet weak private var emailTF: UITextField!
    @IBOutlet weak private var phoneNumberTF: UITextField!
    @IBOutlet weak private var profileImageView: UIImageView!
    @IBOutlet weak private var profileBg: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    
    //MARK: Properties
    private let cpvInternal = CountryPickerView()
    private var imagePicker: ImagePicker!
    private var imgType = ""
    private var locationCoordinates: CLLocationCoordinate2D?
    private var userData: User?
    private var updateProfileImage = false
    private var updateBannerImage = false
    
    //MARK: Property Observers
    var profileData:ProfileData? {
        didSet {
            self.imgType = ""
            if let data = profileData?.data { profileDetails = data }
        }
    }
    
    var profileDetails: ProfileDetails? { didSet { updateUI() } }

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "Edit Profile".localiz()
        configLanguage()
        userData = SessionManager.getUserData()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        userData?.user_type_id == "6" ? driverProfileAPI() : commonProfileAPI()
        progressView.isHidden = userData?.user_type_id == "6"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    func configLanguage(){
        fullNameLabel.text = "Full Name".localiz()
        emailLabel.text = "Email Address".localiz()
        mobileLabel.text = "Mobile Number".localiz()
        addressLabel.text = "ADDRESS".localiz()
        updateButton.setTitle("Update".localiz(), for: .normal)
    }
    @objc func setupNotificationObserver(){
        if userData?.user_type_id == "6"{
            self.driverProfileAPI()
        } else {
            self.commonProfileAPI()
        }
    }
    
    //MARK: Custom Methods
    private func updateUI() {
        fullNameTF.text = profileDetails?.name ?? ""
        emailTF.text = profileDetails?.email ?? ""
        phoneNumberTF.text = profileDetails?.phone ?? ""
        if let dialCode = profileDetails?.dial_code { lblCountryCode.text = "+\(dialCode)"}
        lblLocation.text = profileDetails?.location_data?.location_name ?? ""
        
        profileBg.sd_setImage(with: URL(string: profileDetails?.banner_image ?? ""), placeholderImage: UIImage(named: "placeholder_banner"))
        profileImageView.sd_setImage(with: URL(string: profileDetails?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
    }
    
    //MARK: IBActions
    @IBAction private func actionCountryCode(_ sender: UIButton) {
        cpvInternal.delegate = self
        cpvInternal.showCountriesList(from: self)
    }

    @IBAction private func updateProfileImage(_ sender: UIButton) {
        if profileDetails?.user_type_id == UserAccountType.ACCOUNT_TYPE_DELIVERY_REPRESENTATIVE.rawValue {
            if profileDetails?.allow_profile_pic_upload == "1" {
                imgType = "1"
                self.imagePicker.present(from: self.view)
            } else {
                showRequestAlert()
            }
        } else {
            imgType = "1"
            self.imagePicker.present(from: self.view)
        }

    }
    
    @IBAction private func updateProfileBanner(_ sender: UIButton) {
        imgType = "2"
        imagePicker.present(from: self.view)
    }
    
    @IBAction private func actionSelectLocation(_ sender: UIButton) {
        //Utilities.presentPlacePicker(vc: self)
        let placePickerVC = UIStoryboard(name: "PlacePicker", bundle: nil).instantiateViewController(withIdentifier: "ODAddressPickerViewController") as! ODAddressPickerViewController

        placePickerVC.delegate = self
        placePickerVC.titleString = "Select Location".localiz()
        placePickerVC.isShowCountryOption = true
        let navVC = UINavigationController.init(rootViewController: placePickerVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction private func actionEditFullName(_ sender: UIButton) { fullNameTF.becomeFirstResponder() }
    
    @IBAction private func actionUpdateMobileNumber(_ sender: UIButton) { phoneNumberTF.becomeFirstResponder() }
    
    @IBAction private func actionUpdateProfile(_ sender: UIButton) {
        if isValidForm() {
            if updateProfileImage { updateProfileImg() }
            if updateBannerImage { updateBannerImg() }
            if locationCoordinates != nil { updateLocation() }
            updateUserProfile()
        }
//        let nextVC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "EditBankDetailViewController") as! EditBankDetailViewController
//        nextVC.profileDetails = profileDetails
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    func showRequestAlert() {
        let vc = UIAlertController(title: "Request to Change Profile Image?".localiz(), message: "", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Yes".localiz(), style: .default){ ac in
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? ""
            ]
            AuthenticationAPIManager.profilePicChangeRequest(parameters: parameters) { response in
                Utilities.showWarningAlert(message: response.message ?? "") {

                }
            }
        })

        vc.addAction(UIAlertAction(title: "No".localiz(), style: .cancel){ ac in

        })

        self.present(vc,animated: true)
    }
}

//MARK: Country Picker View Delegate Methods
extension EditProfileVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.lblCountryCode.text = country.phoneCode
    }
}

//MARK: Image Picker Delegate
extension EditProfileVC: ImagePickerDelegate {
    func didSelect(image: UIImage?, fileName: String, fileSize: String) {
        if(image != nil) {
            if imgType == "1" {
                profileImageView.image = image
                self.updateProfileImage = true
//                self.updateProfileImg()
            } else if imgType == "2" {
                profileBg.image = image
                self.updateBannerImage = true
            }
        }
    }
}

//MARK: PlacePickerDelegate
extension EditProfileVC: PlacePickerDelegate {
    func placePicked(coordinate: CLLocationCoordinate2D, address: String) {
        self.lblLocation.text = address
        self.locationCoordinates = coordinate
    }
}

//MARK: API Calls
extension EditProfileVC {
    private func updateBannerImg() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        let userFile:[String:[UIImage?]] = ["image" :[self.profileBg.image]]
        AuthenticationAPIManager.updateBannerAPI(images:userFile, parameters: parameters) { response in
            switch response.status {
            case "1":
                return
            default :
                Utilities.showWarningAlert(message: response.message ?? "") {
                    
                }
            }
        }
    }
    
    private func updateProfileImg() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        let userFile:[String:[UIImage?]] = ["image" :[self.profileImageView.image]]
        AuthenticationAPIManager.updateProfileImgAPI(images:userFile, parameters: parameters) { response in
            switch response.status {
            case "1":
                return
            default :
                Utilities.showWarningAlert(message: response.message ?? "") {
                    
                }
            }
        }
    }
    
    private func driverProfileAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.driverProfileAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.profileData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    private func commonProfileAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.userProfileAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.profileData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    private func updateUserProfile() {
        let dialCode = lblCountryCode.text ?? ""
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "name" : fullNameTF.text ?? "",
            "dial_code" : dialCode.replacingOccurrences(of: "+", with: ""),
            "phone" : phoneNumberTF.text ?? ""
        ]
        
        var userImage = UIImage(named: "placeholder_banner")!
        var bannerImage = UIImage(named: "placeholder_banner")!
        
        if let profileImage = profileImage.image { userImage = profileImage }
        if let profileBGimage = profileBg.image { bannerImage = profileBGimage }
        
        AuthenticationAPIManager.updateProfileAPI(image: [userImage], firstImage: [bannerImage], parameters: parameters) { response in
            switch response.status {
            case "1":
                let nextVC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "EditBankDetailViewController") as! EditBankDetailViewController
                nextVC.profileDetails = self.profileDetails
                self.navigationController?.pushViewController(nextVC, animated: true)
            default :
                Utilities.showWarningAlert(message: response.message ?? "") {
                    
                }
            }
        }
    }
    
    private func updateLocation() {
        if locationCoordinates == nil { return }
        else {
            let parameters:[String:String] = [
                "lattitude" : String(locationCoordinates?.latitude ?? 0.0),
                "longitude" : String(locationCoordinates?.longitude ?? 0.0),
                "location_name" : self.lblLocation.text ?? "",
                "user_id" : String(SessionManager.getUserData()?.id ?? "")
            ]
            AuthenticationAPIManager.addLocationAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    return
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }

    
    func isValidForm() -> Bool {
        if fullNameTF.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter full name".localiz()) {
                
            }
            return false
        }
        if lblCountryCode.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please choose country code".localiz()) {
                
            }
            return false
        }
        if phoneNumberTF.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please enter mobile number".localiz()) {
                
            }
            return false
        }
        
        return true
    }
}

//
//  EditVehicleDetailVC.swift
//  LiveMArket
//
//  Created by Farhan on 14/08/2023.
//

import UIKit
import SDWebImage

class EditVehicleDetailVC: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak private var progressView: EditDriverProfileProgressView!
    @IBOutlet weak private var frontImg: UIImageView!
    @IBOutlet weak private var backImg: UIImageView!
    @IBOutlet weak private var drivingImg: UIImageView!
    @IBOutlet weak private var vehicleRegImg: UIImageView!
    
    @IBOutlet weak private var pickupView: UIView!
    @IBOutlet weak private var NormalView: UIView!
    @IBOutlet weak private var BigTruckView: UIView!
    @IBOutlet weak private var MediumTruckView: UIView!
    @IBOutlet weak private var BikeView: UIView!

    @IBOutlet weak private var bikesLbl: UILabel!
    @IBOutlet weak private var pickupLbl: UILabel!
    @IBOutlet weak private var normalupLbl: UILabel!
    @IBOutlet weak private var bigTruckLbl: UILabel!
    @IBOutlet weak private var medimTruckLbl: UILabel!
    
    
    @IBOutlet weak private var bikeIcon: UIImageView!
    @IBOutlet weak private var pickupIcon: UIImageView!
    @IBOutlet weak private var normalIcon: UIImageView!
    @IBOutlet weak private var bigTruckIcon: UIImageView!
    @IBOutlet weak private var medimTruckIcon: UIImageView!
    
    @IBOutlet weak var vehicleDetailsLabel: UILabel!
    @IBOutlet weak var frontPicLabel: UILabel!
    @IBOutlet weak var backPicLabel: UILabel!
    @IBOutlet weak var vehregLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var vehTypeLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    //MARK: Properties
    private var frontImage: UIImage?
    private var backImage: UIImage?
    private var drivingImage: UIImage?
    private var vehicleRegImage: UIImage?
    private var imagePicker: ImagePicker!
    
    private var selectedType = 0
    private var selectedVehicleType = 0
    
    var profileDetails: ProfileDetails?
    var isFromEditbusiness = false

    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        configLanguage()
        viewControllerTitle = "Edit Vehicle Details".localiz()
        if isFromEditbusiness {
            viewControllerTitle = "Become Delivery Representative".localiz()
            progressView.isHidden = true
        }
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        configureUI()
        progressView.selectedTab = 2
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
        vehicleDetailsLabel.text = "VEHICLE DETAILS".localiz()
        frontPicLabel.text = "Front picture of the car".localiz()
        backPicLabel.text = "Car picture from the back".localiz()
        vehregLabel.text = "Vehicle Registration".localiz()
        licenseLabel.text = "Driving License".localiz()
        vehTypeLabel.text = "VEHICLE TYPE".localiz()
        bikesLbl.text = "MOTORCYCLE".localiz()
        pickupLbl.text = "Pick Up".localiz()
        normalupLbl.text = "Normal".localiz()
        medimTruckLbl.text = "Medium Truck".localiz()
        bigTruckLbl.text = "Big Truck".localiz()
        updateButton.setTitle("".localiz(), for: .normal)
    }
    
    //MARK: IBActions
    @IBAction private func actionUpdate(_ sender: UIButton) { if isFormValid() { updateVehicleDetails() } }
    
    @IBAction func btnFront(_ sender: Any) {
        self.selectedType = 1
        self.imagePicker.present(from: self.view)
    }
    @IBAction func btnback(_ sender: Any) {
        self.selectedType = 2
        self.imagePicker.present(from: self.view)
    }
    @IBAction func btnDriving(_ sender: Any) {
        self.selectedType = 3
        self.imagePicker.present(from: self.view)
    }
    @IBAction func btnReg(_ sender: Any) {
        self.selectedType = 4
        self.imagePicker.present(from: self.view)
    }
    
    @IBAction func bikePressed(_ sender: UIButton) {
        selectedVehicleType = 5
        resetNow()
        bikesLbl.textColor = .white
        BikeView.backgroundColor = Color.theme.color()
        bikeIcon.image = UIImage(named: "select_bike_active")
    }
    @IBAction func pickupPressed(_ sender: UIButton) {
        selectedVehicleType = 6
        resetNow()
        pickupLbl.textColor = .white
        pickupView.backgroundColor = Color.theme.color()
        pickupIcon.image = UIImage(named: "select_pickUp_active")
    }
    @IBAction func normalPressed(_ sender: UIButton) {
        selectedVehicleType = 4
        resetNow()
        normalupLbl.textColor = .white
        NormalView.backgroundColor = Color.theme.color()
        normalIcon.image = UIImage(named: "select_normal_active")
    }
    @IBAction func bigTruckPressed(_ sender: UIButton) {
        selectedVehicleType = 3
        resetNow()
        bigTruckLbl.textColor = .white
        BigTruckView.backgroundColor = Color.theme.color()
        bigTruckIcon.image = UIImage(named: "select_big_truck")
    }
    @IBAction func MediumTruckPressed(_ sender: UIButton) {
        selectedVehicleType = 1
        resetNow()
        medimTruckLbl.textColor = .white
        MediumTruckView.backgroundColor = Color.theme.color()
        medimTruckIcon.image = UIImage(named: "select_medium_active")
    }
    
    func resetNow() {
        pickupView.backgroundColor = .white
        BikeView.backgroundColor = .white
        NormalView.backgroundColor = .white
        BigTruckView.backgroundColor = .white
        MediumTruckView.backgroundColor = .white
        
        bikesLbl.textColor = Color.darkGray.color()
        pickupLbl.textColor = Color.darkGray.color()
        bigTruckLbl.textColor = Color.darkGray.color()
        normalupLbl.textColor = Color.darkGray.color()
        medimTruckLbl.textColor = Color.darkGray.color()
        
        bikeIcon.image = UIImage(named: "Group 236184")
        pickupIcon.image = UIImage(named: "noun-pickup-4270958")
        normalIcon.image = UIImage(named: "noun-car-4270950")
        bigTruckIcon.image = UIImage(named: "Group 236180")
        medimTruckIcon.image = UIImage(named: "Group 236182")
    }
    
    private func configureUI() {
        if let selectedVehicleType = profileDetails?.vehicle_data?.vehicle_type {
            if let vehicleType = Int(selectedVehicleType) { self.selectedVehicleType = vehicleType }
            switch selectedVehicleType {
            case "1":
                resetNow()
                medimTruckLbl.textColor = .white
                MediumTruckView.backgroundColor = Color.theme.color()
                medimTruckIcon.image = UIImage(named: "select_medium_active")
            case "3":
                resetNow()
                bigTruckLbl.textColor = .white
                BigTruckView.backgroundColor = Color.theme.color()
                bigTruckIcon.image = UIImage(named: "select_big_truck")
            case "4":
                resetNow()
                normalupLbl.textColor = .white
                NormalView.backgroundColor = Color.theme.color()
                normalIcon.image = UIImage(named: "select_normal_active")
            case "5":
                resetNow()
                bikesLbl.textColor = .white
                BikeView.backgroundColor = Color.theme.color()
                bikeIcon.image = UIImage(named: "select_bike_active")
            case "6":
                resetNow()
                pickupLbl.textColor = .white
                pickupView.backgroundColor = Color.theme.color()
                pickupIcon.image = UIImage(named: "select_pickUp_active")
            default: resetNow()
            }
        }
        if !isFromEditbusiness {
            frontImg.sd_setImage(with: URL(string: profileDetails?.vehicle_data?.vehicle_front ?? ""), placeholderImage: UIImage(named: "App-placeholder_profile"),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                if error == nil {
                    self.frontImage = self.frontImg.image
                }
            })
            backImg.sd_setImage(with: URL(string: profileDetails?.vehicle_data?.vehicle_back ?? ""), placeholderImage: UIImage(named: "App-placeholder_profile"),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                if error == nil {
                    self.backImage = self.backImg.image
                }
            })
            drivingImg.sd_setImage(with: URL(string: profileDetails?.vehicle_data?.driving_license ?? ""), placeholderImage: UIImage(named: "App-placeholder_profile"),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                if error == nil {
                    self.drivingImage = self.drivingImg.image
                }
            })
            vehicleRegImg.sd_setImage(with: URL(string: profileDetails?.vehicle_data?.vehicle_registration ?? ""), placeholderImage: UIImage(named: "App-placeholder_profile"),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                if error == nil {
                    self.vehicleRegImage = self.vehicleRegImg.image
                }
            })
            
            
        }
    }
}

//MARK: Validation
extension EditVehicleDetailVC {
    func isFormValid() -> Bool {
        if self.frontImage == nil {
            Utilities.showWarningAlert(message: "Please select front picture of the car".localiz()) {
                
            }
            return false
        }
        if self.backImage == nil {
            Utilities.showWarningAlert(message: "Please select back picture of the car".localiz()) {
                
            }
            return false
        }
        if self.drivingImage == nil {
            Utilities.showWarningAlert(message: "Please select driving license".localiz()) {
                
            }
            return false
        }
        if self.vehicleRegImage == nil {
            Utilities.showWarningAlert(message: "Please select vehicle register".localiz()) {
                
            }
            return false
        }
        if selectedVehicleType == 0 {
            Utilities.showWarningAlert(message: "Please select vehicle type".localiz()) {
                
            }
            return false
        }
        
        return true
    }

}

//MARK: ImagePickerDelegate
extension EditVehicleDetailVC: ImagePickerDelegate {
    func didSelect(image: UIImage?, fileName: String, fileSize: String) {
        if(image != nil){
            if selectedType == 1 {
                self.frontImage = image
                self.frontImg.image = image
            }else if selectedType == 2 {
                self.backImage = image
                self.backImg.image = image
            }else if selectedType == 3 {
                self.drivingImage = image
                self.drivingImg.image = image
            }else if selectedType == 4 {
                self.vehicleRegImage = image
                self.vehicleRegImg.image = image
            }
        }
    }
}

extension EditVehicleDetailVC {
    private func updateVehicleDetails() {
        var parameters:[String:String] = [
            "vehicle_type" : String(selectedVehicleType),
            "user_id" : String(SessionManager.getUserData()?.id ?? "")
        ]
        if isFromEditbusiness{
            parameters["upgrade_to_driver"] = "1"
         }
        let userFile:[String:[UIImage?]] = ["vehicle_front" :[self.frontImg.image] ,
                                            "vehicle_back" : [self.backImg.image],
                                            "vehicle_registration" : [self.vehicleRegImg.image],
                                            "driving_license" : [self.drivingImg.image]]
        
        AuthenticationAPIManager.VehicleDeliveryAPI(images:userFile, parameters: parameters) { response in
            switch response.status {
            case "1":
                self.driverProfileAPI()
            default :
                Utilities.showWarningAlert(message: response.message ?? "") {
                    
                }
            }
        }

    }
    
    func driverProfileAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        
        StoreAPIManager.driverProfileAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                let nextVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: "ProfileSubmit") as! ProfileSubmit
                self.navigationController?.pushViewController(nextVC, animated: true)
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

//
//  DAAccountStep3ViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 25/01/2023.
//

import UIKit

class DAAccountStep3ViewController: BaseViewController {
    
    @IBOutlet weak var frontImg: UIImageView!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var drivingImg: UIImageView!
    @IBOutlet weak var vehicleRegImg: UIImageView!
    
    var frontImage: UIImage?
    var backImage: UIImage?
    var drivingImage: UIImage?
    var vehicleRegImage: UIImage?
    var imagePicker: ImagePicker!
    
    
    var selectedType = 0
    var selectedVehicleType = 0

    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: DRAccountProgress!
    
    @IBOutlet weak var pickupView: UIView!
    @IBOutlet weak var NormalView: UIView!
    @IBOutlet weak var BigTruckView: UIView!
    @IBOutlet weak var MediumTruckView: UIView!
    @IBOutlet weak var BikeView: UIView!

    @IBOutlet weak var bikesLbl: UILabel!
    @IBOutlet weak var pickupLbl: UILabel!
    @IBOutlet weak var normalupLbl: UILabel!
    @IBOutlet weak var bigTruckLbl: UILabel!
    @IBOutlet weak var medimTruckLbl: UILabel!
    
    
    @IBOutlet weak var bikeIcon: UIImageView!
    @IBOutlet weak var pickupIcon: UIImageView!
    @IBOutlet weak var normalIcon: UIImageView!
    @IBOutlet weak var bigTruckIcon: UIImageView!
    @IBOutlet weak var medimTruckIcon: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        setInterface()
    }
    //MARK: - Methode
    func setInterface() {
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
        progressView.selectedTab = 2
    }
    @IBAction func next(_ sender: Any) {
        if isValidIndividual() {
            callIndividual()
        }
        
        
    }
    func callIndividual() {
        let parameters:[String:String] = [
            "vehicle_type" : String(selectedVehicleType),
           // "user_id" : String(SessionManager.getUserData()?.id ?? 0)
            "user_id" : String(SessionManager.getUserData()?.id ?? ""),
            "temp_user_id" : String(SessionManager.getUserData()?.id ?? ""),
        ]
        let userFile:[String:[UIImage?]] = ["vehicle_front" :[self.frontImg.image] , "vehicle_back" : [self.backImg.image],"vehicle_registration" : [self.vehicleRegImg.image],"driving_license" : [self.drivingImg.image]]
        AuthenticationAPIManager.VehicleDeliveryAPIV2(images:userFile, parameters: parameters) { response in
            switch response.status {
            case "1":
                WholeSellerAuthCoordinator.goToDRStep4(controller: self)
            default :
                Utilities.showWarningAlert(message: response.message ?? "") {
                    
                }
            }
        }
    }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        WholeSellerAuthCoordinator.goToDRStep4(controller: self)
    }
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
    
    func isValidIndividual() -> Bool {
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
extension DAAccountStep3ViewController:ImagePickerDelegate {
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

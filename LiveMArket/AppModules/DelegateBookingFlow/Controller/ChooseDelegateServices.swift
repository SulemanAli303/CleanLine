//
//  ChooseDelegateServices.swift
//  LiveMArket
//
//  Created by Zain on 26/08/2023.
//

import UIKit
import CoreLocation

class ChooseDelegateServices: BaseViewController {
    
    @IBOutlet weak var topCollection: IntrinsicCollectionView!
    @IBOutlet weak var pickTxt: UITextField!
    @IBOutlet weak var dropTxt: UITextField!
    var isSelected = -1
    var selectedType = 0
    var pickLat = ""
    var pickLng = ""
    var dropLat = ""
    var dropLng = ""
    var pickupCoorinate : CLLocation? = nil
    var dropCoorinate : CLLocation? = nil
    
    var delegetServices : [DelegateServicesList]? {
        didSet {
            self.setProductCell()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "Choose Delegate Services".localiz()
        self.getDelegateAPI()
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
    func setProductCell() {
        topCollection.delegate = self
        topCollection.dataSource = self
        topCollection.register(UINib.init(nibName: "DelegateServicesCell", bundle: nil), forCellWithReuseIdentifier: "DelegateServicesCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.topCollection.collectionViewLayout = layout
        self.topCollection.reloadData()
        self.topCollection.layoutIfNeeded()
    }
    @IBAction func setLocNow(_ sender: UIButton) {
        self.selectedType = 0
        let VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "ServicesLocation") as! ServicesLocation
        VC.delegate = self as? ChooseDelegateServices
        if self.pickupCoorinate != nil{
            VC.pickupCoorinate = self.pickupCoorinate
            VC.dropCoorinate = nil
        }else{
            VC.pickupCoorinate = nil
            VC.dropCoorinate = nil
        }
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func setLocDrop(_ sender: UIButton) {
        self.selectedType = 1
        let VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "ServicesLocation") as! ServicesLocation
        VC.delegate = self as? ChooseDelegateServices
        if self.dropCoorinate != nil {
            VC.pickupCoorinate = nil
            VC.dropCoorinate = self.dropCoorinate
        }else{
            VC.pickupCoorinate = nil
            VC.dropCoorinate = nil
        }
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func conTinue(_ sender: UIButton) {
        if isValidForm() {
            Coordinator.goToAddDelegateServices(controller: self,deligate_service_id: self.delegetServices?[self.isSelected].id ?? "",pickup_location: self.pickTxt.text ?? "", pickup_lattitude: self.pickLat,pickup_longitude: self.pickLng,dropoff_location: self.dropTxt.text ?? "",dropoff_lattitude: self.dropLat,dropoff_longitude: self.dropLng)
//            getBalance()
        }
    }
    func createGradientColor(colors : [UIColor]) -> UIColor {
        // Customize your gradient color here
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIColor(patternImage: gradientImage!)
    }
}
extension ChooseDelegateServices {
    func getBalance() {
//        let parameters:[String:String] = [
//            "access_token" : SessionManager.getAccessToken() ?? ""
//        ]
//        AuthenticationAPIManager.getWalletAPI(parameters: parameters) { result in
//            switch result.status {
//            case "1":
//                var balance = Double("\(result.oData.balance)")
//                if balance ?? 0 < 100 {
//                    Utilities.showQuestionAlert(message: "Wallet amount is less than SAR 100. Please recharge your wallet?"){
//                        Coordinator.gotoRecharge(controller: self)
//                    }
//                }else{
// Coordinator.goToAddDelegateServices(controller: self,deligate_service_id: self.delegetServices?[self.isSelected].id ?? "",pickup_location: self.pickTxt.text ?? "", pickup_lattitude: self.pickLat,pickup_longitude: self.pickLng,dropoff_location: self.dropTxt.text ?? "",dropoff_lattitude: self.dropLat,dropoff_longitude: self.dropLng)
//                }
//            default:
//                Utilities.showWarningAlert(message: result.message ) {
//                    
//                }
//            }
//        }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AuthenticationAPIManager.getWalletAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                var balance = Double("\(result.oData.balance)")
                if balance ?? 0 < 100 {
                    Utilities.showQuestionAlert(message: "Wallet amount is less than SAR 100. Please recharge your wallet?".localiz()){
                        Coordinator.gotoRecharge(controller: self)
                    }
                }else{
                    Coordinator.goToAddDelegateServices(controller: self,deligate_service_id: self.delegetServices?[self.isSelected].id ?? "",pickup_location: self.pickTxt.text ?? "", pickup_lattitude: self.pickLat,pickup_longitude: self.pickLng,dropoff_location: self.dropTxt.text ?? "",dropoff_lattitude: self.dropLat,dropoff_longitude: self.dropLng)
                }
            default:
                Utilities.showWarningAlert(message: result.message ) {
                    
                }
            }
        }
    }
}

extension ChooseDelegateServices {
    func getDelegateAPI() {
        let parameters:[String:String] = [
            "": ""
        ]
        DelegateServiceAPIManager.getServicesListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegetServices = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension ChooseDelegateServices: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegetServices?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DelegateServicesCell", for: indexPath) as? DelegateServicesCell else
        { return UICollectionViewCell()
        }
        cell.profileNameLabel.text = delegetServices?[indexPath.row].serviceName ?? ""
        if self.isSelected == indexPath.row {
            cell.profileNameLabel.textColor = UIColor(hex: "FFFFFF")
//            var gradientLabel = UIImage()
//            gradientLabel = UIImage.verticalGradientImageWithBounds(bounds: self.skipLable.bounds, colors: [UIColor(hexString: "1442E4").cgColor, UIColor(hexString: "D573C9").cgColor,UIColor(hexString: "FF7DC3").cgColor])
//            UIColor.init(patternImage: gradientLabel)
            
            let gradientColor = createGradientColor(colors: [UIColor(hexString: "9A8ED4"), UIColor(hexString: "8EB2D4"),UIColor(hexString: "F1B8A0"),UIColor(hexString: "8ED4BA")])
            
            cell.bgView.backgroundColor =  UIColor(hex: "8EB2D4")
            cell.img.sd_setImage(with: URL(string: delegetServices?[indexPath.row].processedImageURL ?? "")){ image, error, cache, url in
                if error == nil {
                    cell.img.image = image
                    let tintColor = UIColor(hex: "FFFFFF")
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    cell.img.tintColor = tintColor
                    cell.img.image = tintedImage
                }else {
                    cell.img.image = UIImage(named: "placeholder_profile")
                }
            }
            
        }else {
            cell.profileNameLabel.textColor = UIColor(hex: "8EB2D4")
            cell.bgView.backgroundColor = UIColor(hex: "FFFFFF")
            
            cell.img.sd_setImage(with: URL(string: delegetServices?[indexPath.row].processedImageURL ?? "")){ image, error, cache, url in
                if error == nil {
                    cell.img.image = image
                    let tintColor = UIColor(hex: "F6B400")
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    cell.img.tintColor = tintColor
                    cell.img.image = tintedImage
                }else {
                    cell.img.image = UIImage(named: "placeholder_profile")
                }
            }
            
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width - 20
        return CGSize(width: (screenWidth/3.2), height:160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isSelected = indexPath.row
        self.topCollection.reloadData()
        self.topCollection.layoutIfNeeded()
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension ChooseDelegateServices: ServicesLocationDelegate {
    func placePicked(coordinate: CLLocationCoordinate2D, address: String) {
        if self.selectedType == 0 {
            self.pickTxt.text = address
            let center = CLLocation (latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.pickupCoorinate = center
            self.pickLat = String(center.coordinate.latitude)
            self.pickLng = String(center.coordinate.longitude)
        }else {
            self.dropTxt.text = address
            let center = CLLocation (latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.dropCoorinate = center
            self.dropLat = String(center.coordinate.latitude)
            self.dropLng = String(center.coordinate.longitude)
        }
    }
}
extension ChooseDelegateServices {
    func isValidForm() -> Bool {
        if self.isSelected == -1 {
            Utilities.showWarningAlert(message: "Please select delegate service".localiz()) {
                
            }
            return false
        }
        if pickTxt.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please select pick location".localiz()) {
                
            }
            return false
        }
        if dropTxt.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please select drop location".localiz()) {
                
            }
            return false
        }
        
        let coordinate₀ = CLLocation(latitude: Double("\(self.pickLat)") ?? 0.0, longitude: Double("\(self.pickLng)") ?? 0.0)
        let coordinate₁ = CLLocation(latitude: Double("\(self.dropLat)") ?? 0.0, longitude: Double("\(self.dropLng)") ?? 0.0)

        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        
//        if(distanceInMeters <= 50)
//         {
//         // under 1 mile
//            Utilities.showWarningAlert(message: "Pick up and Delivery locations should not be same") {
//                
//            }
//            return false
//         }
//         else
//        {
         // out of 1 mile
             
//         }
//        if pickTxt.text == dropTxt.text || self.pickLat == self.dropLat {
//            Utilities.showWarningAlert(message: "Pick up and Delivery locations should not be same") {
//                
//            }
//            return false
//        }
        return true
    }
}

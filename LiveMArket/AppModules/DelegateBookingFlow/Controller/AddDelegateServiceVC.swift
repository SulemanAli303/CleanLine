//
//  AddServiceVC.swift
//  LiveMArket
//
//  Created by Zain on 27/01/2023.
//

import UIKit
import DatePickerDialog
import KMPlaceholderTextView
import OpalImagePicker
import Photos
import SDWebImage
import FittedSheets


class AddDelegateServiceVC: BaseViewController {
    @IBOutlet weak var bannerImg: UIImageView!
    let vc = UIImagePickerController()
    var imageMultiPicker = OpalImagePickerController()
    @IBOutlet weak var collectionViewImage: UICollectionView!
    @IBOutlet weak var collectionVehicle: UICollectionView!
    @IBOutlet weak var collectionCare: UICollectionView!
    var isSelected = -1
    
    @IBOutlet weak var des: KMPlaceholderTextView!
    @IBOutlet weak var loc: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    var selectedLat = ""
    var selectedlong = ""
    var storeId = ""
    
    var deligate_service_id = ""
    var pickup_location = ""
    var pickup_lattitude = ""
    var pickup_longitude = ""
    var dropoff_location = ""
    var dropoff_lattitude = ""
    var dropoff_longitude = ""
    var servicesCareArray = [ServicesCare]()
    var selectedCare = [String]()
    
    var bookingID:String = ""
    
    var vehicleList : [VehicleList]? {
        didSet {
            self.collectionVehicle.reloadData()
        }
    }
    var SellerData : SellerData? {
        didSet {
            viewControllerTitle = SellerData?.activity_type?.name ?? ""
            //  bannerImg.sd_setImage(with: URL(string: SellerData?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "Path 321176"))
        }
    }
    
    var serviceData : ServiceData? {
        didSet {
            
            //Coordinator.goToDelegateThank(controller: self,step: "1",invoiceId: serviceData?.service_invoice_id,serviceId: serviceData?.id)
            self.bookingID = serviceData?.id ?? ""
            DispatchQueue.main.async {
                let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                controller.delegate = self
                controller.heading = "Order placed successfully".localiz()
                controller.confirmationText = "Please wait for confirmation"
                controller.invoiceNumber = self.serviceData?.service_invoice_id ?? ""
                let sheet = SheetViewController(
                    controller: controller,
                    sizes: [.fullscreen],
                    options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
                sheet.minimumSpaceAbovePullBar = 0
                sheet.dismissOnOverlayTap = true
                sheet.dismissOnPull = false
                sheet.contentBackgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.present(sheet, animated: true, completion: nil)
            }
            
        }
    }
    var imagesArray = [PostImages]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.0, right: 0.0)
        viewControllerTitle = "Book Now".localiz()
        type = .transperantBack
        servicesCareArray.append(ServicesCare(name: "COLD",selectedImg: "ice-crystal_selected",unSelectedImg: "ice-crystal"))
        servicesCareArray.append(ServicesCare(name: "HOT",selectedImg: "fire-flame_selected",unSelectedImg: "fire-flame"))
        servicesCareArray.append(ServicesCare(name: "FRAGILE",selectedImg: "broken-glass_selected",unSelectedImg: "broken-glass"))
        setPayCollectionCell()
        self.getVehcielAPI()
    }
    func setPayCollectionCell() {
        
        collectionViewImage.delegate = self
        collectionViewImage.dataSource = self
        collectionViewImage.register(UINib.init(nibName: "ShowPicCell", bundle: nil), forCellWithReuseIdentifier: "ShowPicCell")
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        layout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionViewImage.collectionViewLayout = layout2
        
        collectionVehicle.delegate = self
        collectionVehicle.dataSource = self
        collectionVehicle.register(UINib.init(nibName: "VehicelCells", bundle: nil), forCellWithReuseIdentifier: "VehicelCells")
        let layout3 = UICollectionViewFlowLayout()
        layout3.scrollDirection = .horizontal
        layout3.minimumInteritemSpacing = 0
        layout3.minimumLineSpacing = 0
        self.collectionVehicle.collectionViewLayout = layout3
        self.collectionVehicle.reloadData()
        
        collectionCare.delegate = self
        collectionCare.dataSource = self
        collectionCare.register(UINib.init(nibName: "VehicelCells", bundle: nil), forCellWithReuseIdentifier: "VehicelCells")
        let layout4 = UICollectionViewFlowLayout()
        layout4.scrollDirection = .horizontal
        layout4.minimumInteritemSpacing = 0
        layout4.minimumLineSpacing = 0
        self.collectionCare.collectionViewLayout = layout4
        self.collectionCare.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    @IBAction func PlaceAction(_ sender: UIButton) {
        if SessionManager.isLoggedIn() {
            var str = ""
            if self.selectedCare.count > 0 {
                str = self.selectedCare.joined(separator: ",")
            }
            if isValidForm() {
                let parameters:[String:String] = [
                    "access_token" : SessionManager.getUserData()?.accessToken ?? "" ,
                    "service_description" : des.text ?? "",
                    "deligate_service_id" : self.deligate_service_id ,
                    "pickup_location" : self.pickup_location ,
                    "pickup_lattitude" : self.pickup_lattitude ,
                    "pickup_longitude" : self.pickup_longitude,
                    "dropoff_location" : self.dropoff_location ,
                    "dropoff_lattitude" : self.dropoff_lattitude ,
                    "dropoff_longitude" : self.dropoff_longitude,
                    "mode_of_delivery" : "", //self.vehicleList?[isSelected].id ?? "",/
                    "special_care" : str
                ]
                
                var selectedArray = [UIImage]()
                for item in imagesArray {
                    if(item.mediaID != -1 && item.mediaID != 2){
                        selectedArray.append(item.img ?? UIImage())
                    }
                }
                DelegateServiceAPIManager.addDelegateTabPayApi(image: selectedArray, parameters: parameters) { response in
                    switch response.status {
                    case "1" :
                        self.serviceData = response.oData
                    default :
                        Utilities.showWarningAlert(message: response.message ?? "")
                    }
                }
            }
        }else {
            Coordinator.presentLogin(viewController: self)
        }
        // Coordinator.goToServiceThank(controller: self,step: "1")
    }
    func isValidForm() -> Bool {
        if des.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please add details".localiz()) {
                
            }
            return false
        }
//        if self.isSelected == -1 {
//            Utilities.showWarningAlert(message: "Please select delivery type") {
//                
//            }
//            return false
//        }
        return true
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    @IBAction func dateAction(_ sender: UIButton) {
        DatePickerDialog().show("Select Date".localiz(), doneButtonTitle: "Done".localiz(), cancelButtonTitle: "Cancel".localiz(),minimumDate: Date(), datePickerMode: .date) { date in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.dateField.text = formatter.string(from: dt)
                self.timeField.text = ""
            }
        }
    }
    @IBAction func timeAction(_ sender: UIButton) {
        DatePickerDialog().show("Select Time".localiz(), doneButtonTitle: "Done".localiz(), cancelButtonTitle: "Cancel".localiz(), datePickerMode: .time) { date in
            if let dt = date {
                let difference = Calendar.current.dateComponents([.hour], from: Date(), to: dt)
                let formatter = DateFormatter()
                if Calendar.current.isDateInToday(dt){
                    if (difference.hour ?? 0) >= 1 {
                        formatter.dateFormat = "HH:mm"
                        self.timeField.text = formatter.string(from: dt)
                    }else {
                        self.timeField.text = ""
                    }
                }else {
                    formatter.dateFormat = "HH:mm"
                    self.timeField.text = formatter.string(from: dt)
                }
            }
        }
    }
    @IBAction func selectPicture(_ sender: UIButton) {
        self.ShowOptions()
    }
    @IBAction func setLocNow(_ sender: UIButton) {
        let VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "ServicesLocation") as! ServicesLocation
        VC.delegate = self
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
extension AddDelegateServiceVC: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewImage {
            if imagesArray.count == 0 {
                pictureView.isHidden = true
                height.constant = 950
            }else {
                height.constant = 1150
                pictureView.isHidden = false
            }
            return imagesArray.count
        }else if collectionView == collectionVehicle {
            return vehicleList?.count ?? 0
        }else if collectionView == collectionCare {
            return servicesCareArray.count
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewImage {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowPicCell", for: indexPath) as? ShowPicCell else { return UICollectionViewCell() }
            let item = imagesArray[indexPath.row]
            cell.img.image = item.img
            cell.crossBtn.tag = indexPath.row
            cell.actionBlock = {
                self.imagesArray.remove(at: indexPath.row)
                self.collectionViewImage.reloadData()
            }
            return cell
        }else if collectionView == collectionCare {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicelCells", for: indexPath) as? VehicelCells else
            { return UICollectionViewCell()
            }
            let item = self.servicesCareArray[indexPath.row]
            cell.profileNameLabel.text = self.servicesCareArray[indexPath.row].name ?? ""
            cell.img.image = UIImage(named: self.servicesCareArray[indexPath.row].unSelectedImg ?? "")
            cell.profileNameLabel.textColor = UIColor(hex: "F6B400")
            cell.bgView.backgroundColor = UIColor(hex: "FFFFFF")
            if self.selectedCare.count > 0 {
                for (_,sev) in self.selectedCare.enumerated() {
                    if sev == item.name ?? ""{
                        cell.profileNameLabel.textColor = UIColor(hex: "FFFFFF")
                        cell.bgView.backgroundColor = UIColor(hex: "F6B400")
                        cell.img.image = UIImage(named: self.servicesCareArray[indexPath.row].selectedImg ?? "")
                        break
                    }else  {
                    }
                }
            }
            
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicelCells", for: indexPath) as? VehicelCells else
            { return UICollectionViewCell()
            }
            cell.profileNameLabel.text = vehicleList?[indexPath.row].deligateName ?? ""
            if self.isSelected == indexPath.row {
                cell.profileNameLabel.textColor = UIColor(hex: "FFFFFF")
                cell.bgView.backgroundColor = UIColor(hex: "F6B400")
                
                cell.img.sd_setImage(with: URL(string: vehicleList?[indexPath.row].deligateIcon ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile")){ image, error, cache, url in
                    cell.img.image = image
                    let tintColor = UIColor(hex: "FFFFFF")
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    cell.img.tintColor = tintColor
                    cell.img.image = tintedImage
                }
                
            }else {
                cell.profileNameLabel.textColor = UIColor(hex: "F6B400")
                cell.bgView.backgroundColor = UIColor(hex: "FFFFFF")
                cell.img.sd_setImage(with: URL(string: vehicleList?[indexPath.row].deligateIcon ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile")){ image, error, cache, url in
                    cell.img.image = image
                    let tintColor = UIColor(hex: "F6B400")
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    cell.img.tintColor = tintColor
                    cell.img.image = tintedImage
                }
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewImage {
            return CGSize(width: 103, height:130)
        }else if  collectionView == collectionVehicle {
            return CGSize(width: 85, height:95)
        }else if  collectionView == collectionCare {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width - 10
            return CGSize(width: screenWidth/3, height:95)
        }else {
            return CGSize(width: 0, height:0)
        }
        
        
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
        if collectionView == collectionCare {
            let item = self.servicesCareArray[indexPath.row]
            if self.selectedCare.count > 0 {
                for (index,sev) in self.selectedCare.enumerated() {
                    if sev == item.name ?? ""{
                        self.selectedCare.remove(at: index)
                        break
                    }else  {
                        if index == ((self.selectedCare.count) - 1) {
                            self.selectedCare.append(item.name ?? "")
                        }
                    }
                }
            }else {
                self.selectedCare.append(item.name ?? "")
            }
            self.collectionCare.reloadData()
        }else if collectionView == collectionVehicle {
            self.isSelected  = indexPath.row
            self.collectionVehicle.reloadData()
        }
    }
}
extension AddDelegateServiceVC  : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func ShowOptions () {
        let optionMenuController = UIAlertController(title: nil, message: "Choose Photo".localiz(), preferredStyle: .actionSheet)
        let addAction = UIAlertAction(title: "Camera".localiz(), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.CameraSelection()
        })
        let libraryAction = UIAlertAction(title: "Gallery".localiz(), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.gallerySelection()
        })
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenuController.addAction(addAction)
        optionMenuController.addAction(libraryAction)
        optionMenuController.addAction(cancelAction)
        self.present(optionMenuController, animated: true, completion: nil)
    }
    
    func CameraSelection() {
        showCamera()
//        vc.sourceType = .camera
//        vc.allowsEditing = true
//        vc.delegate = self
//        present(vc, animated: true)
        
    }

    func showCamera() {
        let vc =  UIStoryboard(name: "CameraImagePickerStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CameraImagePickerViewController") as! CameraImagePickerViewController
        vc.delegate = self
        self.present(vc, animated: true)
    }

    
    func gallerySelection() {
        imageMultiPicker = OpalImagePickerController()
        imageMultiPicker.imagePickerDelegate = self
        imageMultiPicker.allowedMediaTypes =  Set([PHAssetMediaType.image])
        imageMultiPicker.maximumSelectionsAllowed = 100
        present(imageMultiPicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
            var postImg = PostImages()
            postImg.mediaID = 1
            postImg.img = image
            self.imagesArray.append(postImg)
            self.collectionViewImage.reloadData()
        
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}


extension AddDelegateServiceVC: SwiftyCamDidCaptureImage {
    func didCaptureImage(image: UIImage, viewController: UIViewController) {
        viewController.dismiss(animated: true)
        var postImg = PostImages()
        postImg.mediaID = 1
        postImg.img = image
        self.imagesArray.append(postImg)
        self.collectionViewImage.reloadData()
    }

    func didCancel(viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
}
extension AddDelegateServiceVC: OpalImagePickerControllerDelegate {
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        //Save Images, update UI
        
        for items in assets {
            let img = self.getUIImage(asset: items)
            if(img != nil){
                var postImg = PostImages()
                postImg.mediaID = 1
                postImg.img = img
                self.imagesArray.append(postImg)
                self.collectionViewImage.reloadData()
            }
        }
        
        //Dismiss Controller
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return 1
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return NSLocalizedString("External", comment: "External (title for UISegmentedControl)")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
        return URL(string: "https://placeimg.com/500/500/nature")
    }
}
extension AddDelegateServiceVC: ServicesLocationDelegate {
    func placePicked(coordinate: CLLocationCoordinate2D, address: String) {
        self.loc.text = address
        let center = CLLocation (latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.selectedlong = String(center.coordinate.longitude)
        self.selectedLat = String(center.coordinate.latitude)
    }
}
extension AddDelegateServiceVC {
    
    func getVehcielAPI() {
        let parameters:[String:String] = [
            "":""
        ]
        DelegateServiceAPIManager.getServicesVehicleAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.vehicleList = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension AddDelegateServiceVC:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: self.bookingID)
    }
}



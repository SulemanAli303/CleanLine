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
import goSellSDK
struct PostImages {
    var mediaID: Int?
    var img : UIImage?
    var name : String?
}

class AddServiceVC: BaseViewController {
    @IBOutlet weak var bannerImg: UIImageView!
    let vc = UIImagePickerController()
    var imageMultiPicker = OpalImagePickerController()
    @IBOutlet weak var collectionViewImage: UICollectionView!
    @IBOutlet weak var des: KMPlaceholderTextView!
    @IBOutlet weak var loc: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    
    @IBOutlet weak var micIcon: UIButton!
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    var selectedLat = ""
    var selectedlong = ""
    var storeId = ""
    var selectedDate = Date()
    var selectedTime = Date()
    var bookingID:String = ""
    
    @IBOutlet weak var bottomHideView: UIView!
    ///Record View
    @IBOutlet weak var audioRecordingTimeLbl: UILabel!
    @IBOutlet weak var cancelRecordingBtn: UIButton!
    @IBOutlet weak var pauseRecordingBtn: UIButton!
    @IBOutlet weak var sendAudioBtn: UIButton!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var waveImageVw: UIImageView!
    @IBOutlet weak var secondWaveImageWidConst: NSLayoutConstraint!
    @IBOutlet weak var waveImageView2: UIImageView!
    @IBOutlet weak var playAudioVw: UIView!
    @IBOutlet weak var playAudioBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var audioViewHeightConst: NSLayoutConstraint!

    @IBOutlet weak var billingDetailsView: UIView!
    @IBOutlet weak var serviceChargesLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var grandTotalLbl: UILabel!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var isPaused: Bool = false
    var audioPlayer: AVAudioPlayer?
    //var playTimer: Timer!
    var waveTimer: Timer!
    var timer: Timer?
    var cardToken:String?
    var paymentService:PaymentViaTapPayService!
    var paymentInit : PaymentResponse? {
        didSet {
            let selectedPaymentType = AddServicePayCollectionDataSource.shared.selectedPaymentType
            if selectedPaymentType == "1"  {
                paymentService.paymentResponse = paymentInit?.oTabTransaction
            } else {
                self.callPlaceOrderAPI()
            }
        }
    }
    deinit{
        meterTimer?.invalidate()
        waveTimer?.invalidate()
        timer?.invalidate()
    }

    var recordedAudioData: Data?
    
    var isAudioAttached = false
    
    var balanceAmount: WalletHistoryData? {
        didSet {
        }
    }
    var total = 0.0
    var transID = ""
    var selectedIndex = -1
    
    var pickupCoorinate : CLLocation? = nil
    
    var SellerData : SellerData? {
        didSet {
            viewControllerTitle = SellerData?.activity_type?.name ?? ""
            bannerImg.sd_setImage(with: URL(string: SellerData?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "Path 321176"))
        }
    }
    
    var sellerPaymentData : StorePaymentData? {
        didSet 
        {
            billingDetailsView.isHidden = false
            serviceChargesLbl.text = sellerPaymentData?.amount ?? ""
            taxLbl.text = sellerPaymentData?.tax ?? ""
            self.total = Double (sellerPaymentData?.grand_total ?? "0") ?? 0
            grandTotalLbl.text = (sellerPaymentData?.cuurency_code ?? "") + " " + (sellerPaymentData?.grand_total ?? "")
        }
    }
    
    var serviceData : ServiceData? {
        didSet {
            
            
            self.bookingID = serviceData?.id ?? ""
            
            DispatchQueue.main.async {
                let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                controller.delegate = self
                controller.heading = "Order placed successfully".localiz()
                controller.confirmationText = "Please wait for confirmation".localiz()
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
        loc.placeholder = "Location".localiz()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .transperantBack
        self.getStoreDetailsAPI()
        setPayCollectionCell()
        audioViewHeightConst.constant = 0
        self.view.bringSubviewToFront(self.recordView)

        // Do any additional setup after loading the view.
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
        AddServicePayCollectionDataSource.shared.selectedPaymentType = ""
        AddServicePayCollectionDataSource.shared.selectedIndex = -1
        let vcObject = AddServicePayCollectionDataSource.shared
        vcObject.selectedPaymentType = ""
        payCollection.delegate = vcObject
        payCollection.dataSource = vcObject
        payCollection.register(UINib.init(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.payCollection.collectionViewLayout = layout
        payCollection.reloadData()
        self.payCollection.layoutIfNeeded()
        vcObject.payCollection = self.payCollection
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBalance()
        self.getServiceBillingDetails()
    }
    
    func getServiceBillingDetails(){
        
        billingDetailsView.isHidden = true
        let parameters:[String:String] = [
            "access_token" : SessionManager.getUserData()?.accessToken ?? "" ,
            "store_id":self.storeId
        ]
        StoreAPIManager.storeDetailsBillingAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.sellerPaymentData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    @IBAction func PlaceAction(_ sender: UIButton) {
        if SessionManager.isLoggedIn() {
            if isValidForm() 
            {
                self.paymentInitAPI()
            }
        }
        else {
            Coordinator.presentLogin(viewController: self)
        }
        // Coordinator.goToServiceThank(controller: self,step: "1")
    }
    
    func paymentInitAPI() {
        paymentService.invoiceId = "\(storeId)_\(SessionManager.getCartId() ?? "")_\(Date().debugDescription)"
        let vcObject = AddServicePayCollectionDataSource.shared

        if vcObject.selectedPaymentType == "1" {
            paymentService.startPaymentViaSellSDK(amount: Decimal.init(total))
        } else if vcObject.selectedPaymentType == "4" {
            paymentService.startApplePaymentViaSellSDK(amount: Double(total))
        } else if vcObject.selectedPaymentType == "3" {
            if ((Float(self.total) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0))){
                Utilities.showSuccessAlert(message: "Insufficient wallet balance") {
                    self.cardToken = nil
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                BookNow()
            }
        }
    }

    func BookNow() {
        let vcObject = AddServicePayCollectionDataSource.shared
        let parameters:[String:String] = [
            "access_token" : SessionManager.getUserData()?.accessToken ?? "" ,
            "description" : des.text ?? "",
            "store_id" : storeId,
            "location_name" : self.loc.text ?? "",
            "latitude" : selectedLat,
            "longitude" : selectedlong,
            "payment_type" : vcObject.selectedPaymentType,
            "token_id": self.cardToken  ?? ""
        ]

        var selectedArray = [UIImage]()
        for item in imagesArray {
            if(item.mediaID != -1 && item.mediaID != 2){
                selectedArray.append(item.img ?? UIImage())
            }
        }
        
        StoreAPIManager.paymentInitAPIForServiceBooking(image: selectedArray, audioData: recordedAudioData ?? nil,parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.paymentInit = result.oData
                    if result.oData?.oTabTransaction == nil {
                        self.callPlaceOrderAPI()
                    }
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {

                    }
            }
        }
    }

    func callPlaceOrderAPI() {
        let vcObject = AddServicePayCollectionDataSource.shared
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getUserData()?.accessToken ?? "" ,
            "description" : des.text ?? "",
            "store_id" : storeId,
            "location_name" : self.loc.text ?? "",
            "latitude" : selectedLat,
            "longitude" : selectedlong,
            "payment_type" : vcObject.selectedPaymentType,
            "invoice_id": self.paymentInit?.invoice_id ?? "",
            "transaction_ref": self.paymentInit?.payment_ref ?? "",
            "temp_order_id": self.paymentInit?.temp_order_id ?? ""
        ]
        var selectedArray = [UIImage]()
        for item in imagesArray {
            if(item.mediaID != -1 && item.mediaID != 2){
                selectedArray.append(item.img ?? UIImage())
            }
        }
        
        ServiceAPIManager.addServiceApi(image: selectedArray, audioData: recordedAudioData ?? nil,parameters: parameters) { response in
            switch response.status {
                case "1" :
                    self.serviceData = response.oData
                default :
                    Utilities.showWarningAlert(message: response.message ?? "")
            }
        }
    }
    
    func isValidForm() -> Bool {
        
        let vcObject = AddServicePayCollectionDataSource.shared

        if des.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please add details".localiz()) {
                
            }
            return false
        }
        if loc.text?.trimmingCharacters(in: .whitespaces) == "" {
            Utilities.showWarningAlert(message: "Please select location".localiz()) {
                
            }
            return false
        }
        if vcObject.selectedPaymentType == "" {
            Utilities.showWarningAlert(message: "Please select payment option".localiz()) {
                
            }
            return false

        }
//        if dateField.text?.trimmingCharacters(in: .whitespaces) == "" {
//            Utilities.showWarningAlert(message: "Please enter date") {
//                
//            }
//            return false
//        }
//        if timeField.text?.trimmingCharacters(in: .whitespaces) == "" {
//            Utilities.showWarningAlert(message: "Please enter time") {
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
        DatePickerDialog().show("Select Date".localiz(), doneButtonTitle: "Done".localiz(), cancelButtonTitle: "Cancel".localiz(),defaultDate: self.selectedDate,minimumDate: Date(), datePickerMode: .date) { date in
            if let dt = date {
                self.selectedDate = dt
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.dateField.text = formatter.string(from: dt)
                self.timeField.text = ""
                self.selectedTime = Date()
            }
        }
    }
    @IBAction func recordPressed(_ sender: Any) {
        
    //    self.view.endEditing(true)
        sendAudioBtn.alpha = 0.3
        sendAudioBtn.isUserInteractionEnabled = false
        self.audioRecordingTimeLbl.text = "00:00"
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1113)) {
            DispatchQueue.main.async {
                if self.recordingSession == nil {
                    self.recordAudio()
                } else {
                    self.recordTapped()
                }
                self.pauseRecordingBtn.isSelected = false
                self.setRecorderVisiblity(isHidden: false)
               // self.bottomVwBConst.constant = 0
            }
        }
    }
    
    func setRecorderVisiblity(isHidden: Bool) {
        self.recordView.isHidden = isHidden
        //self.inputTF.isHidden = !isHidden
        //self.mediaStack.isHidden = !isHidden
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        isAudioAttached = false
        audioViewHeightConst.constant = 0
        micIcon.isHidden = false
        
    }
    @IBAction func timeAction(_ sender: UIButton) {
        DatePickerDialog().show("Select Time".localiz(), doneButtonTitle: "Done".localiz(), cancelButtonTitle: "Cancel".localiz(),defaultDate: selectedTime, datePickerMode: .time) { date in
            if let dt = date {
                print(self.selectedDate)
                self.selectedTime = dt
                let difference = Calendar.current.dateComponents([.hour], from: Date(), to: dt)
                let formatter = DateFormatter()
                if Calendar.current.isDateInToday(self.selectedDate){
                    if (difference.hour ?? 0) >= 1 {
                        formatter.dateFormat = "HH:mm"
                        self.timeField.text = formatter.string(from: dt)
                    }else {
                        Utilities.showWarningAlert(message: "Please select time after the 1 hour from now".localiz()) {
                            
                        }
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
        VC.delegate = self as? ServicesLocationDelegate
        
        if self.pickupCoorinate != nil{
            VC.pickupCoorinate = self.pickupCoorinate
            VC.dropCoorinate = nil
        }else{
            VC.pickupCoorinate = nil
            VC.dropCoorinate = nil
        }
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
extension AddServiceVC: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imagesArray.count == 0 {
            pictureView.isHidden = true
            height.constant = 1300
        }else {
            height.constant = 1550
            pictureView.isHidden = false
        }
        return imagesArray.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowPicCell", for: indexPath) as? ShowPicCell else { return UICollectionViewCell() }
        let item = imagesArray[indexPath.row]
        cell.img.image = item.img
        cell.crossBtn.tag = indexPath.row
        cell.actionBlock = {
            self.imagesArray.remove(at: indexPath.row)
            self.collectionViewImage.reloadData()
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 103, height:130)
        
        
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
        
    }
}
extension AddServiceVC  : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
//        vc.sourceType = .camera
//        vc.allowsEditing = true
//        vc.delegate = self
//        present(vc, animated: true)

        showCamera()
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
        if(image != nil){
            var postImg = PostImages()
            postImg.mediaID = 1
            postImg.img = image
            self.imagesArray.append(postImg)
            self.collectionViewImage.reloadData()
        }
        
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


extension AddServiceVC: SwiftyCamDidCaptureImage {
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
extension AddServiceVC: OpalImagePickerControllerDelegate {
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        //Save Images, update UI
        
        for items in assets {
            var img = self.getUIImage(asset: items)
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
extension AddServiceVC: ServicesLocationDelegate {
    func placePicked(coordinate: CLLocationCoordinate2D, address: String) {
        self.loc.text = address
        let center = CLLocation (latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.pickupCoorinate = center
        self.selectedlong = String(center.coordinate.longitude)
        self.selectedLat = String(center.coordinate.latitude)
    }
}
extension AddServiceVC {
    func getStoreDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "seller_user_id" : storeId
        ]
        StoreAPIManager.storeDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.SellerData = result.oData?.sellerData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension AddServiceVC:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        Coordinator.goToServiceRequestDetails(controller: self,step: "1",serviceID: self.bookingID,isFromThanks: true)
    }
}


extension AddServiceVC: AVAudioRecorderDelegate {
    
    func recordAudio() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord,options: .defaultToSpeaker)
            try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordTapped()
                    } else {
                        // failed to record!
                        Utilities.showWarningAlert(message: "MicSetting".localiz())
                    }
                }
            }
        } catch let error {
            // failed to record!
            print(error.localizedDescription)
        }
    }
    func recordTapped() {
        
        if audioRecorder == nil {
            startRecording()
//            self.viewModel?.changeRecordingStatus(groupId: groupId ?? "", status: true)
        } else {
            finishRecording(success: true)
        }
    }
    
    
    func startRecording() {
        
        //let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.aac")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        if audioRecorder != nil {
            audioRecorder.stop()
            meterTimer.invalidate()
            audioRecorder = nil
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if self.isPaused {
            return
        }
        if !flag {
            finishRecording(success: false)
        } else {
            self.sendAudioMessage(url: recorder.url)
        }
    }
    
    @objc func updateAudioMeter(timer: Timer) {
        if audioRecorder.isRecording {
            //let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            audioRecordingTimeLbl.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func sendAudioMessage(url: URL) {
        do {
            recordedAudioData = try Data(contentsOf: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func playAudioTapped(_ sender: Any) {

        if playAudioBtn.isSelected == false {
        
            audioPlayer?.play()
            playAudioBtn.isSelected = true
            timer  = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            timer?.fire()
        } else {
            audioPlayer?.pause()
            playAudioBtn.isSelected = false
            timer?.invalidate()
        }
    }
    
    @IBAction func cancelRecording(_ sender: Any) {
        if audioRecorder != nil {
            audioRecorder = nil
        }
        if meterTimer != nil {
            meterTimer.invalidate()
        }
        handlePlayAudioView(isShow: true)
        self.pauseRecordingBtn.isSelected = false
        self.isPaused = false
        self.setRecorderVisiblity(isHidden: true)
        audioViewHeightConst.constant = 0
        resetAudioView()
        //self.bottomVwBConst.constant = -15
        
    }
    fileprivate func resetAudioView() {
        self.pauseRecordingBtn.isSelected = false
        self.playAudioBtn.isSelected = false
        handlePlayAudioView(isShow: true)
        if audioPlayer != nil {
            audioPlayer?.stop()
            timer?.invalidate()
        }
     //   playTimerLbl.text = "00:00"
        secondWaveImageWidConst.constant = 0
    }
    
    @IBAction func pauseAudioRecording(_ sender: Any) {
        if audioRecorder != nil {
            if isPaused {
                isPaused = false
                audioRecorder.record()
                resetAudioView()
            } else {
                self.isPaused = true
                self.pauseRecordingBtn.isSelected = true
                self.audioRecorder.pause()
                handlePlayAudioView(isShow: false)
                self.setupAudioPlayer()
            }
            
            sendAudioBtn.alpha = isPaused ? 1.0 : 0.3
            sendAudioBtn.isUserInteractionEnabled = isPaused
        }
    }
    @IBAction func sendAudioBtnPressed(_ sender: Any) {
        
        audioViewHeightConst.constant = 50
        self.pauseRecordingBtn.isSelected = false
        if audioRecorder != nil {
            isPaused = false
            self.audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            handlePlayAudioView(isShow: true)
        }
        isAudioAttached = true
        //self.recordView.isHidden = true
        self.setRecorderVisiblity(isHidden: true)
        resetAudioView()
        micIcon.isHidden = true
    }
    
    func handlePlayAudioView(isShow: Bool) {
       // playAudioVw.isHidden = isShow
    }
    
    func setupAudioPlayer() {
        var error : NSError?
        do {
            let player = try AVAudioPlayer(contentsOf: getAudioFileUrl())
            audioPlayer = player
         //   audioPlayer.volume = 3.0
            audioPlayer?.isMeteringEnabled = true
            audioPlayer?.delegate = self
        } catch {
            print(error)
        }
        
        if let err = error{
            print("audioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer?.prepareToPlay()
            timer  = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getAudioFileUrl() -> URL
    {
        let filename = "myRecording.aac"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
}


extension AddServiceVC: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playAudioBtn.isSelected = false
        timer?.invalidate()
        secondWaveImageWidConst.constant = 0
        audioPlayer?.stop()
        isPaused = true
        self.slider.setValue(0, animated: false)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
        playAudioBtn.isSelected = false
        timer?.invalidate()
        secondWaveImageWidConst.constant = 0
        audioPlayer?.stop()
        isPaused = false
    }
    
    @objc func timerFired() {
        if self.audioPlayer != nil {
            DispatchQueue.main.async {
                let currentTime = self.audioPlayer?.currentTime ?? 0
                let totalTime = self.audioPlayer?.duration ?? 0
                
                let sliderValue = Float(currentTime/totalTime)
                UIView.animate(withDuration: 1.0, animations: {
                  self.slider.setValue(sliderValue, animated:true)
                    self.slider.layoutIfNeeded()
                })
            }
        }
    }
    
}


extension AddServiceVC {
    func getBalance() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AuthenticationAPIManager.getWalletAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.balanceAmount = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ) {
                    
                }
            }
        }
    }
}
extension AddServiceVC: PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithPaymentCharge(_ isSuccess: Bool) {
        if isSuccess {
            self.callPlaceOrderAPI()
        }
    }

    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        self.BookNow()
    }
}

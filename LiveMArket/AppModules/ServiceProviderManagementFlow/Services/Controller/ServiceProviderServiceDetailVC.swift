//
//  ServiceRequestDetails.swift
//  LiveMArket
//
//  Created by Zain on 28/01/2023.
//

import UIKit
import FloatRatingView
import KMPlaceholderTextView
import NVActivityIndicatorView
import AudioStreaming
import DPOTPView
import FirebaseDatabase

enum UserAccountType : String,Codable
{
    case ACCOUNT_TYPE_DELIVERY_REPRESENTATIVE = "6"
    case ACCOUNT_TYPE_SERVICE_WHOLE_SELLERS = "5"
    case ACCOUNT_TYPE_SERVICE_PROVIDERS = "4"
    case ACCOUNT_TYPE_INDIVIDUAL = "3"
    case ACCOUNT_TYPE_COMMERCIAL_CENTER_SHOPS = "1"
    case ACCOUNT_TYPE_RESERVATION = "2"

}

enum ParentController: String {
    case None = "none"
    case FoodOrderDetail = "FoodOrderDetail"
    case SellerBookingDetail = "SellerBookingDetail"
}

enum ActivityType : String{
    case ACTIVITY_TYPE_FRUIT_VEGETABLE = "9"
    case ACTIVITY_TYPE_CLOTHING = "11"
    case ACTIVITY_TYPE_RESTAURANT = "12"
    case ACTIVITY_TYPE_MEDICINE = "13"
    case ACTIVITY_TYPE_MARKET = "14"
    case ACTIVITY_TYPE_CAFE = "23"
    case ACTIVITY_TYPE_HOTEL_ROOM = "4"
    case ACTIVITY_TYPE_PLAYGROUND = "17"
    case ACTIVITY_TYPE_GYM = "16"
    case ACTIVITY_TYPE_CHALET = "6"
}

class ServiceProviderServiceDetailVC: BaseViewController {
    
    
    @IBOutlet weak var pScrollView: UIScrollView!
    @IBOutlet weak var acceptButtonStackView: UIStackView!
    @IBOutlet weak var locationButtonStackView: UIStackView!
    @IBOutlet weak var finishButtonStackView: UIStackView!
    @IBOutlet weak var paymentButtonStackView: UIStackView!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var serviceIdLbl: UILabel!
    @IBOutlet weak var servicedateLbl: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storyImg: UIImageView!
    @IBOutlet weak var completedOn: UILabel!
    @IBOutlet weak var paymentTypeLbl: UILabel!
    
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var servicePriceLbl: UILabel!
    @IBOutlet weak var taxCharges: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var mapImg: UIImageView!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var comment: KMPlaceholderTextView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var paymentReceivedView: UIView!
    @IBOutlet weak var paymentReceivedViewLbl: UILabel!
    
    @IBOutlet weak var floatRt: UIStackView!
    @IBOutlet weak var deliveryDetails: UIStackView!
    @IBOutlet weak var paymentType: UIView!
    @IBOutlet weak var finishedView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var providerView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var billing: UIView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var priceView: UIView!
   // @IBOutlet weak var StatusView: UIView!
   // @IBOutlet weak var StatusImg: UIView!
    @IBOutlet weak var Statuslbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    @IBOutlet weak var collectionViewImage: UICollectionView!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var serviceDateFinish: UILabel!
    
    @IBOutlet weak var statusIndicator: NVActivityIndicatorView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var acceptLbl: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentTextViewContainer: UIView!
    
    @IBOutlet weak var attachedAudioView: UIView!
    @IBOutlet weak var slider: UISlider!
    var timer: Timer?

    deinit {
        timer?.invalidate()
    }
    var audioPlayer: AudioPlayer?
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var playBtnView: UIView! {
        didSet {
            playBtnView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.playAudioBtnPressed(_:))))
        }
    }
    
    @IBOutlet weak var VerificationView: UIStackView!
    @IBOutlet weak var OtpView: DPOTPView!
    
    @IBOutlet weak var uploadsView: UIStackView!
    var isFromThankYouPage:Bool = false
    let refNotifications = Database.database().reference().child("Nottifications")
    var observceFirebaseValue = true
    var isFromNotification:Bool = false
    var imagesArray2 = [String]()
    //var imageArray = [UIImage(named: "visaPayment"),UIImage(named: "madaPayment"),UIImage(named: "PayPal"),UIImage(named: "ApplePayment"),UIImage(named: "Stc_Payment"),UIImage(named: "tamaraPayment")]
    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var step = ""
    var serviceId = ""
    var serviceData : ServiceData? {
        didSet {
            self.pScrollView.isHidden = serviceData == nil
            viewControllerTitle = serviceData?.service_invoice_id ?? ""
            self.des.text = serviceData?.description ?? ""
            self.serviceIdLbl.text = serviceData?.service_invoice_id ?? ""
            self.servicedateLbl.text = serviceData?.booking_date ?? ""
            self.storeName.text = serviceData?.user?.name ?? ""
            storyImg.sd_setImage(with: URL(string:serviceData?.user?.user_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            self.collectionViewImage.reloadData()
            if(serviceData?.service_request_images?.count == 0){
                self.uploadsView.isHidden = true
            }else{
                self.uploadsView.isHidden = false
            }
            setData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pScrollView.isHidden = true
        type = .backWithTop
        setPayCollectionCell()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    
    func observiceFirebaseValuesForOrderStatus()
    {
        
        print(self.serviceId)
        if let userId = SessionManager.getUserData()?.firebase_user_key{
            
            
            refNotifications.child(userId).observe(.value) { snapshot in
                guard snapshot.exists(), let notifications = snapshot.children.allObjects as? [DataSnapshot] else
                {
                    return
                }
                if self.observceFirebaseValue == false{
                    return
                }
                var tempNotifications: [NotificationModel] = []
                for item in notifications {
                    guard let value = item.value as? [String: Any] else { continue }
                    do {
                        let json = try JSONSerialization.data(withJSONObject: value)
                        let notification = try JSONDecoder().decode(NotificationModel.self, from: json)
                        notification.key = item.key
                        tempNotifications.insert(notification, at: 0)
                    } catch (let error){
                        print(error.localizedDescription)
                    }
                }
                
                var orderNotifications: [NotificationModel] = []
                for n in tempNotifications
                {
                    if let invoiceId = n.invoiceId
                    {
                        if invoiceId == self.serviceId
                        {
                            orderNotifications.append(n)
                        }
                    }
                    if let orderId = n.orderId
                    {
                        if orderId == self.serviceId
                        {
                            orderNotifications.append(n)
                        }
                    }
                }
                
                var shouldShowPopup = false
                if orderNotifications.count > 0
                {
                    for n in orderNotifications
                    {
                        let notificationType = n.notificationType
                        if notificationType == "work_finished_user"
                        {
                            if let showPopup = n.showPopup{
                                if showPopup == "0"
                                {
                                    shouldShowPopup = true
                                }
                            }
                            else{
                                shouldShowPopup = true
                            }
                            if let key = n.key
                            {
                                self.observceFirebaseValue = false
                                self.refNotifications.child(userId).child(key).child("showPopup").setValue("1")
                                self.refNotifications.child(userId).removeAllObservers()
                                break
                            }
                        }
                    }
                    if shouldShowPopup
                    {
                        self.isFromNotification = true
                    }
                    self.getServiceDetails()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let userId = SessionManager.getUserData()?.firebase_user_key{
            self.refNotifications.child(userId).removeAllObservers()
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.getServiceDetails()
        DispatchQueue.main.async {
                    if self.statusIndicator != nil {
                        self.statusIndicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                        self.statusIndicator.color = .white
                        self.statusIndicator.startAnimating()
                    }
                }
        self.observiceFirebaseValuesForOrderStatus()

    }
    func setData(){
        
        self.attachedAudioView.isHidden = true
        self.VerificationView.isHidden = true
        statusIndicator.isHidden = false
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        self.providerView.isHidden = true
        self.priceView.isHidden = true
        self.acceptView.isHidden = true
        acceptButtonStackView.isHidden = true
        self.paymentView.isHidden = true
        paymentButtonStackView.isHidden = true
        self.paymentReceivedView.isHidden = true
        self.billing.isHidden = true
        self.mapView.isHidden = true
        self.locationView.isHidden = true
        locationButtonStackView.isHidden = true
        self.numberLbl.isHidden = false
        self.deliveryDetails.isHidden = true
        self.floatRt.isHidden = true
        self.Statuslbl.text = serviceData?.status_text ?? ""
        self.locLbl.text = self.serviceData?.location_name ?? ""
        self.priceLbl.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.total_amount ?? "") ?? 0.0)"
        self.subLbl.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.amount ?? "") ?? 0.0)"
        self.servicePriceLbl.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.service_charges ?? "") ?? 0.0)"
        self.taxCharges.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.tax ?? "") ?? 0.0)"
        self.grandTotal.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.total_amount ?? "") ?? 0.0)"
        
        self.userName.text  = self.serviceData?.user?.name ?? ""
        if ((self.serviceData?.user?.dial_code ?? "")).hasPrefix("+") {
            self.numberLbl.text  = "\(self.serviceData?.user?.dial_code ?? "") \(self.serviceData?.user?.phone ?? "")"
        } else {
            self.numberLbl.text  = "+\(self.serviceData?.user?.dial_code ?? "") \(self.serviceData?.user?.phone ?? "")"
        }
        userImg.sd_setImage(with: URL(string: self.serviceData?.user?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        
//        self.serviceDateFinish.text = "\(self.serviceData?.service_date ?? "") \(self.serviceData?.service_time ?? "")"
        
        let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(serviceData?.latitude ?? ""),\(serviceData?.longitude ?? "")&\("zoom=15&size=\(340)x130")&sensor=true&key=\(Config.googleApiKey)"
        
        let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        self.mapImg.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_profile"))
        self.completedOn.text = self.serviceData?.completed_on ?? ""
        
        self.paymentTypeLbl.text = self.serviceData?.payment_text
        if (self.serviceData?.status ?? "" == "0"){
            //self.StatusView.backgroundColor = UIColor(hex: "FCB813")
            //self.StatusImg.backgroundColor = UIColor(hex: "FCB813")
            self.acceptView.isHidden = false
            acceptButtonStackView.isHidden = false
            Statuslbl.textColor = UIColor(hex: "FCB813")
            
        }else if (self.serviceData?.status ?? "" == "10" || self.serviceData?.status ?? "" == "11"){
            statusIndicator.isHidden = true
           // self.StatusView.backgroundColor = UIColor(hex: "F57070")
            //self.StatusImg.backgroundColor = UIColor(hex: "F57070")
           // self.StatusImg.isHidden = true
            Statuslbl.textColor = UIColor(hex: "F57070")
        }else  if (self.serviceData?.status ?? "" == "1"){
            self.priceView.isHidden = false
           // self.StatusView.backgroundColor = UIColor(hex: "FCB813")
           // self.StatusImg.backgroundColor = UIColor(hex: "FCB813")
            self.billing.isHidden = false
            Statuslbl.textColor = UIColor(hex: "FCB813")
            
        }else  if (self.serviceData?.status ?? "" == "2"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.finishedView.isHidden = false
            self.providerView.isHidden = false
            finishButtonStackView.isHidden = false
           // self.StatusView.backgroundColor = UIColor(hex: "#5795FF")
           // self.StatusImg.backgroundColor = UIColor(hex: "#5795FF")
            Statuslbl.textColor = UIColor(hex: "#5795FF")
            self.orderButton.setTitle("On the way".localiz(), for: .normal)
            self.orderLbl.text! = "Going to site visit?".localiz()
        }else  if (self.serviceData?.status ?? "" == "4"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.providerView.isHidden = false
            self.finishedView.isHidden = false
            finishButtonStackView.isHidden = false
            //self.StatusView.backgroundColor = UIColor(hex: "#5795FF")
            //self.StatusImg.backgroundColor = UIColor(hex: "#5795FF")
            Statuslbl.textColor = UIColor(hex: "#5795FF")
            //self.orderButton.setTitle("Reached Site", for: .normal)
            self.orderButton.isHidden = true
            self.orderLbl.text! = "Reached Location?".localiz()
            self.VerificationView.isHidden = false
        }else  if (self.serviceData?.status ?? "" == "5"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
          //  self.mapView.isHidden = false
            self.providerView.isHidden = false
            self.finishedView.isHidden = true
            finishButtonStackView.isHidden = true
            //self.StatusView.backgroundColor = UIColor(hex: "5795FF")
            //self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor = UIColor(hex: "#5795FF")
            self.Statuslbl.text = "Work on progress".localiz()
            self.commentView.isHidden = false
            self.commentTextViewContainer.isHidden = true
            
        }else  if (self.serviceData?.status ?? "" == "6" || (self.serviceData?.status ?? "" == "7")){
            self.priceView.isHidden = false
            self.billing.isHidden = false
      //      self.mapView.isHidden = false
            self.providerView.isHidden = false
            self.paymentView.isHidden = true
            paymentButtonStackView.isHidden = true
            self.acceptView.isHidden = true
            acceptButtonStackView.isHidden = true
            self.commentView.isHidden  = false
            self.paymentReceivedView.isHidden = false
            self.commentBtn.setTitle("Payment Received".localiz(), for: .normal)
            self.comment.text = ""
            //self.StatusView.backgroundColor = UIColor(hex: "5795FF")
            //self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor = UIColor(hex: "#5795FF")
            self.paymentReceivedViewLbl.text = "Did you received cash?".localiz()
        }else  if (self.serviceData?.status ?? "" == "8"){
            self.commentView.isHidden  = true
            self.priceView.isHidden = false
            self.billing.isHidden = false
        //    self.mapView.isHidden = false
            self.providerView.isHidden = false
            self.paymentType.isHidden = false
            //self.StatusImg.isHidden = true
            self.numberLbl.isHidden = false
            self.deliveryDetails.isHidden = false
            self.floatRt.isHidden = true
            //self.StatusView.backgroundColor = UIColor(hex: "00B24D")
            //self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            Statuslbl.textColor = UIColor(hex: "00B24D")
            self.statusIndicator.isHidden = true
            //self.StatusImg.isHidden = true
            self.orderLbl.text! = "Maid Service".localiz()
            
            //Shoaib :: Display popup seperately here
            if isFromNotification
            {
                isFromNotification = false
                
                let userData = SessionManager.getUserData()
                if userData?.user_type_id == UserAccountType.ACCOUNT_TYPE_SERVICE_PROVIDERS.rawValue
                {
                    self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Service Completed".localiz(), confirmMessage: "", invoiceID: self.serviceData?.service_invoice_id ?? "", viewcontroller: self)
                }
                else
                {
                    self.showCompletedPopup(titleMessage: "Service Completed".localiz(), confirmMessage: "", invoiceID: self.serviceData?.service_invoice_id ?? "", viewcontroller: self)
                }
                
            }
        }
        if (serviceData?.voice_message_url != nil && serviceData?.voice_message_url != "") {
            self.attachedAudioView.isHidden = false
        }
    }
    @objc func showRating()
    {
        Coordinator.goToServiceRate(controller: self)
    }
    @objc func setupNotificationObserver()
    {
        isFromNotification = true
        getServiceDetails()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    func setPayCollectionCell() {
        payCollection.delegate = self
        payCollection.dataSource = self
        payCollection.register(UINib.init(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.payCollection.collectionViewLayout = layout
        payCollection.reloadData()
        self.payCollection.layoutIfNeeded()
        
        collectionViewImage.delegate = self
        collectionViewImage.dataSource = self
        collectionViewImage.register(UINib.init(nibName: "ShowPicCell", bundle: nil), forCellWithReuseIdentifier: "ShowPicCell")
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        layout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionViewImage.collectionViewLayout = layout2
        
    }
    @IBAction func statsAction(_ sender: UIButton) {
        
    }
    @IBAction func acceptAction(_ sender: UIButton) {
       // Coordinator.goToAcceptRequestVC(controller: self, step: "",service_request_id: serviceId,service_inVoice: serviceData?.service_invoice_id)
        self.serviceAcceptAPI(service_request_id: serviceId)
    }
    
    func serviceAcceptAPI(service_request_id:String) {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : service_request_id,
            "amount" : "",
            "service_charges" : "",
            "accept_note" : ""
        ]
        print(parameters)
        ServiceAPIManager.Accept_ProviderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getServiceDetails()
                    
                default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    @IBAction func rejectAction(_ sender: UIButton) {
        self.rejectAPI()
    }
    @IBAction func sendLocation(_ sender: UIButton) {
        
    }
    @IBAction func finished(_ sender: UIButton) {
        if (self.serviceData?.status ?? "" == "2") {
            self.OntheyWayAPI()
        }else if (self.serviceData?.status ?? "" == "4"){
            self.ReachedAPI()
        }
    }
    @IBAction func payNow(_ sender: UIButton) {
        if (self.serviceData?.status ?? "" == "5") {
            self.CompletedAPI()
        }else if (self.serviceData?.status ?? "" == "7") || (self.serviceData?.status ?? "" == "6"){
            self.FinishedAPI()
        }
        
    }
    @IBAction func payYes(_ sender: UIButton) {
        
        self.FinishedAPI()
    }
    @IBAction func FloatAction(_ sender: UIButton) {
       // Coordinator.goToServiceRate(controller: self)
    }
    
    @IBAction func mapOptionAction(_ sender: Any) {
        
        self.showMapOptions(latitude: serviceData?.latitude ?? "", longitude: serviceData?.longitude ?? "", name: serviceData?.store?.name ?? "")
    }
    override func backButtonAction(){
        if isFromThankYouPage == true
        {
           // Coordinator.updateRootVCToTab()
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "Service Booking")
        }
        else
        {
            //self.navigationController?.popViewController(animated: true)
            for controller in self.navigationController!.viewControllers as Array{
                if controller.isKind(of: NewServicesViewController.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
                    return
                }
            }
        }
    }
    @IBAction func viewMapBtn(_ sender: Any) {
        mapOptionAction(sender)
//        Coordinator.goToTrackOrder(controller: self, trackType: "6",Orderid: self.serviceId, getDriverRequestDetails: true)
    }
    
}
extension ServiceProviderServiceDetailVC: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == payCollection){
            return imageArray.count
        }else  {
            return self.serviceData?.service_request_images?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == payCollection){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodsCell", for: indexPath) as? PaymentMethodsCell else
            { return UICollectionViewCell()
            }
            
            cell.image.image = imageArray[indexPath.row]
            
            if indexPath.row == self.selectedIndex {
                cell.checkBoxBtn.setImage(UIImage(named: "Group 236139"), for: .normal)
            } else {
                cell.checkBoxBtn.setImage(UIImage(named: "Ellipse 1449"), for: .normal)
            }
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowPicCell", for: indexPath) as? ShowPicCell else { return UICollectionViewCell() }
            cell.img.sd_setImage(with: URL(string:serviceData?.service_request_images?[indexPath.row].image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            cell.crossBtn.isHidden = true
            cell.btnImg.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == payCollection){
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-40
            return CGSize(width: screenWidth/2.08, height:70)
        }else {
            return CGSize(width: 103, height:130)
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
        if collectionView == collectionViewImage {
            var array = [String]()
            if let images = serviceData?.service_request_images {
                let current = images[indexPath.row]
                array.append(current.image)
                for (index,item) in images.enumerated() {
                    if(index != indexPath.row){
                        array.append(item.image)
                    }
                }
            }
            let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
            VC.imageURLArray = array
            self.present(VC, animated: true)
        } else {
            self.selectedIndex = indexPath.row
            self.payCollection.reloadData()
        }
    }
}
extension ServiceProviderServiceDetailVC {
    func getServiceDetails() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_request_id" : self.serviceId
        ]
        ServiceAPIManager.providerServiceAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.serviceData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func rejectAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceId
        ]
        ServiceAPIManager.reject_ProviderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getServiceDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func OntheyWayAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceId
        ]
        ServiceAPIManager.onTheWay_ProviderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getServiceDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func ReachedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceId,
            "opt": OtpView.text ?? ""
        ]
        ServiceAPIManager.reached_ProviderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getServiceDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func CompletedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceId,
            "note" : comment.text ?? ""
        ]
        ServiceAPIManager.completed_ProviderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getServiceDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func FinishedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceId,
            "note" : comment.text ?? ""
        ]
        ServiceAPIManager.work_finishedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getServiceDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
//MARK: - Audio Player
extension ServiceProviderServiceDetailVC {
    
    @objc func playAudioBtnPressed(_ sender: UITapGestureRecognizer) {
        if audioPlayer != nil {
            if sender.view?.tag == 1 {
                self.audioPlayer?.pause()
            } else {
                if audioPlayer?.state == .stopped {
                    self.playAudio()
                } else if audioPlayer?.state == .paused {
                    self.audioPlayer?.resume()
                }
            }
        } else {
            self.playAudio()
        }
    }
    
    func playAudio() {
        let fileURL =  URL(string: serviceData?.voice_message_url ?? "")!
        audioPlayer = AudioPlayer()
        audioPlayer?.play(url: fileURL)
        audioPlayer?.delegate = self
    }
}

//MARK: Audio Player delegate
extension ServiceProviderServiceDetailVC: AudioPlayerDelegate {
    func audioPlayerDidStartPlaying(player: AudioStreaming.AudioPlayer, with entryId: AudioStreaming.AudioEntryId) {
        self.playImageView.image = UIImage(systemName: "pause.circle.fill")
    }
    
    func audioPlayerDidFinishBuffering(player: AudioStreaming.AudioPlayer, with entryId: AudioStreaming.AudioEntryId) {
    }
    
    @objc func timerFired() {
        DispatchQueue.main.async {
            let currentTime = self.audioPlayer?.progress ?? 0
            let totalTime = self.audioPlayer?.duration ?? 0
            let sliderValue = Float(currentTime/totalTime)
            UIView.animate(withDuration: 1.0, animations: {
              self.slider.setValue(sliderValue, animated:true)
                self.slider.layoutIfNeeded()
            })
        }
    }
    
    func audioPlayerStateChanged(player: AudioStreaming.AudioPlayer, with newState: AudioStreaming.AudioPlayerState, previous: AudioStreaming.AudioPlayerState) {
        print(newState)
        switch newState {
        case .ready:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.playBtnView.tag = 0
        case .running:
            self.playImageView.image = UIImage(systemName: "pause.circle.fill")
            self.playBtnView.tag = 1
        case .playing:
            self.playImageView.image = UIImage(systemName: "pause.circle.fill")
            self.playBtnView.tag = 1
            timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            timer?.fire()
        case .bufferring:
            self.playImageView.image = UIImage(systemName: "pause.circle.fill")
            self.playBtnView.tag = 1
        case .paused:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.playBtnView.tag = 0
            self.timer?.invalidate()
        case .stopped:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.playBtnView.tag = 0
            audioPlayer = nil
            self.playBtnView.tag = 0
            self.timer?.invalidate()
            self.slider.setValue(0, animated: false)
        case .error:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.slider.setValue(0, animated: false)
        case .disposed:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.slider.setValue(0, animated: false)
        }
    }

    func audioPlayerDidFinishPlaying(player: AudioStreaming.AudioPlayer, entryId: AudioStreaming.AudioEntryId, stopReason: AudioStreaming.AudioPlayerStopReason, progress: Double, duration: Double) {
        self.playImageView.image = UIImage(systemName: "play.circle.fill")
    }

    func audioPlayerUnexpectedError(player: AudioStreaming.AudioPlayer, error: AudioStreaming.AudioPlayerError) {

    }

    func audioPlayerDidCancel(player: AudioStreaming.AudioPlayer, queuedItems: [AudioStreaming.AudioEntryId]) {

    }

    func audioPlayerDidReadMetadata(player: AudioStreaming.AudioPlayer, metadata: [String : String]) {
        print(metadata)
    }
}

//MARK: Audio Player delegate
extension ServiceProviderServiceDetailVC {
    @IBAction func ReachedSiteBTN(_ sender: UIButton) {
        if OtpView.validate() {
            ReachedAPI()
        }else {
            Utilities.showWarningAlert(message: "Enter valid otp".localiz()) {
                
            }
        }
    }
}

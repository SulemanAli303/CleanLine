//
//  ServiceRequestDetails.swift
//  LiveMArket
//
//  Created by Zain on 28/01/2023.
//

import UIKit
import FloatRatingView
import Stripe
import Cosmos
import FittedSheets
import NVActivityIndicatorView
import AVFAudio
import AVFoundation
import AudioStreaming
import DPOTPView
import goSellSDK

class ServiceRequestDetails: BaseViewController {
    

    var balanceAmount: WalletHistoryData? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var pScrollView: UIScrollView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var acceptButtonStackView: UIStackView!
    @IBOutlet weak var locationButtonStackView: UIStackView!
    @IBOutlet weak var finishButtonStackView: UIStackView!
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var rateingView: CosmosView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var serviceIdLbl: UILabel!
    @IBOutlet weak var servicedateLbl: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storyImg: UIImageView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerImg: UIImageView!
    @IBOutlet weak var providerCompete: UILabel!
    @IBOutlet weak var providerActivity: NVActivityIndicatorView!
    @IBOutlet weak var codBtn: UIButton!
    @IBOutlet weak var serviceDateFinish: UILabel!
    
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var servicePriceLbl: UILabel!
    @IBOutlet weak var taxCharges: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var paymentTypeLbl: UILabel!
    
    @IBOutlet weak var floatRt: UIStackView!
    @IBOutlet weak var deliveryDetails: UIStackView!
    @IBOutlet weak var paymentType: UIView!
    @IBOutlet weak var finishedView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var providerView: UIView!
    @IBOutlet weak var billing: UIView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var attachedAudioView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playAudioBtn: UIButton!
    var timer: Timer?
    var audioPlayer: AudioPlayer?
    
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var playBtnView: UIView! {
        didSet {
            playBtnView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.playAudioBtnPressed(_:))))
        }
    }
    
   // @IBOutlet weak var StatusView: UIView!
   // @IBOutlet weak var StatusImg: UIView!
    @IBOutlet weak var Statuslbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    @IBOutlet weak var collectionViewImage: UICollectionView!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var providerComment: UIStackView!
    @IBOutlet var providerCommentLbl: UILabel!
    
    @IBOutlet var uploads: UIStackView!
    
    @IBOutlet var providerNotesView: UIView!
    @IBOutlet var providerNotesLbl: UILabel!
    
    @IBOutlet weak var VerificationView: UIStackView!
    @IBOutlet weak var OtpView: DPOTPView!
    
    
    @IBOutlet weak var serviceRequestLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var serviceSummaryLabel: UILabel!
    @IBOutlet weak var yourRequirementLbl: UILabel!
    @IBOutlet weak var completeCmntLbl: UILabel!
    @IBOutlet weak var uploadsLbl: UILabel!//Uploads
    @IBOutlet weak var serviceProviderLbl: UILabel!
    @IBOutlet weak var verificationCodeLbl: UILabel!
    @IBOutlet weak var routeLocationLbl: UILabel!
    @IBOutlet weak var trackOrderLbl: UILabel!
    @IBOutlet weak var billDetailsLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var serviceChargeLbl: UILabel!
    @IBOutlet weak var taxChargeLbl: UILabel!
    @IBOutlet weak var grandTotalLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var cashPaymentLbl: UILabel!
    @IBOutlet weak var payNowButton: UIButton!
    
    
    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var paymentService:PaymentViaTapPayService!

    var isFromNotification:Bool = false
    var serviceId = ""
    var step = ""
    var paymentMethod = "2"
    var paymentSheet: PaymentSheet?
    var secretkey = ""
    var transID = ""
    var bookingID:String = ""
    var isOpenfrom = false
    
    @IBOutlet weak var trackOrderView: UIView!

    var cardToken:String?
    var paymentInit : PaymentResponse? {
        didSet {
            if selectedPaymentType == "1"  {
                paymentService.paymentResponse = paymentInit?.oTabTransaction
            } else {
                self.paymentCompletedAPI()
            }
        }
    }
    
    var serviceData : ServiceData? {
        didSet {
            
            self.pScrollView.isHidden = serviceData == nil
            viewControllerTitle = serviceData?.service_invoice_id ?? ""
            self.des.text = serviceData?.description ?? ""
            self.serviceIdLbl.text = serviceData?.service_invoice_id ?? ""
            self.servicedateLbl.text = serviceData?.booking_date ?? ""
            self.storeName.text = serviceData?.store?.name ?? ""
            storyImg.sd_setImage(with: URL(string:serviceData?.store?.user_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            self.collectionViewImage.reloadData()
            
            if(serviceData?.service_request_images?.count == 0){
                uploads.isHidden = true
            }else{
                uploads.isHidden = false
            }
            
            if let notes = serviceData?.accept_note , notes != "" {
                self.providerNotesView.isHidden = false
                self.providerNotesLbl.text = notes
            }else{
                self.providerNotesView.isHidden = true
            }
            setData()
        }
    }
    var addressList : [List]? {
        didSet {
            
            if addressList != nil {
                for (index,item) in addressList!.enumerated() {
                    if item.isDefault == "1" {
                        self.addressPrime = item
                        addressList?.remove(at: index)
                        break
                    }else if (index == ((addressList?.count ?? 0) - 1)){
                        self.addressPrime = item
                    }
                }
            }
        }
    }
    var addressPrime : List? {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLanguage()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .backWithTop
        viewControllerTitle = ""
        pScrollView.isHidden = true
        setPayCollectionCell()
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        
    }
    func configLanguage(){
        serviceRequestLabel.text = "Service Request".localiz()
        notesLabel.text = "Notes".localiz()
        serviceSummaryLabel.text = "Service Summary".localiz()
        yourRequirementLbl.text = "Your requirement".localiz()
        completeCmntLbl.text = "Complete Comments".localiz()
        uploadsLbl.text = "Uploads".localiz()
        serviceProviderLbl.text = "Service Provider Details".localiz()
        verificationCodeLbl.text = "VERIFICATION CODE FOR SERVICE PROVIDER".localiz()
        routeLocationLbl.text = "Route Location".localiz()
        trackOrderLbl.text = "Track Order".localiz()
        billDetailsLbl.text = "Bill Details".localiz()
        subTotalLbl.text = "Sub Total".localiz()
        serviceChargeLbl.text = "Services Charge".localiz()
        taxChargeLbl.text = "Tax Charge".localiz()
        grandTotalLbl.text = "Grand Total".localiz()
        paymentMethodLbl.text = "Payment Methods".localiz()
        cashPaymentLbl.text = "Cash Payment".localiz()
        payNowButton.setTitle("Pay Now".localiz(), for: .normal)
    }
    @objc func setupNotificationObserver()
    {
        isFromNotification = true
        getServiceDetails()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    override func backButtonAction() {
        if isOpenfrom {
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "Service Booking")
           // self.navigationController?.popToRootViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.cardToken == nil {
            self.getAdressAPI()
            getServiceDetails()
            self.getBalance()
        }
        // tabbar?.hideTabBar()
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        DispatchQueue.main.async {
            if self.providerActivity != nil {
                self.providerActivity.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.providerActivity.color = .white
                self.providerActivity.startAnimating()
            }
        }
    }
    func setData(){
        let tabbar = tabBarController as? TabbarController
        //        if self.serviceData?.status ?? "" == "7" {
        //            tabbar?.showTabBar()
        //        }else {
        //            tabbar?.hideTabBar()
        //        }
        //        $config['service_status_pending']                               = 0;
        //        $config['service_status_rejected']                              = 11;
        //        $config['service_quote_added']                                  = 1;
        //        $config['service_quote_accepted']                               = 2;
        //        $config['service_quote_rejected']                               = 10;
        //        $config['service_location_added']                               = 3;
        //        $config['service_on_the_way']                                   = 4;
        //        $config['service_work_started']                                 = 5;
        //        $config['service_work_completed']                               = 6;
        //        $config['service_payment_completed']                            = 7;
        //        $config['service_service_completed']                            = 8;
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        floatRatingView.rating = Double(self.serviceData?.rating ?? "") ?? 0
        self.providerView.isHidden = true
        self.priceView.isHidden = true
        self.acceptView.isHidden = true
        acceptButtonStackView.isHidden = true
        self.paymentView.isHidden = true
        self.billing.isHidden = true
        self.locationView.isHidden = true
        self.locationButtonStackView.isHidden = true
        self.numberLbl.isHidden = false
        self.deliveryDetails.isHidden = true
        self.floatRt.isHidden = true
        self.providerCompete.isHidden = true
        self.attachedAudioView.isHidden = true
        self.VerificationView.isHidden = true
        
//        self.serviceDateFinish.text = "\(self.serviceData?.service_date ?? "") \(self.serviceData?.service_time ?? "")"
        self.providerCompete.text = self.serviceData?.completed_on ?? ""
        self.Statuslbl.text = self.serviceData?.status_text ?? ""
        self.priceLbl.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.total_amount ?? "") ?? 0.0)"
        self.subLbl.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.amount ?? "") ?? 0.0)"
        self.servicePriceLbl.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.service_charges ?? "") ?? 0.0)"
        self.taxCharges.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.tax ?? "") ?? 0.0)"
        self.grandTotal.text = "\(self.serviceData?.currency_code ?? "") \(Double(self.serviceData?.total_amount ?? "") ?? 0.0)"
        self.providerName.text  = self.serviceData?.store?.name ?? ""
        self.numberLbl.text  = "+\(self.serviceData?.store?.dial_code ?? "") \(self.serviceData?.store?.phone ?? "")"
        providerComment.isHidden = true
        providerImg.sd_setImage(with: URL(string: self.serviceData?.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        self.providerCommentLbl.text =  self.serviceData?.complete_note ?? ""
        OtpView.text = self.serviceData?.otp ?? ""
        
        let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(serviceData?.latitude ?? ""),\(serviceData?.longitude ?? "")&\("zoom=15&size=\(340)x130")&sensor=true&key=\(Config.googleApiKey)"
        
        self.paymentTypeLbl.text = self.serviceData?.payment_text
        self.rateButton.isHidden = true
        trackOrderView.isHidden = true
        if (self.serviceData?.status ?? "" == "0"){
//            self.StatusView.backgroundColor = UIColor(hex: "FCB813")
//            self.StatusImg.backgroundColor = UIColor(hex: "FCB813")
            Statuslbl.textColor = UIColor(hex: "FCB813")
        }else if (self.serviceData?.status ?? "" == "10" || self.serviceData?.status ?? "" == "11"){
//            self.StatusView.backgroundColor = UIColor(hex: "F57070")
//            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor = UIColor(hex: "F57070")
            self.providerActivity.isHidden = true
           // self.StatusImg.isHidden = true
        }else  if (self.serviceData?.status ?? "" == "1"){
            self.acceptView.isHidden = false
            acceptButtonStackView.isHidden = false
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.paymentType.isHidden = false
//            self.StatusView.backgroundColor = UIColor(hex: "F57070")
//            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor = UIColor(hex: "F57070")
        }else if (self.serviceData?.status ?? "" == "2"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.paymentType.isHidden = false
//            self.StatusView.backgroundColor = UIColor(hex: "F57070")
//            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor = UIColor(hex: "F57070")
            // self.Statuslbl.text = "Offer Accepted"
        }else if (self.serviceData?.status ?? "" == "4"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.paymentType.isHidden = false
            self.providerView.isHidden = false
            trackOrderView.isHidden = false
            self.VerificationView.isHidden = false

//            self.StatusView.backgroundColor = UIColor(hex: "5795FF")
//            self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor = UIColor(hex: "5795FF")
            // self.Statuslbl.text = "Wait for Service Provider"
        }else if (self.serviceData?.status ?? "" == "5"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.paymentType.isHidden = false
            self.providerView.isHidden = false
            
//            self.StatusView.backgroundColor = UIColor(hex: "5795FF")
//            self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor = UIColor(hex: "5795FF")
            //  self.Statuslbl.text = "On the way to site"
        }else if (self.serviceData?.status ?? "" == "6"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.paymentType.isHidden = false
            self.providerView.isHidden = false
            self.finishedView.isHidden = true
            finishButtonStackView.isHidden = true
            self.paymentView.isHidden = false
            self.rateButton.isHidden = false
//            self.StatusView.backgroundColor = UIColor(hex: "5795FF")
//            self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor = UIColor(hex: "5795FF")
            //  self.Statuslbl.text = "Work on progress"
            self.providerCompete.isHidden = false
            self.providerComment.isHidden = false
            self.providerCommentLbl.text = self.serviceData?.complete_note ?? ""
        }else if (self.serviceData?.status ?? "" == "7"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.providerView.isHidden = false
            self.paymentType.isHidden = false
            //self.StatusImg.isHidden = true
            self.numberLbl.isHidden = true
            self.deliveryDetails.isHidden = false
            self.floatRt.isHidden = false
//            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
//            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            Statuslbl.textColor = UIColor(hex: "00B24D")
            self.providerActivity.isHidden = true
            self.providerCompete.isHidden = false
            self.providerComment.isHidden = false
            self.providerCommentLbl.text = self.serviceData?.complete_note ?? ""
        }else if (self.serviceData?.status ?? "" == "8"){
            self.rateButton.isHidden = false
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.providerView.isHidden = false
            self.paymentType.isHidden = false
           // self.StatusImg.isHidden = true
            self.numberLbl.isHidden = true
            self.deliveryDetails.isHidden = false
            self.floatRt.isHidden = false
//            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
//            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            Statuslbl.textColor = UIColor(hex: "00B24D")
            self.providerActivity.isHidden = true
            self.providerCompete.isHidden = false
            self.providerComment.isHidden = false
            self.providerCommentLbl.text = self.serviceData?.complete_note ?? ""
            //   self.Statuslbl.text = " Completed "
            if isFromNotification{
                isFromNotification = false
                self.showCompletedPopup(titleMessage: "Service Completed".localiz(), confirmMessage: "", invoiceID: self.serviceData?.service_invoice_id ?? "", viewcontroller: self)
            }
        }
        if (serviceData?.voice_message_url != nil && serviceData?.voice_message_url != "") {
            self.attachedAudioView.isHidden = false
        }
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
    deinit{
        timer?.invalidate()
    }
    @IBAction func trackOrderPressed(_ sender: UIButton) {
//        Coordinator.goToTrackOrder(controller: self,trackType: "5" , Orderid: self.serviceData?.id ?? "")
        Coordinator.goToTrackOrder(controller: self,trackType: "6" , Orderid: self.serviceData?.id ?? "")
    }
    
    @IBAction func statsAction(_ sender: UIButton) {
        
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        self.acceptQuoatAPI()
    }
    @IBAction func rejectAction(_ sender: UIButton) {
        self.rejectQuoatAPI()
    }
    @IBAction func sendLocation(_ sender: UIButton) {
        if (step == "3"){
            Coordinator.goToServiceLocation(controller: self)
            
        }
    }
    @IBAction func finished(_ sender: UIButton) {
        self.finishAPI()
    }
    @IBAction func actionCod(_ sender: UIButton) {
        self.codBtn.setImage(UIImage(named: "Group 236139"), for: .normal)
        self.paymentMethod = "2"
        self.selectedPaymentType = "2"
        self.selectedIndex = -1
        self.payCollection.reloadData()
    }
    @IBAction func payNow(_ sender: UIButton) {
        paymentService.invoiceId = "ServiceBooking_\(SessionManager.getCartId() ?? "")_\(serviceData?.service_invoice_id ?? "")_\(Date().debugDescription)"
        if selectedPaymentType == "1" {
            paymentService.startPaymentViaSellSDK(amount: Decimal(floatLiteral: Double(self.serviceData?.total_amount ?? "") ?? 0.0))
        } else if selectedPaymentType == "4" {
            paymentService.startApplePaymentViaSellSDK(amount:  Double(self.serviceData?.total_amount ?? "") ?? 0.0)
        } else if selectedPaymentType == "3" {
            if ((Float(self.serviceData?.total_amount ?? "") ?? 0.0) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0)){

                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    self.cardToken = nil
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                payNow()
            }
        } else {
            self.payNow()
        }
    }
    @IBAction func FloatAction(_ sender: UIButton) {
        if let isRated = self.serviceData?.is_rated , isRated == "0" {
            let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
            VC.serviceData = self.serviceData
            VC.isFromServices = true
            VC.isFromOrder = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        
    }
    
    @objc func showRating(){
        
        if let isRated = self.serviceData?.is_rated , isRated == "0"
        {
            let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
            VC.serviceData = self.serviceData
            VC.isFromServices = true
            VC.isFromOrder = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func mapOptionAction(_ sender: Any) {
        
        self.showMapOptions(latitude: serviceData?.latitude ?? "", longitude: serviceData?.longitude ?? "", name: serviceData?.store?.name ?? "")
    }
    
}
extension ServiceRequestDetails: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
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
            if self.selectedIndex == 0 {
                self.selectedPaymentType = "1"
            } else if  self.selectedIndex == 1 {
                self.selectedPaymentType = "4"
            } else if  self.selectedIndex == 2 {
                self.selectedPaymentType = "3"
            }
            self.codBtn.setImage(UIImage(named: "Ellipse 1449"), for: .normal)
            self.payCollection.reloadData()
        }
    }
}

extension ServiceRequestDetails {
    func getServiceDetails() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_request_id" : self.serviceId
        ]
        ServiceAPIManager.requestServiceAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.serviceData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func acceptQuoatAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceId
        ]
        ServiceAPIManager.accept_quoteAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getServiceDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func rejectQuoatAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceId
        ]
        ServiceAPIManager.reject_quoteAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getServiceDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func finishAPI() {
        
        self.isFromNotification = true
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "service_request_id" : self.serviceId,
            "note" : "test"
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
    
    func payNow() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : TimeZone.current.identifier,
            "address_id" : self.addressPrime?.id ?? "",
            "service_request_id" : self.serviceId,
            "token_id": cardToken  ?? ""
        ]
        ServiceAPIManager.payment_initAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                    self.paymentInit = result.oData
                    self.transID = result.oData?.payment_ref ?? ""
                    if result.oData?.oTabTransaction == nil {
                        self.paymentCompletedAPI()
                    }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func paymentCompletedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : TimeZone.current.identifier,
            "address_id" : self.addressPrime?.id ?? "",
            "service_request_id" : self.serviceId,
            "payment_method" : self.selectedPaymentType,
            "invoice_id":  self.paymentInit?.invoice_id ?? "",
            "temp_order_id": self.paymentInit?.temp_order_id ?? "",
            "transaction_ref": self.paymentInit?.payment_ref ?? ""
        ]
        print(parameters)
        ServiceAPIManager.completeAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                //Coordinator.goToServiceThank(controller: self,step: "1",invoiceId: self.serviceData?.service_invoice_id,serviceId: self.serviceData?.id,isPaymentSuccess: true)
                self.bookingID = self.serviceData?.id ?? ""
                DispatchQueue.main.async {
                    let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                    controller.delegate = self
                    controller.heading = "Payment made successfully".localiz()
                    controller.confirmationText = ""
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
                
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
// MARK: - Stripe Integration
extension ServiceRequestDetails {
    
    fileprivate func launchStripePaymentSheet() {

        Utilities.showWarningAlert(message: "Payment via wallet is only supported method right now as pay via card is under development...".localiz())
       return
        var paymentSheetConfiguration = PaymentSheet.Configuration()
        paymentSheetConfiguration.merchantDisplayName = "Live Market".localiz()
        paymentSheetConfiguration.style = .alwaysLight
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: secretkey, configuration: paymentSheetConfiguration)
        self.paymentSheet?.present(from: self) { [self] paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                self.paymentCompletedAPI()
            case .canceled:
                print("User Cancelled")
                Utilities.showWarningAlert(message: "User cancelled the payment".localiz())
                
            case .failed(_):
                print("Failed")
                Utilities.showWarningAlert(message: "Payment failed.Please try later".localiz())
            }
        }
    }
    func getAdressAPI() {
        self.topStackView.isHidden = true
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AddressAPIManager.listAddressAPI(parameters: parameters) { result in
            self.topStackView.isHidden = false
            switch result.status {
            case "1":
                self.addressList = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
}
extension ServiceRequestDetails {
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
extension ServiceRequestDetails:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        Coordinator.goToServiceRequestDetails(controller: self,step: "1",serviceID: self.bookingID)
    }
}

//MARK: - Audio Player
extension ServiceRequestDetails {
    
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
extension ServiceRequestDetails: AudioPlayerDelegate {
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
extension ServiceRequestDetails:PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        payNow()
    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        if isSuccess {
            self.paymentCompletedAPI()
        }
    }
}

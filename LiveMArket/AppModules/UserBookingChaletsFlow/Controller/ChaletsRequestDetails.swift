//
//  ServiceRequestDetails.swift
//  LiveMArket
//
//  Created by Zain on 28/01/2023.
//

import UIKit
import FloatRatingView
import DPOTPView
import Cosmos
import Stripe
import FittedSheets
import NVActivityIndicatorView
import goSellSDK


class ChaletsRequestDetails: BaseViewController {
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var rateButton: UIButton!
    var paymentSheet: PaymentSheet?
    var secretkey = ""
    var transID = ""

    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var paymentService:PaymentViaTapPayService!

    var vcType:String?
    var balanceAmount: WalletHistoryData? {
        didSet {
            scroller?.isHidden = false
            topStackView?.isHidden = false

        }
    }
    @IBOutlet weak var acceptButtonStackView: UIStackView!
    @IBOutlet weak var locationButtonStackView: UIStackView!
    @IBOutlet weak var finishButtonStackView: UIStackView!
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var collectionFacilitiesView: UICollectionView!
    @IBOutlet weak var userOtpTxt1: UITextField!
    @IBOutlet weak var userOtpTxt2: UITextField!
    @IBOutlet weak var userOtpTxt3: UITextField!
   
    @IBOutlet weak var completedDateLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var invoiceNoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storyImg: UIImageView!
    @IBOutlet weak var mapImg: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var scheduleDate: UILabel!
    
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var servicePriceLbl: UILabel!
    @IBOutlet weak var taxCharges: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var priceMain: UILabel!
    @IBOutlet weak var OtpView: DPOTPView!
    
    @IBOutlet weak var providerImg: UIImageView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var paymentTypeLbl: UILabel!
    
    
    @IBOutlet weak var activity: NVActivityIndicatorView!
    @IBOutlet weak var floatRt: UIStackView!
    @IBOutlet weak var deliveryVerification: UIStackView!
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
    @IBOutlet weak var Statuslbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var sec: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    
    @IBOutlet weak var discountView: UIView!
    var timer:Timer?
    var isFromNotification:Bool = false
    var chaletID = ""
    var isFromThankYouPage:Bool = false
    var RequestData :  ChaletsBookingDetailsData? {
        didSet {
            scroller?.isHidden = false
            topStackView?.isHidden = false
            setData()
            setFacilites()
        }
    }
    var payment : ChaletPayment? {
        didSet {
            topStackView.isHidden = false
            scroller?.isHidden = false
            self.secretkey = payment?.payment_ref ?? ""
            self.transID = self.RequestData?.booking?.bookingID ?? ""
            if self.selectedPaymentType == "2" {
                self.launchStripePaymentSheet()
            }else {
                self.self.paymentCompletedAPI()
            }
        }
    }
    
    @IBOutlet weak var timerView: UIStackView!
    let futureDate: Date = {
        var future = DateComponents(
            year: 2023,
            month: 5,
            day: 20,
            hour: 0,
            minute: 0,
            second: 0
        )
        return Calendar.current.date(from: future)!
    }()
    var countdown: DateComponents {
        return Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: futureDate)
    }

    var step = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .backWithTop
        scroller.isHidden = true
        topStackView.isHidden = true
        otpTextFieldSetup()
        setPayCollectionCell()
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    @objc func setupNotificationObserver()
    {
        isFromNotification = true
        self.getRequestDetails()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
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
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        self.getRequestDetails()
        self.getBalance()
        
    }
    func otpTextFieldSetup(){
        userOtpTxt1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        userOtpTxt2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        userOtpTxt3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        userOtpTxt1.delegate = self
        userOtpTxt2.delegate = self
        userOtpTxt3.delegate = self
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case userOtpTxt1:
                userOtpTxt2.becomeFirstResponder()
            case userOtpTxt2:
                userOtpTxt3.becomeFirstResponder()
            case userOtpTxt3:
                userOtpTxt3.resignFirstResponder()
                self.SetOPT()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case userOtpTxt1:
                userOtpTxt1.becomeFirstResponder()
            case userOtpTxt2:
                userOtpTxt1.becomeFirstResponder()
            case userOtpTxt3:
                userOtpTxt2.becomeFirstResponder()
            case userOtpTxt3:
                userOtpTxt3.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func runCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    func setFacilites() {
        collectionFacilitiesView.delegate = self
        collectionFacilitiesView.dataSource = self
        collectionFacilitiesView.register(UINib.init(nibName: "EventFaclitiesCell", bundle: nil), forCellWithReuseIdentifier: "EventFaclitiesCell")
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        self.collectionFacilitiesView.collectionViewLayout = layout2
        collectionFacilitiesView.reloadData()
    }
    
    @objc func updateTime() {
        
        let releaseDate = "\(self.RequestData?.booking?.startDateTime ?? "")"
        let futureDateFormatter = DateFormatter()
        futureDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date: Date = futureDateFormatter.date(from: releaseDate){
            
            let currentDate = Date()
            let currentFormatter = DateFormatter();
            currentFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let CompetitionDayDifference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: date)
            
            
            //finally, here we set the variable to our remaining time
            let daysLeft = CompetitionDayDifference.day
            let hoursLeft = CompetitionDayDifference.hour
            let minutesLeft = CompetitionDayDifference.minute
            let secsLeft = CompetitionDayDifference.second
            
            lblDays.text = "\(daysLeft ?? 0)"
            hour.text = "\(hoursLeft ?? 0)"
            minute.text = "\(minutesLeft ?? 0)"
            sec.text = "\(secsLeft ?? 0)"
            self.timerView.isHidden = false
            
            if (daysLeft ?? 0) <= 0 {
                lblDays.text = "0"
            }
            if (hoursLeft ?? 0) <= 0 {
                hour.text = "0"
            }
            if (hoursLeft ?? 0) <= 0 && (minutesLeft ?? 0) <= 0 && (secsLeft ?? 0) <= 0 {
                minute.text = "0"
            }
            
            if (daysLeft ?? 0) <= 0 && (hoursLeft ?? 0) <= 0 && (minutesLeft ?? 0) <= 0 && (secsLeft ?? 0) <= 0 {
                timerView.isHidden = true
                Timer().invalidate()
            }
        }
        
    }
    
    deinit{
        timer?.invalidate()
    }

    func setData(){
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        self.providerView.isHidden = true
        self.priceView.isHidden = true
        self.acceptView.isHidden = true
        acceptButtonStackView.isHidden = true
        self.paymentView.isHidden = true
        self.billing.isHidden = true
        self.mapView.isHidden = true
        self.locationView.isHidden = true
        locationButtonStackView.isHidden = true
        self.numberLbl.isHidden = false
        self.deliveryDetails.isHidden = true
        self.floatRt.isHidden = true
        self.deliveryVerification.isHidden = true
        self.timerView.isHidden = true
        viewControllerTitle = RequestData?.booking?.bookingID ?? ""
        self.Statuslbl.text = RequestData?.booking?.bookingStatus ?? ""
        storyImg.sd_setImage(with: URL(string: RequestData?.product?.primary_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        providerImg.sd_setImage(with: URL(string: RequestData?.product?.primary_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        self.providerName.text = RequestData?.product?.product_name ?? ""
        self.storeName.text = RequestData?.product?.product_name ?? ""
        self.invoiceNoLbl.text = RequestData?.booking?.bookingID ?? ""
        self.address.text =  RequestData?.product?.address ?? ""
        paymentTypeLbl.text = RequestData?.booking?.payment_mode_text ?? ""
        self.numberLbl.text = RequestData?.product?.vendor_contact ?? ""
        
        self.priceLbl.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.totalAmount ?? "") ?? 0.0)"
        self.subLbl.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.bookingPrice ?? "") ?? 0.0)"
        self.servicePriceLbl.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.serviceCharges ?? "") ?? 0.0)"
        self.taxCharges.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.taxCharges ?? "") ?? 0.0)"
        self.grandTotal.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.totalAmount ?? "") ?? 0.0)"
        
        self.discount.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.discountAmount ?? "") ?? 0.0)"
        
        if (Double(self.RequestData?.booking?.discountAmount ?? "") ?? 0.0) > 0.0 {
            self.discountView.isHidden = false
        }else{
            self.discountView.isHidden = true
        }
        if let rating = RequestData?.review_data?.ratings{
            self.rateButton.isHidden = true
        }else{
            self.rateButton.isHidden = false
        }
        
        self.name.text =  RequestData?.product?.product_name ?? ""
        self.currency.text =  RequestData?.product?.currency_code ?? ""
        self.priceMain.text =  "\(Double(self.RequestData?.product?.product_price ?? "") ?? 0.0)"
        //self.dateLbl.text = self.formatDate(date: self.RequestData?.booking?.created_at ?? "") // self.RequestData?.booking?.created_at
        self.scheduleDate.text = self.RequestData?.booking?.schedule
        self.completedDateLbl.text = self.formatDate(date: self.RequestData?.booking?.completed_on ?? "")
        
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//        if let date = inputFormatter.date(from: self.RequestData?.booking?.created_at ?? "") {
//            let outputFormatter = DateFormatter()
//            outputFormatter.dateFormat = "dd MMM yyyy HH:mm a"
//            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
//            let formattedDate = outputFormatter.string(from: date)
//            dateLbl.text = formattedDate
//        } else {
//            print("Invalid date format")
//            dateLbl.text = self.RequestData?.booking?.created_at ?? ""
//        }
        dateLbl.text = self.formatDate(date: self.RequestData?.booking?.created_at ?? "") //self.RequestData?.booking?.created_at ?? ""
        
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        if let reviewData = RequestData?.review_data {
            self.floatRatingView.rating = Double(reviewData.ratings ?? "0.0") ?? 0.0
        }
        
        self.userOtpTxt1.isUserInteractionEnabled = false
        self.userOtpTxt2.isUserInteractionEnabled = false
        self.userOtpTxt3.isUserInteractionEnabled = false
        let array = Array( self.RequestData?.booking?.user_code ?? "")
        if array.count>0{
            userOtpTxt1.text = "\(array[0])"
            userOtpTxt2.text = "\(array[1])"
            userOtpTxt3.text = "\(array[2])"
        }
        
        let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(RequestData?.product?.latitude ?? ""),\(RequestData?.product?.longitude ?? "")&\("zoom=15&size=\(340)x130")&sensor=true&key=\(Config.googleApiKey)"
        
        let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        self.mapImg.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_profile"))
        
        if (self.RequestData?.booking?.bookingStatusNumber == "4") || (self.RequestData?.booking?.bookingStatusNumber == "5"){
            self.activity.stopAnimating()
        }else{
            self.activity.type = NVActivityIndicatorType.lineSpinFadeLoader
            self.activity.color = .white
            self.activity.startAnimating()
        }
        
        if (self.RequestData?.booking?.bookingStatusNumber == "0"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
//            self.StatusView.backgroundColor = UIColor(hex: "FCB813")
//            self.StatusImg.backgroundColor = UIColor(hex: "FCB813")
            self.Statuslbl.textColor = UIColor(hex: "FCB813")
            //  self.Statuslbl.text = "Waiting for confirmation"
        }else if (self.RequestData?.booking?.bookingStatusNumber == "1"){
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.paymentView.isHidden = false
//            self.StatusView.backgroundColor = UIColor(hex: "F57070")
//            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            self.Statuslbl.textColor = UIColor(hex: "F57070")
            // self.Statuslbl.text = "Booking Confirmed"
        }else if (self.RequestData?.booking?.bookingStatusNumber == "2"){
            self.timerView.isHidden = false
            runCountdown()
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.providerView.isHidden = false
            self.deliveryVerification.isHidden = false
            self.paymentType.isHidden = false
//            self.StatusView.backgroundColor = UIColor(hex: "5795FF")
//            self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            self.Statuslbl.textColor = UIColor(hex: "5795FF")
            //  self.Statuslbl.text = "Wait for your Schedule"
        }else if (self.RequestData?.booking?.bookingStatusNumber == "4"){
            self.timerView.isHidden = true
            self.priceView.isHidden = false
            self.billing.isHidden = false
            self.mapView.isHidden = false
            self.providerView.isHidden = false
            self.deliveryDetails.isHidden = false
            self.paymentType.isHidden = false
            //self.StatusImg.isHidden = true
            self.numberLbl.isHidden = true
            self.floatRt.isHidden = false
            self.activity.isHidden = true
//            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
//            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            self.Statuslbl.textColor =  UIColor(hex: "00B24D")
            
            if isFromNotification{
                isFromNotification = false
                self.showCompletedPopup(titleMessage: "Booking completed".localiz(), confirmMessage: "", invoiceID: RequestData?.booking?.bookingID ?? "", viewcontroller: self)
            }
        }
    }
    
    //MARK: - Date Convertion
    func formatDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let dateFromString = dateFormatter.date(from: date) {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "d MMM yyyy h:mma"
            let dateString = formatter.string(from: dateFromString)
            return dateString
        }
        return ""
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
        
        
    }
    override func backButtonAction(){
        if isFromThankYouPage == true{
           // Coordinator.updateRootVCToTab()
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "My Bookings")
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func statsAction(_ sender: UIButton) {
//        if (step == "1"){
//            Coordinator.goToChaletRequestDetails(controller: self, step: "2")
//        }else if (step == "3"){
//            Coordinator.goToChaletRequestDetails(controller: self, step: "4")
//        }else if (step == "5"){
//            Coordinator.goToServiceRequestDetails(controller: self, step: "6")
//        }
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        if (step == "2"){
            Coordinator.goToServiceRequestDetails(controller: self, step: "3")
        }
    }
    @IBAction func sendLocation(_ sender: UIButton) {
        if (step == "3"){
            Coordinator.goToServiceLocation(controller: self)
            
        }
    }
    @IBAction func finished(_ sender: UIButton) {
        if (step == "6"){
            Coordinator.goToServiceRequestDetails(controller: self, step: "7")
        }
    }
    @IBAction func payNow(_ sender: UIButton) {
        paymentService.invoiceId = RequestData?.booking?.bookingID ?? ""
        if selectedIndex == 0 {
            selectedPaymentType = "1"
            let grandTotalAmount = RequestData?.booking?.totalAmount ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            paymentService.startPaymentViaSellSDK(amount: Decimal.init(string: grandTotal) ?? 0.0)
                // self.payNow()
        } else if selectedIndex == 1 {
            selectedPaymentType = "4"
            let grandTotalAmount = RequestData?.booking?.totalAmount ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            paymentService.startApplePaymentViaSellSDK(amount: Double(grandTotal) ?? 0)
        } else if selectedIndex == 2 {
            selectedPaymentType = "3"
            let grandTotalAmount = RequestData?.booking?.totalAmount ?? ""
            let grandTotal = grandTotalAmount.replacingOccurrences(of: ",", with: "")
            if ((Float(grandTotal) ?? 0.0) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0)){
                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    Coordinator.gotoRecharge(controller: self)
                }
            }else {
                self.getPayNow()
            }
        } else {
            self.getPayNow()
        }
    }
    //Review
    @IBAction func FloatAction(_ sender: UIButton) {
        if let isRated = self.RequestData?.is_rated , isRated == "0" {
            Coordinator.goToServiceRate(controller: self,RequestData: self.RequestData,isFromChalet: true)
        }
    }
    @IBAction func openMapOption(_ sender: Any) {
        self.showMapOptions(latitude: RequestData?.product?.latitude ?? "", longitude: RequestData?.product?.longitude ?? "", name: RequestData?.product?.product_name ?? "")
    }
    //Review
    @IBAction func reviewPressed(_ sender: UIButton) {
        //self.myTimer.invalidate()
        let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
      //  VC.chaletsRequestData = RequestData
        VC.isFromOrder = true
        VC.isFromStore = false
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func showRating(){
//        let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
//        //VC.chaletsRequestData = RequestData
//        VC.isFromOrder = true
//        VC.isFromStore = false
//        self.navigationController?.pushViewController(VC, animated: true)
        if let isRated = self.RequestData?.is_rated , isRated == "0" {
            Coordinator.goToServiceRate(controller: self,RequestData: self.RequestData)
        }
    }
    
}
extension ChaletsRequestDetails: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionFacilitiesView {
            return self.RequestData?.product?.facilities.count ?? 0
        }else {
            return imageArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionFacilitiesView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventFaclitiesCell", for: indexPath) as? EventFaclitiesCell else { return UICollectionViewCell() }
            
            cell.name.text! = self.RequestData?.product?.facilities[indexPath.row].name ?? ""
            cell.img.sd_setImage(with: URL(string: "\( self.RequestData?.product?.facilities[indexPath.row].icon ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodsCell", for: indexPath) as? PaymentMethodsCell else { return UICollectionViewCell() }
            cell.image.image = imageArray[indexPath.row]
            if indexPath.row == self.selectedIndex {
                cell.checkBoxBtn.setImage(UIImage(named: "Group 236139"), for: .normal)
            } else {
                cell.checkBoxBtn.setImage(UIImage(named: "Ellipse 1449"), for: .normal)
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionFacilitiesView {
            return CGSize(width: 72, height:85)
        }else {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-40
            return CGSize(width: screenWidth/2.08, height:70)
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
        self.selectedIndex = indexPath.row
        self.payCollection.reloadData()
    }
}
extension ChaletsRequestDetails {
    
    func getRequestDetails() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "id" :self.chaletID
        ]
        CharletAPIManager.charletuserBookingDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.RequestData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func getPayNow() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "id" :self.chaletID,
            "payment_type" : self.selectedPaymentType
        ]
        CharletAPIManager.charletBookingPayAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.payment = result.oData?.payment_ref
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func SetOPT() {
        let otp = "\(self.userOtpTxt1.text ?? "")\(self.userOtpTxt2.text ?? "")\(self.userOtpTxt3.text ?? "")"
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "id" :self.chaletID,
            "code" : otp
        ]
        CharletAPIManager.charletBookingPaySetOTPAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.isFromNotification = true
                self.getRequestDetails()
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
            "booking_id" : self.chaletID
        ]
        CharletAPIManager.charletBookingCompleteAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
               // Coordinator.goToChaletThanks(controller: self,step: "1",chaletID: self.chaletID, invoiceId: self.RequestData?.booking?.bookingID ?? "",isPaymentAction: true)
                DispatchQueue.main.async {
                    let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                    controller.delegate = self
                    controller.heading = "Payment made successfully".localiz()
                    controller.confirmationText = ""
                    controller.invoiceNumber = self.RequestData?.booking?.bookingID ?? ""
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
extension ChaletsRequestDetails: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
// MARK: - Stripe Integration
extension ChaletsRequestDetails {
    
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
}
extension ChaletsRequestDetails {
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
//Coordinator.goToChaletThanks(controller: self,step: "1",chaletID: self.chaletID, invoiceId: self.RequestData?.booking?.bookingID ?? "",isPaymentAction: true)
extension ChaletsRequestDetails:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        Coordinator.goToChaletRequestDetails(controller: self,step: vcType ?? "1",chaletID: self.chaletID)
    }
}
extension ChaletsRequestDetails:PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {

    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        
    }
}

//
//  HotelNewBookingRequest.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit
import DPOTPView
import NVActivityIndicatorView
import FirebaseDatabase

class ChaletsReserveRequest: BaseViewController {
    
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var acceptButtonStackView: UIStackView!
    @IBOutlet weak var confirmButtonStackView: UIStackView!
    
    @IBOutlet weak var StatusView: UIView!
    @IBOutlet weak var StatusImg: UIView!
    @IBOutlet weak var Statuslbl: UILabel!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var ConfimedView: UIView!
    @IBOutlet weak var ProviderView: UIView!
    @IBOutlet weak var VerificationView: UIStackView!
    @IBOutlet weak var CompelteView: UIStackView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var bookingLbl: UILabel!
    @IBOutlet weak var collectionFacilitiesView: UICollectionView!
    @IBOutlet weak var OtpView: DPOTPView!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var invoiceNoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storyImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var priceMain: UILabel!
    
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var grand: UILabel!
    @IBOutlet weak var typePyment: UILabel!
    @IBOutlet weak var scheduleDate: UILabel!
    
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var sec: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var timerView: UIStackView!
    
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var paymentTypeView: UIView!
    @IBOutlet weak var providerImg: UIImageView!
    @IBOutlet weak var ProviderName: UILabel!
    @IBOutlet weak var ProviderNumber: UILabel!
    //@IBOutlet weak var ProviderNumber: UILabel!
    let refNotifications = Database.database().reference().child("Nottifications")
    var observceFirebaseValue = true
    var isFromThankYou = false
    var isFromNotification:Bool = false
    var step = ""
    var chaletID = ""
    var timer:Timer?
    var RequestData :  ChaletsBookingDetailsData? {
        didSet {
            scroller.isHidden = false
            topStackView.isHidden = false
            viewControllerTitle = RequestData?.booking?.bookingID ?? ""
            setData()
            setFacilites()
        }
    }
    
    let futureDate: Date = {
        var future = DateComponents(
            year: 2023,
            month: 2,
            day: 30,
            hour: 0,
            minute: 0,
            second: 0
        )
        return Calendar.current.date(from: future)!
    }()
    var countdown: DateComponents {
        return Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: futureDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        scroller.isHidden = true
        topStackView.isHidden = true
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
        
    }

    override func backButtonAction(){
        if isFromThankYou == true {
            Coordinator.gotoRespectiveOrdersList(fromController: self, category: "My Bookings")
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }


    func observiceFirebaseValuesForOrderStatus(){
        
        print(self.chaletID)
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
                        if invoiceId == self.chaletID
                        {
                            orderNotifications.append(n)
                        }
                    }
                    if let orderId = n.orderId
                    {
                        if orderId == self.chaletID
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
                        if notificationType == "user_completed_chalet_booking"
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
                    if shouldShowPopup{
                        self.isFromNotification = true
                    }
                    self.getRequestDetails()
                   
                }
            }
        }
    }
    @objc func setupNotificationObserver()
    {   isFromNotification = true
        self.getRequestDetails()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let userId = SessionManager.getUserData()?.firebase_user_key
        {
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
        tabbar?.showTabBar()
        self.getRequestDetails()
        self.observiceFirebaseValuesForOrderStatus()
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
    func setData() {

        ConfimedView.isHidden = true
        confirmButtonStackView.isHidden = true
        acceptView.isHidden = true
        acceptButtonStackView.isHidden = true
        self.paymentTypeView.isHidden = true
        
        
        if RequestData?.booking?.bookingStatusNumber == "4" || RequestData?.booking?.bookingStatusNumber == "5" || RequestData?.booking?.bookingStatusNumber == "6"{
            self.indicator.stopAnimating()
        }else{
            self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
            self.indicator.color = .white
            self.indicator.startAnimating()
        }
        
        storyImg.sd_setImage(with: URL(string: RequestData?.booking?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        providerImg.sd_setImage(with: URL(string: RequestData?.booking?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        self.ProviderName.text = " \(RequestData?.booking?.user_name ?? "") "
        self.ProviderNumber.text = " \(RequestData?.booking?.phone ?? "") "
        self.storeName.text = " \(RequestData?.booking?.user_name ?? "") "
        self.invoiceNoLbl.text = RequestData?.booking?.bookingID ?? ""
        self.priceLbl.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.totalAmount ?? "") ?? 0.0)"
        self.name.text =  RequestData?.product?.product_name ?? ""
        self.currency.text =  RequestData?.product?.currency_code ?? ""
        self.priceMain.text =  "\(Double(self.RequestData?.product?.product_price ?? "") ?? 0.0)"
        self.dateLbl.text = self.formatDate(date: self.RequestData?.booking?.created_at ?? "") //self.RequestData?.booking?.created_at
        self.ProviderView.isHidden = true
        
        if let payment_mode_text = RequestData?.booking?.payment_mode_text , payment_mode_text != "" {
            typePyment.text = payment_mode_text
            self.paymentTypeView.isHidden = false
        }else{
            self.paymentTypeView.isHidden = true
        }
        
        self.discountLbl.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.discountAmount ?? "") ?? 0.0)"
        if (Double(self.RequestData?.booking?.discountAmount ?? "") ?? 0.0) > 0.0 {
            self.discountView.isHidden = false
        }else{
            self.discountView.isHidden = true
        }
        
        self.subTotal.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.bookingPrice ?? "") ?? 0.0)"
        self.tax.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.taxCharges ?? "") ?? 0.0)"
        self.grand.text = "\(RequestData?.product?.currency_code ?? "") \(Double(self.RequestData?.booking?.totalAmount ?? "") ?? 0.0)"
        typePyment.text = RequestData?.booking?.payment_mode_text ?? ""
        self.scheduleDate.text = self.RequestData?.booking?.schedule ?? ""
        self.Statuslbl.text = " \(RequestData?.booking?.bookingStatus ?? "") "
        if (RequestData?.booking?.bookingStatusNumber ?? "" == "0"){
            self.acceptView.isHidden = false
            acceptButtonStackView.isHidden = false
        }
       else if (RequestData?.booking?.bookingStatusNumber ?? "" == "1"){
//            self.StatusView.backgroundColor = UIColor(hex: "F57070")
//            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor = UIColor(hex: "F57070")
            self.ConfimedView.isHidden = false
           confirmButtonStackView.isHidden = false
        }
        else if (RequestData?.booking?.bookingStatusNumber ?? "" == "2"){
            self.runCountdown()
//             self.StatusView.backgroundColor = UIColor(hex: "5795FF")
//             self.StatusImg.backgroundColor = UIColor(hex: "5795FF")
            Statuslbl.textColor = UIColor(hex: "5795FF")
             self.ProviderView.isHidden = false
             self.ConfimedView.isHidden = true
            confirmButtonStackView.isHidden = true
         }
       else if (RequestData?.booking?.bookingStatusNumber ?? "" == "4"){
            self.bookingLbl.isHidden = true
            self.timerView.isHidden = true
            self.VerificationView.isHidden = true
            self.CompelteView.isHidden = false
//            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
//            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
           Statuslbl.textColor = UIColor(hex: "00B24D")
            //self.StatusImg.isHidden = true
            //self.indicator.isHidden = true
           if isFromNotification{
               isFromNotification = false
               self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Booking completed".localiz(), confirmMessage: "", invoiceID: RequestData?.booking?.bookingID ?? "", viewcontroller: self)
           }
           
        }else if (RequestData?.booking?.bookingStatusNumber ?? "" == "5"){
             self.bookingLbl.isHidden = true
             self.timerView.isHidden = true
             self.VerificationView.isHidden = true
             self.CompelteView.isHidden = false
//             self.StatusView.backgroundColor = UIColor(hex: "F57070")
//             self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            Statuslbl.textColor = UIColor(hex: "F57070")
             //self.StatusImg.isHidden = true
           // self.indicator.isHidden = true
            
            
         }
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        self.chaledAcceptedAPI()
    }
    
    @IBAction func rejectAction(_ sender: UIButton) {
        self.chaledRejectAPI()
    }

    func runCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    deinit {
        timer?.invalidate()
    }

    @IBAction func EnterGroundBTN(_ sender: UIButton) {
        if OtpView.validate() {
            self.SetOPT()
        }else {
            Utilities.showWarningAlert(message: "Enter valid otp".localiz()) {
                
            }
        }
    }
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

}
extension ChaletsReserveRequest {
    
    func getRequestDetails() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "id" :self.chaletID
        ]
        CharletAPIManager.charletManagementBookingDetailsAPI(parameters: parameters) { result in
            switch result.status {
                
            case "1":
                self.RequestData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func chaledAcceptedAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.chaletID,
            "status" : "1"
        ]
        print(parameters)
        CharletAPIManager.charletManagmentBookingYesNOAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getRequestDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func chaledRejectAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : self.chaletID,
            "status" : "5"
        ]
        print(parameters)
        CharletAPIManager.charletManagmentBookingYesNOAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getRequestDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func SetOPT() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "id" :self.chaletID,
            "code" : OtpView.text ?? ""
        ]
        CharletAPIManager.charletManagementBookingPaySetOTPAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getRequestDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension ChaletsReserveRequest: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.RequestData?.product?.facilities.count ?? 0
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventFaclitiesCell", for: indexPath) as? EventFaclitiesCell else { return UICollectionViewCell() }
        
        cell.name.text! = self.RequestData?.product?.facilities[indexPath.row].name ?? ""
        cell.img.sd_setImage(with: URL(string: "\( self.RequestData?.product?.facilities[indexPath.row].icon ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 72, height:85)
        
        
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

//
//  TableRequestDetails.swift
//  LiveMArket
//
//  Created by Zain on 23/09/2023.
//

import UIKit
import DPOTPView
import SDWebImage
import FloatRatingView
import NVActivityIndicatorView
import FirebaseDatabase

class TableRequestDetails: BaseViewController {
    
    @IBOutlet weak var specialrequestsLabel: UILabel!
    @IBOutlet weak var bookingVerificationLabel: UILabel!
    @IBOutlet weak var resturantDetailsLabel: UILabel!
    @IBOutlet weak var resturantLocationLabel: UILabel!
    
    
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var specialRquestView: UIView!
    @IBOutlet weak var tblposition: UILabel!
    @IBOutlet weak var desTxt: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var rateStackView: UIStackView!
    @IBOutlet weak var ratingStarView: FloatRatingView!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var storeVerificationCode: DPOTPView!
    @IBOutlet weak var storeVerificationStack: UIStackView!
    @IBOutlet weak var profileView: UIStackView!
    @IBOutlet weak var detailsViewHeadingLabel: UILabel!
    @IBOutlet weak var userVerificationCode: DPOTPView!
    @IBOutlet weak var bookingDetailsView: UIView!
    @IBOutlet weak var orderRejectAcceptView: UIView!
    @IBOutlet weak var orderCancelView: UIView!
    @IBOutlet weak var timerStackview: UIStackView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var deliveryDetailsView: UIStackView!
    @IBOutlet weak var verificationView: UIStackView!
    @IBOutlet weak var bookingAddresView: UIView!
    
    @IBOutlet weak var orderCancelStackView: UIStackView!
    @IBOutlet weak var rejectAcceptButtonStackView: UIStackView!
    
    
    @IBOutlet weak var verificationCodeView: DPOTPView!
    @IBOutlet weak var invoiceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var personCountLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    @IBOutlet weak var timeSlotLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minitLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var storeDetailsLabel: UILabel!
    
    @IBOutlet weak var storeDetailsImageView: UIImageView!
    @IBOutlet weak var storePhoneNumberLabel: UILabel!
    @IBOutlet weak var addressImageView: UIImageView!
    
    @IBOutlet weak var statusIndicatorBgImageView: UIImageView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    let refNotifications = Database.database().reference().child("Nottifications")
    var observceFirebaseValue = true
    
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    var selectedIndex = 1
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]

    var bookingID:String = ""
    var shopID:String = ""
    var isFromReceivedBooking:Bool = false
    var futureDate:Date = Date()
    var isFromThankYouPage:Bool = false
    var timer:Timer?

    var countdown: DateComponents {
        return Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: futureDate)
    }
    var isFromNotification = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        topStackView.isHidden = true
        type = .backWithTop
        self.setPayCollectionCell()
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
    }
    
    func configureLanguage(){
        specialrequestsLabel.text = "Special requests".localiz()
        bookingVerificationLabel.text = "Booking Verification".localiz()
        resturantDetailsLabel.text = "Resturant Location".localiz()
    }
    func observiceFirebaseValuesForOrderStatus() {

        print(self.bookingID)
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
                        if invoiceId == self.bookingID
                        {
                            orderNotifications.append(n)
                        }
                    }
                    if let orderId = n.orderId
                    {
                        if orderId == self.bookingID
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
                        if notificationType == "table_booking_completed_user" || notificationType == "table_booking_completed_store"
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
                    if self.isFromReceivedBooking{
                        self.myReceivedBookingDetaisAPI()
                    } else {
                        self.myBookingDetaisAPI()
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        
        if isFromReceivedBooking{
            myReceivedBookingDetaisAPI()
        }else{
            myBookingDetaisAPI()
        }
        
        self.observiceFirebaseValuesForOrderStatus()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        
        if let userId = SessionManager.getUserData()?.firebase_user_key{
            self.refNotifications.child(userId).removeAllObservers()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    @objc func setupNotificationObserver()
    {
        isFromNotification = true
        if isFromReceivedBooking{
            self.myReceivedBookingDetaisAPI()
        }else{
            self.myBookingDetaisAPI()
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopAlaram()
    }
    
    func setPayCollectionCell() {
        payCollection.delegate = self
        payCollection.dataSource = self
        payCollection.register(UINib.init(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width-80
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = CGSize(width: screenWidth/2, height: 70)
        self.payCollection.collectionViewLayout = layout
        
    }
    
    var bookingData:TableBookDetailsData?{
        didSet{
            UIView.animate(withDuration: 1.0, animations: {
                self.topStackView.isHidden = false
            })

            print(bookingData)
            self.convertDate(dateString: bookingData?.booking_date ?? "")
            viewControllerTitle = bookingData?.invoice_id ?? ""
            dateLabel.text = self.formatDate(date: bookingData?.created_at ?? "")
            priceLabel.text = ""
            invoiceLabel.text = bookingData?.invoice_id ?? ""
            statuslabel.text = bookingData?.booking_status_text ?? ""
            desTxt.text = bookingData?.description ?? ""
            tblposition.text = bookingData?.table_possition?.positionName ?? "" + "  "
            addressPrime = bookingData?.store?.location_data
            personCountLabel.text = "\(bookingData?.no_of_persons ?? "") \("Person".localiz())"
            scheduleDateLabel.text = bookingData?.booking_date ?? ""
            timeSlotLabel.text = "\(bookingData?.booking_from ?? "") - \(bookingData?.booking_to ?? "")"
            deliveryDateLabel.text = self.formatDate(date: bookingData?.completed_on ?? "")
            ratingStarView.rating = Double(bookingData?.rating ?? "") ?? 0
            
            if bookingData?.description ?? "" == ""{
                self.specialRquestView.isHidden = true
            }else{
                self.specialRquestView.isHidden = false
            }
            
            if bookingData?.rating ?? "" == ""{
                rateButton.isUserInteractionEnabled = true
            }else{
                rateButton.isUserInteractionEnabled = false
            }
            
            if isFromReceivedBooking{
                detailsViewHeadingLabel.text = "CUSTOMER DETAILS".localiz()
                storeNameLabel.text = bookingData?.user?.name ?? ""
                storeImageView.sd_setImage(with: URL(string: bookingData?.user?.user_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
                
                storeDetailsLabel.text = bookingData?.user?.name ?? ""
                storeDetailsImageView.sd_setImage(with: URL(string: bookingData?.user?.user_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
                if bookingData?.store?.dial_code?.prefix(1) == "+"{
                    storePhoneNumberLabel.text = "\(bookingData?.user?.dial_code ?? "") \(bookingData?.user?.phone ?? "")"
                }else{
                    storePhoneNumberLabel.text = "+\(bookingData?.user?.dial_code ?? "") \(bookingData?.user?.phone ?? "")"
                }
            } else {
                detailsViewHeadingLabel.text = "RESTURANT DETAILS".localiz()
                mapView.isHidden = false
                storeNameLabel.text = bookingData?.store?.name ?? ""
                storeImageView.sd_setImage(with: URL(string: bookingData?.store?.user_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))

                storeDetailsLabel.text = bookingData?.store?.name ?? ""
                storeDetailsImageView.sd_setImage(with: URL(string: bookingData?.store?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                if bookingData?.store?.dial_code?.prefix(1) == "+"{
                    storePhoneNumberLabel.text = "\(bookingData?.store?.dial_code ?? "") \(bookingData?.store?.phone ?? "")"
                }else{
                    storePhoneNumberLabel.text = "+\(bookingData?.store?.dial_code ?? "") \(bookingData?.store?.phone ?? "")"
                }
                userVerificationCode.text = bookingData?.booking_otp ?? ""
            }
            mapView.isHidden = isFromReceivedBooking
            orderRejectAcceptView.isHidden = true
            rejectAcceptButtonStackView.isHidden = true
            orderCancelView.isHidden = true
            orderCancelStackView.isHidden = true
            timerStackview.isHidden = true
            deliveryDetailsView.isHidden = true
            verificationView.isHidden = true
            bookingDetailsView.isHidden = true
            profileView.isHidden = true
            storeVerificationStack.isHidden = true
            rateStackView.isHidden = true
            rateButton.isHidden = true

            
            if bookingData?.booking_status == "4" || bookingData?.booking_status == "11"{
                self.indicator.stopAnimating()
            }else{
                self.indicator.type = NVActivityIndicatorType.lineSpinFadeLoader
                self.indicator.color = .white
                self.indicator.startAnimating()
            }
            
            if isFromReceivedBooking{
                if bookingData?.booking_status == "0" {
                    orderRejectAcceptView.isHidden = false
                    rejectAcceptButtonStackView.isHidden = false
                    statusColorCode(color: Color.StatusYellow.color())
                }else if bookingData?.booking_status == "1" {
                    statusColorCode(color: Color.StatusRed.color())
                    timerStackview.isHidden       = false
                    bookingDetailsView.isHidden   = false
                    storeVerificationStack.isHidden = false
                    profileView.isHidden = false
                }else if bookingData?.booking_status == "2"{
                    statusColorCode(color: Color.StatusRed.color())
                }else if bookingData?.booking_status == "4"{
                    bookingDetailsView.isHidden   = false
                    profileView.isHidden = false
                    deliveryDetailsView.isHidden = false
                    statusColorCode(color: Color.StatusGreen.color())
                    
                    if isFromNotification
                    {
                        isFromNotification = false
                        self.showCompletedPopupWithHomeButtonOnly(titleMessage: "Table Booking Completed".localiz(), confirmMessage: "", invoiceID: self.bookingData?.invoice_id ?? "", viewcontroller: self)
                    }
         
                }else if bookingData?.booking_status == "5"{
                    statusColorCode(color: Color.StatusBlue.color())
                }else if bookingData?.booking_status == "6"{
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                }else if bookingData?.booking_status == "10" || bookingData?.booking_status == "12" || bookingData?.booking_status == "11"{
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                    deliveryDetailsView.isHidden  = false
                    verificationView.isHidden     = false
                }else{
                    statusColorCode(color: Color.StatusYellow.color())
                }
            }else{
                if bookingData?.booking_status == "0" {
                    statusColorCode(color: Color.StatusYellow.color())
                }else if bookingData?.booking_status == "1" {
                    statusColorCode(color: Color.StatusRed.color())
                    timerStackview.isHidden       = false
                    verificationView.isHidden     = false
                    bookingDetailsView.isHidden   = false
                    profileView.isHidden          = false
                    rateButton.isHidden = false
                }else if bookingData?.booking_status == "2"{
                    statusColorCode(color: Color.StatusRed.color())
                    rateButton.isHidden = false
                }else if bookingData?.booking_status == "4"{
                    bookingDetailsView.isHidden   = false
                    profileView.isHidden = false
                    deliveryDetailsView.isHidden = false
                    rateStackView.isHidden = false
                    rateButton.isHidden = false
                    statusColorCode(color: Color.StatusGreen.color())
                    
                    if isFromNotification
                    {
                        isFromNotification = false
                        self.showCompletedPopup(titleMessage: "Table Booking Completed".localiz(), confirmMessage: "", invoiceID: self.bookingData?.invoice_id ?? "", viewcontroller: self)
                    }

                }else if bookingData?.booking_status == "5"{
                    statusColorCode(color: Color.StatusBlue.color())
                }else if bookingData?.booking_status == "6"{
                    statusColorCode(color: Color.StatusGreen.color(),indicatiorHide: true)
                }else if bookingData?.booking_status == "10" || bookingData?.booking_status == "12" || bookingData?.booking_status == "11"{
                    statusColorCode(color: Color.StatusDarkRed.color(),indicatiorHide: true)
                    deliveryDetailsView.isHidden  = false
                    verificationView.isHidden     = false
                }else{
                    statusColorCode(color: Color.StatusYellow.color())
                }
            }
            runCountdown()
        
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
    
    func convertDate(dateString:String){
        let dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        if let date = dateFormatter.date(from: dateString) {
            // `date` is the parsed Date object
            print("Parsed Date: \(date)")
            futureDate = date
            runCountdown()
        } else {
            print("Error parsing date.")
        }
    }
    deinit{
        timer?.invalidate()
    }
    func runCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(_ timer2:Timer) {

        let releaseDate = "\(bookingData?.booking_date ?? "") \(bookingData?.booking_from ?? ""):00"
        let futureDateFormatter = DateFormatter()
        futureDateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        if let date = futureDateFormatter.date(from: releaseDate){
            let currentDate = Date()
            let currentFormatter = DateFormatter();
            currentFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let CompetitionDayDifference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: date)
            
            
            //finally, here we set the variable to our remaining time
            let daysLeft = CompetitionDayDifference.day
            let hoursLeft = CompetitionDayDifference.hour
            let minutesLeft = CompetitionDayDifference.minute
            let secsLeft = CompetitionDayDifference.second
            
            dayLabel.text = "\(daysLeft ?? 0)"
            hoursLabel.text = "\(hoursLeft ?? 0)"
            minitLabel.text = "\(minutesLeft ?? 0)"
            secondLabel.text = "\(secsLeft ?? 0)"
            //self.timerView.isHidden = false
            
            if (daysLeft ?? 0) <= 0 {
                dayLabel.text = "00"
            }

            if (hoursLeft ?? 0) <= 0 {
                hoursLabel.text = "00"
            }

            if (minutesLeft ?? 0) <= 0 {
                minitLabel.text = "00"
            }

            if  (secsLeft ?? 0) <= 0 {
                secondLabel.text = "00"
            }


            if (daysLeft ?? 0) <= 0 && (hoursLeft ?? 0) <= 0 && (minutesLeft ?? 0) <= 0 && (secsLeft ?? 0) <= 0 {
                //self.timerStackview.isHidden = true
                timer?.invalidate()
                timer2.invalidate()
                timer = nil
            }
        }
        
        //        hour.text! = "\(String(format: "%02d",hours))"
        //        minute.text! = "\(String(format: "%02d",minutes))"
        //        sec.text! = "\(String(format: "%02d",seconds))"
    }
    
    /// Status Color change
    /// - Parameters:
    ///   - color: UIColor
    ///   - isHide: hide indicator and background
    func statusColorCode(color:UIColor,indicatiorHide isHide:Bool = false)  {
//        statusBarView.backgroundColor = color
//        statusIndicatorBgImageView.backgroundColor  = color
        statuslabel.textColor = color
        if isHide{
           // statusIndicatorBgImageView.isHidden       = true
            //indicator.isHidden = true
        }else{
           // statusIndicatorBgImageView.isHidden       = false
            //indicator.isHidden = false
        }
    }
    var addressPrime : Location_data? {
        didSet {
            self.addressLabel.text = addressPrime?.location_name ?? ""
            let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(addressPrime?.lattitude ?? ""),\(addressPrime?.longitude ?? "")&\("zoom=15&size=\(510)x310")&sensor=true&key=\(Config.googleApiKey)"
            print(staticMapUrl)
            let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            loadMapFromURL(url!,completion: { self.addressImageView.image = $0 })
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
    }
    @IBAction func rejectButtonAction(_ sender: UIButton) {
        self.myTableBookingRejectAPI()
    }
    @IBAction func AcceptButtonAction(_ sender: UIButton) {
        self.myTableBookingAcceptedAPI()
    }
    @IBAction func addresButtonAction(_ sender: Any) {
        // Create an alert controller
        let alertController = UIAlertController(title: "Select Map".localiz(), message: "", preferredStyle: .alert)
        
        // Add an action (button) to the alert
        let appleAction = UIAlertAction(title: "Apple Map".localiz(), style: .default) { (action) in
            // Handle the "OK" button tap if needed
            self.navigateAppleMap(lat: self.bookingData?.store?.location_data?.lattitude ?? "", longi:  self.bookingData?.store?.location_data?.longitude ?? "")
        }
        alertController.addAction(appleAction)
        let googleAction = UIAlertAction(title: "Google Map".localiz(), style: .default) { (action) in
            self.navigateGoogleMap(lat: self.bookingData?.store?.location_data?.lattitude ?? "", longi:  self.bookingData?.store?.location_data?.longitude ?? "")
        }
        alertController.addAction(googleAction)
        
        // Optionally, you can add more actions (buttons) to the alert
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { (action) in
            // Handle the "Cancel" button tap if needed
            print("Cancel tapped")
        }
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bookCompletedAction(_ sender: UIButton) {
        guard self.storeVerificationCode.text != "" else {
            Utilities.showWarningAlert(message: "Please type OTP from customer.".localiz()) {
                
            }
            return
        }
        self.myTableBookingCompletedAPI()
    }
    @IBAction func rateButtonAction(_ sender: UIButton) {
        if bookingData?.booking_status == "1" || bookingData?.booking_status == "2" || bookingData?.booking_status == "3" {
            let url: NSURL = URL(string: "TEL://+\(self.bookingData?.store?.dial_code ?? "")\(self.bookingData?.store?.phone ?? "")")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            self.showRating()
        }
    }
    
    @objc func showRating(){
        let  VC = AppStoryboard.Rate.instance.instantiateViewController(withIdentifier: "RateVC") as! RateVC
        VC.myTableBookingData = bookingData
        VC.isFromTableBooking = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    override func backButtonAction(){
        if isFromThankYouPage == true {
                //Coordinator.updateRootVCToTab()
                //Coordinator.gotoRespectiveOrdersList(fromController: self, category: "Table Booking")
            let  VC = AppStoryboard.NewOrder.instance.instantiateViewController(withIdentifier: "TabelBookingViewController") as! TabelBookingViewController
            VC.isFromDriver = false
            VC.isPopRoot = true
            VC.isFromNewProcessOrdersFromProfile = false

            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? ""
            ]
            Utilities.showIndicatorView()
            StoreAPIManager.userProfileAPI(parameters: parameters) { result in
                Utilities.hideIndicatorView()
                switch result.status {
                    case "1":
                        let count = Int(result.oData?.data?.received_table_booking_count ?? "") ?? 0
                        if count > 0 {
                            VC.isReceivedEnable = true
                        } else {
                            VC.isReceivedEnable = false
                        }
                        self.navigationController?.pushViewController(VC, animated: true)
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") { }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func navigateGoogleMap(lat:String, longi:String){
        if let url = URL(string: "comgooglemaps://?q=\(lat),\(longi)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Handle the case where Google Maps is not installed.
            }
        }
    }
    
    override func navigateAppleMap(lat:String, longi:String){
        if let url = URL(string: "http://maps.apple.com/?q=\(lat),\(longi)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Handle the case where Apple Maps is not available.
            }
        }
    }
}
extension TableRequestDetails: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width-80
        return CGSize(width: screenWidth/2, height:70)
        
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
extension TableRequestDetails{
    func myBookingDetaisAPI() {
//        self.topStackView.isHidden = true
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : bookingID
        ]
        print(parameters)
        StoreAPIManager.tabelBookingdetailsAPI(parameters: parameters) { result in
//            self.topStackView.isHidden = false
            switch result.status {
            case "1":
                self.bookingData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {

                }
            }
        }
    }
    func myReceivedBookingDetaisAPI() {
//        self.topStackView.isHidden = true
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : bookingID
        ]
        print(parameters)
        StoreAPIManager.receivedTabelBookingdetailsAPI(parameters: parameters) { result in
//            self.topStackView.isHidden = false
            switch result.status {
            case "1":
                self.bookingData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {

                }
            }
        }
    }
    
    func myTableBookingAcceptedAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : bookingID
        ]
        print(parameters)
        StoreAPIManager.tableBookingAcceptedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myReceivedBookingDetaisAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func myTableBookingRejectAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : bookingID
        ]
        print(parameters)
        StoreAPIManager.tableBookingRejectedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myReceivedBookingDetaisAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func myTableBookingCompletedAPI() {
        
        self.isFromNotification = true
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "booking_id" : bookingID,
            "otp":storeVerificationCode.text ?? ""
        ]
        print(parameters)
        StoreAPIManager.tableBookingCompletedAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myReceivedBookingDetaisAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

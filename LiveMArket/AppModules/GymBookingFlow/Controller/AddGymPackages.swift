//
//  AddGymPackages.swift
//  LiveMArket
//
//  Created by Zain on 30/01/2023.
//

import UIKit
import Stripe
import CountryPickerView
import FittedSheets
import goSellSDK
class AddGymPackages: BaseViewController {
    
  
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak 
    var dialTextField: UITextField!
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var billingView: UIView!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    var total = 0
    
    @IBOutlet weak var grandTotalLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var serviceChargeLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    //    @IBOutlet weak var monthView: UIView!
    //    @IBOutlet weak var monthView_3: UIView!
    //    @IBOutlet weak var monthView_6: UIView!
    
    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var addressID  = ""
    var cardToken:String?
    var paymentService:PaymentViaTapPayService!

    var balanceAmount: WalletHistoryData? {
        didSet {

        }
    }

    var storeID:String = ""
    var packageID:String = ""
    var selectedSubscription:[String] = []
    let cpvInternal = CountryPickerView()
 
    
    var bookingID:String = ""
    
    
    var paymentSheet: PaymentSheet?
    var secretkey = ""
    var transID = ""
    var genderText:String = ""
    var userData: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameTextField.placeholder = "Full Name".localiz()
        emailTextField.placeholder = "Email ID".localiz()
        ageTextField.placeholder = "Age".localiz()
        phoneTextField.placeholder = "Number".localiz()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .transperantBackWithTwo
        viewControllerTitle = "Gold's Gym".localiz()
        reset()
        // scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        setPayCollectionCell()
        userData = SessionManager.getUserData()
        heightCons.constant = 700
    }
 
    var gymData:GymDetailsOData?{
        didSet{
            myImage.sd_setImage(with: URL(string: gymData?.seller_data?.banner_image ?? ""), placeholderImage: UIImage(named: "placeholder_banner"))
            viewControllerTitle = gymData?.seller_data?.name ?? ""
        }
    }
    var packageDetails: PackageData?{
        didSet{
            print(packageDetails?.list ?? 0)
            self.tableview.reloadData()
        }
    }
    var paymentDetails: PaymentResponse?{
        didSet{
            if self.selectedPaymentType == "1" {
                paymentService.paymentResponse = paymentDetails?.oTabTransaction
            } else {
                self.placeGymSubscriptionAPI()
            }
        }
    }
    
    var placeSubscriptionDetails: PlaceSubscriptionData?{
        didSet{
            print(placeSubscriptionDetails)
            DispatchQueue.main.async {
                //Coordinator.goToGymThanks(controller: self,id: self.placeSubscriptionDetails?.subscription_invoice_id ?? "",subscriptionid: self.placeSubscriptionDetails?.id ?? "")
                
                self.bookingID = self.placeSubscriptionDetails?.id ?? ""
                DispatchQueue.main.async {
                    let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                    controller.delegate = self
                    controller.heading = "Payment made successfully".localiz()
                    controller.confirmationText = ""
                    controller.invoiceNumber = self.placeSubscriptionDetails?.subscription_invoice_id ?? ""
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
    }
    
    var addressList : [List]? {
        didSet {
            var str = ""
            if addressList?.count ?? 0 > 0{
                str = addressList?.first?.id ?? ""
            }
//            print( addressList?.count ?? 0)
//            if addressList?.count ?? 0 > 0{
                if self.selectedPaymentType == "" {
                    Utilities.showSuccessAlert(message: "Please select payment type".localiz())
                }else {
                    self.paymentInitAPI(addressID: str)
                }
//            }else{
//                Utilities.showQuestionAlert(message: "Please add address") {
//                    SellerOrderCoordinator.goToAddNewAddress(controller: self, isEdit: false)
//                }
//            }
        }
    }
    override func liveAction () {
        Coordinator.goToLive(controller: self)
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
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
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
        tableview.register(UINib(nibName: "GymSubscriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "GymSubscriptionTableViewCell")
        if self.cardToken == nil {
            gymDetailsAPI()
            getPackageDetailsAPI()
            self.getBalance()
            setInitialData()
        }



    }
    
//    fun String.removePlus(): String {
//        return this.replace("+", "")
//    }
//
//    fun String.addPlus(): String {
//        return "+${this.removePlus()}"
//    }
//    func removePlus(char : [String]) -> [String]{
//        if char.contains("+") {
//            return char.splitted(by: "+")
//        }
//    }
//    func checkCountryCodeSymble(str : String, text : String) -> String  {
//        let numOccurrences = text.filter{ $0 == "+" }.count
//        print(text)
//        var phoneCode = text
//        if numOccurrences > 0 {
//            for i in 0..<numOccurrences {
//                phoneCode = phoneCode.replacingOccurrences(of: "+", with: "")
//            }
//            phoneCode = "+\(phoneCode)"
//            return phoneCode
//        }else{
//            phoneCode = "+\(phoneCode)"
//            return phoneCode
//        }
//    }
    func setInitialData(){
        
        var phoneCode = userData?.dial_code ?? ""
        phoneCode = Utilities.checkCountryCodeSymble(str: "+", text: phoneCode)
        fullNameTextField.text = userData?.name ?? ""
        dialTextField.text     = phoneCode //"+\(userData?.dial_code ?? "")"
        phoneTextField.text    = userData?.phone_number ?? ""
        emailTextField.text    = userData?.email ?? ""
        /*
        if userData?.gender == "male"{
            genderText = "male"
            maleButton.setTitleColor(.white, for: .normal)
            maleButton.setImage(UIImage(named: "maleArrow_white"), for: .normal)
            maleButton.setBackgroundImage(UIImage(named: "buttonGradientBg"), for: .normal)
        }else{
            genderText = "female"
            femaleButton.setTitleColor(.white, for: .normal)
            femaleButton.setImage(UIImage(named: "femaleArrow_white"), for: .normal)
            femaleButton.setBackgroundImage(UIImage(named: "buttonGradientBg"), for: .normal)
        }*/
    }
    
    @IBAction func PlaceAction(_ sender: UIButton) {
        //Coordinator.goToGymThanks(controller: self)
        
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: self)
            return
        }
        guard packageID != "" else {
            scroller.setContentOffset(.zero, animated: true)
            Utilities.showWarningAlert(message: "Please selected your subscription.".localiz()) {}
            return
        }
        guard self.fullNameTextField.text != "" else {
            Utilities.showWarningAlert(message: "Please enter your full name.".localiz()) {}
            return
        }
        guard self.ageTextField.text != "" else {
            Utilities.showWarningAlert(message: "Please enter your age.".localiz()) {}
            return
        }
        guard self.genderText != "" else {
            Utilities.showWarningAlert(message: "Please choose your gender.".localiz()) {}
            return
        }
        guard self.dialTextField.text != "" else {
            Utilities.showWarningAlert(message: "Please enter your dial number.".localiz()) {}
            return
        }
        guard self.phoneTextField.text != "" else {
            Utilities.showWarningAlert(message: "Please enter your phone number.".localiz()) {}
            return
        }
        guard self.emailTextField.text != "" else {
            Utilities.showWarningAlert(message: "Please enter your email id.".localiz()) {}
            return
        }
        guard self.emailTextField.text?.isValidEmail == true else {
            Utilities.showWarningAlert(message: "Please enter valid email address".localiz()) {}
            return
        }
        
        self.getAdressAPI()
    }
    @IBAction func dialCodeAction(_ sender: UIButton) {
        
        cpvInternal.delegate = self
        cpvInternal.showCountriesList(from: self)
    }
    @IBAction func femaleAction(_ sender: UIButton) {
        genderText = "female".localiz()
        femaleButton.setTitleColor(.white, for: .normal)
        femaleButton.setImage(UIImage(named: "femaleArrow_white"), for: .normal)
        femaleButton.setBackgroundImage(UIImage(named: "buttonGradientBg"), for: .normal)
        
        maleButton.setBackgroundColor(color: .white, forState: .normal)
        maleButton.setTitleColor(Color.darkOrange.color(), for: .normal)
        maleButton.setImage(UIImage(named: "maleArrow_orange"), for: .normal)
        //setGradientBackground(button: femaleButton)
    }
    @IBAction func maleAction(_ sender: UIButton) {
        genderText = "male"
        maleButton.setTitleColor(.white, for: .normal)
        maleButton.setImage(UIImage(named: "maleArrow_white"), for: .normal)
        maleButton.setBackgroundImage(UIImage(named: "buttonGradientBg"), for: .normal)
        
        femaleButton.setBackgroundColor(color: .white, forState: .normal)
        femaleButton.setTitleColor(Color.darkOrange.color(), for: .normal)
        femaleButton.setImage(UIImage(named: "femaleArrow_orange"), for: .normal)
        //setGradientBackground(button: maleButton)
    }
    func reset() {
        //monthView.backgroundColor = .clear
        //monthView_3.backgroundColor = .clear
        // monthView_6.backgroundColor = .clear
    }
    
    //MARK: - API Calls
    
    func gymDetailsAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "seller_user_id" : storeID
        ]
        print(parameters)
        
        GymAPIManager.gymDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.gymData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func getPackageDetailsAPI() {
        let parameters:[String:String] = [
            "store_id" : storeID,
            "access_token":SessionManager.getAccessToken() ?? ""
        ]
        print(parameters)
        GymAPIManager.gymPackagesAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.packageDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                }
            }
        }
    }
    
    func getSinglePackageDetailsAPI(packageID : String) {
        let parameters:[String:String] = [
            "package_id" : packageID,
            "access_token":SessionManager.getAccessToken() ?? ""
        ]
        print(parameters)
        GymAPIManager.gymPackageDetailAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.billingView.isHidden = false
                self.subTotalLbl.text = "\(result.oData?.currencyCode ?? "SAR".localiz()) \(result.oData?.price ?? "")"
                self.serviceChargeLbl.text = "\(result.oData?.currencyCode ?? "SAR".localiz()) \(result.oData?.serviceCharge ?? "")"
                self.taxLbl.text = "\(result.oData?.currencyCode ?? "SAR".localiz()) \(result.oData?.tax ?? "")"
                self.grandTotalLbl.text = "\(result.oData?.currencyCode ?? "SAR".localiz()) \(result.oData?.grandTotal ?? "")"
                self.heightCons.constant = 700
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    
    func paymentInitAPI(addressID:String){
        self.addressID = addressID
        paymentService.invoiceId = "\(storeID)_\(packageID)_\(Date().debugDescription)_\(addressID)"
        if selectedPaymentType == "1" {
            paymentService.startPaymentViaSellSDK(amount: Decimal.init(total))
        } else if selectedPaymentType == "4" {
            paymentService.startApplePaymentViaSellSDK(amount: Double(total) ?? 0)
        } else if selectedPaymentType == "3" {
            if ((Float(self.total) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0))){
                
                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    self.cardToken = nil
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                BookNow()
            }
        } else {
            BookNow()
        }
    }
    func BookNow() {
        let parameters:[String:String] = [
            "address_id" : self.addressID,
            "token_id": cardToken  ?? "",
            "store_id" : storeID,
            "package_id":packageID,
            "access_token":SessionManager.getAccessToken() ?? "",
            "full_name":self.fullNameTextField.text ?? "",
            "age":self.ageTextField.text ?? "",
            "gender":genderText ,
            "dial_code":self.dialTextField.text ?? "",
            "phone":self.phoneTextField.text ?? "",
            "email":self.emailTextField.text ?? "",
            "payment_type" : self.selectedPaymentType,
            "temp_order_id" : self.paymentDetails?.temp_order_id ?? ""
        ]
        print(parameters)
        GymAPIManager.paymentInitAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.paymentDetails = result.oData
                    self.transID = result.oData?.payment_ref ?? ""
                    if result.oData?.oTabTransaction == nil {
                        self.placeGymSubscriptionAPI()
                    }

                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {

                    }
            }
        }
    }
    func placeGymSubscriptionAPI(){
        let parameters:[String:String] = [
            "store_id" : storeID,
            "package_id":packageID,
            "access_token":SessionManager.getAccessToken() ?? "",
            "full_name":self.fullNameTextField.text ?? "",
            "age":self.ageTextField.text ?? "",
            "gender":genderText ,
            "dial_code":self.dialTextField.text ?? "",
            "phone":self.phoneTextField.text ?? "",
            "email":self.emailTextField.text ?? "",
            "transaction_ref" : self.paymentDetails?.payment_ref ?? "",
            "payment_type" : self.selectedPaymentType,
            "temp_order_id" :self.paymentDetails?.temp_order_id ?? ""
        ]
        print(parameters)
        GymAPIManager.placegySubscriptionAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.placeSubscriptionDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func getAdressAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AddressAPIManager.listAddressAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.addressList = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func setGradientBackground(button:UIButton) {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.bounds.width/2
        
        button.layer.insertSublayer(gradientLayer, at:0)
    }
}
extension AddGymPackages: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
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
        let screenSize: CGRect = collectionView.bounds
        let screenWidth = screenSize.width-50
        return CGSize(width: screenWidth/2.08, height:70)
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
        if self.selectedIndex == 0 {
            self.selectedPaymentType = "1"
        } else if  self.selectedIndex == 1 {
            self.selectedPaymentType = "4"
        } else if  self.selectedIndex == 2 {
            self.selectedPaymentType = "3"
        }
        self.payCollection.reloadData()
    }
}

extension AddGymPackages:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageDetails?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GymSubscriptionTableViewCell", for: indexPath) as! GymSubscriptionTableViewCell
        cell.data = packageDetails?.list?[indexPath.row]
        if selectedSubscription.contains(packageDetails?.list?[indexPath.row].id ?? ""){
            cell.cellBgView.backgroundColor = .white
            cell.subscriptionButton.setTitleColor(UIColor(named: Color.darkOrange.rawValue), for: .normal)
        }else{
            cell.cellBgView.backgroundColor = .clear
            cell.subscriptionButton.setTitleColor(UIColor.white, for: .normal)

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        packageID = packageDetails?.list?[indexPath.row].id ?? ""
        selectedSubscription.removeAll()
        selectedSubscription.append(packageDetails?.list?[indexPath.row].id ?? "")
        total = (Int(packageDetails?.list?[indexPath.row].price ?? "") ?? 0) + (Int(packageDetails?.list?[indexPath.row].service_charge ?? "") ?? 0)
        self.tableview.reloadData()
        getSinglePackageDetailsAPI(packageID: packageID)
    }
}
// MARK: - Stripe Integration
extension AddGymPackages {
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
                self.placeGymSubscriptionAPI()
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


extension AddGymPackages: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: CPVCountry) {

        self.dialTextField.text = country.phoneCode
    }
}
extension AddGymPackages {
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
extension AddGymPackages:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
        VC.subscriptionID = self.bookingID
        VC.isFromReceivedSubscription = false
        VC.isFrommThankuPage = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
extension AddGymPackages:PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        self.BookNow()
    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        if isSuccess {
            self.placeGymSubscriptionAPI()
        }
    }
}

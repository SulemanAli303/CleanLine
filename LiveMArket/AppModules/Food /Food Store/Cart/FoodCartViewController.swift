//
//  FoodCartViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 05/05/23.
//


import UIKit
import FloatRatingView
import FittedSheets
import Stripe
import DatePickerDialog
import goSellSDK
class FoodCartViewController: BaseViewController {
    
    var selectedDelegete : DelegateList?
    var selectedDeligateId:String = ""
    var dateSelected = false
    var timeSelected = false
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var taxView: UIView!
    @IBOutlet weak var deliveryChargeView: UIView!
    @IBOutlet weak var discountView: UIView!
    var assignValue = ""
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var paymentService:PaymentViaTapPayService!
    var paymentSheet: PaymentSheet?
    var balanceAmount: WalletHistoryData? {
        didSet {
        }
    }
    var total = 0.0
    var orderID:String = ""
    var storeID:String  = ""
    var invoice_id:String  = ""
    @IBOutlet weak var dateTimeContainerView: UIView!
    
    var addressList : [List]? {
        didSet {
            self.addressView.isHidden  = true
            if addressList != nil {
                for (index,item) in addressList!.enumerated() {
                    if item.isDefault == "1" {
                        self.addressPrime = item
                        addressList?.remove(at: index)
                        self.addressView.isHidden = false
                        break
                    }else {
                        self.addressPrime = addressList?.first
                        self.addressView.isHidden = false
                        break
                    }
                }
            }
        }
    }
    
    var cart: FoodCartData? {
        didSet {
            if cart?.cart_items?.count == 0 {
                //self.navigationController?.popViewController(animated: true)
                for controller in self.navigationController!.viewControllers as Array{
                    if controller.isKind(of: FoodStoreDetailsViewController.self) || controller.isKind(of: ProductDetailsViewController.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
            }
            storeID = cart?.cart_items?.first?.store_id ?? ""
            self.itemTotal.text = "\("SAR".localiz()) \(String(format: "%.2f", Double(cart?.cart_subtotal ?? "") ?? 0.0))"
            self.deliveryCharges.text = "\("SAR".localiz()) \(String(format: "%.2f", Double(cart?.delivery_charge ?? "") ?? 0.0))"
            self.taxCharges.text = "\("SAR".localiz()) \(String(format: "%.2f", Double(cart?.tax_amount ?? "") ?? 0.0))"
            self.grandTotal.text = "\("SAR".localiz()) \(String(format: "%.2f", Double(cart?.cart_grand_total ?? "") ?? 0.0))"
            self.total = Double(cart?.cart_grand_total ?? "0") ?? 0.0
            self.discountLbl.text = "\("SAR".localiz()) \(String(format: "%.2f", Double(cart?.discount ?? "") ?? 0.0))"
//            if cart?.coupon_applied == "1" {
//                self.couponApply.setTitle("Remove", for:.normal)
//                self.couponField.isUserInteractionEnabled = false
//            }else {
//                self.couponApply.setTitle("Apply", for:.normal)
//                self.couponField.isUserInteractionEnabled = true
//            }
            if cart?.delivery_charge ?? "" == "0.00"{
                deliveryChargeView.isHidden = true
            }else{
                self.deliveryChargeView.isHidden = false
            }
            if cart?.tax_amount ?? "" == "0.00"{
                taxView.isHidden = true
            }else{
                taxView.isHidden = false
            }
            if cart?.coupon_applied ?? "" == "0"{
                discountView.isHidden = true
            }else{
                discountView.isHidden = false
            }
            if cart?.discount ?? "" == "0.00" || cart?.discount ?? "" == nil {
                discountView.isHidden = true
            }else{
                discountView.isHidden = false
            }
            
            if let status = cart?.storeDetails?.user_type_id
            {
                if status == UserAccountType.ACCOUNT_TYPE_INDIVIDUAL.rawValue
                {
                    dateTimeContainerView.isHidden = false
                }
            }
            setData()
        }
    }
    var cardToken:String?
    var payment : OTabTransaction? {
        didSet {
            if self.selectedPaymentType == "1" {
                paymentService.paymentResponse = payment
            } else if self.selectedPaymentType == "4" {
                self.orderRequestAPI()
            } else {
                self.orderRequestAPI()
            }
        }
    }


    var paymentInit : PaymentData? {
        didSet {
            
            self.orderID = self.paymentInit?.invoiceID ?? ""
            DispatchQueue.main.async {
                let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                controller.delegate = self
                controller.heading = "Order placed successfully".localiz()
                controller.confirmationText = "Please wait for confirmation".localiz()
                controller.invoiceNumber = self.paymentInit?.invoiceID ?? ""
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
    
    @IBOutlet var tbl: IntrinsicallySizedTableView!
    @IBOutlet var assigedView: UIView!
    @IBOutlet var RequestView: UIView!
    @IBOutlet var itemTotal: UILabel!
    @IBOutlet var deliveryCharges: UILabel!
    @IBOutlet var taxCharges: UILabel!
    @IBOutlet var grandTotal: UILabel!
    @IBOutlet var discountLbl: UILabel!
    @IBOutlet var addressView: UIView!
    @IBOutlet var addressImg: UIImageView!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var couponApply: UIButton!
    @IBOutlet var couponField: UITextField!
    @IBOutlet var assignedDelegate: UILabel!
    
    var addressPrime : List? {
        didSet {
            self.addressLbl.text = "\(addressPrime?.buildingName ?? ""), \(addressPrime?.flatNo ?? ""), \(addressPrime?.address ?? "")"
            
            let staticMapUrl = "http://maps.google.com/maps/api/staticmap?center=\(addressPrime?.latitude ?? ""),\(addressPrime?.longitude ?? "")&\("zoom=15&size=\(110)x110")&sensor=true&key=\(Config.googleApiKey)"
            
            print(staticMapUrl)
            
            let url = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            loadMapFromURL(url!,completion: { self.addressImg.image = $0 })
        }
    }
    
    var isAssigned = false
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .notifications
        viewControllerTitle = "Cart".localiz()
        dateTimeContainerView.isHidden = true
        self.setPayCollectionCell()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.cardToken == nil {
            self.getAdressAPI()
            self.getBalance()
        }
    }
    
    func setPayCollectionCell() {
        payCollection.delegate = self
        payCollection.dataSource = self
        payCollection.register(UINib.init(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        payCollection.register(UINib.init(nibName: "ProductComboCellTableViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductComboCellTableViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.payCollection.collectionViewLayout = layout
        payCollection.reloadData()
        self.payCollection.layoutIfNeeded()
        
    }
    override func clearAll() {
        Utilities.showQuestionAlert(message: "Are you sure you want to clear cart?".localiz()) {
            self.cleartAll()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    func setData() {
        if (isAssigned) {
            assigedView.isHidden = false
            RequestView.isHidden = true
        }else {
            assigedView.isHidden = true
            RequestView.isHidden = false
        }
        self.tbl.delegate = self
        self.tbl.dataSource = self
        self.tbl.separatorStyle = .none
        self.tbl.register(FoodItemsCartTableViewCell.nib, forCellReuseIdentifier: FoodItemsCartTableViewCell.identifier)
        tbl.reloadData()
        self.tbl.layoutIfNeeded()
    }
    
    @IBAction func requestADelegate(_ sender: UIButton) {
        self.goTORequest()
    }
    func goTORequest() {
        let  VC = AppStoryboard.ReceivingOption.instance.instantiateViewController(withIdentifier: "ReceivingViewController") as! ReceivingViewController
        VC.delegate = self
        self.cardToken = nil
        VC.isFromFoodCart = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func placeOrderPressed(_ sender: UIButton) {
        if self.addressPrime == nil {
            Utilities.showQuestionAlert(message: "Please add address".localiz()) {
                SellerOrderCoordinator.goToAddNewAddress(controller: self, isEdit: false)
            }
        }else if self.selectedDeligateId == "" {
            Utilities.showQuestionAlert(message: "Please select receiving option".localiz()) {
                self.goTORequest()
            }
        }
        else if self.selectedPaymentType == "" {
            Utilities.showWarningAlert(message: "Please select payment option".localiz()) {
                
            }
        } else  {

            if self.dateSelected && self.timeSelected{
                var scheduleDate = ""
                if self.dateSelected
                {
                    scheduleDate = dateButton.title(for: .normal) ?? ""
                }
                if self.timeSelected{
                    scheduleDate.append(" \(timeButton.title(for: .normal) ?? "")")
                }
               
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
                let nowString = dateFormatter.string(from: Date())
                let aDate = dateFormatter.date(from: scheduleDate)
                
                let diffComponents = Calendar.current.dateComponents([.hour], from: Date(), to: aDate!)
                let hours = diffComponents.hour
                print(hours)
                if hours! < 1
                {
                    Utilities.showWarningAlert(message: "Please select time atlest 1 hour later from now".localiz()) {
                    }
                    return
                }
            }
            
            self.paymentInitAPI(addressID: self.addressPrime?.id ?? "")

        }
        
        //  Coordinator.goTThankYouPage(controller: self,vcType: "order")
    }
    var selectedAddressID:String = ""
    func paymentInitAPI(addressID:String) {
        selectedAddressID = addressID
        paymentService.invoiceId = "\(SessionManager.getCartId() ?? "")_\(addressID)"
        if selectedIndex == 0 {
            selectedPaymentType = "1"
            paymentService.startPaymentViaSellSDK(amount: Decimal.init(self.total))
        } else if selectedIndex == 1 {
            selectedPaymentType = "4"
            paymentService.startApplePaymentViaSellSDK(amount:  self.total)
        } else if selectedIndex == 2 {
            selectedPaymentType = "3"
            if ((Float(self.total) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0))){

                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    self.cardToken = nil
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                self.PayNow()
            }
        }
    }

    
    
    @IBAction func changeAdd(_ sender: UIButton) {
        cardToken = nil
        SellerOrderCoordinator.goToAddressVC(controller: self)
    }
    override func backButtonAction() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FoodStoreDetailsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    @IBAction func Apply(_ sender: UIButton) {

        self.applyCouponAPI()
    }
    @IBAction func selectDate(_ sender: Any) {

        let maximumDate = Date().dateBeforeOrAfterFrom(days: 5)
        DatePickerDialog().show("Select Date".localiz(), doneButtonTitle: "Done".localiz(), cancelButtonTitle: "Cancel".localiz(), defaultDate:Date(), minimumDate:Date(), maximumDate: maximumDate , datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.dateSelected = true
                self.dateButton.setTitle(formatter.string(from:dt), for: .normal)
            }
        }
    }
    @IBAction func selectTime(_ sender: Any) {
        
        if self.dateSelected == false
        {
            Utilities.showWarningAlert(message: "Please Select Date first".localiz())
            return
        }
       
        let vcObject = self.storyboard?.instantiateViewController(withIdentifier: "FoodCartHoursPicker") as! FoodCartHoursPicker
        vcObject.existingValueString = self.timeSelected ? (timeButton.title(for: .normal) ?? "") : ""
        vcObject.onDonePress = { result in
            print(result)
            self.timeSelected = true
            self.timeButton.setTitle(result, for: .normal)
        }
        self.tabBarController?.view.addSubview(vcObject.view!)
        self.tabBarController?.addChild(vcObject)
        
//        UIDatePicker.appearance().minuteInterval = 30
//        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel" , datePickerMode: .time) { (date) in
//            if let dt = date {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "hh:00 a"
//                self.timeSelected = true
//                self.timeButton.setTitle(formatter.string(from:dt), for: .normal)
//            }
//        }
    }
    func PayNow() {
        let parameters:[String:String] = [
            "access_token" :SessionManager.getAccessToken() ?? "",
            "payment_type" : self.selectedPaymentType,
            "address_id"   : selectedAddressID,
            "store_id"     : storeID,
            "coupon_code"  : self.couponField.text ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "request_deligate" : self.selectedDeligateId,
            "token_id"     : self.cardToken  ?? ""
        ]
        print(parameters)
        FoodAPIManager.orderFoodPayInit(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.invoice_id = result.oData?.payment_ref ?? ""
                    self.payment = result.oData?.oTabTransaction
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {

                    }
            }
        }
    }
}
// MARK: - TableviewDelegate
extension FoodCartViewController : UITableViewDelegate ,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart?.cart_items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notificationCell = self.tbl.dequeueReusableCell(withIdentifier: FoodItemsCartTableViewCell.identifier) as! FoodItemsCartTableViewCell
        notificationCell.cellType = .cart
        notificationCell.productList = cart?.cart_items?[indexPath.row]
        notificationCell.setdate()
        notificationCell.delegate = self
        notificationCell.baseVc = self
        return notificationCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let productListCount = cart?.cart_items?[indexPath.row].cart_combos?.count
        let headerHeight = productListCount == 0 ? 0 : 30

        return CGFloat(170 + headerHeight + ((productListCount ?? 0) * 35))
    }
}
extension FoodCartViewController {
    func getCartAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "address_id" : addressPrime?.id ?? "",
            "deligate_id" : selectedDeligateId,
            "store_id" : storeID
            
        ]
        print(parameters)
        FoodAPIManager.listCartItemsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.cart = result.oData
            default:
                self.cart?.cart_items?.removeAll()
                self.tbl.reloadData()
                Utilities.showWarningAlert(message: result.message ?? "") {
                }
            }
        }
    }
    
    func applyCouponAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "coupon_code" : self.couponField.text ?? "",
            "address_id" : addressPrime?.id ?? "",
            "deligate_id" : selectedDeligateId,
            "store_id" : storeID
        ]
        print(parameters)
        FoodAPIManager.applyCouponItemsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.cart = result.oData
            default:
                self.cart?.cart_items?.removeAll()
                self.tbl.reloadData()
                Utilities.showWarningAlert(message: result.message ?? "") {
                }
            }
        }
    }
    
    func getAdressAPI() {
        self.addressView.isHidden = true
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
            self.getCartAPI()
        }
    }
    func cleartAll() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? ""
        ]
        StoreAPIManager.clearCartFoodAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                for controller in self.navigationController!.viewControllers as Array{
                    if controller.isKind(of: FoodStoreDetailsViewController.self) || controller.isKind(of: ProductDetailsViewController.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func orderRequestAPI() {
        
        var scheduleDate = ""
        if self.dateSelected {
            scheduleDate = dateButton.title(for: .normal) ?? ""
        }
        if self.timeSelected {
            scheduleDate.append(" \(timeButton.title(for: .normal) ?? "")")
        }
        
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "payment_type" : selectedPaymentType,
            "address_id" : self.addressPrime?.id ?? "",
            "coupon_code" : self.couponField.text ?? "",
            "request_deligate" : self.selectedDeligateId,
            "deligate_id" : selectedDeligateId,
            "store_id" : storeID,
            "invoice_id" : self.invoice_id,
            "strip_ref" : self.invoice_id,
            "scheduled_date" : scheduleDate,
            "scheduled_date_text" : scheduleDate,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        FoodAPIManager.orderRequestAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.paymentInit = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func placeORderAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "invoice_id" : paymentInit?.invoiceID ?? "",
            "stripe_ref" : paymentInit?.paymentRef ?? ""
        ]
        StoreAPIManager.placeOrderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
               // Coordinator.goTThankYouPage(controller: self,vcType: "order",invoiceId: self.paymentInit?.invoiceID ?? "", order_id: self.paymentInit?.invoiceID ?? "", isFromFoodStore: true)
                self.orderID = self.paymentInit?.invoiceID ?? ""
                DispatchQueue.main.async {
                    let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                    controller.delegate = self
                    controller.heading = "Order placed successfully".localiz()
                    controller.confirmationText = "Please wait for confirmation".localiz()
                    controller.invoiceNumber = self.paymentInit?.invoiceID ?? ""
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
extension FoodCartViewController:FoodCartProductDelegate,ReceivingViewDelegate {
    func getCartCall() {
        self.getCartAPI()
    }
    func goBack(pickData: DelegateList?) {
        self.assignedDelegate.text = pickData?.deligateName ?? ""
        self.selectedDeligateId = "1"
        self.isAssigned = true
        if (isAssigned) {
            assigedView.isHidden = false
            RequestView.isHidden = true
        }else {
            assigedView.isHidden = true
            RequestView.isHidden = false
        }
    }
    
    func selectedPickupbyPerson(pickText: String?, id: String?) {
        
        self.assignedDelegate.text = pickText ?? ""
        self.assignValue = pickText ?? ""
        self.selectedDelegete = nil
        self.selectedDeligateId = id ?? ""
        self.isAssigned = true
        if (isAssigned) {
            assigedView.isHidden = false
            RequestView.isHidden = true
        }else {
            assigedView.isHidden = true
            RequestView.isHidden = false
        }
        if self.assignValue == "PICK UP IN PERSON"{
            self.deliveryChargeView.isHidden = true
        }else {
            self.deliveryChargeView.isHidden = false
        }
    }
}

extension FoodCartViewController:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        Constants.shared.isCommingFromOrderPopup = false
        SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: orderID, isSeller: false,isThankYouPage: true,assignValue: self.assignValue)
    }
}



extension FoodCartViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
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
        let screenWidth = screenSize.width-40
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
                self.selectedPaymentType  = "1"
            } else if self.selectedIndex == 1 {
                self.selectedPaymentType  = "4"
            } else if selectedIndex == 2 {
                self.selectedPaymentType  = "3"
            }
        self.payCollection.reloadData()
    }
}

extension FoodCartViewController {
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

extension Date {

    static func difference (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
extension FoodCartViewController: PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        self.PayNow()
    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        if isSuccess {
            self.orderRequestAPI()
        }
    }
}


//
//  BookingDetailsVC.swift
//  LiveMArket
//
//  Created by Zain on 17/01/2023.
//

import UIKit
import FloatRatingView
import FittedSheets
import Stripe
import goSellSDK
class UserCartVC: BaseViewController {
    
    @IBOutlet weak var promocodeErrorLabel: UILabel!
    @IBOutlet weak var taxView: UIView!
    @IBOutlet weak var deliveryChargeView: UIView!
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var addressTopLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var itemsChartLabel: UILabel!
    @IBOutlet weak var pCodeLabel: UILabel!
    @IBOutlet weak var billDteailsLabel: UILabel!
    @IBOutlet weak var itemTotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var taxChangeLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var paymentMethodsLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    
    var selectedDelegete : DelegateList?
    var selectedDeligateId:String = ""
    var appliedCoupon:String = ""
    var isPromoClicked:Bool = false
    var orderID:String = ""
    var assignValue = ""
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    var paymentSheet: PaymentSheet?
    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var paymentService:PaymentViaTapPayService!
    var balanceAmount: WalletHistoryData? {
        didSet {
        }
    }
    var total = 0.0
    var transID = ""

    
    var addressList : [List]? {
        didSet {
            self.addressView.isHidden  = true
            if addressList?.count ?? 0 > 0 {
                for (index,item) in addressList!.enumerated() {
                    if item.isDefault == "1" {
                        self.addressPrime = item
                        addressList?.remove(at: index)
                        self.addressView.isHidden = false
                        self.getCartAPI()
                        break
                    }else {
                        self.addressPrime = addressList?.first
                        self.addressView.isHidden = false
                        self.getCartAPI()
                    }
                }
            }else {
                self.getCartAPI()
            }
        }
    }
    
    var cart: checkOutData? {
        didSet {
            if cart?.items.count == 0 {
                for controller in self.navigationController!.viewControllers as Array{
                    if controller.isKind(of: ProductDetailsViewController.self) || controller.isKind(of: ShopDetailViewController.self){
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
            }
            self.itemTotal.text = "\(String(format: "%.2f", Double(cart?.cartTotal ?? "") ?? 0.0)) \("SAR".localiz())"
            self.deliveryCharges.text = "\(String(format: "%.2f", Double(cart?.deliveryCharge ?? "") ?? 0.0)) \("SAR".localiz())"
            self.taxCharges.text = "\(String(format: "%.2f", Double(cart?.tax ?? "") ?? 0.0)) \("SAR".localiz())"
            self.grandTotal.text = "\(String(format: "%.2f", Double(cart?.grandTotal ?? "") ?? 0.0)) SAR "
            self.total = Double(cart?.grandTotal ?? "0") ?? 0.0
            self.discountLbl.text = "\(String(format: "%.2f", Double(cart?.totalCouponDiscount ?? "") ?? 0.0)) \("SAR".localiz())"
            if cart?.couponAppliedStatus == "1" {
                self.couponApply.setTitle("Remove".localiz(), for:.normal)
                self.couponField.isUserInteractionEnabled = false
            }else {
                self.couponApply.setTitle("Apply".localiz(), for:.normal)
                self.couponField.isUserInteractionEnabled = true
            }
            
            if cart?.deliveryCharge ?? "" == "0"{
                deliveryChargeView.isHidden = true
            }else{
                if self.assignValue == "PICK UP IN PERSON"{
                    self.deliveryChargeView.isHidden = true
                }else {
                    self.deliveryChargeView.isHidden = false
                }
            }
            
            if cart?.tax ?? "" == "0"{
                taxView.isHidden = true
            }else{
                taxView.isHidden = false
            }
            if cart?.totalCouponDiscount ?? "" == "0"{
                discountView.isHidden = true
            }else{
                discountView.isHidden = false
            }
            
            
            setData()
        }
    }

    var cardToken:String?
    var payment : OTabTransaction? {
        didSet {
             if self.selectedPaymentType == "1" {
                paymentService.paymentResponse = payment
            } else {
                self.placeORderAPI()
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
        configLanguage()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .notifications
        viewControllerTitle = "Cart".localiz()
        self.setPayCollectionCell()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.cardToken == nil {
            getBalance()
        }
    }
    
    override func backButtonAction() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ShopDetailViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
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
        if self.cardToken == nil {
            self.getAdressAPI()
        }

        if let data = selectedDelegete{
            self.assignedDelegate.text = data.deligateName
            self.selectedDeligateId = data.id
        }
        ///self.getCartAPI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func configLanguage(){
        addressTopLabel.text = "Address".localiz()
        changeButton.setTitle("Change".localiz(), for: .normal)
        itemsChartLabel.text = "Items in cart".localiz()
        pCodeLabel.text = "Promotional Code".localiz()
        billDteailsLabel.text = "Bill Details".localiz()
        itemTotalLabel.text = "Item Total ".localiz()
        discountLabel.text = "Discount".localiz()
        deliveryChargeLabel.text = "Delivery Charge".localiz()
        taxChangeLabel.text = "Tax Charge".localiz()
        paymentType.text = "Payment Type".localiz()
        grandTotalLabel.text = "Grand Total".localiz()
        paymentMethodsLabel.text = "  Payment Methods".localiz()
        placeOrderButton.setTitle("Place your order".localiz(), for: .normal)
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
        //self.tbl.register(BookingProductCell.nib, forCellReuseIdentifier: BookingProductCell.identifier)
        self.tbl.register(BookingProductCellAdjusted.nib, forCellReuseIdentifier: BookingProductCellAdjusted.identifier)
        tbl.reloadData()
        self.tbl.layoutIfNeeded()
    }
    
    @IBAction func requestADelegate(_ sender: UIButton) {
        self.goTORequest()
    }
    func goTORequest() {
        let  VC = AppStoryboard.ReceivingOption.instance.instantiateViewController(withIdentifier: "ReceivingViewController") as! ReceivingViewController
        VC.delegate = self
        cardToken = nil
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func placeOrderPressed(_ sender: UIButton) {
        
        if self.addressPrime == nil {
            Utilities.showQuestionAlert(message: "Please add address".localiz()) {
                self.cardToken = nil
                if self.addressList?.count ?? 0 > 0{

                    SellerOrderCoordinator.goToAddressVC(controller: self)
                }else{
                    SellerOrderCoordinator.goToAddNewAddress(controller: self, isEdit: false)
                }
                
            }
        }else if self.selectedDeligateId == "" {
            Utilities.showQuestionAlert(message: "Please select receiving option".localiz()) {
                self.cardToken = nil
                self.goTORequest()
            }
        }
        else if self.selectedPaymentType == "" {
            Utilities.showWarningAlert(message: "Please select payment option".localiz()) {
                
                self.cardToken = nil
            }
        }else {
            self.paymentInitAPI()
        }
//        }else {
//            self.paymentInitAPI()
//        }
        
        //  Coordinator.goTThankYouPage(controller: self,vcType: "order")
    }
    @IBAction func changeAdd(_ sender: UIButton) {
        
        SellerOrderCoordinator.goToAddressVC(controller: self)
    }
    @IBAction func Apply(_ sender: UIButton) {
        if cart?.couponAppliedStatus == "1" {
            self.couponField.text = ""
        }else {
            
        }
        Constants.shared.appliedCoupon = self.couponField.text ?? ""
        isPromoClicked = true
        self.getCartAPI()
    }
    
}
// MARK: - TableviewDelegate
extension UserCartVC : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart?.items.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let notificationCell = self.tbl.dequeueReusableCell(withIdentifier: BookingProductCell.identifier, for: indexPath) as! BookingProductCell
        let notificationCell = self.tbl.dequeueReusableCell(withIdentifier: BookingProductCellAdjusted.identifier, for: indexPath) as! BookingProductCellAdjusted
        notificationCell.productList = cart?.items[indexPath.row]
        notificationCell.setdate()
        notificationCell.delegate = self
        notificationCell.baseVc = self
        notificationCell.selectionStyle = .none
        return notificationCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
extension UserCartVC {
    func getCartAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "coupon_code" : Constants.shared.appliedCoupon,
            "request_deligate" : self.selectedDelegete?.id ?? "",
            "address_id" :self.addressPrime?.id ?? ""
        ]
        print("sdfsdf \(parameters)")
        StoreAPIManager.checkOutAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.cart = result.oData
                self.promocodeErrorLabel.text = ""
            default:
                Constants.shared.appliedCoupon = ""
                if self.isPromoClicked{
                    if let msg =  result.errors?.coupon_code{
                        self.promocodeErrorLabel.text = msg.first ?? ""
                    }else{
                        Utilities.showWarningAlert(message: result.message ?? "") {
                        }
                    }
                    
                }else{
                    self.cart?.items.removeAll()
                    self.tbl.reloadData()
                    Utilities.showWarningAlert(message: result.message ?? "") {
                   
                    }
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
                self.getCartAPI()
            }
        }
    }
    func cleartAll() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? ""
        ]
        StoreAPIManager.clearCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.navigationController?.popViewController(animated: true)
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func paymentInitAPI() {
        if selectedPaymentType == "1" {
            paymentService.startPaymentViaSellSDK(amount: Decimal(floatLiteral: Double(self.total)))
        } else if selectedPaymentType == "4" {
            paymentService.startApplePaymentViaSellSDK(amount:  Double(self.total))
        } else if selectedPaymentType == "3" {
            if ((Float(self.total) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0))){
                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    self.cardToken = nil
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                self.PayNow()
            }
        }

     
        /*
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "payment_type" : "2",
            "address_id" : self.addressPrime?.id ?? "",
            "coupon_code" : Constants.shared.appliedCoupon,
            "request_deligate" : self.selectedDeligateId 
        ]
        print(parameters)
        StoreAPIManager.paymentInitAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.paymentInit = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
         */
    }

    func PayNow() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "payment_type" : self.selectedPaymentType,
            "address_id" : self.addressPrime?.id ?? "",
            "coupon_code" : Constants.shared.appliedCoupon,
            "request_deligate" : self.selectedDeligateId,
            "token_id": cardToken  ?? ""
        ]
        print(parameters)
        StoreAPIManager.paymentInitAPI(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.transID = result.oData?.payment_ref ?? ""
                    if result.oData?.oTabTransaction == nil {
                        self.placeORderAPI()
                    } else {
                        self.transID = result.oData?.payment_ref ?? ""
                        self.payment = result.oData?.oTabTransaction
                    }
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
            "invoice_id" : transID,
            "stripe_ref" : transID,
            "payment_type" : self.selectedPaymentType,
        ]
        StoreAPIManager.placeOrderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Constants.shared.appliedCoupon = ""
                self.orderID = result.oData?.order_id ?? ""
                DispatchQueue.main.async {
                    let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                    controller.delegate = self
                    controller.heading = "Order placed successfully".localiz()
                    controller.confirmationText = "Please wait for confirmation".localiz()
                    controller.invoiceNumber = result.oData?.invoice_id ?? ""
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
extension UserCartVC:BookingProductDelegate,ReceivingViewDelegate {
    func getCartCall() {
        self.getCartAPI()
    }
    func goBack(pickData: DelegateList?) {
        self.assignedDelegate.text = pickData?.deligateName ?? ""
        self.selectedDeligateId = pickData?.id ?? ""
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
    }
}


extension UserCartVC:UITextFieldDelegate{
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        //            if let text = textField.text,
        //               let textRange = Range(range, in: text) {
        //               let updatedText = text.replacingCharacters(in: textRange,
        //                                                           with: string)
        //                if updatedText == ""{
        //                    self.promocodeErrorLabel.text = ""
        //                }
        //                Constants.shared.appliedCoupon = text
        //            }
        
        if let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            print("Full Text:", updatedText)
            if updatedText == ""{
                self.promocodeErrorLabel.text = ""
            }
            //Constants.shared.appliedCoupon = updatedText
        }
        
        return true
    }
    
    
}
extension UserCartVC:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: orderID,isSeller: false, isThankYouPage: true,assignValue: self.assignValue)
    }
}


extension UserCartVC: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
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
            self.selectedPaymentType = "1"
        } else if self.selectedIndex == 1 {
            self.selectedPaymentType = "4"
        } else if  self.selectedIndex == 2 {
            self.selectedPaymentType = "3"
        }
        self.payCollection.reloadData()
    }
}

extension UserCartVC {
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

extension UserCartVC: PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        self.PayNow()
    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        if isSuccess {
            self.placeORderAPI()
        }
    }
}

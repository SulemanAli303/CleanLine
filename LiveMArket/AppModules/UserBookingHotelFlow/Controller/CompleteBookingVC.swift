//
//  ChaletCartVC.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit
import FittedSheets
import Stripe
import goSellSDK
class CompleteBookingVC: BaseViewController {
    
    var facilityArray:[Facilities] = []
    
    @IBOutlet weak var couponAmountView: UIView!
    @IBOutlet weak var couponAmountLable: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var taxChargeLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var promoCodeTextField: UITextField!
    
    @IBOutlet weak var facilityCollectionView: UICollectionView!
    
    @IBOutlet weak var adultsCountLabel: UILabel!
    @IBOutlet weak var childAboveCountLabel: UILabel!
    @IBOutlet weak var childBelowCountLabel: UILabel!
    @IBOutlet weak var roomCountLabel: UILabel!
    
    @IBOutlet weak var scheduleDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var roomNumber: UILabel!
    
    var isPromoClicked :Bool = false
    var bookingID:String = ""
    var paymentService:PaymentViaTapPayService!

    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    var paymentSheet: PaymentSheet?
    var balanceAmount: WalletHistoryData? {
        didSet {
        }
    }
    var cardToken:String?
    var paymentInit : PaymentResponse? {
        didSet {
            paymentService.paymentResponse = paymentInit?.oTabTransaction
        }
    }
    
    var total = 0.0
    var transID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .backWithTop
        viewControllerTitle = "Complete Booking".localiz()
        
        facilityCollectionView.delegate = self
        facilityCollectionView.dataSource = self
        
        facilityCollectionView.register(UINib.init(nibName: "FacilityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FacilityCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = CGSize(width: 90, height: 60)
        self.facilityCollectionView.collectionViewLayout = layout
        self.facilityCollectionView.reloadData()
        self.facilityCollectionView.layoutIfNeeded()
        
        self.setPayCollectionCell()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBalance()
    }
    
    func setPayCollectionCell() {
        
        let vcObject = CompleteBookingCollectionDataSource.shared
        
        payCollection.delegate = vcObject
        payCollection.dataSource = vcObject
        payCollection.register(UINib.init(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        payCollection.reloadData()
        self.payCollection.layoutIfNeeded()
        vcObject.payCollection = payCollection
    }
    
    var placeOrderData:GroundPlaceOrderData?{
        didSet{
            self.bookingID = placeOrderData?.booking_id ?? ""
            DispatchQueue.main.async {
                let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                controller.delegate = self
                controller.heading = "Order placed successfully".localiz()
                controller.confirmationText = "Please wait for confirmation".localiz()
                controller.invoiceNumber = self.placeOrderData?.invoice_id ?? ""
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
    
    var data:HotelCheckOutData?{
        
        didSet{
            
            facilityArray = data?.booking?.room?.facilities ?? []
            priceLabel.text = (data?.booking?.room?.price ?? "") + "/\("Per Day".localiz())"
            roomNumber.text = data?.booking?.room?.name ?? ""
            scheduleDateLabel.text = "\(data?.booking?.start_date ?? "") - \(data?.booking?.end_date ?? "")"
            
            subTotalLabel.text = "\(data?.currency_code ?? "") \(data?.subtotal ?? "")"
            serviceChargeLabel.text = "\(data?.currency_code ?? "") \(data?.service_charges ?? "")"
            taxChargeLabel.text = "\(data?.currency_code ?? "") \(data?.tax_amount ?? "")"
            grandTotalLabel.text = "\(data?.currency_code ?? "") \(data?.grand_total ?? "")"
            self.total = Double(data?.grand_total ?? "0") ?? 0.0
            adultsCountLabel.text = data?.booking?.adults ?? "0"
            childAboveCountLabel.text = data?.booking?.children_above_two ?? "0"
            childBelowCountLabel.text = data?.booking?.children_below_two ?? "0"
            roomCountLabel.text = data?.booking?.room_count ?? "0"
            
            if data?.coupon_applied == "1"{
                self.couponAmountLable.text = "\(data?.currency_code ?? "") \(data?.coupon_discount ?? "")"
                self.couponAmountView.isHidden = false
            }else{
                self.couponAmountView.isHidden = true
            }
            DispatchQueue.main.async {
                self.facilityCollectionView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        if cardToken == nil {
            self.checkoutAPI(coupon: "")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    @IBAction func editButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ApplyButtonAction(_ sender: UIButton) {
        guard self.promoCodeTextField.text != "" else {
            return
        }
        self.isPromoClicked = true
        checkoutAPI(coupon: self.promoCodeTextField.text)
    }
    @IBAction func PlaceOrder(_ sender: UIButton) {
        paymentService.invoiceId = "\(SessionManager.getCartId() ?? "")_\(Date().debugDescription)"
        let vcObject = CompleteBookingCollectionDataSource.shared
        if vcObject.selectedPaymentType == "1" {
            paymentService.startPaymentViaSellSDK(amount: Decimal.init(total))
        } else if vcObject.selectedPaymentType == "4" {
            paymentService.startApplePaymentViaSellSDK(amount: Double(total) ?? 0)
        } else if vcObject.selectedPaymentType == "3" {
            if ((Float(self.total) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0))){
                Utilities.showSuccessAlert(message: "Insufficient wallet balance") {
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                self.paymentInitAPI()
            }
        }
            //
    }
    
    func paymentInitAPI(){
        
        let vcObject = CompleteBookingCollectionDataSource.shared
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "payment_type" : vcObject.selectedPaymentType,
            "token_id": cardToken  ?? ""
        ]
        print(parameters)
        StoreAPIManager.paymentInitAPIForRooms(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.paymentInit = result.oData
                    self.transID = result.oData?.payment_ref ?? ""
                    if result.oData?.oTabTransaction?.redirect == nil {
                        self.roomPlaceOrderAPI()
                    }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension CompleteBookingVC {
   
    func checkoutAPI(coupon:String?) {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" :  SessionManager.getCartId() ?? "",
            "coupon_code":coupon ?? ""
        ]
        StoreAPIManager.roomCheckOutAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.data = result.oData
            default:
                if self.isPromoClicked{
                    self.isPromoClicked = false
                    if let msg =  result.errors{
                        Utilities.showWarningAlert(message: msg.coupon_code?.first ?? "") {
                        }
                    }else{
                        Utilities.showWarningAlert(message: result.message ?? "") {
                        }
                    }
                    
                }else{
                    Utilities.showWarningAlert(message: result.message ?? "") {
                    }
                }
            }
        }
    }
    
    func roomPlaceOrderAPI() {
        
        let vcObject = CompleteBookingCollectionDataSource.shared
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" :  SessionManager.getCartId() ?? "",
            "coupon_code" : Constants.shared.appliedCoupon,
            "payment_type": vcObject.selectedPaymentType,
            "invoice_id":  self.paymentInit?.invoice_id ?? "",
            "temp_order_id": self.paymentInit?.temp_order_id ?? "",
            "transaction_ref": self.paymentInit?.payment_ref ?? ""
        ]
        StoreAPIManager.roomPlaceOrderAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.placeOrderData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                }
            }
        }
    }
}
extension CompleteBookingVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.facilityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCollectionViewCell", for: indexPath) as? FacilityCollectionViewCell else { return UICollectionViewCell() }
        cell.iconImageView.sd_setImage(with: URL(string: facilityArray[indexPath.row].icon ?? ""), placeholderImage:UIImage(named: "placeholder_profile"))
        cell.nameLabel.text = facilityArray[indexPath.row].name ?? ""
        return cell
    }
}
extension CompleteBookingVC:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
       // Coordinator.goToHotelBookingThanks(controller: self, step: "1",invoiceID: placeOrderData?.invoice_id ?? "", bookingID: placeOrderData?.booking_id ?? "")
        Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: false,booking_ID: self.bookingID,isFromThankYou: true)
    }
}

extension CompleteBookingVC {
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


extension CompleteBookingVC: PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        paymentInitAPI()
    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        if isSuccess {
            self.roomPlaceOrderAPI()
        }
    }
}

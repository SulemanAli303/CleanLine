//
//  ChaletCartVC.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit
import FittedSheets
import goSellSDK
class ChaletCartVC: BaseViewController {
    
    
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var collectionFacilitiesView: UICollectionView!
    @IBOutlet weak var itemsTotal: UILabel!
    @IBOutlet weak var deliveryTotal: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var grand: UILabel!
    @IBOutlet weak var promoField: UITextField!
    @IBOutlet weak var promoBtn: UIButton!
    @IBOutlet weak var discount: UILabel!
    var bookingID:String = ""
    var vcType:String?
    
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    var balanceAmount: WalletHistoryData? {
        didSet {
        }
    }
    
    var cardToken:String?
    var paymentInit : PaymentResponse? {
        didSet {
            let selectedPaymentType = ChalletsPaymentCollectionDataSouce.shared.selectedPaymentType
            if selectedPaymentType == "1" {
                paymentService.paymentResponse = paymentInit?.oTabTransaction
            } else {
                self.createBookingAPI()
            }
        }
    }
    
    var total = 0.0
    var paymentService:PaymentViaTapPayService!
    var checkOutData : ChaletsCheckOutData? {
        didSet {
            self.discount.isHidden = true
            self.discountView.isHidden = true
            self.name.text = checkOutData?.product_name ?? ""
            self.currency.text = checkOutData?.currency_code ?? ""
            self.price.text = " \((Double(checkOutData?.product_price ?? "") ?? 0.0))"
            self.itemsTotal.text = "\(checkOutData?.currency_code ?? "") \((Double(checkOutData?.subtotal ?? "") ?? 0.0))"
            self.deliveryTotal.text = "\(checkOutData?.currency_code ?? "") \((Double(checkOutData?.service_charges ?? "") ?? 0.0))"
            self.tax.text = "\(checkOutData?.currency_code ?? "") \((Double(checkOutData?.tax_charges ?? "") ?? 0.0))"
            self.grand.text = "\(checkOutData?.currency_code ?? "") \((Double(checkOutData?.total_amount ?? "") ?? 0.0))"
            
            self.total = Double(checkOutData?.total_amount ?? "0") ?? 0.0

            self.discount.text = "\(checkOutData?.currency_code ?? "") 0.0"
            self.date.text = checkOutData?.schedule ?? ""
            setFacilites()
            if self.promoField.isUserInteractionEnabled == false {
                self.applyPromo()
            }
        }
    }
    var promoData : ChaletsPromoData? {
        didSet {
            self.discount.isHidden = true
            self.discountView.isHidden = true
            self.itemsTotal.text = "\(checkOutData?.currency_code ?? "") \((Double(promoData?.subtotal ?? "") ?? 0.0))"
            self.deliveryTotal.text = "\(checkOutData?.currency_code ?? "") \((Double(promoData?.service_charges ?? "") ?? 0.0))"
            self.tax.text = "\(checkOutData?.currency_code ?? "") \((Double(promoData?.tax_amount ?? "") ?? 0.0))"
            self.discount.text = "\(checkOutData?.currency_code ?? "") \((Double(promoData?.coupon_discount ?? "") ?? 0.0))"
            
            if (Double(promoData?.coupon_discount ?? "") ?? 0.0) > 0.0 {
                self.discount.isHidden = false
                self.discountView.isHidden = false
            }
            
            self.grand.text = "\(checkOutData?.currency_code ?? "") \((Double(promoData?.grand_total ?? "") ?? 0.0))"
            
            self.total = Double(promoData?.grand_total ?? "0") ?? 0.0

            if (promoData?.coupon_applied ?? "") == "1" {
                self.promoField.isUserInteractionEnabled = false
                self.promoBtn.setTitle("Remove".localiz(), for: .normal)
            }else {
                self.promoField.isUserInteractionEnabled = true
                self.promoBtn.setTitle("Apply".localiz(), for: .normal)
            }
        }
    }
    
    var bookingData : ChaletsCreateBookingData? {
        didSet {
            //Coordinator.goToChaletThanks(controller: self,step: "1",chaletID: bookingData?.booking_id ?? "", invoiceId: bookingData?.invoice_number ?? "")
            self.bookingID = bookingData?.booking_id ?? ""
            DispatchQueue.main.async {
                let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                controller.delegate = self
                controller.heading = "Order placed successfully".localiz()
                controller.confirmationText = "Please wait for confirmation".localiz()
                controller.invoiceNumber = self.bookingData?.invoice_number ?? ""
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
    
    var chaletID = ""
    var startDate = ""
    var endDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .backWithTop
        viewControllerTitle = "Complete Booking".localiz()
        self.setPayCollectionCell()
    }
    
    func setPayCollectionCell() {
        
        let vcObject = ChalletsPaymentCollectionDataSouce.shared
        
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
        vcObject.payCollection = payCollection
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBalance()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.chaletCheckOutAPI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    @IBAction func PlaceOrder(_ sender: UIButton) {

        let vcObject = ChalletsPaymentCollectionDataSouce.shared
        paymentService.invoiceId = "\(SessionManager.getCartId() ?? "")_\(Date().debugDescription)"
        if vcObject.selectedPaymentType == "1" {
            paymentService.startPaymentViaSellSDK(amount: Decimal.init(total))
        } else if vcObject.selectedPaymentType == "4" {
            paymentService.startApplePaymentViaSellSDK(amount: Double(total) ?? 0)
        } else if vcObject.selectedPaymentType == "3" {
            if ((Float(self.total) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0))){
                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                self.paymentInitAPI()
            }
        } else {
            self.paymentInitAPI()
        }
    }
       

    
    func paymentInitAPI(){
        
        let vcObject = ChalletsPaymentCollectionDataSouce.shared
        let parameters:[String:String] = [
            "start_date_time" : self.startDate,
            "end_date_time" : self.endDate,
            "invoice_id": self.paymentInit?.invoice_id ?? "",
            "transaction_ref": self.paymentInit?.payment_ref ?? "",
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "payment_type" : vcObject.selectedPaymentType,
            "reservation_product_id" : chaletID,
            "token_id": self.cardToken  ?? ""
        ]
        print(parameters)
        StoreAPIManager.paymentInitAPIForChalets(parameters: parameters) { result in
            switch result.status {
            case "1":
                    self.paymentInit = result.oData
                    if result.oData?.oTabTransaction == nil {
                        self.createBookingAPI()
                    }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    @IBAction func goTocalender(_ sender: UIButton) {
        self.goBack()
    }
    func goBack(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DateAndCalanderVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    @IBAction func goList(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ChaletsListVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
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
    @IBAction func apply(_ sender: UIButton) {
        if promoField.isUserInteractionEnabled == false {
            self.promoField.text = ""
            self.applyPromo()
        }else {
            if promoField.text?.trimmingCharacters(in: .whitespaces) == "" {
                Utilities.showQuestionAlert(message: "Enter valid promo code".localiz())
            }else {
                self.applyPromo()
            }
        }
    }
}
extension ChaletCartVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.checkOutData?.facilities?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventFaclitiesCell", for: indexPath) as? EventFaclitiesCell else { return UICollectionViewCell() }
        
        cell.name.text! = self.checkOutData?.facilities?[indexPath.row].name ?? ""
        cell.img.sd_setImage(with: URL(string: "\( self.checkOutData?.facilities?[indexPath.row].icon ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
        
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



extension ChaletCartVC {
    func chaletCheckOutAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "reservation_product_id" : self.chaletID,
            "start_date_time" : self.startDate,
            "end_date_time" : self.endDate,
            "device_cart_id" : SessionManager.getCartId() ?? ""
        ]
        CharletAPIManager.charletCheckoutAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.checkOutData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "", okayHandler: {
                    self.goBack()
                })
            }
        }
    }
    
    func createBookingAPI() {

        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "reservation_product_id" : self.chaletID,
            "start_date_time" : self.startDate,
            "end_date_time" : self.endDate,
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "invoice_id": self.paymentInit?.invoice_id ?? "",
            "transaction_ref": self.paymentInit?.payment_ref ?? "",
            "temp_order_id": self.paymentInit?.temp_order_id ?? ""
        ]
        CharletAPIManager.charletCreateBookingAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.bookingData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func applyPromo() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "coupon_code" : self.promoField.text ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? ""
        ]
        CharletAPIManager.charletPromoAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.promoData = result.oData
            default:
                Utilities.showWarningAlert(message: result.errors?.couponCode?.first ?? "") {
                    
                }
            }
        }
    }
}

extension ChaletCartVC:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        Coordinator.goToChaletRequestDetails(controller: self,step: vcType ?? "1",chaletID: self.bookingID,isFromThankPage: true)
    }
}


extension ChaletCartVC {
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
extension ChaletCartVC:PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithPaymentCharge(_ isSuccess: Bool) {
        if isSuccess {
            self.createBookingAPI()
        }
    }
    
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        self.paymentInitAPI()

    }
}

//
//  CompleteBookingViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 27/01/2023.
//

import UIKit
import FittedSheets
import Stripe
import goSellSDK
class CompleteBookingViewController: BaseViewController {

    @IBOutlet weak var grandtotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var totalAmoutLabel: UILabel!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    @IBOutlet weak var timeSlotsCollectionView: IntrinsicCollectionView!
    


    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    var selectedPaymentType = "1"
    var paymentService:PaymentViaTapPayService!
    var paymentRef = ""
    var invoiceID = ""



    var balanceAmount: WalletHistoryData? {
        didSet {
            //self.payCollection.reloadData()
        }
    }
    var total = 0.0
    var transID = ""

    var cardToken:String?
    var paymentInit : PaymentResponse? {
        didSet {
            if self.selectedPaymentType == "1"  {
                paymentService.paymentResponse = paymentInit?.oTabTransaction
            } else {
                self.placeOrderAPI()
            }
        }
    }
    var bookingID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        type = .backWithTop
        viewControllerTitle = "Complete Booking".localiz()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setPayCollectionCell()

        getBalance()
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
        
        timeSlotsCollectionView.delegate = self
        timeSlotsCollectionView.dataSource = self
        timeSlotsCollectionView.register(UINib.init(nibName: "OptionsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "OptionsCollectionCell")
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2
        self.timeSlotsCollectionView.collectionViewLayout = layout1
        self.timeSlotsCollectionView.layoutIfNeeded()
        
        payCollection.reloadData()
        self.payCollection.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        type = .backWithTop
        viewControllerTitle = "Complete Booking".localiz()
        super.viewWillAppear(animated)
        if cardToken == nil {
            self.checkOutAPI()
        }
    }
    
    var data : GroundCheckOutData?{
        didSet{
            self.bookingID = data?.booking?.id ?? ""
            scheduleDateLabel.text = data?.booking?.date ?? ""
            scheduleTimeLabel.text = data?.booking?.slot_value ?? ""
            totalAmoutLabel.text = "\(data?.currency_code ?? "") \(data?.subtotal ?? "")"
            serviceChargeLabel.text = "\(data?.currency_code ?? "") \(data?.service_charges ?? "")"
            taxLabel.text = "\(data?.currency_code ?? "") \(data?.tax_amount ?? "")"
            grandtotalLabel.text = "\(data?.currency_code ?? "") \(data?.grand_total ?? "")"
            self.total = Double(data?.grand_total ?? "0") ?? 0.0

            self.timeSlotsCollectionView.reloadData()
        }
    }
    
    var placeOrderData : GroundPlaceOrderData?{
        didSet{
           // Coordinator.goTThankYouPage(controller: self, vcType: "", invoiceId: placeOrderData?.invoice_id ?? "", order_id: placeOrderData?.booking_id ?? "", isFromFoodStore: false,isFromPlayGround: true)
            
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
    

    @IBAction func editButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func placeRequest(_ sender: UIButton) {
        
       // placeOrderAPI()
        if self.selectedPaymentType == "" {
            Utilities.showWarningAlert(message: "Please select payment option".localiz()) {
                
            }
            return
        }else {
            self.paymentInitAPI()
        }
    }
    
    func paymentInitAPI() {
        paymentService.invoiceId = "\(SessionManager.getCartId() ?? "")_\(Date().debugDescription)"
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
            }else {
                self.BookNow()
            }
        }
    }

    func BookNow() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "payment_type" : selectedPaymentType,
            "booking_id" : self.bookingID,
            "token_id": cardToken  ?? ""
        ]
        print(parameters)
        StoreAPIManager.paymentInitAPIForPlayground(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.transID = result.oData?.payment_ref ?? ""
                    self.paymentInit = result.oData
                    if result.oData?.oTabTransaction == nil {
                        self.placeOrderAPI()
                    }
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {

                    }
            }
        }
    }

}

extension CompleteBookingViewController{
    func checkOutAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        StoreAPIManager.playGroundCheckOutAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.data = result.oData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func placeOrderAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "invoice_id" : self.paymentInit?.payment_ref ?? "",
            "transaction_ref" : self.paymentInit?.payment_ref ?? "",
            "payment_type" : selectedPaymentType,
            "temp_order_id": self.paymentInit?.temp_order_id ?? "",
        ]
        print(parameters)
        StoreAPIManager.playGroundPlaceOrderAPI(parameters: parameters) { result in
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
extension CompleteBookingViewController:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: false,booking_ID: self.bookingID,isFromThankYou: true)
    }
}


extension CompleteBookingViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == timeSlotsCollectionView {
            return self.data?.booking?.slot_lists?.count ?? 0
        } else if collectionView == payCollection {
            return imageArray.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == timeSlotsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCollectionCell", for: indexPath) as? OptionsCollectionCell else { return UICollectionViewCell() }
            cell.isUserInteractionEnabled = false
            cell.timeSlotValue = self.data?.booking?.slot_lists?[indexPath.row].slot_value_text ?? ""
            cell.namelbl.textColor = UIColor.white
            cell.baseView.backgroundColor = UIColor(hex: "#DA591F")
            cell.baseView.layer.cornerRadius = 14
            cell.baseView.clipsToBounds = true
            return cell
        } else {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == timeSlotsCollectionView {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-30
            return CGSize(width: screenWidth/3, height:30)
        } else {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-40
            return CGSize(width: screenWidth/2.08, height:70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if (collectionView == timeSlotsCollectionView){
            return 5.0
        }else {
            return 0.0
        }
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

extension CompleteBookingViewController {
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
extension CompleteBookingViewController:PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        BookNow()
    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        if isSuccess {
            self.placeOrderAPI()
        }
    }
}

//
//  TableBookingPlace.swift
//  LiveMArket
//
//  Created by Zain on 23/09/2023.
//

import UIKit
import FittedSheets
import KMPlaceholderTextView
import goSellSDK
class TableBookingPlace: BaseViewController {
    
    @IBOutlet weak var billDetailsLabel: UILabel!
    @IBOutlet weak var itemTotalLabel: UILabel!
    @IBOutlet weak var taxChargeLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var placeRequestButton: UIButton!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var grandTotalLBL: UILabel!
    
    @IBOutlet weak var dst: KMPlaceholderTextView!
    @IBOutlet weak var perferType: UILabel!
    @IBOutlet weak var timeSlotLabel: UILabel!
    @IBOutlet weak var personCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!

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
    var orderID:String = ""
    var storeID:String  = ""
    
    var shopData:SellerData?
    var timeSlot:Slot_list?
    var postionTbl : Postionlist? {
        didSet {
            
        }
    }

    var cardToken:String?
    var paymentInit : PaymentResponse? {
        didSet {
            if selectedPaymentType == "1" {
                paymentService.paymentResponse = paymentInit?.oTabTransaction
            } else {
                self.placeRequestAPI()
            }
        }
    }
    var personCount:String = ""
    var selectedDate:String = ""
    var bookingID:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        configureLanguage()
        paymentService = PaymentViaTapPayService(delegate: self, controller: self)
        viewControllerTitle = "Complete Booking".localiz()
        self.setPayCollectionCell()
    }
    override func viewWillAppear(_ animated: Bool) {
     
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        timeSlotLabel.text = timeSlot?.slot_text ?? ""
        personCountLabel.text = "\(personCount) \("Person".localiz())"
        dateLabel.text = selectedDate
        addressLabel.text = shopData?.user_location?.location_name ?? ""
        perferType.text = postionTbl?.positionName ?? ""
        
        let aData = TableBookingBillingData.shared
        priceLbl.text = aData.service_charge
        taxLbl.text = aData.tax
        grandTotalLBL.text = aData.currency_code + " " + aData.grand_total
        
        self.total = Double(aData.grand_total) ?? 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getBalance()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    func configureLanguage(){
        billDetailsLabel.text = "Bill Details".localiz()
        itemTotalLabel.text = "Item Total".localiz()
        taxChargeLabel.text = "Tax Charge".localiz()
        grandTotalLabel.text = "Grand Total".localiz()
        paymentMethodLabel.text = "Payment Methods".localiz()
        placeRequestButton.setTitle("Place your Request".localiz(), for: .normal)
        
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
    
    var placeBookingData:TableBookingPlaceData?{
        didSet{
            print(placeBookingData)
            self.bookingID = placeBookingData?.id ?? ""
            DispatchQueue.main.async {
                let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
                controller.delegate = self
                controller.heading = "Order placed successfully".localiz()
                controller.confirmationText = "Please wait for confirmation".localiz()
                controller.invoiceNumber = self.placeBookingData?.invoice_id ?? ""
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
    
    @IBAction func addresButtonAction(_ sender: Any) {
        // Create an alert controller
        let alertController = UIAlertController(title: "Select Map".localiz(), message: "", preferredStyle: .alert)
        
        // Add an action (button) to the alert
        let appleAction = UIAlertAction(title: "Apple Map".localiz(), style: .default) { (action) in
            // Handle the "OK" button tap if needed
            self.navigateAppleMap(lat: self.shopData?.user_location?.lattitude ?? "", longi: self.shopData?.user_location?.longitude ?? "")
        }
        alertController.addAction(appleAction)
        let googleAction = UIAlertAction(title: "Google Map".localiz(), style: .default) { (action) in
            self.navigateGoogleMap(lat: self.shopData?.user_location?.lattitude ?? "", longi: self.shopData?.user_location?.longitude ?? "")
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
    
    
    @IBAction func eidtButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func placeOrder(_ sender: UIButton) {
        self.paymentInitAPI()
    }

    
    func paymentInitAPI() {
        paymentService.invoiceId = self.placeBookingData?.invoice_id ?? ""
        if selectedIndex == 0 {
            selectedPaymentType = "1"
            paymentService.startPaymentViaSellSDK(amount: Decimal.init(self.total))
        } else if selectedIndex == 1 {
            selectedPaymentType = "4"
            paymentService.startApplePaymentViaSellSDK(amount: Double(total) ?? 0)
        } else if selectedIndex == 2 {
            selectedPaymentType = "3"
            if ((Float(self.total) > (Float(self.balanceAmount?.balance ?? "") ?? 0.0))){
                Utilities.showSuccessAlert(message: "Insufficient wallet balance".localiz()) {
                    Coordinator.gotoRecharge(controller: self)
                }
            } else {
                BookNow()
            }
        }
    }
    func BookNow() {

        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "payment_type" : self.selectedPaymentType,
            "store_id" : shopData?.id ?? "",
            "date":selectedDate,
            "no_of_person":personCount,
            "booking_from":timeSlot?.slot_from ?? "",
            "booking_to":timeSlot?.slot_to ?? "",
            "table_possition_id" : self.postionTbl?.id ?? "",
            "address_id":"0",
            "description" : self.dst.text ?? "",
            "token_id": self.cardToken  ?? ""
        ]
        print(parameters)
        FoodAPIManager.orderTableBookingPayInit(parameters: parameters) { result in
            switch result.status {
                case "1":
                    self.paymentInit = result.oData
                    self.transID = result.oData?.payment_ref ?? ""
                    if result.oData?.oTabTransaction == nil {
                        self.placeRequestAPI()
                    }

                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                    }
            }
        }
    }

//    func navigateGoogleMap(lat:String, longi:String){
//        if let url = URL(string: "comgooglemaps://?q=\(lat),\(longi)") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                // Handle the case where Google Maps is not installed.
//            }
//        }
//    }
//    
//    func navigateAppleMap(lat:String, longi:String){
//        if let url = URL(string: "http://maps.apple.com/?q=\(lat),\(longi)") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                // Handle the case where Apple Maps is not available.
//            }
//        }
//    }
    
}
extension TableBookingPlace{
    func placeRequestAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "store_id" : shopData?.id ?? "",
            "date":selectedDate,
            "no_of_person":personCount,
            "booking_from":timeSlot?.slot_from ?? "",
            "booking_to":timeSlot?.slot_to ?? "",
            "table_possition_id" : self.postionTbl?.id ?? "",
            "address_id":"0",
            "invoice_id": self.paymentInit?.invoice_id ?? "",
            "description" : self.dst.text ?? "",
            "temp_order_id": self.paymentInit?.temp_order_id ?? "",
            "transaction_ref": self.paymentInit?.payment_ref ?? ""
        ]
        print(parameters)
        StoreAPIManager.tabelBookingPlaceAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.placeBookingData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension TableBookingPlace:SuccessProtocol{
    func navigateOrderDetailsPage() {
        self.dismiss(animated: true)
        Coordinator.goToTableRequest(controller: self,bookID: self.bookingID,isFromPopup: true)
    }
}

extension TableBookingPlace {
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

extension TableBookingPlace: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
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
        } else if  self.selectedIndex == 1 {
            self.selectedPaymentType = "4"
        } else if  self.selectedIndex == 2 {
            self.selectedPaymentType = "3"
        }
        self.payCollection.reloadData()
    }
}
extension TableBookingPlace:PaymentViaTapPayServiceCompletionDelegate {
    func didCompleteWoithToken(_ token: String) {
        self.cardToken = token
        BookNow()
    }

    func didCompleteWoithPaymentCharge(_ isSuccess:Bool) {
        if isSuccess {
            self.placeRequestAPI()
        }
    }
}

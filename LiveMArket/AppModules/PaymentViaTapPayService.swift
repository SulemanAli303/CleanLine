//
//  PaymentViaTapPayService.swift
//  LiveMArket
//
//  Created by Suleman Ali on 03/07/2024.
//

import Foundation
import goSellSDK
import TapApplePayKit_iOS
import PassKit

protocol PaymentViaTapPayServiceCompletionDelegate {
func didCompleteWoithToken(_ token: String)
func didCompleteWoithPaymentCharge(_ isScuss: Bool)
}
class PaymentViaTapPayService:NSObject, WebViewControllerDelegate {
    func didScuccessRedirect(_ isScuss: Bool) {
        delegate.didCompleteWoithPaymentCharge(isScuss)
    }
    
    private var paymentTapSession = Session()
    let delegate:PaymentViaTapPayServiceCompletionDelegate
    let controller:UIViewController
    var amountToDisplay:Decimal = 0.0
    var invoiceId:String = ""
    var paymentResponse:OTabTransaction? {
        didSet {
            if let transaction = paymentResponse?.transaction?.url,let successURL = paymentResponse?.redirect?.url {
                self.showWebView(url: transaction, successURL: successURL)
            }
        }
    }



    init(delegate: PaymentViaTapPayServiceCompletionDelegate, controller: UIViewController, amountToDisplay:Decimal = 0.0) {

        self.delegate = delegate
        self.controller = controller
        self.amountToDisplay = amountToDisplay
        super.init()
        defer {
            paymentTapSession.delegate = self
            paymentTapSession.dataSource = self
            paymentTapSession.appearance = self
        }
    }

    func startPaymentViaSellSDK(amount:Decimal) {
        self.amountToDisplay = amount
        if paymentTapSession.canStart {
            paymentTapSession.start()
        }
    }

    func startApplePaymentViaSellSDK(amount:Double) {
        self.amountToDisplay = Decimal(amount)
        TapApplePay.sdkMode = .sandbox
        let myTapApplePayRequest:TapApplePayRequest = .init()
        myTapApplePayRequest.build(paymentAmount: 10, merchantID: "merchant.payment.app")
        myTapApplePayRequest.build(paymentNetworks: [.Amex,.Mada,.Visa,.MasterCard], paymentAmount: Double.init(amount), currencyCode: .SAR, merchantID:"merchant.payment.app",merchantCapabilities:  [.capability3DS,.capabilityCredit,.capabilityDebit,.capabilityEMV])

        Utilities.showIndicatorView()
        TapApplePay.setupTapMerchantApplePay(merchantKey: .init(sandbox: tapTestKey, production: tapLiveKey), onSuccess: {
            DispatchQueue.main.async {[weak self] in
                Utilities.hideIndicatorView()
                self?.startAppleProcess(amount: amount)
            }
        }, onErrorOccured: { error in
            DispatchQueue.main.async {[error, weak self] in
                Utilities.hideIndicatorView()
                let alertView:UIAlertController = .init(title: "Error occured", message: "We couldn't process your request. \(error ?? "")", preferredStyle: .alert)
                alertView.addAction(.init(title: "Cancel", style: .cancel))
                self?.controller.present(alertView, animated: true)

            }
        }, tapApplePayRequest: myTapApplePayRequest)
    }

    func startAppleProcess(amount:Double) {
        let myTapApplePayRequest:TapApplePayRequest = .init()
        let tapApplePay:TapApplePay = .init()
        TapApplePay.secretKey = .init(sandbox: tapTestKey, production: tapLiveKey)
        TapApplePay.sdkMode = .sandbox
//        myTapApplePayRequest.build(
//            paymentAmount: amount,
//            merchantID: "merchant.com.hopLiveMarket.dummy")
        myTapApplePayRequest.build(
            paymentNetworks: [.Mada,.Amex,.Visa,.MasterCard],
            paymentItems: [],
            paymentAmount: amount,
            currencyCode: .SAR, 
            merchantID: "merchant.payment.app",
            merchantCapabilities: [.capability3DS,.capabilityCredit,.capabilityDebit,.capabilityEMV])
        tapApplePay.authorizePayment(in: self.controller,
                                     for: myTapApplePayRequest,
                                     tokenized: { [weak self] (token) in

            tapApplePay.createTapToken(for: token, onTokenReady: { tapToken in
                self?.delegate.didCompleteWoithToken(tapToken.identifier)
            }, onErrorOccured: { _,_,error in
                self?.showError(message: error.debugDescription)
            })

            print("I can do whatever i want with the result token")
        }, 
                                     onErrorOccured: { [weak self] error in
            self?.showError(message: error.TapApplePayRequestValidationErrorRawValue())
        })
    }

    func showError(message:String) {
        DispatchQueue.main.async {[weak self] in
            Utilities.hideIndicatorView()
            let alertView:UIAlertController = .init(title: "Error occured", message: "We couldn't process your request. \(message)", preferredStyle: .alert)
            alertView.addAction(.init(title: "Cancel", style: .cancel))
            self?.controller.present(alertView, animated: true)
        }
    }
    func showWebView(url:String,successURL:String) {
        let sb = UIStoryboard(name: "WebViewSB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.delegate = self
        vc.OTPUrl = url
        vc.callSuccssURL = successURL
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        self.controller.present(nvc, animated: true)
    }
}
extension PaymentViaTapPayService:SessionDataSource {
    var mode: TransactionMode {
        return .cardTokenization
    }

    var customer: goSellSDK.Customer? {
        if let loginUser = SessionManager.getUserData() {
            do {
                let emailAddress = try EmailAddress(emailAddressString: loginUser.email ?? "")
                let phoneNumber = try PhoneNumber(isdNumber: loginUser.dial_code ?? "", phoneNumber: loginUser.phone_number ?? "")
                return try goSellSDK.Customer(emailAddress:  emailAddress,
                                              phoneNumber:   phoneNumber,
                                              name: loginUser.name ?? "")
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }

    var setCardScannerIconVisible: Bool {
        return true
    }

    var uiModeDisplay: UIModeDisplayEnum {
        return .followDevice
    }

    var enableSaveCard: Bool {
        return true
    }

    var isSaveCardSwitchOnByDefault: Bool {
        return true
    }

    var currency: Currency? {
        return .with(isoCode: "SAR")
    }

    var paymentType: PaymentType {
        return PaymentType.card
    }
    var amount: Decimal {
        return  amountToDisplay
    }

    var items: [PaymentItem]? {
        return [PaymentItem.init(title: invoiceId, quantity: Quantity.init(value: 1, unitOfMeasurement: .units), amountPerUnit: amountToDisplay)]
    }

    var require3DSecure: Bool {
        return true
    }

    var receiptSettings: Receipt? {
        return Receipt(email: true, sms: true)
    }

    var authorizeAction: AuthorizeAction {
        return .capture(after: 8)
    }

    var merchantID: String? {
        return "36815999"
    }

    var allowsToSaveSameCardMoreThanOnce: Bool {
        return false
    }

    var applePayMerchantID: String {
        return "merchant.payment.app"
    }

}

extension PaymentViaTapPayService: SessionAppearance {

}

extension PaymentViaTapPayService: SessionDelegate {
    func paymentSucceed(_ charge: Charge, on session: SessionProtocol) {
        print("ServiceDelegateRequestDetails",#function)
    }

    func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol) {

        if let error = error {
            Utilities.showWarningAlert(message: "\(error) \n \(error.description)")
        }
        print("ServiceDelegateRequestDetails",#function)
    }

    func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol) {
        print("ServiceDelegateRequestDetails",#function)
    }
    func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol) {
        if let customerID = authorize?.customer.identifier {
            print(customerID)
        }
        print("ServiceDelegateRequestDetails",#function)
    }
    func cardSaved(_ cardVerification: CardVerification, on session: SessionProtocol) {
        print("ServiceDelegateRequestDetails",#function)
    }

    func cardSavingFailed(with cardVerification: CardVerification?, error: TapSDKError?, on session: SessionProtocol) {
        print("ServiceDelegateRequestDetails",#function)
    }
    func cardTokenized(_ token: Token, on session: SessionProtocol, customerRequestedToSaveTheCard saveCard: Bool) {
        delegate.didCompleteWoithToken(token.identifier)
        print("ServiceDelegateRequestDetails",#function,token)
    }
    func cardTokenizationFailed(with error: TapSDKError, on session: SessionProtocol) {
        print("ServiceDelegateRequestDetails",#function)
    }
    func sessionIsStarting(_ session: SessionProtocol) {
        Utilities.showIndicatorView()
        print("ServiceDelegateRequestDetails",#function)

    }
    func sessionHasStarted(_ session: SessionProtocol) {
        Utilities.hideIndicatorView()
        print("ServiceDelegateRequestDetails",#function)
    }
    
    func sessionHasFailedToStart(_ session: SessionProtocol) {
        print("ServiceDelegateRequestDetails",#function)
    }
    func sessionCancelled(_ session: SessionProtocol){
        Utilities.hideIndicatorView()
        print("ServiceDelegateRequestDetails",#function)
        self.paymentTapSession.stop()
    }

    func applePaymentTokenizationFailed(_ error: String, on session: SessionProtocol) {
        self.paymentTapSession.stop()
    }

    func applePaymentTokenizationSucceeded(_ token: Token, on session: SessionProtocol) {
        delegate.didCompleteWoithToken(token.identifier)
        self.paymentTapSession.stop()
    }

    func applePaymentSucceed(_ charge: String, on session: SessionProtocol) {
        delegate.didCompleteWoithPaymentCharge(true)
        self.paymentTapSession.stop()
    }

    func applePaymentCanceled(on session: SessionProtocol) {
        Utilities.showWarningAlert(message: "User Canceled Payment Process")
        self.paymentTapSession.stop()
    }


    func applePaymen(_ charge: String, on session: SessionProtocol) {
        delegate.didCompleteWoithPaymentCharge(true)
            //print(charge)

        self.paymentTapSession.stop()
    }
}

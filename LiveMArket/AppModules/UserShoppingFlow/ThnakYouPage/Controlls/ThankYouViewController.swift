//
//  ThankYouViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit

class ThankYouViewController: UIViewController {

    var vcType:String?
    var invoiceId:String?
    var orderID:String = ""
    var isFromFoodStore:Bool = false
    var isFromPlayGroundBooking:Bool = false
    var isFromPGDetailsPage:Bool = false
    var titleHead:String = "Your order has been placed successfully! please wait for confirmation"
    var isForPaymentDone = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var invoiceIdLbl: UILabel!
    @IBOutlet weak var thankYouLabel: UILabel!
    @IBOutlet weak var invoiceNoLbl: UILabel!
    @IBOutlet weak var viewOrderButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invoiceIdLbl.text = "\(invoiceId ?? "")"
        configLanguage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        if(isFromPlayGroundBooking){
            titleLabel.text = "Your request has been placed successfully! please wait for confirmation".localiz()
            if(isForPaymentDone){
                titleLabel.text = "Your payment has been done successfully!".localiz()
            }
        }else{
            titleLabel.text = self.titleHead.localiz()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    
    func configLanguage(){
        thankYouLabel.text = "Thank You".localiz()
        invoiceNoLbl.text = "Invoice no".localiz()
        viewOrderButton.setTitle("View Order Details".localiz(), for: .normal)
        returnButton.setTitle("Return To Home".localiz(), for: .normal)
    }
    
    @IBAction func OrderDetailPressed(_ sender: UIButton) {
        
        if isFromFoodStore{
            SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: orderID, isSeller: false,isThankYouPage: true)
        }else if isFromPlayGroundBooking{
            if isFromPGDetailsPage{
                PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: false,booking_ID: orderID,isFromThankYou: false)
            }else{
                PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: false,booking_ID: orderID,isFromThankYou: true)
            }
            
        }else{
            SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: orderID,isSeller: false, isThankYouPage: true)
        }
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        Coordinator.updateRootVCToTab()
    }

}

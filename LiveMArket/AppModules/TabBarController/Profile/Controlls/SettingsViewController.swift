//
//  SettingsViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 23/01/2023.
//

import UIKit
import StoreKit

class SettingsViewController: BaseViewController {
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var myBookingsLabel: UILabel!
    @IBOutlet weak var myAddressLabel: UILabel!
    @IBOutlet weak var rateAppLabel: UILabel!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var colorThemeLabel: UILabel!
    @IBOutlet weak var inviteFriendsLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .backWithTop
        viewControllerTitle = "Settings".localiz()
        configureLanguage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func configureLanguage(){
        editProfileLabel.text = "Edit Profile".localiz()
        changePasswordLabel.text = "Change Password".localiz()
        myBookingsLabel.text = "My Bookings".localiz()
        myAddressLabel.text = "My Address".localiz()
        rateAppLabel.text = "Rate the app".localiz()
        helpLabel.text = "Help Center".localiz()
        languageLabel.text = "Language".localiz()
        colorThemeLabel.text = "App Color Theme".localiz()
        inviteFriendsLabel.text = "Invite Friends".localiz()
        logoutLabel.text = "Logout".localiz()
        deleteLabel.text = "Delete My Account".localiz()
    }
    @IBAction func EditProfile(_ sender: UIButton) {
        SellerOrderCoordinator.goToEditProfileVC(controller: self)

    }
    @IBAction func ChangePasswordVC(_ sender: UIButton) {
        SellerOrderCoordinator.goToChangePassVC(controller: self)
    }
    @IBAction func BannedAccountsVC(_ sender: UIButton) {
        SellerOrderCoordinator.goToBannedAccountsVC(controller: self)
    }
    @IBAction func MyBookingVC(_ sender: UIButton) {
        SellerOrderCoordinator.goToMyBookingVC(controller: self)
    }
    @IBAction func HelpCenterVC(_ sender: UIButton) {
        SellerOrderCoordinator.goToHelpCenterVC(controller: self)
    }
    @IBAction func TaxCertificateVC(_ sender: UIButton) {
        SellerOrderCoordinator.goToTaxCertificateVC(controller: self)
    }
    @IBAction func ComplaintListVC(_ sender: UIButton) {
        SellerOrderCoordinator.goToComplaintVC(controller: self)
    }
    @IBAction func rateButtonAction(_ sender: UIButton) {
        if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Handle older iOS versions where SKStoreReviewController is not available
                openAppStoreURL()
            }
    }
    @IBAction func inviteFriendsAction(_ sender: UIButton) {
        SellerOrderCoordinator.goToInviteFriendVC(controller: self)
    }
    @IBAction func AddressVC(_ sender: UIButton) {
        SellerOrderCoordinator.goToAddressVC(controller: self)
    }
    @IBAction func AfterSaleServiceVC(_ sender: UIButton) {
        SellerOrderCoordinator.goToAfterSaleService(controller: self)
    }
    @IBAction func LanguageVC(_ sender: UIButton) {
        SellerOrderCoordinator.goToLanguageVC(controller: self)
    }
    @IBAction func becomeDelegate(_ sender: UIButton) {
        let nextVC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "EditVehicleDetailVC") as! EditVehicleDetailVC
        nextVC.isFromEditbusiness = true
       // nextVC.profileDetails = self.profileDetails
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func appTheamColorAction(_ sender: UIButton) {
    }
    @IBAction func logoutAction(_ sender: UIButton) {
        Utilities.showQuestionAlert(message: "Are you sure you want to logout?".localiz()){
            self.logoutAPI()
        }
    }
    @IBAction func deleteMyAccountTapped(_ sender: UIButton) {
        Utilities.showQuestionAlert(message: "Are you sure you want to Delete Your account?".localiz()){
            self.deleteAccountAPI()
        }
    }
    func logoutAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AuthenticationAPIManager.logoutAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Constants.shared.searchHashTagText = ""
                UserDefaults.standard.removeObject(forKey: "flow")
                SessionManager.clearLoginSession()
                Coordinator.setRoot(controller: self)
                let tabbar = self.tabBarController as? TabbarController
                tabbar?.hideTabBar()
                UserDefaults.standard.setValue(true, forKey: "isReload")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }

    func deleteAccountAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AuthenticationAPIManager.deleteAccountAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Constants.shared.searchHashTagText = ""
                UserDefaults.standard.removeObject(forKey: "flow")
                SessionManager.clearLoginSession()
                Coordinator.setRoot(controller: self)
                let tabbar = self.tabBarController as? TabbarController
                tabbar?.hideTabBar()
                UserDefaults.standard.setValue(true, forKey: "isReload")
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func openAppStoreURL() {
        if let appStoreURL = URL(string: "https://apps.apple.com/us/app/livemarket/id6465203019") {
            if UIApplication.shared.canOpenURL(appStoreURL) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }

}

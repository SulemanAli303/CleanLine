//
//  WholeSellerAuthCoordinator.swift
//  LiveMArket
//
//  Created by Zain falak on 25/01/2023.
//

import Foundation
import UIKit
class WholeSellerAuthCoordinator {
    
    
    static func goToWSCreateAnAccount(controller:UIViewController?) {
        let  VC = AppStoryboard.WSAuth.instance.instantiateViewController(withIdentifier: "WSCreateAccountViewController") as! WSCreateAccountViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToWSBankAccount(controller:UIViewController?) {
        let  VC = AppStoryboard.WSAuth.instance.instantiateViewController(withIdentifier: "WSAddBankDetailsViewController") as! WSAddBankDetailsViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDRCreateAccount(controller:UIViewController?) {
        let  VC = AppStoryboard.DRAuth.instance.instantiateViewController(withIdentifier: "DMCreateAccountViewController") as! DMCreateAccountViewController
        
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDRStep2(controller:UIViewController?,data : DeliveryRepresentative) {
        let  VC = AppStoryboard.DRAuth.instance.instantiateViewController(withIdentifier: "DRAccountStep2ViewController") as! DRAccountStep2ViewController
        VC.deliveryRepresentative = data
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDRStep3(controller:UIViewController?) {
        let  VC = AppStoryboard.DRAuth.instance.instantiateViewController(withIdentifier: "DAAccountStep3ViewController") as! DAAccountStep3ViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDRStep4(controller:UIViewController?) {
        let  VC = AppStoryboard.DRAuth.instance.instantiateViewController(withIdentifier: "DMStep4ViewController") as! DMStep4ViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDRStep5(controller:UIViewController?) {
        let  VC = AppStoryboard.DRAuth.instance.instantiateViewController(withIdentifier: "DMSrep5ViewController") as! DMSrep5ViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToDRStep6(controller:UIViewController?) {
        let  VC = AppStoryboard.DRAuth.instance.instantiateViewController(withIdentifier: "DMStep6ViewController") as! DMStep6ViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToRRCompanyAccount(controller:UIViewController?,VCtype:Int?,RowType:Int?) {
        let  VC = AppStoryboard.RRAuth.instance.instantiateViewController(withIdentifier: "RRCreateAccountViewController") as! RRCreateAccountViewController
        VC.VCtype = VCtype
        VC.RowType = RowType
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToRRBankDetail(controller:UIViewController?) {
        let  VC = AppStoryboard.RRAuth.instance.instantiateViewController(withIdentifier: "RRBankDetailViewController") as! RRBankDetailViewController
        controller?.navigationController?.pushViewController(VC, animated: true)
    }
    static func goToServiceProviderAccount(controller:UIViewController?,VCtype:Int?,RowType:Int?) {
        let  VC = AppStoryboard.RRAuth.instance.instantiateViewController(withIdentifier: "ServiceProviderCreateAccountViewController") as! ServiceProviderCreateAccountViewController
        VC.VCtype = VCtype
        VC.RowType = RowType
        controller?.navigationController?.pushViewController(VC, animated: true)
    }

}

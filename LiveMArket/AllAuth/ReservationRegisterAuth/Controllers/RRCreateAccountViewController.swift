//
//  LMCreateAccountViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import UIKit

class RRCreateAccountViewController: BaseViewController {

    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: CreateAccountProgress!
    @IBOutlet weak var ImgView: UIView!
    
    var VCtype : Int?
    var RowType : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        print(VCtype)
        print(RowType)
        setInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    //MARK: - Methode
    func setInterface() {
        if (VCtype == 0){
            self.ImgView.isHidden = true
        }else {
            self.ImgView.isHidden = false
        }
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
        progressView.selectedTab = 0
        
    }
    @IBAction func termsAction(_ sender: Any) {
        Coordinator.goToCMSPage(controller: self)
    }
    @IBAction func skipAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Actions
    @IBAction func nextAction(_ sender: Any) {
        if VCtype == 0 && RowType == 4
        {
            WholeSellerAuthCoordinator.goToWSBankAccount(controller: self)
            
        }
        else if VCtype == 1 && RowType == 4
        {
            WholeSellerAuthCoordinator.goToRRBankDetail(controller: self)
        }
        else if VCtype == 0 && RowType == 5
        {
            WholeSellerAuthCoordinator.goToWSBankAccount(controller: self)
            
        }

    }
    
}

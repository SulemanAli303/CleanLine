//
//  EditProfilePagerViewController.swift
//  LiveMArket
//
//  Created by Farhan on 12/08/2023.
//

import UIKit
import XLPagerTabStrip

class EditProfilePagerViewController: ButtonBarPagerTabStripViewController {

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
        
    //MARK: ButtonBarPagerTabStripViewController Methods
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let child_1 = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC")
    let child_2 = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "EditBankDetailViewController")
    return [child_1, child_2]
    }
}

//MARK: Pager Child Controller Titles
extension EditProfileVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "")
    }
}

extension EditBankDetailViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "")
    }
}

//
//  LanguageViewController.swift
//  LiveMArket
//
//  Created by Apple on 14/02/2023.
//

import UIKit

class LanguageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "Languages".localiz()

        // Do any additional setup after loading the view.
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

    @IBAction func arabicAction(_ sender: Any) {
//        Live_Market.LanguageManager.shared.defaultLanguage = .ar
//        let language = Live_Market.LanguageManager.shared.currentLanguage.rawValue
//        Live_Market.LanguageManager.shared.setLanguage(language: Languages(rawValue: language) ?? .ar)
//        UserDefaults.standard.set("ar", forKey: "language")
//        languageBool = true
//        
//        Coordinator.updateRootVCToTab()
        
    }
    @IBAction func englishAction(_ sender: Any) {
        
//        Live_Market.LanguageManager.shared.defaultLanguage = .en
//        let language = Live_Market.LanguageManager.shared.currentLanguage.rawValue
//        Live_Market.LanguageManager.shared.setLanguage(language: Languages(rawValue: language) ?? .en)
//        UserDefaults.standard.set("en", forKey: "language")
//        languageBool = false
//        
//        Coordinator.updateRootVCToTab()
    }
}

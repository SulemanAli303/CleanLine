//
//  UINavigationBarAppearence.swift
//  TalentBazar
//
//  Created by Muneeb on 09/05/2022.
//

import Foundation
import Foundation
import UIKit
extension UINavigationBar {
    func setNavigationBarAppearence() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.init(red: 20.0/255.0, green: 90/255.0, blue: 235.0/255.0, alpha: 0.8)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .clear
    
        UINavigationBar.appearance().setBackgroundImage( UIImage(named: ""), for: .default)
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

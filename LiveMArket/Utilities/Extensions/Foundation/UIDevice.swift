//
//  UIDevice.swift
//  TalentBazar
//
//  Created by Muneeb on 07/05/2022.
//

import UIKit
extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
}

//
//  UIApplication+Extension.swift
//  TemployMe
//
//  Created by A2 MacBook Pro 2012 on 04/12/21.
//

import UIKit

extension UIApplication {
    var keywindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    func setRoot(vc: UIViewController) {
        keywindow?.rootViewController = vc
    }
}


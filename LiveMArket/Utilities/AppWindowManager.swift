//
//  AppWindowManager.swift
//  TalentBazar
//
//  Created by Muneeb on 06/05/2022.
//

import UIKit
enum AppWindowManager {
    static func setupWindow<T>(controller: T) where T: UIViewController {
        window = self.window ?? UIWindow.init(frame: windowFrame)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        UIView.transition(with: window!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: nil,
                              completion: nil)
    }
}

private extension AppWindowManager {
    static var window: UIWindow? {
        get {
            return (UIApplication.shared.delegate as? AppDelegate)?.window
        }
        set {
            (UIApplication.shared.delegate as? AppDelegate)?.window = newValue
        }
    }

    static var windowFrame: CGRect {
        UIScreen.main.bounds
    }
}

//
//  UITabBarController.swift
//  
//
//  Created by Muneeb on 28/09/2021.
//

import Foundation
import UIKit
extension UITabBarController{
    func getHeight()->CGFloat{
        return self.tabBar.frame.size.height
    }
    
    func getWidth()->CGFloat{
        return self.tabBar.frame.size.width
    }
}

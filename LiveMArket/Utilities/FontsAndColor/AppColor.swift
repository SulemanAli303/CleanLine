//
//  AppColor.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import Foundation
import UIKit
enum Color: String, CaseIterable {
    case dark = "Dark"
    case yellow = "LightOrange"
    case darkOrange = "DarkOrange"
    case textBg  = "TextBg"
    case darkGray  = "DarkGrey"
    case theme = "theme"
    case  Dark_blue = "Dark_blue"
    case  StatusBlue = "StatusBlue"
    case  StatusDarkRed = "StatusDarkRed"
    case  StatusGreen = "StatusGreen"
    case  StatusRed = "StatusRed"
    case StatusYellow  = "StatusYellow"
    
    func color() -> UIColor {
        guard let color = UIColor(named: rawValue) else {
            fatalError("No such color found")
        }
        return color
    }
}

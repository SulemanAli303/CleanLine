//
//  AppFonts.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import Foundation

import UIKit

private let familyName = "Roboto"

enum AppFonts: String {
    case light = "Light"
    case regular = "Regular"
    case bold = "Bold"
    case semibold = "SemiBold"
    case medium = "Medium"
    case extraBold = "ExtraBold"
    func size(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: fullFontName, size: size + 1.0) {
            return font
        }
        fatalError("Font '\(fullFontName)' does not exist.")
    }
    fileprivate var fullFontName: String {
        return rawValue.isEmpty ? familyName : familyName + "-" + rawValue
    }
}

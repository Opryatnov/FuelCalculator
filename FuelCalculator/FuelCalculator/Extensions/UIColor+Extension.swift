//
//  UIColor+Extension.swift
//  CurrencyConverter
//
//  Created by Dmitriy Opryatnov on 16.03.23.
//

import UIKit
import SwiftUI

extension UIColor {
    static var tabBarItemAccent: UIColor {
        if #available(iOS 15.0, *) {
            UIColor.systemCyan
        } else {
            UIColor.cyan
        }
    }
    
    static var mainWhite: UIColor {
        UIColor.white
    }
    
    static var tabBarItemLight: UIColor {
        UIColor.gray
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

/// Example = UIColor(hexString: "010000", alpha: 0)

enum ColorName: String {
    case achromatic = "achromatic"
    case black = "black"
    case blue = "blue"
    case blue20 = "blue20"
    case blue50 = "blue50"
    case c2073C0 = "c2073C0"
    case c3046B2 = "c3046B2"
    case c5470Fb = "c5470FB"
    case c54B5Fb = "c54B5FB"
    case cyan = "cyan"
    case cyan20 = "cyan20"
    case cyan50 = "cyan50"
    case darkBlue = "darkBlue"
    case gray = "gray"
    case gray0 = "gray0"
    case gray10 = "gray10"
    case gray100 = "gray100"
    case gray20 = "gray20"
    case gray30 = "gray30"
    case gray50 = "gray50"
    case gray57 = "gray57"
    case gray60 = "gray60"
    case gray70 = "gray70"
    case gray80 = "gray80"
    case green = "green"
    case green20 = "green20"
    case green50 = "green50"
    case orange = "orange"
    case orange20 = "orange20"
    case red = "red"
    case red20 = "red20"
    case red50 = "red50"
    case turquoise = "turquoise"
    case white = "white"
    case yellow = "yellow"
    case yellow20 = "yellow20"
}

enum ImageName: String {
    case splashBackground = "splashBackground"
    case alert = "alert"
    case alertBlocked = "alertBlocked"
    case applePay = "applePay"
    case dollar = "dollar"
    case euro = "euro"
    case fav = "fav"
    case favCard = "favCard"
    case ruble = "ruble"
    case calculator = "calculator"
    case day = "day"
    case morning = "morning"
    case night = "night"
    case evening = "evening"
    case exchange = "exchange"
    case exchangeIcon = "exchangeIcon"
    case fuelSelected = "fuel_selected"
    case fuelUnselected = "fuel_unselected"
    case homeUnselectedImage = "exchange_unselected_icon"
    case homeSelectedImage = "exchange_selected_icon"
    case currencyUnselectedImage = "currency_unselected_icon"
    case currencySelectedImage = "currency_selected_icon"
    case fuelAI95 = "fuel-95"
    case fuelAI92 = "fuel-92"
    case fuelDieselWinter = "winter-diesel-fuel"
    case fuelDiesel = "diesel-fuel"
    case fuelEco = "fuel-eco"
    case fuelGas = "fuel-gas"
    case analysisSelected = "analysisSelected"
    case analysisUnSelected = "analysisUnSelected"
}

// MARK: - UIKit Assets Initialization

extension UIColor {
    convenience init?(named: ColorName) {
        self.init(named: named.rawValue, in: Bundle.main, compatibleWith: nil)
    }
}

extension UIImage {
    convenience init?(named imageName: ImageName?) {
        guard let imageName = imageName else { return nil }
        self.init(named: imageName.rawValue)
    }
}

// MARK: - SwiftUI Assets Initialization

extension Color {
    init(named: ColorName) {
        self.init(named.rawValue, bundle: Bundle.main)
    }
}

extension Image {
    init(named imageName: ImageName) {
        let image = UIImage(named: imageName) ?? UIImage()
        self.init(uiImage: image)
    }
}

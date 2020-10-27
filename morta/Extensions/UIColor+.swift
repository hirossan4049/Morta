//
//  UIColor+.swift
//  morta
//
//  Created by unkonow on 2020/10/24.
//

import Foundation
import UIKit

extension UIColor{

    static let backgroundColor = ldColor(light: UIColor(hex: "#F0F0F0"), dark: UIColor(hex: "#252E40"))
    static let backgroundSubColor = ldColor(light: UIColor(hex: "#FFFFFF"), dark: UIColor(hex: "#313B50"))
    static let clockBackgroundColor = ldColor(light: UIColor(hex: "#DDDDDD"), dark: UIColor(hex: "#DDDDDD"))
    static let tabbarColor = ldColor(light: UIColor(hex: "#1AC0C6"), dark: UIColor(hex: "#1AC0C6"))
    static let textColor = ldColor(light: UIColor(hex: "#134E6F"), dark: UIColor(hex: "#dee0e6"))
    
    
    static func ldColor(light:UIColor,dark:UIColor) -> UIColor{
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                    dark:
                    light
                }
        }else{
            return light
        }
    }
}

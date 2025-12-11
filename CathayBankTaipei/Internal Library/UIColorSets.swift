//
//  ColorSets.swift
//  Created by Eric Lin on 2022/2/21.
//  Copyright © 2022 Eric Lin. All rights reserved.
//
import UIKit
extension UIColor {
    // MARK: - White / Base Colors
    /// 近白色（APP 底色用）
    static let whiteColor: UIColor = {
        return UIColor(red: 252, green: 252, blue: 252, alpha: 1)
    }()

    /// 淺粉灰（分隔線或次要背景）
    static let pinkishColor: UIColor = {
        return UIColor(red: 201, green: 201, blue: 201, alpha: 1)
    }()

    // MARK: - Pink / Highlight Colors
    /// 熱粉紅（品牌主色、按鈕、強調用）
    static let hotPinkColor: UIColor = {
        return UIColor(red: 236, green: 0, blue: 140, alpha: 1)
    }()

    // MARK: - Gray / Neutral Colors
    /// 次標題棕灰色（副文本、時間標記）
    static let subTitleColor: UIColor = {
        return UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
    }()

    /// 標題暗灰色（主要文字）
    static let titleColor: UIColor = {
        return UIColor(red: 71, green: 71, blue: 71, alpha: 1.0)
    }()

    /// 黑色陰影（卡片、元件陰影用途）
    static let blackShadowColor: UIColor = {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 10)
    }()
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
}

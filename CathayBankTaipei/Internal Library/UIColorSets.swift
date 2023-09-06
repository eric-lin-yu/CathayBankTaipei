//
//  ColorSets.swift
//  Created by Eric Lin on 2022/2/21.
//  Copyright © 2022 Eric Lin. All rights reserved.
//
import UIKit
extension UIColor {
    //MARK: - 灰
    /// 淡灰
    static let lightGray: UIColor = { return UIColor.init(red: 136, green: 136, blue: 136, alpha: 1) }()

    /// 木炭灰
    static let charcoalGray: UIColor = { return UIColor.init(red: 85, green: 85, blue: 85, alpha: 1.0) }()

    /// 暗灰色
    static let dimGray: UIColor = { return UIColor.init(red: 68, green: 68, blue: 68, alpha: 1.0) }()

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

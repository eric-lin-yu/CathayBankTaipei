//
//  Extension+UIView.swift
//
//  Created by Thinkpower on 2019/11/1.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

//MARK: 邊框相關
extension UIView {
    /// 設定視圖的圓角、邊框線條和背景顏色。
    ///
    /// - Parameters:
    ///   - roundView: 要進行設定的視圖。
    ///   - boarderWidth: 邊框線條的寬度，預設值為0.2。
    ///   - borderColor: 邊框線條的顏色，預設值為空。
    ///   - backgroundColor: 背景顏色，預設值為白色。
    public func setupRoundFrame(for roundView: UIView,
                                boarderWidth: CGFloat = 0.2,
                                borderColor: UIColor? = nil,
                                backgroundColor: UIColor = .white) {
        // 設定圓角
        roundView.layer.cornerRadius = 20
        roundView.layer.masksToBounds = true
        
        // 設定邊框線條
        roundView.layer.borderWidth = boarderWidth
        roundView.layer.borderColor = borderColor?.cgColor ?? UIColor.clear.cgColor
        
        // 設定背景顏色
        roundView.backgroundColor = backgroundColor
    }

    func addBottomBarStyle() {
        self.layer.cornerRadius = 26

        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 5
    }
}

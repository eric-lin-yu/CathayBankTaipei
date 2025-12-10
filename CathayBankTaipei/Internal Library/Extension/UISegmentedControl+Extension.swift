//
//  File.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2023/9/11.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func removeBorders() {
        // 移除背景
        setBackgroundImage(imageWithColor(color: .white), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: .white), for: .selected, barMetrics: .default)
        
        // 移除分隔線
        setDividerImage(imageWithColor(color: .clear),
                        forLeftSegmentState: .normal,
                        rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }
        return nil
    }
}


//
//  String+Extension.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/10.
//

import Foundation

extension String {
    
    /// 將指定的日期字串（格式為 YYYY/MM/DD hh:mm:ss）轉換為 Date 物件。
    /// - Returns: 轉換後的 Date 物件，如果格式不符合則返回 nil。
    func toDate() -> Date? {
        let formatter = DateFormatter()
        // 假設 API 的 updateDate 格式為 "2024/01/01 10:30:00"
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: self)
    }
}

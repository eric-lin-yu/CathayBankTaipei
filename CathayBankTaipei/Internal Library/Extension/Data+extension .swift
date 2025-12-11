//
//  Data+extension .swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/11.
//

import Foundation

extension Data {
    /// 將 Data 轉換為美化格式的 JSON 字串，用於日誌輸出。
    var prettyJsonString: String {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else {
            return String(data: self, encoding: .utf8) ?? "Invalid Data"
        }
        return prettyPrintedString
    }
}

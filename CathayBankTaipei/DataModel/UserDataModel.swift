//
//  UserDataModel.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2023/9/6.
//

import Foundation

struct UserDataResponse: Codable {
    let response: [UserDataModel]
}

struct UserDataModel: Codable {
    let name: String
    let kokoid: String
}

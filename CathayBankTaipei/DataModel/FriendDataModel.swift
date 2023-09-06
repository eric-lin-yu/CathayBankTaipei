//
//  DataModel.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2023/9/6.
//

import Foundation

struct FriendDataResponse: Codable {
    let response: [FriendDataModel]
}

struct FriendDataModel: Codable {
    let name: String
    let status: Int
    let isTop: String
    let fid: String
    let updateDate: String
}

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
    let status: FriendStatus
    let isTop: String
    let fid: String
    let updateDate: String
}

enum FriendStatus: Int, Codable {
    /// 0：邀請送出
    case inviteSent = 0
    
    /// 1：已完成
    case completed = 1
    
    /// 2：邀請中
    case inviting = 2
}

//
//  APIInfo.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2023/9/6.
//

import Foundation
struct APIInfo {
    // API domain
    private static let baseDomain = "https://dimanyen.github.io/"
    
    
    public static let userData = baseDomain + "man.json"
    public static let friendList1 = baseDomain + "friend1.json"
    public static let friendList2 = baseDomain + "friend2.json"
    
    /// 好友列表 & 邀請
    public static let friendIncludesInvitationsList = baseDomain + "friend3.json"
    
    /// 無資料列表
    public static let noDataInvitationFriendList = baseDomain + "friend4.json"
}


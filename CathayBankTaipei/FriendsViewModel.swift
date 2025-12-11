//
//  FriendsViewModel.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/10.
//

import Foundation

protocol FriendsViewModelDelegate: AnyObject {
    /// 當使用者資料 (userData) 更新完成時呼叫
    func userDataDidUpdate()
    
    /// 當好友列表 (invitationList, friendList, filteredFriendList) 更新完成、篩選完成或狀態改變時呼叫
    func friendsDataDidUpdate()
    
    /// 當邀請區塊的展開狀態被切換時呼叫
    func invitationExpansionDidToggle()
    
    /// 當 API 請求失敗時呼叫
    func didFailWithError(_ error: Error)
}

class FriendsViewModel {
    
    weak var delegate: FriendsViewModelDelegate?
    
    enum FriendListScenario {
        /// 無好友
        case noFriends
        /// 僅有一個好友
        case onlyFriends
        /// 好友 + 邀請列表
        case friendsAndInvitations
    }
    
    /// Data Properties
    var currentScenario: FriendListScenario = .onlyFriends
    
    var userData: UserDataModel?
    var invitationList: [FriendDataModel] = []
    var friendList: [FriendDataModel] = []
    var filteredFriendList: [FriendDataModel] = []
    
    /// Invitation Expand
    var isInvitationExpanded: Bool = true
    
    /// 1. 取得使用者資料
    func fetchUserData(completion: (() -> Void)? = nil) {
        APIManager.shared.sendGet(
            endpoint: APIInfo.userData,
            responseType: UserDataResponse.self
        ) { [weak self] result in
            defer { completion?() }
            
            switch result {
            case .success(let model):
                self?.userData = model.response.first
                // 呼叫 Delegate 通知資料更新
                self?.delegate?.userDataDidUpdate()
            case .failure(let error):
                // 呼叫 Delegate 通知錯誤
                self?.delegate?.didFailWithError(error)
            }
        }
    }
    
    /// 情境 I: 無好友（API 2-(5)）
    func fetchNoDataList(completion: (() -> Void)? = nil) {
        APIManager.shared.sendGet(
            endpoint: APIInfo.noDataInvitationFriendList,
            responseType: FriendDataResponse.self
        ) { [weak self] result in
            defer { completion?() }
            self?.handleSingleFriendAPI(result)
        }
    }
    
    /// 情境 III: 有好友 + 邀請（API 2-(4)）
    func fetchFriendAndInvitationList(completion: (() -> Void)? = nil) {
        APIManager.shared.sendGet(
            endpoint: APIInfo.friendIncludesInvitationsList,
            responseType: FriendDataResponse.self
        ) { [weak self] result in
            defer { completion?() }
            self?.handleSingleFriendAPI(result)
        }
    }
    
    /// 情境 II: 只有好友（API 2-(2) + API 2-(3)）
    func fetchAndMergeFriendLists(completion: (() -> Void)? = nil) {
        let group = DispatchGroup()
        var friendsMap: [String: FriendDataModel] = [:]
        var apiError: Error? // 用於捕獲多個非同步 API 中的錯誤
        
        // API 2-(2)
        group.enter()
        APIManager.shared.sendGet(endpoint: APIInfo.friendList1,
                                  responseType: FriendDataResponse.self) { [weak self] result in
            self?.mergeFriendAPIResult(result, into: &friendsMap, errorHolder: &apiError)
            group.leave()
        }
        
        // API 2-(3)
        group.enter()
        APIManager.shared.sendGet(endpoint: APIInfo.friendList2,
                                  responseType: FriendDataResponse.self) { [weak self] result in
            self?.mergeFriendAPIResult(result, into: &friendsMap, errorHolder: &apiError)
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            defer { completion?() }
            
            if let error = apiError {
                self?.delegate?.didFailWithError(error)
                return
            }
            
            self?.sortAndDistributeFriends(friends: Array(friendsMap.values))
        }
    }
    
    /// Search / Filter
    func filterFriends(with keyword: String?) {
        guard let keyword = keyword?.lowercased(), !keyword.isEmpty else {
            filteredFriendList = friendList
            // 呼叫 Delegate 通知資料更新 (UI reload)
            delegate?.friendsDataDidUpdate()
            return
        }
        
        filteredFriendList = friendList.filter {
            $0.name.lowercased().contains(keyword)
        }
        // 呼叫 Delegate 通知資料更新 (UI reload)
        delegate?.friendsDataDidUpdate()
    }
    
    func toggleInvitationExpansion() {
        isInvitationExpanded.toggle()
        // 呼叫 Delegate 通知展開狀態改變 (UI reload section)
        delegate?.invitationExpansionDidToggle()
    }
}

// MARK: - Private Helpers
extension FriendsViewModel {
    
    /// 處理單一 API（情境 I、III）
    private func handleSingleFriendAPI(_ result: Result<FriendDataResponse, Error>) {
        switch result {
        case .success(let model):
            sortAndDistributeFriends(friends: model.response)
        case .failure(let error):
            // 呼叫 Delegate 通知錯誤
            delegate?.didFailWithError(error)
        }
    }
    
    /// 合併好友 API（情境 II）
    private func mergeFriendAPIResult(_ result: Result<FriendDataResponse, Error>,
                                      into map: inout [String: FriendDataModel],
                                      errorHolder: inout Error?) {
        switch result {
        case .success(let model):
            for friend in model.response {
                if let existing = map[friend.fid] {
                    // ... 處理日期更新邏輯
                    let newDate = friend.updateDate.toDate() ?? .distantPast
                    let oldDate = existing.updateDate.toDate() ?? .distantPast
                    if newDate > oldDate {
                        map[friend.fid] = friend
                    }
                } else {
                    map[friend.fid] = friend
                }
            }
            
        case .failure(let error):
            // 僅儲存第一個錯誤
            if errorHolder == nil {
                errorHolder = error
            }
        }
    }
    
    /// 排序 + 分配到 invitationList / friendList
    private func sortAndDistributeFriends(friends: [FriendDataModel]) {
        // 邀請列表: status = 2
        invitationList = friends
            .filter { $0.status == .inviting }
            .sorted {
                ($0.updateDate.toDate() ?? .distantPast) >
                ($1.updateDate.toDate() ?? .distantPast)
            }
        
        // 好友列表
        let coreList = friends.filter { $0.status == .inviteSent || $0.status == .completed }
        
        friendList = coreList.sorted { f1, f2 in
            if f1.isTop == "1", f2.isTop != "1" { return true }
            if f1.isTop != "1", f2.isTop == "1" { return false }
            
            return (f1.updateDate.toDate() ?? .distantPast) >
            (f2.updateDate.toDate() ?? .distantPast)
        }
        
        filteredFriendList = friendList
        
        // 呼叫 Delegate 通知所有列表數據更新
        delegate?.friendsDataDidUpdate()
    }
}

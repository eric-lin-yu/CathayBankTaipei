//
//  FriendsViewModel.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/10.
//

import Foundation

protocol FriendsViewModelDelegate: AnyObject {
    /// 統一通知 View Controller 刷新 TableView 資料
    func reloadData()
    /// 當 API 請求失敗時
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
    
    var currentScenario: FriendListScenario = .onlyFriends
    
    // 原始資料
    var userData: UserDataModel?
    var invitationList: [FriendDataModel] = []
    /// 未篩選的完整好友列表
    var friendList: [FriendDataModel] = []
    /// 用於顯示的好友列表/
    var filteredFriendList: [FriendDataModel] = []
    var isInvitationExpanded: Bool = true
    
    private(set) var contents: [FriendsTableViewRowModel] = []
    
    func numberOfRows() -> Int {
        return contents.count
    }
    
    func rowModel(at indexPath: IndexPath) -> FriendsTableViewRowModel {
        return contents[indexPath.row]
    }
    
    /// 初始載入資料
    func loadData(scenario: FriendListScenario) {
        self.currentScenario = scenario
        fetchUserData()
        
        switch scenario {
        case .noFriends:
            fetchNoDataList()
        case .onlyFriends:
            fetchAndMergeFriendLists()
        case .friendsAndInvitations:
            fetchFriendAndInvitationList()
        }
    }
    
    /// 下拉刷新
    func refreshData() {
        switch currentScenario {
        case .noFriends:
            fetchNoDataList(completion: { [weak self] in self?.delegate?.reloadData() })
        case .onlyFriends:
            fetchAndMergeFriendLists(completion: { [weak self] in self?.delegate?.reloadData() })
        case .friendsAndInvitations:
            fetchFriendAndInvitationList(completion: { [weak self] in self?.delegate?.reloadData() })
        }
    }
    
    /// Search / Filter
    func filterFriends(with keyword: String?) {
        guard let keyword = keyword?.lowercased(), !keyword.isEmpty else {
            filteredFriendList = friendList // 恢復完整好友列表
            buildViewModel()
            return
        }
        
        filteredFriendList = friendList.filter {
            $0.name.lowercased().contains(keyword)
        }
        
        // 篩選後，重建 ViewModel
        buildViewModel()
    }
    
    /// 展開/收合邀請
    func toggleInvitationExpansion() {
        isInvitationExpanded.toggle()
        // 狀態改變，重建 ViewModel
        buildViewModel()
    }
    
    // MARK: - API Fetching (保持與原程式碼一致的結構)
    
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
                // 資料更新，重建 ViewModel
                self?.buildViewModel()
            case .failure(let error):
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
        var apiError: Error?
        
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
            
            // 合併後，進行排序與分配
            self?.sortAndDistributeFriends(friends: Array(friendsMap.values))
        }
    }
}

// MARK: - Private Helpers
extension FriendsViewModel {
    
    private func createRowModel(_ type: FriendsCellType, data: Any?) -> FriendsTableViewRowModel {
        return FriendsTableViewRowModel(cellType: type, cellModel: data)
    }
    
    private func buildViewModel() {
        contents.removeAll()
        
        if self.userData != nil {
            contents.append(createRowModel(.userData, data: self.userData))
        }
        
        if !invitationList.isEmpty {
            contents.append(createRowModel(.invitation, data: invitationList.count))
            
            if isInvitationExpanded {
                for invite in invitationList {
                    contents.append(createRowModel(.invitation, data: invite))
                }
            }
        }
        
        contents.append(createRowModel(.segmentAndSearch, data: nil))
        
        let hasInvitations = !invitationList.isEmpty
        let hasFriends = !friendList.isEmpty
        let isSearching = filteredFriendList.count != friendList.count
        
        if currentScenario == .noFriends && !hasInvitations && !hasFriends && !isSearching {
            // 情境 I: 確實是無好友情境 (無好友、無邀請、且非搜尋狀態)
            contents.append(createRowModel(.emptyState, data: nil))
        } else if filteredFriendList.isEmpty && isSearching {
            // 情境：有好友，但搜尋結果為空 (此時通常顯示「查無此人」的 Cell，這裡假設用 .emptyState 替代或跳過)
            // 根據原設計，我們只在 .noFriends 時顯示 EmptyState。搜尋結果為空時，列表下方是空的。
        } else {
            // 情境 II, III, 或有搜尋結果 -> 顯示好友列表
            for friend in filteredFriendList {
                contents.append(createRowModel(.friend, data: friend))
            }
        }
        delegate?.reloadData()
    }
    
    /// 處理單一 API（情境 I、III）
    private func handleSingleFriendAPI(_ result: Result<FriendDataResponse, Error>) {
        switch result {
        case .success(let model):
            sortAndDistributeFriends(friends: model.response)
        case .failure(let error):
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
        // 邀請列表: status = 2 (inviting)
        invitationList = friends
            .filter { $0.status == .inviting }
            .sorted {
                ($0.updateDate.toDate() ?? .distantPast) >
                ($1.updateDate.toDate() ?? .distantPast)
            }
        
        // 好友列表 (inviteSent or completed)
        let coreList = friends.filter { $0.status == .inviteSent || $0.status == .completed }
        
        friendList = coreList.sorted { f1, f2 in
            // 優先排序 isTop = "1"
            if f1.isTop == "1", f2.isTop != "1" { return true }
            if f1.isTop != "1", f2.isTop == "1" { return false }
            
            // 次要排序 updateDate
            return (f1.updateDate.toDate() ?? .distantPast) >
            (f2.updateDate.toDate() ?? .distantPast)
        }
        // 初始時 filtered = 完整列表
        filteredFriendList = friendList
        buildViewModel()
    }
}

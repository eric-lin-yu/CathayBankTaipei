//
//  ViewController.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2023/9/6.
//

import UIKit


// Row Model
struct FriendsTableViewRowModel {
    var cellType: FriendsCellType
    var cellModel: Any?
}

// Cell Types
enum FriendsCellType {
    /// 使用者資料
    case userData
    /// 邀請列表
    case invitation
    /// 選單
    case segment
    /// 搜尋欄
    case search
    /// 好友列表
    case friend
    /// 無資料
    case emptyState
}

class FriendsViewController: UIViewController {
    private let viewModel = FriendsViewModel()
    
    private let refreshControl = UIRefreshControl()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - UI
    private let withdrawBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "icNavPinkWithdraw")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let transferBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "icNavPinkTransfer")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scanBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "icNavPinkScan")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - setup
    private func setupNav() {
        withdrawBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        transferBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        scanBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let leftStack = UIStackView(arrangedSubviews: [withdrawBtn, transferBtn])
        leftStack.spacing = 24
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftStack)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: scanBtn)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        setupViews()
        
        setupDelegateAndDataSource()
        setupPullToRefresh()
        
        initialDataLoad()
    }
    
    // MARK: - Setup & Config
    private func setupDelegateAndDataSource() {
        viewModel.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register Cells
        tableView.register(UserDataCell.self, forCellReuseIdentifier: UserDataCell.identifier)
        tableView.register(SegmentControlCell.self, forCellReuseIdentifier: SegmentControlCell.identifier)
        tableView.register(SearchBarCell.self, forCellReuseIdentifier: SearchBarCell.identifier)
        tableView.register(FriendsCell.self, forCellReuseIdentifier: FriendsCell.identifier)
        tableView.register(InviteCell.self, forCellReuseIdentifier: InviteCell.identifier)
        tableView.register(EmptyStateCell.self, forCellReuseIdentifier: EmptyStateCell.identifier)
        
    }
    
    private func setupPullToRefresh() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func initialDataLoad() {
        viewModel.fetchUserData()
        
        viewModel.currentScenario = .onlyFriends
        viewModel.fetchAndMergeFriendLists()
        
        // 若要測試無好友情境:
        // viewModel.currentScenario = .noFriends
        // viewModel.fetchNoDataList()
        
        // 若要測試好友+邀請情境:
        // viewModel.currentScenario = .friendsAndInvitations
        // viewModel.fetchFriendAndInvitationList()
    }
    
    @objc private func refreshData() {
        // 在下拉刷新時，重新載入資料
        switch viewModel.currentScenario {
        case .noFriends:
            viewModel.fetchNoDataList(completion: { [weak self] in self?.refreshControl.endRefreshing() })
        case .onlyFriends:
            viewModel.fetchAndMergeFriendLists(completion: { [weak self] in self?.refreshControl.endRefreshing() })
        case .friendsAndInvitations:
            viewModel.fetchFriendAndInvitationList(completion: { [weak self] in self?.refreshControl.endRefreshing() })
        }
    }
}

// MARK: - FriendsViewModelDelegate

extension FriendsViewController: FriendsViewModelDelegate {
    
    func reloadData() {
        self.tableView.reloadData()
        
        self.refreshControl.endRefreshing()
    }
    
    /// 當 API 請求失敗時
    func didFailWithError(_ error: Error) {
        print("API 錯誤: \(error)")
        self.refreshControl.endRefreshing()
        //TODO: 實作顯示 Alert 或 Toast 的邏輯
    }
}

// MARK: - UITableViewDataSource

extension FriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowModel = viewModel.rowModel(at: indexPath)
        
        switch rowModel.cellType {
        case .userData:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserDataCell.identifier, for: indexPath) as! UserDataCell
            
            if let model = rowModel.cellModel as? UserDataModel {
                cell.configure(with: model)
            }
            return cell
        case .invitation:
            let cell = tableView.dequeueReusableCell(withIdentifier: InviteCell.identifier, for: indexPath) as! InviteCell
            if let friend = rowModel.cellModel as? FriendDataModel {
                // 傳入資料和 indexPath
                cell.configure(data: friend, indexPath: indexPath)
            }
            
            // 修正點：使用新的 ViewModel helper 方法檢查該 Cell 的展開狀態
            let isExpanded = viewModel.isInviteExpanded(at: indexPath)
            cell.updateLayout(isExpanded: isExpanded)
            
            cell.delegate = self
            return cell
            
        case .segment:
            let cell = tableView.dequeueReusableCell(withIdentifier: SegmentControlCell.identifier, for: indexPath) as! SegmentControlCell
            cell.delegate = self
            return cell
            
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchBarCell.identifier, for: indexPath) as! SearchBarCell
            cell.delegate = self
            return cell
            
        case .friend:
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendsCell.identifier, for: indexPath) as! FriendsCell
            
            if let friend = rowModel.cellModel as? FriendDataModel {
                cell.setData(friend)
            }
            return cell
            
        case .emptyState:
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateCell.identifier, for: indexPath) as! EmptyStateCell
            return cell
        }
    }
}

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowModel = viewModel.rowModel(at: indexPath)
        switch rowModel.cellType {
        case .userData:
            return 80
        case .segment, .search:
            return 100
        case .emptyState:
            return 500
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - InviteDelegate

extension FriendsViewController: InviteDelegate {
    func didTapContent(at indexPath: IndexPath) {
        viewModel.toggleInvite(at: indexPath)
    }
}

// MARK: - SegmentControlCellDelegate

extension FriendsViewController: SegmentControlCellDelegate {
    func didChangeSegment(index: Int) {
        print("切換 SegmentedControl 至 index: \(index)")
        // TODO:
    }
}

// MARK: - SearchBarCellDelegate

extension FriendsViewController: SearchBarCellDelegate {
    func didSearch(keyword: String) {
        viewModel.filterFriends(with: keyword)
    }
}

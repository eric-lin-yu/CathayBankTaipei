//
//  FriendsCell.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/10.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    static let identifier = "FriendsCell"
    
    private let startIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icFriendsStar")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "imgFriendsList")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .subTitleColor
        return label
    }()
    
    private let transferMoneyBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("轉帳", for: .normal)
        button.setTitleColor(.hotPinkColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.hotPinkColor.cgColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        return button
    }()
    
    private let inviteBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("邀請中", for: .normal)
        button.setTitleColor(.subTitleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.pinkishColor.cgColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        return button
    }()
    
    private let moreBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icFriendsMore"), for: .normal)
        return button
    }()
    
    var transferMoneyRight: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setData(_ data: FriendDataModel?) {
        guard let data = data else { return }
        
        userName.text = data.name
        startIcon.isHidden = (data.isTop == "0")
        
        switch data.status {
        case .inviting:
            // 邀請中
            transferMoneyRight?.constant = -10
            inviteBtn.isHidden = false
            moreBtn.isHidden = true
            
        case .completed:
            // 已完成
            transferMoneyRight?.constant = 15
            inviteBtn.isHidden = true
            moreBtn.isHidden = false
            
        case .inviteSent:
            // 邀請送出
            transferMoneyRight?.constant = -10
            inviteBtn.isHidden = false
            moreBtn.isHidden = true
        }
    }
    
    private func setupViews() {
        let views: [UIView] = [
            startIcon,
            userImage,
            userName,
            transferMoneyBtn,
            moreBtn,
            inviteBtn
        ]
        views.forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // startIcon
            startIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            startIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            startIcon.widthAnchor.constraint(equalToConstant: 14),
            startIcon.heightAnchor.constraint(equalToConstant: 14),
            
            // userImage
            userImage.leftAnchor.constraint(equalTo: startIcon.rightAnchor, constant: 6),
            userImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 40),
            userImage.heightAnchor.constraint(equalToConstant: 40),
            
            userName.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 15),
            userName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // inviteBtn（右側最右邊）
            inviteBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            inviteBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            inviteBtn.widthAnchor.constraint(equalToConstant: 60),
            inviteBtn.heightAnchor.constraint(equalToConstant: 24),
            
            // moreBtn（位於右側，但比 inviteBtn 更左）
            moreBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            moreBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            moreBtn.widthAnchor.constraint(equalToConstant: 18),
            moreBtn.heightAnchor.constraint(equalToConstant: 4),
            
            // transferMoneyBtn（位置由狀態決定）
            transferMoneyBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            transferMoneyBtn.widthAnchor.constraint(equalToConstant: 47),
            transferMoneyBtn.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        /// 依情況更新的 trailingConstraint
        transferMoneyRight = transferMoneyBtn.rightAnchor.constraint(
            equalTo: inviteBtn.leftAnchor,
            constant: -10
        )
        transferMoneyRight?.isActive = true
    }
}

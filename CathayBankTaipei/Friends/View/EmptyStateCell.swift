//
//  EmptyStateCell.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/12.
//

import UIKit

protocol EmptyStateCellDelegate: AnyObject {
    func didTapContent()
}

class EmptyStateCell: UITableViewCell {
    
    static let identifier = "EmptyStateCell"
    
    weak var delegate: EmptyStateCellDelegate?
    
    // MARK: - UI Components
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgFriendsEmpty")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "就只差你一個了\n快點邀請朋友加入 KOKO 吧"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addFriendBtn: UIButton = {
        let button = UIButton()
        button.setTitle("加好友", for: .normal)
        button.backgroundColor = .hotPinkColor
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addButtonTapped() {
        self.delegate?.didTapContent()
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(emptyImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(addFriendBtn)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image
            emptyImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            emptyImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 245),
            emptyImageView.heightAnchor.constraint(equalToConstant: 172),
            
            // Label
            descriptionLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 40),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            
            // Button
            addFriendBtn.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            addFriendBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addFriendBtn.widthAnchor.constraint(equalToConstant: 192),
            addFriendBtn.heightAnchor.constraint(equalToConstant: 40),
            addFriendBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
}

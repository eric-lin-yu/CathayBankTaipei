//
//  UserDataCell.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/12.
//

import UIKit

class UserDataCell: UITableViewCell {
    
    static let identifier = "UserDataCell"
    
    // MARK: - UI Components
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let kokoIdsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let kokoIdLabel: UILabel = {
        let label = UILabel()
        label.text = "設定 KOKO ID" // 預設文字
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let rightArrowImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icInfoBackDeepGray")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let sleDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .hotPinkColor // 假設您有這個 extension，或用 .systemPink
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgFriendsFemaleDefault")
        imageView.layer.cornerRadius = 25 // 假設寬高 50
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    // MARK: - Configuration
    func configure(with model: UserDataModel) {
        userNameLabel.text = model.name
        
        if model.kokoid.isEmpty {
            kokoIdLabel.text = "設定 KOKO ID"
            userIdLabel.text = ""
            sleDotView.isHidden = true
            rightArrowImageView.isHidden = false // 顯示箭頭引導設定
        } else {
            kokoIdLabel.text = "KOKO ID : "
            userIdLabel.text = model.kokoid
            sleDotView.isHidden = false
            rightArrowImageView.isHidden = true // 有 ID 時通常隱藏箭頭或視需求而定
        }
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(userNameLabel)
        contentView.addSubview(kokoIdsStackView)
        contentView.addSubview(sleDotView)
        contentView.addSubview(userImageView)
        
        // StackView arranged subviews
        kokoIdsStackView.addArrangedSubview(kokoIdLabel)
        kokoIdsStackView.addArrangedSubview(userIdLabel)
        kokoIdsStackView.addArrangedSubview(rightArrowImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // User Image (Right side)
            userImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Padding Top
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10), // Padding Bottom
            userImageView.widthAnchor.constraint(equalToConstant: 52),
            userImageView.heightAnchor.constraint(equalToConstant: 52),
            
            // User Name
            userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 2),
            userNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            userNameLabel.rightAnchor.constraint(lessThanOrEqualTo: userImageView.leftAnchor, constant: -10),
            
            // ID Stack
            kokoIdsStackView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            kokoIdsStackView.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor),
            
            // Arrow Image Size (inside stack)
            rightArrowImageView.widthAnchor.constraint(equalToConstant: 18),
            rightArrowImageView.heightAnchor.constraint(equalToConstant: 18),
            
            // Pink Dot
            sleDotView.centerYAnchor.constraint(equalTo: kokoIdsStackView.centerYAnchor),
            sleDotView.leftAnchor.constraint(equalTo: kokoIdsStackView.rightAnchor, constant: 15),
            sleDotView.widthAnchor.constraint(equalToConstant: 10),
            sleDotView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
}

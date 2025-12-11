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
        imageView.image = UIImage(named: "StartIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "DefultUserPhoto")
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
        button.setImage(UIImage(named: "MoreIcon"), for: .normal)
        return button
    }()

    var transferMoneyRight: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    public func setData(_ data: FriendDataModel?) {
        if let data = data {

            userName.text = data.name
            startIcon.isHidden = data.isTop == "0"

            if data.status == 2 {
                transferMoneyRight?.constant = -10
                inviteBtn.isHidden = false
                moreBtn.isHidden = true
            }

            if data.status == 1 {
                transferMoneyRight?.constant = 15
                inviteBtn.isHidden = true
                moreBtn.isHidden = false
            }
        }
    }

    private func setView() {
        contentView.addSubview(startIcon)
        contentView.addSubview(userImage)
        contentView.addSubview(userName)
        contentView.addSubview(transferMoneyBtn)
        contentView.addSubview(moreBtn)
        contentView.addSubview(inviteBtn)
    }

    private func setLayout() {

        [
            startIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            startIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            startIcon.widthAnchor.constraint(equalToConstant: 14),
            startIcon.heightAnchor.constraint(equalToConstant: 14),
        ].forEach({
            $0.isActive = true
        })

        [
            userImage.leftAnchor.constraint(equalTo: startIcon.rightAnchor, constant: 6),
            userImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            userImage.widthAnchor.constraint(equalToConstant: 40),
            userImage.heightAnchor.constraint(equalToConstant: 40),
        ].forEach({
            $0.isActive = true
        })

        [
            userName.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 15),
            userName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
        ].forEach({
            $0.isActive = true
        })

        [
            inviteBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            inviteBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            inviteBtn.widthAnchor.constraint(equalToConstant: 60),
            inviteBtn.heightAnchor.constraint(equalToConstant: 24)
        ].forEach({
            $0.isActive = true
        })

        [
            moreBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            moreBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            moreBtn.widthAnchor.constraint(equalToConstant: 18),
            moreBtn.heightAnchor.constraint(equalToConstant: 4)
        ].forEach({
            $0.isActive = true
        })

        [
            transferMoneyBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            transferMoneyBtn.widthAnchor.constraint(equalToConstant: 47),
            transferMoneyBtn.heightAnchor.constraint(equalToConstant: 24)
        ].forEach({
            $0.isActive = true
        })

        transferMoneyRight = transferMoneyBtn.rightAnchor.constraint(equalTo: inviteBtn.leftAnchor, constant: -10)
        transferMoneyRight?.isActive = true

    }

}

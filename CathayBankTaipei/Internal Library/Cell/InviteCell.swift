//
//  InviteCell.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/10.
//

import UIKit

protocol InviteDelegate: AnyObject {
    func didTapContent()
}

class InviteCell: UITableViewCell {

    static let identifier = "InviteCell"

    weak var delegate: InviteDelegate?

    private let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.shadowOpacity = 1.5
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.blackShadowColor.cgColor
        return view
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
        label.textColor = .titleColor
        label.font = .systemFont(ofSize: 16)
        label.text = "彭安婷"
        return label
    }()

    private let inviteDescribe: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .subTitleColor
        label.font = .systemFont(ofSize: 13)
        label.text = "邀請你成為好友 :)"
        return label
    }()

    private lazy var acceptBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnFriendsAgree"), for: .normal)
        button.addTarget(self, action: #selector(didTapAccept), for: .touchUpInside)
        return button
    }()

    private lazy var rejectBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btnFriendsDelet"), for: .normal)
        button.addTarget(self, action: #selector(didTapReject), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .whiteColor
        setView()
        setLayout()
        setHandle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setData(data: FriendDataModel) {

        DispatchQueue.main.async { [weak self] in
            self?.userName.text = data.name
        }

    }

    private func setView() {

        contentView.addSubview(background)
        contentView.addSubview(userImage)
        contentView.addSubview(userName)
        contentView.addSubview(inviteDescribe)
        contentView.addSubview(acceptBtn)
        contentView.addSubview(rejectBtn)

    }

    private func setLayout() {

        [
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            background.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            background.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            background.heightAnchor.constraint(equalToConstant: 70),
        ].forEach({
            $0.isActive = true
        })

        [
            userImage.topAnchor.constraint(equalTo: background.topAnchor, constant: 15),
            userImage.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 15),
            userImage.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -15),
            userImage.widthAnchor.constraint(equalToConstant: 40),
            userImage.heightAnchor.constraint(equalToConstant: 40),
        ].forEach({
            $0.isActive = true
        })

        [
            userName.topAnchor.constraint(equalTo: background.topAnchor, constant: 14),
            userName.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 15),
            userName.bottomAnchor.constraint(equalTo: background.centerYAnchor, constant: 0),
        ].forEach({
            $0.isActive = true
        })

        [
            inviteDescribe.topAnchor.constraint(equalTo: background.centerYAnchor, constant: 0),
            inviteDescribe.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 15),
            inviteDescribe.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -14),
        ].forEach({
            $0.isActive = true
        })

        [
            acceptBtn.centerYAnchor.constraint(equalTo: background.centerYAnchor, constant: 0),
            acceptBtn.rightAnchor.constraint(equalTo: rejectBtn.leftAnchor, constant: -15),
            acceptBtn.widthAnchor.constraint(equalToConstant: 30),
            acceptBtn.heightAnchor.constraint(equalToConstant: 30),
        ].forEach({
            $0.isActive = true
        })

        [
            rejectBtn.centerYAnchor.constraint(equalTo: background.centerYAnchor, constant: 0),
            rejectBtn.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -15),
            rejectBtn.widthAnchor.constraint(equalToConstant: 30),
            rejectBtn.heightAnchor.constraint(equalToConstant: 30),
        ].forEach({
            $0.isActive = true
        })

    }

}

// MARK: Event
extension InviteCell {

    private func setHandle() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tap)

    }

    @objc private func didTapContent() {
        delegate?.didTapContent()
    }

    @objc private func didTapAccept() {

    }

    @objc private func didTapReject() {

    }

}

//
//  InviteCell.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/10.
//

import UIKit

protocol InviteDelegate: AnyObject {
    func didTapContent(at indexPath: IndexPath)
}

class InviteCell: UITableViewCell {

    static let identifier = "InviteCell"
    weak var delegate: InviteDelegate?

    private var currentIndexPath: IndexPath?

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
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "imgFriendsList")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        return iv
    }()

    private let userName: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .titleColor
        l.font = .systemFont(ofSize: 16)
        return l
    }()

    private let inviteDescribe: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .subTitleColor
        l.font = .systemFont(ofSize: 13)
        l.text = "邀請你成為好友 :)"
        return l
    }()

    private lazy var acceptBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnFriendsAgree"), for: .normal)
        return btn
    }()

    private lazy var rejectBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnFriendsDelet"), for: .normal)
        return btn
    }()

    private var expandedConstraints: [NSLayoutConstraint] = []
    private var collapsedConstraints: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .whiteColor
        setupViews()
        setupConstraints()
        setHandle()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(data: FriendDataModel, indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        userName.text = data.name
    }

    // 更新展開或收合 UI
    func updateLayout(isExpanded: Bool) {
        NSLayoutConstraint.deactivate(expandedConstraints)
        NSLayoutConstraint.deactivate(collapsedConstraints)

        if isExpanded {
            NSLayoutConstraint.activate(expandedConstraints)
        } else {
            NSLayoutConstraint.activate(collapsedConstraints)
        }

        layoutIfNeeded()
    }
}

// MARK: - Setup
extension InviteCell {

    private func setupViews() {
        [background, userImage, userName, inviteDescribe, acceptBtn, rejectBtn]
            .forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            background.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            background.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            userImage.topAnchor.constraint(equalTo: background.topAnchor, constant: 15),
            userImage.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 15),
            userImage.widthAnchor.constraint(equalToConstant: 40),
            userImage.heightAnchor.constraint(equalToConstant: 40),

            userName.topAnchor.constraint(equalTo: userImage.topAnchor),
            userName.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 15),

            inviteDescribe.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 4),
            inviteDescribe.leftAnchor.constraint(equalTo: userName.leftAnchor)
        ])

        // 收合：高度固定 70
        collapsedConstraints = [
            background.heightAnchor.constraint(equalToConstant: 70),
            acceptBtn.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            acceptBtn.rightAnchor.constraint(equalTo: rejectBtn.leftAnchor, constant: -15),
            acceptBtn.widthAnchor.constraint(equalToConstant: 30),
            acceptBtn.heightAnchor.constraint(equalToConstant: 30),

            rejectBtn.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            rejectBtn.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -15),
            rejectBtn.widthAnchor.constraint(equalToConstant: 30),
            rejectBtn.heightAnchor.constraint(equalToConstant: 30)
        ]

        // 展開：增加下方空間
        expandedConstraints = [
            background.heightAnchor.constraint(equalToConstant: 140),

            acceptBtn.topAnchor.constraint(equalTo: inviteDescribe.bottomAnchor, constant: 16),
            acceptBtn.leftAnchor.constraint(equalTo: userName.leftAnchor),
            acceptBtn.widthAnchor.constraint(equalToConstant: 30),
            acceptBtn.heightAnchor.constraint(equalToConstant: 30),

            rejectBtn.centerYAnchor.constraint(equalTo: acceptBtn.centerYAnchor),
            rejectBtn.leftAnchor.constraint(equalTo: acceptBtn.rightAnchor, constant: 20),
            rejectBtn.widthAnchor.constraint(equalToConstant: 30),
            rejectBtn.heightAnchor.constraint(equalToConstant: 30)
        ]

        NSLayoutConstraint.activate(collapsedConstraints)
    }
}

// MARK: - Event handlers
extension InviteCell {
    private func setHandle() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        background.isUserInteractionEnabled = true
        background.addGestureRecognizer(tap)
    }

    @objc private func didTapContent() {
        if let index = currentIndexPath {
            delegate?.didTapContent(at: index)
        }
    }
}

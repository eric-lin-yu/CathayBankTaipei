//
//  ViewController.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2023/9/6.
//

import UIKit

class FriendsViewController: UIViewController {
    // Parameters 放這....
    // constraint Spacing
    private let spacing: CGFloat = 20
    private let topSpacing: CGFloat = 30
    private let bottomSpacing: CGFloat = 35
    private let btnHeight: CGFloat = 50
    
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
    
    //MARK: -  user Data View
    private let userDataView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "測試人員"
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
        label.text = "設定 KOKO ID"
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightArrowImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icInfoBackDeepGray")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let sleDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .hotPink
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgFriendsFemaleDefault")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    //MARK: - setup
    private func setupViews() {
        view.backgroundColor = .white
        let viewsToAdd: [UIView] = [
            withdrawBtn,
            transferBtn,
            scanBtn,
            userDataView,
        ]
        viewsToAdd.forEach { view.addSubview($0) }
        
        // add to User Data View
        let viewsToAddUserDataView: [UIView] = [
            userNameLabel,
            kokoIdsStackView,
            sleDotView,
            userImageView,
        ]
        viewsToAddUserDataView.forEach { userDataView.addSubview($0) }
 
        // add to stack View
        let viewsToAddStackView: [UIView] = [
            kokoIdLabel,
            userIdLabel,
            rightArrowImageView,
        ]
        viewsToAddStackView.forEach { kokoIdsStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraint() {
        let topSafeArea = view.safeAreaLayoutGuide.topAnchor
        let leftSafeArea = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeArea = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeArea = view.safeAreaLayoutGuide.bottomAnchor
        
        NSLayoutConstraint.activate([
            withdrawBtn.topAnchor.constraint(equalTo: topSafeArea),
            withdrawBtn.leftAnchor.constraint(equalTo: leftSafeArea, constant: 20),
            withdrawBtn.heightAnchor.constraint(equalToConstant: 24),
            withdrawBtn.widthAnchor.constraint(equalToConstant: 24),
            
            transferBtn.leftAnchor.constraint(equalTo: withdrawBtn.rightAnchor, constant: 24),
            transferBtn.centerYAnchor.constraint(equalTo: withdrawBtn.centerYAnchor),
            transferBtn.heightAnchor.constraint(equalToConstant: 24),
            transferBtn.widthAnchor.constraint(equalToConstant: 24),
            
            scanBtn.rightAnchor.constraint(equalTo: rightSafeArea, constant: -20),
            scanBtn.centerYAnchor.constraint(equalTo: transferBtn.centerYAnchor),
            scanBtn.heightAnchor.constraint(equalToConstant: 24),
            scanBtn.widthAnchor.constraint(equalToConstant: 24),
            
            userDataView.topAnchor.constraint(equalTo: withdrawBtn.bottomAnchor, constant: 27),
            userDataView.leftAnchor.constraint(equalTo: leftSafeArea),
            userDataView.rightAnchor.constraint(equalTo: rightSafeArea),
            
            userNameLabel.topAnchor.constraint(equalTo: userDataView.topAnchor, constant: 8),
            userNameLabel.leftAnchor.constraint(equalTo: userDataView.leftAnchor, constant: 30),

            kokoIdsStackView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            kokoIdsStackView.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor),
            kokoIdsStackView.bottomAnchor.constraint(equalTo: userDataView.bottomAnchor),
    
            rightArrowImageView.leftAnchor.constraint(equalTo: userIdLabel.rightAnchor),
            rightArrowImageView.centerYAnchor.constraint(equalTo: userIdLabel.centerYAnchor),
            rightArrowImageView.heightAnchor.constraint(equalToConstant: 18),
            rightArrowImageView.widthAnchor.constraint(equalToConstant: 18),
            
            sleDotView.leftAnchor.constraint(equalTo: kokoIdsStackView.rightAnchor, constant: 15),
            sleDotView.centerYAnchor.constraint(equalTo: kokoIdsStackView.centerYAnchor),
            sleDotView.heightAnchor.constraint(equalToConstant: 10),
            sleDotView.widthAnchor.constraint(equalToConstant: 10),
            
            userImageView.rightAnchor.constraint(equalTo: rightSafeArea, constant: -30),
            userImageView.centerYAnchor.constraint(equalTo: userDataView.centerYAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraint()
    }


}


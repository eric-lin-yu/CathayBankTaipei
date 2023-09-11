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
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "<#imageName#>")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - setup
    private func setupViews() {
        // 如果很多 UIView 需要 add 的用法
        let viewsToAdd: [UIView] = [
            //...
        ]
        viewsToAdd.forEach { view.addSubview($0) }
    }
    
    private func setupConstraint() {
        let topSafeArea = view.safeAreaLayoutGuide.topAnchor
        let leftSafeArea = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeArea = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeArea = view.safeAreaLayoutGuide.bottomAnchor
        
        NSLayoutConstraint.activate([
            // 由上到下、由左到右設計
        ])
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraint()
    }


}


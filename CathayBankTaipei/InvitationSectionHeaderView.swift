//
//  InvitationSectionHeaderView.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/11.
//

import UIKit

protocol InvitationSectionHeaderViewDelegate: AnyObject {
    func didTapToggleButton()
}

class InvitationSectionHeaderView: UIView {
    weak var delegate: InvitationSectionHeaderViewDelegate?
    
    let titleLabel = UILabel()
    let countLabel = UILabel()
    let toggleButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 設置 Label, Button...
        
        // 設置按鈕的點擊事件
        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
    }
    
    func configure(count: Int, isExpanded: Bool) {
        countLabel.text = "\(count)"
        let arrowImageName = isExpanded ? "icNavPinkUp" : "icNavPinkDown"
        toggleButton.setImage(UIImage(named: arrowImageName), for: .normal)
    }
    
    @objc private func toggleButtonTapped() {
        delegate?.didTapToggleButton()
    }
}

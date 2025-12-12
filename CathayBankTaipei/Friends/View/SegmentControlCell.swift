//
//  SegmentControlCell.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/12.
//

import UIKit

protocol SegmentControlCellDelegate: AnyObject {
    func didChangeSegment(index: Int)
}

class SegmentControlCell: UITableViewCell {
    
    static let identifier = "SegmentControlCell"
    weak var delegate: SegmentControlCellDelegate?
    
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["好友", "聊天"])
        sc.selectedSegmentIndex = 0
        sc.removeBorders()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return sc
    }()
    
    private let underline: UIView = {
        let v = UIView()
        v.backgroundColor = .hotPinkColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var underlineLeading: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(segmentedControl)
        contentView.addSubview(underline)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupConstraints() {
        underlineLeading = underline.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor),
            segmentedControl.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            segmentedControl.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            underline.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2),
            underlineLeading!,
            underline.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor,
                                            multiplier: 1 / CGFloat(segmentedControl.numberOfSegments))
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        moveUnderline(to: sender.selectedSegmentIndex)
        delegate?.didChangeSegment(index: sender.selectedSegmentIndex)
    }
    
    private func moveUnderline(to index: Int) {
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        underlineLeading?.constant = segmentWidth * CGFloat(index)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}

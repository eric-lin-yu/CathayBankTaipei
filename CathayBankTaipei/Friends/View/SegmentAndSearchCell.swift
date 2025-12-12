//
//  SegmentAndSearchCell.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/12.
//

import UIKit

protocol SegmentAndSearchCellDelegate: AnyObject {
    func didChangeSegment(index: Int)
    func didSearch(keyword: String)
}

class SegmentAndSearchCell: UITableViewCell {
    
    static let identifier = "SegmentAndSearchCell"
    weak var delegate: SegmentAndSearchCellDelegate?
    
    // MARK: - UI Components
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["好友", "聊天"])
        sc.selectedSegmentIndex = 0
        sc.removeBorders()
        sc.backgroundColor = .white
        
        let normalAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 13)]
        let selectedAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 13)]
        
        sc.setTitleTextAttributes(normalAttr, for: .normal)
        sc.setTitleTextAttributes(selectedAttr, for: .selected)
        sc.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    private let bottomUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .hotPinkColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Search Field
    private lazy var searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "想找誰？"
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = .black
        tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tf.layer.cornerRadius = 10
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .search
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let searchIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icBtnAddFriends")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var leadingConstraint: NSLayoutConstraint?
    
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
    
    // MARK: - Actions
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        animateUnderline(to: sender.selectedSegmentIndex)
        delegate?.didChangeSegment(index: sender.selectedSegmentIndex)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.didSearch(keyword: textField.text ?? "")
    }
    
    private func animateUnderline(to index: Int) {
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let leading = segmentWidth * CGFloat(index)
        
        leadingConstraint?.constant = leading
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(segmentedControl)
        contentView.addSubview(bottomUnderlineView)
        contentView.addSubview(searchField)
        contentView.addSubview(searchIcon)
    }
    
    private func setupConstraints() {
        leadingConstraint = bottomUnderlineView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
        
        NSLayoutConstraint.activate([
            // Segment
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor),
            segmentedControl.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            segmentedControl.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // Underline
            bottomUnderlineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: 2),
            leadingConstraint!,
            bottomUnderlineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 0.5),
            
            // Search Field
            searchField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15),
            searchField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            searchField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            // Search Icon (Right of Text Field)
            searchIcon.leftAnchor.constraint(equalTo: searchField.rightAnchor, constant: 10),
            searchIcon.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            searchIcon.centerYAnchor.constraint(equalTo: searchField.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 24),
            searchIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}

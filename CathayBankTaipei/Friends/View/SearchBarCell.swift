//
//  SearchBarCell.swift
//  CathayBankTaipei
//
//  Created by wistronits on 2025/12/12.
//
import UIKit

protocol SearchBarCellDelegate: AnyObject {
    func didSearch(keyword: String)
}

class SearchBarCell: UITableViewCell {
    
    static let identifier = "SearchBarCell"
    weak var delegate: SearchBarCellDelegate?
    
    private lazy var searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "想找誰？"
        tf.font = .systemFont(ofSize: 14)
        tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tf.layer.cornerRadius = 10
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private let searchIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icBtnAddFriends")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(searchField)
        contentView.addSubview(searchIcon)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            searchField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            searchIcon.leftAnchor.constraint(equalTo: searchField.rightAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: searchField.centerYAnchor),
            searchIcon.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            searchIcon.widthAnchor.constraint(equalToConstant: 24),
            searchIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // bottom constraint
            searchField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    @objc private func textFieldChanged(_ sender: UITextField) {
        delegate?.didSearch(keyword: sender.text ?? "")
    }
}

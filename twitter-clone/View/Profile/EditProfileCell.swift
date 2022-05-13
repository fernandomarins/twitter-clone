//
//  EditProfileCell.swift
//  twitter-clone
//
//  Created by Fernando Marins on 12/05/22.
//

import UIKit

class EditProfileCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: EditProfileViewModel? {
        didSet {
            configure()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .twitterBlue
        textField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        textField.text = "textfield"
        return textField
    }()
    
    let bioTextView: InputTextView = {
        let textView = InputTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .twitterBlue
        textView.placeholderLabel.text = "Bio"
        return textView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(
            top: topAnchor,
            paddingTop: 12,
            left: leftAnchor,
            paddingLeft: 16
        )
        
        addSubview(infoTextField)
        infoTextField.anchor(
            top: topAnchor,
            paddingTop: 4,
            left: titleLabel.rightAnchor,
            paddingLeft: 16,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingRight: 8
        )
        
        addSubview(bioTextView)
        bioTextView.anchor(
            top: topAnchor,
            paddingTop: 4,
            left: titleLabel.rightAnchor,
            paddingLeft: 16,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingRight: 8
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc private func handleUpdateUserInfo() {
        
    }
    
    // MARK: - Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        
        titleLabel.text = viewModel.titleText
        infoTextField.text = viewModel.optionValue
        bioTextView.text = viewModel.optionValue

    }
}

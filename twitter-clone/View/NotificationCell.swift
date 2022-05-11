//
//  NotificationCell.swift
//  twitter-clone
//
//  Created by Fernando Marins on 11/05/22.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func didTapProfileImage(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var notification: Notification? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 40, height: 40)
        imageView.layer.cornerRadius = 40 / 2
        imageView.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some text notification message"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stack)
        stack.addArrangedSubview(profileImageView)
        stack.addArrangedSubview(notificationLabel)
        
        stack.centerY(
            inView: self,
            leftAnchor: leftAnchor,
            paddingLeft: 12
        )
        stack.anchor(
            right: rightAnchor,
            paddingRight: 12
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func handleProfileImageTapped() {
        delegate?.didTapProfileImage(self)
    }
    
    // MARK: - Helpers
    
    private func configure() {
        guard let notification = notification else { return }
        
        let viewModel = NotificationViewModel(notification: notification)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
    }
}

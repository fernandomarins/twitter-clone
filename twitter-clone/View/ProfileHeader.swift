//
//  ProfileHeader.swift
//  twitter-clone
//
//  Created by Fernando Marins on 04/05/22.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(backButton)
        backButton.anchor(
            top: view.topAnchor,
            paddingTop: 42,
            left: view.leftAnchor,
            paddingLeft: 16
        )
        backButton.setDimensions(width: 30, height: 30)
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        imageView.layer.cornerRadius = 80 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.layer.cornerRadius = 36 / 2
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Testing"
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "@fernando.marins"
        label.textColor = .lightGray
        label.numberOfLines = 3
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "This is a user bio that will span more than one line for test purpose"
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        containerView.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: 108
        )
        
        addSubview(profileImageView)
        profileImageView.anchor(
            top: containerView.bottomAnchor,
            paddingTop: -24,
            left: leftAnchor,
            paddingLeft: 8
        )
        profileImageView.setDimensions(width: 80, height: 80)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(
            top: containerView.bottomAnchor,
            paddingTop: 12,
            right: rightAnchor,
            paddingRight: 12
        )
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        
        addSubview(stackView)
        stackView.addArrangedSubview(fullNameLabel)
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(bioLabel)
        stackView.anchor(
            top: profileImageView.bottomAnchor,
            paddingTop: 8,
            left: leftAnchor,
            paddingLeft: 12,
            right: rightAnchor,
            paddingRight: 12
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func handleDismissal() {
        
    }
    
    @objc private func handleEditProfileFollow() {
        
    }
}

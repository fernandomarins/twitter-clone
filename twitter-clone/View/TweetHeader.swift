//
//  TweetHeader.swift
//  twitter-clone
//
//  Created by Fernando Marins on 09/05/22.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -6
        return stackView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Full Name"
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 3
        label.text = "Username"
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "Sme text caption"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "Date text caption"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let retweetsLabel: UILabel = {
        let label = UILabel()
        label.text = "2 retweets"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.text = "0 likes"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            paddingLeft: 8,
            right: view.rightAnchor,
            height: 1.0
        )
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(
            left: view.leftAnchor,
            paddingLeft: 16
        )
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            paddingLeft: 8,
            right: view.rightAnchor,
            height: 1.0
        )
        
        return view
    }()
    
    private let actionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 72
        return stack
    }()
    
    private lazy var commentButton: UIButton = {
        let button = Utilities().createButton(imageName: "comment", selector: #selector(handleCommentTapped))
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = Utilities().createButton(imageName: "retweet", selector: #selector(handleRetweetTapped))
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = Utilities().createButton(imageName: "like", selector: #selector(handleLikeTapped))
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = Utilities().createButton(imageName: "share", selector: #selector(handleShareTapped))
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(labelStackView)
        
        stackView.anchor(
            top: topAnchor,
            paddingTop: 16,
            left: leftAnchor,
            paddingLeft: 16
        )
        
        labelStackView.addArrangedSubview(fullNameLabel)
        labelStackView.addArrangedSubview(userNameLabel)
        
        addSubview(captionLabel)
        captionLabel.anchor(
            top: stackView.bottomAnchor,
            paddingTop: 20,
            left: leftAnchor,
            paddingLeft: 16,
            right: rightAnchor,
            paddingRight: 16
        )
        
        addSubview(dateLabel)
        dateLabel.anchor(
            top: captionLabel.bottomAnchor,
            paddingTop: 20,
            left: leftAnchor,
            paddingLeft: 16,
            right: rightAnchor,
            paddingRight: 16
        )
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stackView)
        optionsButton.anchor(
            right: rightAnchor,
            paddingRight: 8
        )
        
        addSubview(statsView)
        statsView.anchor(
            top: dateLabel.bottomAnchor,
            paddingTop: 20,
            left: leftAnchor,
            right: rightAnchor,
            height: 40
        )
        
        addSubview(actionStack)
        actionStack.addArrangedSubview(commentButton)
        actionStack.addArrangedSubview(retweetButton)
        actionStack.addArrangedSubview(likeButton)
        actionStack.addArrangedSubview(shareButton)
        
        actionStack.anchor(
            bottom: bottomAnchor,
            paddingBottom: 12
        )
        actionStack.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectos
    
    @objc private func handleProfileImageTapped() {
        
    }
    
    @objc private func showActionSheet() {
        
    }
    
    @objc private func handleCommentTapped() {
        
    }
    
    @objc private func handleRetweetTapped() {
        
    }
    
    @objc private func handleLikeTapped() {
        
    }
    
    @objc private func handleShareTapped() {
        
    }
    
}

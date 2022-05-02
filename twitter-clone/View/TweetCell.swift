//
//  TweetCell.swift
//  twitter-clone
//
//  Created by Fernando Marins on 02/05/22.
//

import UIKit

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        return stack
    }()
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Some text caption"
        return label
    }()
    
    private let actionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 72
        return stack
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(imageName: "comment", selector: #selector(handleCommentTapped))
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(imageName: "retweet", selector: #selector(handleRetweetTapped))
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(imageName: "like", selector: #selector(handleLikeTapped))
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(imageName: "share", selector: #selector(handleShareTapped))
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Textingggg"
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(
            top: topAnchor,
            paddingTop: 12,
            left: leftAnchor,
            paddingLeft: 8
        )
        
        addSubview(stackView)
        stackView.anchor(
            top: profileImageView.topAnchor,
            left: profileImageView.rightAnchor,
            paddingLeft: 12,
            right: rightAnchor,
            paddingRight: 12
        )
        
        stackView.addArrangedSubview(captionLabel)
        stackView.addArrangedSubview(infoLabel)
        
        addSubview(actionStack)
        actionStack.addArrangedSubview(commentButton)
        actionStack.addArrangedSubview(retweetButton)
        actionStack.addArrangedSubview(likeButton)
        actionStack.addArrangedSubview(shareButton)
        
        actionStack.anchor(
            bottom: bottomAnchor,
            paddingBottom: 8
        )
        actionStack.centerX(inView: self)
        
        addSubview(underlineView)
        underlineView.anchor(
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            height: 1
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func createButton(imageName: String, selector: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    // MARK: - Selectors
    @objc private func handleCommentTapped() {
        
    }
    
    @objc private func handleRetweetTapped() {
        
    }
    
    @objc private func handleLikeTapped() {
        
    }
    
    @objc private func handleShareTapped() {
        
    }
}

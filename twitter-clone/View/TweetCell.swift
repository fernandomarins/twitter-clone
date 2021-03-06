//
//  TweetCell.swift
//  twitter-clone
//
//  Created by Fernando Marins on 02/05/22.
//

import UIKit
import SDWebImage
import ActiveLabel

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
    func handleFetchUser(withUserName username: String)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: TweetCellDelegate?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8
        return stack
    }()
    
    private let imageCaptionStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 12
        return stack
    }()
    
    private let captionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        return stack
    }()
    
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
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .twitterBlue
        return label
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
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
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
        
        addSubview(stackView)
        stackView.anchor(
            top: topAnchor,
            paddingTop: 8,
            left: leftAnchor,
            paddingLeft: 12,
            right: rightAnchor,
            paddingRight: 12
        )
        
        stackView.addArrangedSubview(replyLabel)
        stackView.addArrangedSubview(imageCaptionStack)
        
        imageCaptionStack.addArrangedSubview(profileImageView)
        imageCaptionStack.addArrangedSubview(captionStack)
        
        captionStack.addArrangedSubview(infoLabel)
        captionStack.addArrangedSubview(captionLabel)
        
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
        
        configureMentionHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    

    
    private func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        infoLabel.attributedText = viewModel.userInfoText
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
    
    private func configureMentionHandler() {
        captionLabel.handleMentionTap { [self] username in
            delegate?.handleFetchUser(withUserName: username)
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc private func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    
    @objc private func handleRetweetTapped() {
        
    }
    
    @objc private func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }
    
    @objc private func handleShareTapped() {
        
    }
}

//
//  UploadTweetController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 29/04/22.
//

import UIKit
import SDWebImage
import ActiveLabel

class UploadTweetController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private var imageCaptionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 12
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
    
    private let captionTextView = InputTextView()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        switch config {
        case .tweet:
            print("tweet")
        case .reply(let tweet):
            print("retweet to \(tweet.caption)")
        }
        
        configureMentionhandler()
    }
    
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) { [weak self] error, ref in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            
            if case .reply(let tweet) = self?.config {
                NotificationService.shared.uploadNotification(toUser: tweet.user, type: .reply, tweetID: tweet.tweetID)
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()

        view.addSubview(stack)
        stack.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: 16,
            left: view.safeAreaLayoutGuide.leftAnchor,
            paddingLeft: 16,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingRight: 16
        )
        
        stack.addArrangedSubview(replyLabel)
        stack.addArrangedSubview(imageCaptionStack)
        
        imageCaptionStack.addArrangedSubview(profileImageView)
        imageCaptionStack.addArrangedSubview(captionTextView)
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    private func configureMentionhandler() {
        replyLabel.handleMentionTap { mention in
            
        }
    }
}

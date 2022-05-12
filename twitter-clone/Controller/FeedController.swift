//
//  FeedControllerViewController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 19/04/22.
//

import UIKit
import SDWebImage

class FeedController: UICollectionViewController {

    // MARK: - Properties
    
    private var tweets = [Tweet]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private let reuseIdentifier = "tweetCell"
    
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(width: 32, height: 32)
        imageView.layer.cornerRadius = 32 / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCell()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    private func fetchTweets() {
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweets { [weak self] tweets in
            self?.tweets = tweets.sorted(by: { $0.timestamp ?? Date() > $1.timestamp ?? Date() })
            self?.checkIfUserLikedTweet()
            
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    
    private func checkIfUserLikedTweet() {
        tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikedTweet(tweet: tweet) { [weak self] didLike in
                guard didLike else { return }
                if let index = self?.tweets.firstIndex(where: { $0.tweetID == tweet.tweetID}) {
                    self?.tweets[index].didLike = true
                }
            }
        }
    }

    private func configureUI() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        configureLeftBarButton()
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureLeftBarButton() {
        guard let user = user else { return }
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    private func configureCell() {
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Selectors
    
    @objc private func handleRefresh() {
        fetchTweets()
    }
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 72)
    }
}

// MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { _, _ in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

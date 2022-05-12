//
//  ProfileController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 04/05/22.
//

import UIKit

class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    private let reuseIdentifier = "tweetCell"
    private let headerIdentifier = "profileHeader"
    
    private var user: User
    
    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private var tweets = [Tweet]()
    private var likes = [Tweet]()
    private var replies = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets:
            return tweets
        case .replies:
            return replies
        case .likes:
            return likes
        }
    }
    
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetcTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchLikeTweets()
        fetchReplies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    private func fetcTweets() {
        TweetService.shared.fetchTweets(forUser: user) { [weak self] tweets in
            self?.tweets = tweets
            self?.collectionView.reloadData()
        }
    }
    
    private func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { [weak self] isFollowed in
            self?.user.isFollowed = isFollowed
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { [weak self] stats in
            self?.user.stats = stats
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchLikeTweets() {
        TweetService.shared.fetcLikes(forUser: user) { [weak self] likes in
            self?.likes = likes
        }
    }
    
    private func fetchReplies() {
        TweetService.shared.fetchReplies(forUser: user) { [weak self] replies in
            self?.replies = replies
        }
    }
    
    // MARK: - Helpers
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        // making sure the collection view takes up the safe area, too
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
}

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.user = user
        
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // changing the cell height
        let tweet = currentDataSource[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        var height = viewModel.size(forWidth: view.frame.width).height + 72
        
        if currentDataSource[indexPath.row].isReply {
            height += 28
        }
            
        return CGSize(width: view.frame.width, height: height)
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        selectedFilter = filter
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        // if it's the current user we don't want to follow or unfollow
        if user.isCurrentUser {
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { [weak self] error, ref in
                self?.user.isFollowed = false
                self?.collectionView.reloadData()
            }
            
        } else {
            UserService.shared.followUser(uid: user.uid) { [weak self] error, ref in
                self?.user.isFollowed = true
                self?.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, user: self?.user)
            }
        }

    }
    
    func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

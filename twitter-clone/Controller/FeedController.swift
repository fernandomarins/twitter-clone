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
    
    private let reuseIdentifier = "tweetCell"
    
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    let profileImageView: UIImageView = {
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
    
    // MARK: - API
    
    private func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            print("tweets are: \(tweets)")
        }
    }
    
    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        configureLeftBarButton()
    }
    
    private func configureLeftBarButton() {
        guard let user = user else { return }
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    private func configureCell() {
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        
        return cell
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

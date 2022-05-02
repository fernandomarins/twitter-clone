//
//  FeedControllerViewController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 19/04/22.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {

    // MARK: - Properties
    
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
    }
    
    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .white
        
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
}

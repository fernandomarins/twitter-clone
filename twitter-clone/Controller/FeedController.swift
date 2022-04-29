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
        navigationItem.titleView = imageView
        
        configureLeftBarButton()
    }
    
    private func configureLeftBarButton() {
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let url = URL(string:  UserService.profileImageUrl) else { return }
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

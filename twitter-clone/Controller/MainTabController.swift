//
//  MainTabController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 19/04/22.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
//        logUserOut()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - API
    private func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async { [weak self] in
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true, completion: nil)
            }
        } else {
            configureUI()
            configureViewControllers()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
            print("Did log out")
        } catch let error {
            print("failed to signout with error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Selectors
    @objc private func actionButtonTapped() {
        
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(actionButton)
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            paddingBottom: 64,
                            right: view.rightAnchor,
                            paddingRight: 16,
                            width: 56,
                            height: 56)
        
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    private func configureViewControllers() {
        
        let feed = FeedController()
        let navFeed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let navExplore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)

        
        let notifications = NotificationsController()
        let navNotifications = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let conversation = ConversationsController()
        let navConversation = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversation)
        
        viewControllers = [navFeed, navExplore, navNotifications, navConversation]
    }
    
    private func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
    }

}

//
//  MainTabController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 19/04/22.
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    // MARK: - Helpers
    
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

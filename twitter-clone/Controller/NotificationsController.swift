//
//  NotificationsController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 19/04/22.
//

import UIKit

class NotificationsController: UITableViewController {

    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet {
            reloadTableView()
        }
    }
    
    private let reuseIdentifier = "notificationCell"
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    private func fetchNotifications() {
        NotificationService.shared.fetchNotifications { [weak self] notifications in
            self?.notifications = notifications
            
            for (index, notification) in notifications.enumerated() {
                if case .follow = notification.type {
                    let user = notification.user
                    
                    UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                        self?.notifications[index].user.isFollowed = isFollowed
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else { return }
        
        TweetService.shared.fetchTweet(withTweetID: tweetID) { [weak self] tweet in
            let controller = TweetController(tweet: tweet)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension NotificationsController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

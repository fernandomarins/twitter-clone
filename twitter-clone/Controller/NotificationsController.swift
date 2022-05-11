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
    
    // MARK: - API
    
    private func fetchNotifications() {
        NotificationService.shared.fetchNotifications { [weak self] notifications in
            self?.notifications = notifications
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
        
        return cell
    }
}

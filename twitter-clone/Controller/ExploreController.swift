//
//  ExploreController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 19/04/22.
//

import UIKit

class ExploreController: UITableViewController {

    // MARK: - Properties
    private let reuseIdentifier = "userCell"
    
    private var users = [User]() {
        didSet {
            reloadTableView()
        }
    }
    
    private var filteredUsers = [User]() {
        didSet {
            reloadTableView()
        }
    }
    
    private var inSearchMode: Bool {
        return searhController.isActive && !searhController.searchBar.text!.isEmpty
    }
    
    private let searhController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        fetchUsers()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    private func fetchUsers() {
        UserService.shared.fetchUsers { [weak self] users in
            self?.users = users
        }
    }
    
    // MARK: - Helpers
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
    }
    
    private func configureSearchController() {
        searhController.searchResultsUpdater = self
        searhController.obscuresBackgroundDuringPresentation = false
        searhController.hidesNavigationBarDuringPresentation = false
        searhController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searhController
        definesPresentationContext = false
    }
}

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({ $0.userName.contains(searchText) })
    }
}

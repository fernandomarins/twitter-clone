//
//  ConversationsController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 19/04/22.
//

import UIKit

class ConversationsController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Messages"
    }
}

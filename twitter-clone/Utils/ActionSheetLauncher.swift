//
//  ActionSheetLauncher.swift
//  twitter-clone
//
//  Created by Fernando Marins on 10/05/22.
//

import UIKit

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    
    private let user: User
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    // MARK: - Helpers
    
    func show() {
        print("action sheet for \(user.userName)")
    }
}

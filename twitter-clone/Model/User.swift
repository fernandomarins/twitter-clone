//
//  User.swift
//  twitter-clone
//
//  Created by Fernando Marins on 27/04/22.
//

import Foundation

struct User {
    let fullName: String
    let email: String
    let userName: String
    let profileImageUrl: String
    let uid: String
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.userName = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}

//
//  UserService.swift
//  twitter-clone
//
//  Created by Fernando Marins on 27/04/22.
//

import Foundation
import Firebase

struct UserService {
    static let shared = UserService()
    private init() {}
    
    static var fullName = ""
    static var email = ""
    static var userName = ""
    static var profileImageUrl = ""
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref_users.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            UserService.fullName = user.fullName
            UserService.email = user.email
            UserService.userName = user.userName
            UserService.profileImageUrl = user.profileImageUrl
        }

    }
}

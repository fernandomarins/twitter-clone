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
    
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {        
        ref_users.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }

    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        
        var users = [User]()
        
        ref_users.observe(.childAdded) { snapshot in
            
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
}

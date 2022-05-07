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
    
    func followUser(uid: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        // here the current user (currentUid) starts to follow the user (uid)
        // hence, the user (uid) gained the current user (currentUid) as a follower
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        ref_user_following.child(currentUid).updateChildValues([uid: 1]) { _, _ in
            ref_user_followers.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
}

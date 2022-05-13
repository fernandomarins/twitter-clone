//
//  UserService.swift
//  twitter-clone
//
//  Created by Fernando Marins on 27/04/22.
//

import Foundation
import Firebase
import UIKit

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

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
    
    func followUser(uid: String, completion: @escaping (DatabaseCompletion)) {
        // here the current user (currentUid) starts to follow the user (uid)
        // hence, the user (uid) gained the current user (currentUid) as a follower
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        ref_user_following.child(currentUid).updateChildValues([uid: 1]) { _, _ in
            ref_user_followers.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping (DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // here we are accessing the child's child to remove this value
        ref_user_following.child(currentUid).child(uid).removeValue { error, ref in
            ref_user_followers.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        ref_user_following.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            // checking if that particular uid exists in the database
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        ref_user_followers.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            ref_user_following.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let fileName = NSUUID().uuidString
        let ref = storage_profile_images.child(fileName)
        
        ref.putData(imageData, metadata: nil) { meta, err in
            ref.downloadURL { url, err in
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = ["profileImageUrl": profileImageUrl]
                
                ref_users.child(uid).updateChildValues(values) { err, ref in
                    completion(url)
                }
            }
        }
    }
    
    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["fullame": user.fullName,
                      "username": user.userName,
                      "bio": user.bio] as [String: AnyObject]
        
        ref_users.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
}

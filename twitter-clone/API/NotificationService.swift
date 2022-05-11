//
//  NotificationService.swift
//  twitter-clone
//
//  Created by Fernando Marins on 11/05/22.
//

import Firebase

struct NotificationService {
    
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestap": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            ref_notifications.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else {
            
        }
    }
}

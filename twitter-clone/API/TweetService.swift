//
//  TweetService.swift
//  twitter-clone
//
//  Created by Fernando Marins on 02/05/22.
//

import Firebase

struct TweetService {
    
    static let shared = TweetService()
    
    private init() {}
    
    func uploadTweet(caption: String, completion: @escaping (Error?, DatabaseReference) -> Void ) {
        // we need to know who made the tweet, that's why we get the UID
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "uid": uid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "likes": 0,
            "retweets": 0,
            "caption": caption
        ] as [String: Any]
        
        ref_tweets.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
}

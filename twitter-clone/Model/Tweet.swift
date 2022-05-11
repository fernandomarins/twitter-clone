//
//  Tweet.swift
//  twitter-clone
//
//  Created by Fernando Marins on 02/05/22.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    var likes: Int
    var timestamp: Date?
    let retweetsCount: Int
    let user: User
    var didLike = false
    
    init(user: User, tweetID: String, dictionary: [String: Any]) {
        self.user = user
        self.tweetID = tweetID
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetsCount = dictionary["retweets"] as? Int ?? 0
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}

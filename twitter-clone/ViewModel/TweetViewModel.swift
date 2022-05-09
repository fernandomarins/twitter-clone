//
//  TweetViewModel.swift
//  twitter-clone
//
//  Created by Fernando Marins on 03/05/22.
//

import Foundation
import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp ?? Date(), to: now) ?? ""
    }
    
    var userNameText: String {
        return "@\(user.userName)"
    }
    
    var headerTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ・ dd/MM/yyyy"
        return formatter.string(from: tweet.timestamp ?? Date())
    }
    
    var retweetAttributedString: NSAttributedString? {
        return Utilities().attributedText(withValue: tweet.retweetsCount, text: " Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        return Utilities().attributedText(withValue: tweet.likes, text: " Likes")
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.userName)", attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                                   .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " ・ \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                                   .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
}

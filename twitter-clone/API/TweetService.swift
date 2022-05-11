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
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping (DatabaseCompletion)) {
        // we need to know who made the tweet, that's why we get the UID
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "uid": uid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "likes": 0,
            "retweets": 0,
            "caption": caption
        ] as [String: Any]
        
        switch type {
        case .tweet:
            ref_tweets.childByAutoId().updateChildValues(values) { _, ref in
                // update user-tweet structure after tweet upload completes
                guard let tweetID = ref.key else { return }
                ref_user_tweets.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            ref_tweet_replies.child(tweet.tweetID).childByAutoId().updateChildValues(values) { err, ref in
                guard let replyKey = ref.key else { return }
                ref_user_replies.child(uid).updateChildValues([tweet.tweetID: replyKey], withCompletionBlock: completion)
            }
        }
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        ref_tweets.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            // gets the key for each tweet
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
            
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        ref_user_tweets.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweet(withTweetID tweetID: String, completion: @escaping (Tweet) -> Void) {
        ref_tweets.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchReplies(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var replies = [Tweet]()
        
        ref_user_replies.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            
            guard let replyKey = snapshot.value as? String else { return }
            
            ref_tweet_replies.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetKey, dictionary: dictionary)
                    replies.append(tweet)
                    completion(replies)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping ([Tweet]) -> Void) {
        var replies = [Tweet]()
        
        ref_tweet_replies.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                replies.append(tweet)
                completion(replies)
            }
        }
    }
    
    func fetcLikes(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var likes = [Tweet]()
        ref_user_likes.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            fetchTweet(withTweetID: tweetID) { likedTweet in
                var tweet = likedTweet
                tweet.didLike = true
                likes.append(tweet)
                completion(likes)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping (DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        // updating the likes value inside the tweets database and
        // setting its value to the like object
        ref_tweets.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            // unlike tweet
            ref_user_likes.child(uid).child(tweet.tweetID).removeValue { err, ref in
                ref_tweet_likes.child(tweet.tweetID).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            // like tweet
            ref_user_likes.child(uid).updateChildValues([tweet.tweetID: 1]) { err, ref in
                ref_tweet_likes.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet(tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref_user_likes.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}

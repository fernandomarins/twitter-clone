//
//  Constants.swift
//  twitter-clone
//
//  Created by Fernando Marins on 22/04/22.
//

import Firebase

let db_ref = Database.database().reference()
let ref_users = db_ref.child("users")
let ref_tweets = db_ref.child("tweets")
let ref_user_tweets = db_ref.child("user-tweets")
let ref_user_followers = db_ref.child("user-followers")
let ref_user_following = db_ref.child("user-following")
let ref_tweet_replies = db_ref.child("tweet-replies")
let ref_user_likes = db_ref.child("user-likes")
let ref_tweet_likes = db_ref.child("tweet-likes")
let ref_notifications = db_ref.child("notifications")
let ref_user_replies = db_ref.child("user-replies")

let storage_ref = Storage.storage().reference()
let storage_profile_images = storage_ref.child("profile_images")



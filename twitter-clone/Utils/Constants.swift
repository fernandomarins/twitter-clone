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

let storage_ref = Storage.storage().reference()
let storage_profile_images = storage_ref.child("profile_images")



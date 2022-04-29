//
//  Constants.swift
//  twitter-clone
//
//  Created by Fernando Marins on 22/04/22.
//

import Firebase

let db_ref = Database.database().reference()
let ref_users = db_ref.child("users")
let storage_ref = Storage.storage().reference()
let storage_profile_images = storage_ref.child("profile_images")

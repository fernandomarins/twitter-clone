//
//  AuthService.swift
//  twitter-clone
//
//  Created by Fernando Marins on 22/04/22.
//

import Foundation
import Firebase
import UIKit

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func registerUser(crendetials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        let email = crendetials.email
        let password = crendetials.password
        let fullName = crendetials.fullName
        let userName = crendetials.userName
        let profileImage = crendetials.profileImage
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        
        // using NSUUID to generate a random name
        let fileName = NSUUID().uuidString
        
        // creating a reference inside the storage to place the images
        let storageRef = storage_profile_images.child(fileName)
        
        storageRef.putData(imageData, metadata: nil) { meta, error in
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    // we are getting the unique uid here so we can make sure we are uploading the information
                    // to the right user, otherwise it could get mixed up
                    guard let uid = result?.user.uid else { return }
                    
                    // the values that will be sent to the database
                    let values = ["email": email, "username": userName, "fullname": fullName, "profileImageUrl": profileImageUrl]
                    
                    ref_users.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}

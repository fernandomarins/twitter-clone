//
//  EditProfileViewModel.swift
//  twitter-clone
//
//  Created by Fernando Marins on 12/05/22.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullName
    case userName
    case bio
    
    var description: String {
        switch self {
        case .fullName: return "Name"
        case .userName: return "Username"
        case .bio: return "Bio"
        }
    }
}

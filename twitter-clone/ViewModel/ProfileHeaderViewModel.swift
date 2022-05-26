//
//  ProfileHeaderViewModel.swift
//  twitter-clone
//
//  Created by Fernando Marins on 05/05/22.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let userNameText: String
    
    var followersString: NSAttributedString? {
        return Utilities().attributedText(withValue: user.stats?.followers ?? 0, text: " Followers")
    }
    
    var followingString: NSAttributedString? {
        return Utilities().attributedText(withValue: user.stats?.following ?? 0, text: " Following")
    }
    
    var actionButtonTitle: String {
        // if user is the current user then set to edit profile
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading"
    }
    
    init(user: User) {
        self.user = user
        userNameText = "@" + user.userName
    }
}

//
//  EditProfileHeader.swift
//  twitter-clone
//
//  Created by Fernando Marins on 12/05/22.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    
    // MARK: - Properties
    
    private let user: User
    
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3.0
        imageView.layer.cornerRadius = 100 / 2
        
        return imageView
    }()
    
    private let changePhotoButon: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        
        backgroundColor = .twitterBlue
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        profileImageView.setDimensions(width: 100, height: 100)
        
        addSubview(changePhotoButon)
        changePhotoButon.centerX(
            inView: self,
            topAnchor: profileImageView.bottomAnchor,
            paddingTop: 8
        )
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    
    @objc private func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
}

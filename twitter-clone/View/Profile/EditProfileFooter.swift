//
//  EditProfileFooter.swift
//  twitter-clone
//
//  Created by Fernando Marins on 13/05/22.
//

import UIKit

protocol EditProfileFooterDelegate: AnyObject {
    func handleLogout()
}

class EditProfileFooter: UIView {
    
    // MARK: - Properties
    
    private lazy var logouButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()
    
    weak var delegate: EditProfileFooterDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logouButton)
        logouButton.anchor(
            left: leftAnchor,
            paddingLeft: 16,
            right: rightAnchor,
            paddingRight: 16
        )
        logouButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logouButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func handleLogout() {
        delegate?.handleLogout()
    }
    
}

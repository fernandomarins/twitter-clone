//
//  LoginController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 19/04/22.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "TwitterLogo")
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let emailContainerView: UIView = {
        let image = UIImage(named: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image)
        return view
    }()
    
    private let passwordContainer: UIView = {
        let image = UIImage(named: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        return textField
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
        
        stackView.addArrangedSubview(emailContainerView)
        stackView.addArrangedSubview(passwordContainer)
        
        emailContainerView.addSubview(emailTextField)
        emailTextField.anchor(left: emailContainerView.leftAnchor,
                                 paddingLeft: 40,
                                 bottom: emailContainerView.bottomAnchor,
                                 paddingBottom: 8,
                                 right: emailContainerView.rightAnchor)
        
        passwordContainer.addSubview(passwordTextField)
        passwordTextField.anchor(left: passwordContainer.leftAnchor,
                                 paddingLeft: 40,
                                 bottom: passwordContainer.bottomAnchor,
                                 paddingBottom: 8,
                                 right: passwordContainer.rightAnchor)
        
    }
}

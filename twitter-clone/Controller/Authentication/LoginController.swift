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
        stackView.spacing = 20
        stackView.distribution = .fillEqually
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
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButon("Don't have an account? ", "Sign Up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc private func handleLogin() {
        
    }
    
    @objc private func handleSignUp() {
        
    }
    
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
                         paddingLeft: 16,
                         right: view.rightAnchor,
                         paddingRight: 16)
        
        stackView.addArrangedSubview(emailContainerView)
        
        emailContainerView.addSubview(emailTextField)
        emailTextField.anchor(left: emailContainerView.leftAnchor,
                                 paddingLeft: 40,
                                 bottom: emailContainerView.bottomAnchor,
                                 paddingBottom: 8,
                                 right: emailContainerView.rightAnchor)
        
        stackView.addArrangedSubview(passwordContainer)
        
        passwordContainer.addSubview(passwordTextField)
        passwordTextField.anchor(left: passwordContainer.leftAnchor,
                                 paddingLeft: 40,
                                 bottom: passwordContainer.bottomAnchor,
                                 paddingBottom: 8,
                                 right: passwordContainer.rightAnchor)
        
        stackView.addArrangedSubview(loginButton)
        
        loginButton.anchor(left: passwordContainer.leftAnchor,
                           right: passwordContainer.rightAnchor,
                           height: 50)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor,
                                     paddingLeft: 40,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingRight: 40)
    }
}

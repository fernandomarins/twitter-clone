//
//  RegistrationController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 19/04/22.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {

    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhoto), for: .touchUpInside)
        button.layer.cornerRadius = 128 / 2
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        return button
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
    
    private let emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordContainer: UIView = {
        let image = UIImage(named: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image)
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let fullNameContainerView: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image)
        return view
    }()
    
    private let fullNameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Full Name")
        return textField
    }()
    
    private let userNamedContainer: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image)
        return view
    }()
    
    private let userNameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Username")
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButon("Already have an account? ", "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureUI()
        setupTextFields()
    }
    
    // MARK: - Selectors
    
    @objc private func handleProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func handleSignUp() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let fullName = fullNameTextField.text,
              let userName = userNameTextField.text?.lowercased(),
              let profileImage = profileImage else { return }
        
        let credentials = AuthCredentials(email: email,
                                          password: password,
                                          fullName: fullName,
                                          userName: userName,
                                          profileImage: profileImage)
        
        AuthService.shared.registerUser(crendetials: credentials) { error, ref in
            print("Sign Up OK!")
            print("Handle Update User!")
        }
        
    }
    
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .twitterBlue
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusButton)
        plusButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusButton.setDimensions(width: 128, height: 128)
        
        view.addSubview(stackView)
        stackView.anchor(top: plusButton.bottomAnchor,
                         paddingTop: 8,
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
        
        stackView.addArrangedSubview(fullNameContainerView)
        
        fullNameContainerView.addSubview(fullNameTextField)
        fullNameTextField.anchor(left: fullNameContainerView.leftAnchor,
                                 paddingLeft: 40,
                                 bottom: fullNameContainerView.bottomAnchor,
                                 paddingBottom: 8,
                                 right: fullNameContainerView.rightAnchor)
        
        stackView.addArrangedSubview(userNamedContainer)
        
        userNamedContainer.addSubview(userNameTextField)
        userNameTextField.anchor(left: userNamedContainer.leftAnchor,
                                 paddingLeft: 40,
                                 bottom: userNamedContainer.bottomAnchor,
                                 paddingBottom: 8,
                                 right: userNamedContainer.rightAnchor)
        
        stackView.addArrangedSubview(signUpButton)
        
        signUpButton.anchor(left: userNamedContainer.leftAnchor,
                           right: userNamedContainer.rightAnchor,
                           height: 50)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor,
                                     paddingLeft: 40,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingRight: 40)
    }
    
    private func setupTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fullNameTextField.delegate = self
        userNameTextField.delegate = self
    }

}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        guard let imageProfile = info[.editedImage] as? UIImage else { return }
        
        profileImage = imageProfile
        
        plusButton.layer.borderColor = UIColor.white.cgColor
        plusButton.layer.borderWidth = 3
        plusButton.setImage(imageProfile.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
    }
}

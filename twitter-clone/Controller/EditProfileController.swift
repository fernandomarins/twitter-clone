//
//  EditProfileController.swift
//  twitter-clone
//
//  Created by Fernando Marins on 12/05/22.
//

import UIKit

protocol EditProfileControllerDelegate: AnyObject {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
    func handleLogout()
}

class EditProfileController: UITableViewController {
    
    // MARK: - Properties
    
    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private let reuseIdentifier = "editProfileCell"
    private let imagePicker = UIImagePickerController()
    private var userInfoChanged = false
    
    private let footer = EditProfileFooter()
    
    private var imageChanged: Bool {
        return selectdImage != nil
    }
    
    weak var delegate: EditProfileControllerDelegate?
    
    private var selectdImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectdImage
        }
    }
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        configureImagePicker()
    }
    
    // MARK: - Selectors
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDone() {
        guard imageChanged || userInfoChanged else { return }
        updatedUserData()
    }
    
    // MARK: - API
    
    private func updatedUserData() {
        
        if imageChanged && !userInfoChanged {
            updateProfileImage()
        }
        
        if userInfoChanged && !imageChanged {
            UserService.shared.saveUserData(user: user) { [self] _, _ in
                delegate?.controller(self, wantsToUpdate: user)
            }
        }
        
        if userInfoChanged && imageChanged {
            UserService.shared.saveUserData(user: user) { [weak self] _, _ in
                self?.updateProfileImage()
            }
        }
    }
    
    private func updateProfileImage() {
        guard let image = selectdImage else { return }
        
        UserService.shared.updateProfileImage(image: image) { [self] profileImageUrl in
            self.user.profileImageUrl = profileImageUrl
            delegate?.controller(self, wantsToUpdate: user)
        }

    }
    
    // MARK: - Helpers
    
    private func configureNavBar() {
        navigationController?.view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
    }
    
    private func configureTableView() {
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        
        footer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        footer.delegate = self
        tableView.tableFooterView = footer
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
}

extension EditProfileController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        
        cell.delegate = self
        
        return cell
    }
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        selectdImage = image
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        switch viewModel.option {
        case .fullName:
            guard let fullName = cell.infoTextField.text else { return }
            user.fullName = fullName
        case .userName:
            guard let userName = cell.infoTextField.text else { return }
            user.userName = userName
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}

extension EditProfileController: EditProfileFooterDelegate {
    func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            self?.delegate?.handleLogout()
            self?.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
}

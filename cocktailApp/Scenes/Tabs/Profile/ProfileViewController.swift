//
//  ProfileViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/29/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    
    let emailEditButton: UIButton = UIButton()
    let passwordEditButton: UIButton = UIButton()
    var isEmailEnabled: Bool = false
    var isPasswordEnabled: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForm()
        configureTapGesture()
    }
    
    func prepareForm() {
        //Setting up the profile picture
        setupProfileImage()
        
        //Setting up labels
        setupLabels()
        
        //Setting up email textField
        setupEmailTextField()
        
        //Setting up password textField
        setupPasswordTextField()

        //Setting up logout button
        setupLogoutButton()
    }
    
    // MARK: - Set up
    
    func setupProfileImage() {
        profileImageView.image = UIImage(systemName: "person.fill")
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    func setupLabels() {
        emailLabel.text = "Email"
        passwordLabel.text = "Password"
    }
    
    func setupEmailTextField() {
        //Setup emailTextField
        emailTextField.text = "example@email.com"
        emailTextField.isEnabled = false
    }
    
    func setupPasswordTextField() {
        //Setup passwordEditButton
        passwordEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        passwordEditButton.addTarget(self, action: #selector(enablePasswordEdit), for: .touchUpInside)
        passwordEditButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        //Setup passwordTextField
        passwordTextField.text = "password123"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.rightViewMode = UITextField.ViewMode.always
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = passwordEditButton
    }
    
    func setupLogoutButton() {
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        logoutButton.tintColor = UIColor.white
        logoutButton.titleLabel?.font = UIFont(name: "Caveat-Regular", size: 17)
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func enablePasswordEdit() {
        if !isPasswordEnabled {
            passwordTextField.allowsEditingTextAttributes = true
            passwordEditButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            isPasswordEnabled = true
            passwordTextField.isSecureTextEntry = false
            passwordTextField.becomeFirstResponder()
            print("Password editing enabled.")
        } else {
            passwordEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            passwordTextField.resignFirstResponder()
            isPasswordEnabled = false
            passwordTextField.isSecureTextEntry = true
            print("Password editing disabled.")
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        print("Email: \(emailTextField.text ?? "Email field is empty")\nPassword: \(passwordTextField.text ?? "Password field is empty")")
    }
}

// MARK: - TextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextField && !isEmailEnabled {
            return false
        }
        if textField == passwordTextField && !isPasswordEnabled {
            return false
        }
        return true
    }
}

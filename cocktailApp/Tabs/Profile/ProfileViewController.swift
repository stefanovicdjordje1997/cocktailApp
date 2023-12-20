//
//  ProfileViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/29/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    
    let nameEditButton: UIButton = UIButton()
    let passwordEditButton: UIButton = UIButton()
    var isNameEnabled: Bool = false
    var isPasswordEnabled: Bool = false
    var email: String = ""
    var password: String = ""
    var name: String = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForm()
        configureTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Settig up the background color
        backgroundView.setMainGradient()
    }
    
    func prepareForm() {
        //Setting up the profile picture
        setupProfileImage()
        
        //Setting up labels
        setupLabels()
        
        //Setup user properties
        if let user = RealmManager.instance.getLoggedInUser() {
            email = user.email
            password = user.password
            name = user.name
        }
        
        //Setting up email textField
        setupEmailTextField()
        
        //Setting up password textField
        setupPasswordTextField()
        
        //Setting up password textField
        setupNameTextField()

        //Setting up logout button
        logoutButton.setupButton(title: ButtonTitle.logout, backgroundColor: UIColor.brownLight.withAlphaComponent(0.5), tintColor: .white)
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
        emailLabel.text = LabelTitle.email
        passwordLabel.text = LabelTitle.password
    }
    
    func setupEmailTextField() {
        //Setup emailTextField
        emailTextField.text = email
        emailTextField.isEnabled = false
    }
    
    func setupPasswordTextField() {
        //Setup passwordEditButton
        passwordEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        passwordEditButton.addTarget(self, action: #selector(enablePasswordEdit), for: .touchUpInside)
        passwordEditButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        //Setup passwordTextField
        passwordTextField.text = password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.rightViewMode = UITextField.ViewMode.always
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = passwordEditButton
    }
    
    func setupNameTextField() {
        //Setup passwordEditButton
        nameEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        nameEditButton.addTarget(self, action: #selector(enableNameEdit), for: .touchUpInside)
        nameEditButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        //Setup passwordTextField
        nameTextField.text = name
        nameTextField.delegate = self
        nameTextField.rightViewMode = UITextField.ViewMode.always
        nameTextField.rightViewMode = .always
        nameTextField.rightView = nameEditButton
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    func isUserAllowed(completion: @escaping (Bool) -> Void) {
        //Create alert to check if the user is allowed to change the password
        let alert = UIAlertController(title: AlertTitle.confirm, message: AlertMessage.confirmPassword, preferredStyle: .alert)
        
        //Add a text field to the alert for the password
        alert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        //Add a Confirm button
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            //Access the entered password
            if let password = alert.textFields?.first?.text {
                //Call a function to handle password confirmation
                let isAllowed = RealmManager.instance.isLoginSuccessful(email: self?.email ?? "", password: password)
                completion(isAllowed)
            }
        })
        
        //Add a Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            return
        })
        
        //Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func enablePasswordEdit() {
        if !isPasswordEnabled {
            //Password is not enabled, check if the user is allowed to enable it and make changes
            isUserAllowed { [weak self] isAllowed in
                if isAllowed {
                    //User is allowed, let him make changes
                    self?.passwordTextField.allowsEditingTextAttributes = true
                    self?.passwordEditButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    self?.isPasswordEnabled = true
                    self?.passwordTextField.isSecureTextEntry = false
                    self?.passwordTextField.becomeFirstResponder()
                } else {
                    //User is not allowed, show alert and return
                    self?.showAlert(title: AlertTitle.warning, message: AlertMessage.notAllowed)
                    return
                }
            }
        } else {
            let oldPassword = passwordTextField.text
            //Password is enabled, update the changed password in User Realm
            if passwordTextField.text?.isValidPassword() == true {
                passwordEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                passwordTextField.resignFirstResponder()
                isPasswordEnabled = false
                passwordTextField.isSecureTextEntry = true
                RealmManager.instance.changeUserPassword(password: passwordTextField.text ?? "")
            } else {
                showAlert(title: AlertTitle.warning, message: AlertMessage.password + "is not valid ❌")
            }
        }
    }
    
    @objc func enableNameEdit() {
        if !isNameEnabled {
            //Name is not enabled, enable edit
            nameTextField.allowsEditingTextAttributes = true
            nameEditButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            isNameEnabled = true
            nameTextField.becomeFirstResponder()
        } else {
            //Name is enabled, update the changed name in User Realm
            nameEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            nameTextField.resignFirstResponder()
            isNameEnabled = false
            RealmManager.instance.changeUserName(name: nameTextField.text ?? "")
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        RealmManager.instance.logoutUser()
        navigateToViewController(fromStoryboard: UIStoryboard.authentication, withIdentifier: LoginViewController.identifier)
    }
}

// MARK: - TextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nameTextField && !isNameEnabled {
            return false
        }
        if textField == passwordTextField && !isPasswordEnabled {
            return false
        }
        return true
    }
}

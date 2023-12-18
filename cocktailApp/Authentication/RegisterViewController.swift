//
//  RegisterViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/18/23.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.setBrownGradient()
        prepareForm()
        configureTapGesture()
    }
    
    func prepareForm() {
        setupLabel()
        setupLoginButton()
        setupRegisterButton()
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
    }
    
    func setupLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .brownLight.withAlphaComponent(0.5)
        loginButton.tintColor = .white
        loginButton.titleLabel?.font = UIFont.customFontRegularNormal
    }
    
    func setupRegisterButton() {
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .white
        registerButton.tintColor = .brownDark
        registerButton.titleLabel?.font = UIFont.customFontRegularNormal
    }
    
    func setupLabel() {
        headerLabel.text = "RegiStar"
        headerLabel.font = .customFontRegularExtraLarge
    }
    
    func setupNameTextField() {
        nameTextField.placeholder = "name"
        nameTextField.delegate = self
    }
    
    func setupEmailTextField() {
        emailTextField.placeholder = "email"
        emailTextField.delegate = self
    }
    
    func setupPasswordTextField() {
        passwordTextField.placeholder = "password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
    }
    
    func isValid() -> Bool {
        var errors: [String] = []
        
        //Validate name
        if let name = nameTextField.text, name.isEmpty {
            errors.append("✍🏼Name")
        }

        //Validate email
        if let email = emailTextField.text, email.isEmpty {
            errors.append("📧Email")
        }

        //Validate password
        if let password = passwordTextField.text, password.isEmpty {
            errors.append("🔐Password")
        }

        //Handle multiple errors
        switch errors.count {
        case 1:
            showAlert(title: "Warning", message: "\(errors[0]) is required.")
            return false
        case 2:
            showAlert(title: "Warning", message: "\(errors[0...1].joined(separator: " and ")) are required.")
            return false
        case 3:
            showAlert(title: "Warning", message: "\(errors[0...1].joined(separator: ", ")) and \(errors[2]) are required.")
            return false
        default:
            return true
        }
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @IBAction func register(_ sender: Any) {
        if isValid() {
            showViewController(fromStoryboard: "Main", withIdentifier: "TabBarController")
        }
    }
    
    @IBAction func login(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

// MARK: - TextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case nameTextField:
            nameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}


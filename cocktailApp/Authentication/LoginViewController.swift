//
//  LoginViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/17/23.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.setGreenGradient()
        prepareForm()
        configureTapGesture()
    }
    
    // MARK: - Set up
    
    func prepareForm() {
        setupLabel()
        setupLoginButton()
        setupRegisterButton()
        setupEmailTextField()
        setupPasswordTextField()
    }
    
    func setupLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.tintColor = .greenDark
        loginButton.titleLabel?.font = UIFont.customFontRegularNormal
    }
    
    func setupRegisterButton() {
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .greenLight.withAlphaComponent(0.5)
        registerButton.tintColor = .white
        registerButton.titleLabel?.font = UIFont.customFontRegularNormal
    }
    
    func setupLabel() {
        headerLabel.text = "LoGin"
        headerLabel.font = .customFontRegularExtraLarge
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
        default:
            return true
        }
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: Any) {
        if isValid() {
            showViewController(fromStoryboard: "Main", withIdentifier: "TabBarController")
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let registerViewController = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "RegisterViewController")
        present(registerViewController, animated: true)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

// MARK: - TextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

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
        
        view.setGreenGradient()
        prepareForm()
        configureTapGesture()
    }
    
    // MARK: - Set up
    
    func prepareForm() {
        setupLabel()
        loginButton.setupButton(title: ButtonTitle.login, backgroundColor: .white, tintColor: .greenDark)
        registerButton.setupButton(title: ButtonTitle.register, backgroundColor: .greenLight.withAlphaComponent(0.5), tintColor: .white)
        setupEmailTextField()
        setupPasswordTextField()
    }
    
    func setupLabel() {
        headerLabel.text = LabelTitle.login
        headerLabel.font = .customFontRegularExtraLarge
    }
    
    func setupEmailTextField() {
        emailTextField.placeholder = TextFieldPlaceholder.email
        emailTextField.delegate = self
    }
    
    func setupPasswordTextField() {
        passwordTextField.placeholder = TextFieldPlaceholder.password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
    }
    
    func isValid() -> Bool {
        var errors: [String] = []
        
        //Validate email
        if let email = emailTextField.text, email.isEmpty {
            errors.append(AlertMessage.email)
        }
        
        //Validate password
        if let password = passwordTextField.text, password.isEmpty {
            errors.append(AlertMessage.password)
        }
        
        //Handle multiple errors
        switch errors.count {
            
        case 1:
            showAlert(title: AlertTitle.warning, message: "\(errors[0]) is required.")
            return false
            
        case 2:
            showAlert(title: AlertTitle.warning, message: "\(errors[0...1].joined(separator: " and ")) are required.")
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
        guard isValid() else {
            return
        }
        
        navigateToViewController(fromStoryboard: UIStoryboard.main, withIdentifier: TabBarController.identifier)
    }
    
    @IBAction func register(_ sender: Any) {
        let registerViewController = UIStoryboard.authentication.instantiateViewController(identifier: RegisterViewController.identifier)
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

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
        loginButton.setupButton(title: ButtonTitle.login, backgroundColor: .brownLight.withAlphaComponent(0.5), tintColor: .white)
        registerButton.setupButton(title: ButtonTitle.register, backgroundColor: .white, tintColor: .brownDark)
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
    }
    
    func setupLabel() {
        headerLabel.text = LabelTitle.register
        headerLabel.font = .customFontRegularExtraLarge
    }
    
    func setupNameTextField() {
        nameTextField.placeholder = TextFieldPlaceholder.name
        nameTextField.delegate = self
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
        
        //Validate name
        if let name = nameTextField.text, name.isEmpty || !name.isValidName() {
            errors.append(AlertMessage.name)
        }

        //Validate email
        if let email = emailTextField.text, email.isEmpty || !email.isValidEmail() {
            errors.append(AlertMessage.email)
        }

        //Validate password
        if let password = passwordTextField.text, password.isEmpty || !password.isValidPassword() {
            errors.append(AlertMessage.password)
        }

        //Handle multiple errors
        switch errors.count {
            
        case 1:
            showAlert(title: AlertTitle.warning, message: "\(errors[0]) is not valid. ❌")
            return false
            
        case 2:
            showAlert(title: AlertTitle.warning, message: "\(errors[0...1].joined(separator: " and ")) are not valid. ❌")
            return false
            
        case 3:
            showAlert(title: AlertTitle.warning, message: "\(errors[0...1].joined(separator: ", ")) and \(errors[2]) are not valid. ❌")
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
        //If form is not valid return
        guard isValid() else { return }
        
        let user = User(name: nameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "", isLoggedIn: true)
        
        //If user already exists show alert with message
        if RealmManager.instance.containsUser(user: user) {
            showAlert(title: AlertTitle.warning, message: AlertMessage.userExists)
            return
        }
        //User does not exist, add it to database and go to cocktails screen
        RealmManager.instance.addUser(user: user)
        navigateToViewController(fromStoryboard: UIStoryboard.main, withIdentifier: TabBarController.identifier)
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.placeholder = ""
        } else if textField == passwordTextField {
            passwordTextField.placeholder = ""
        } else {
            nameTextField.placeholder = ""
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextField.placeholder = TextFieldPlaceholder.email
        } else if textField == passwordTextField {
            passwordTextField.placeholder = TextFieldPlaceholder.password
        } else {
            nameTextField.placeholder = TextFieldPlaceholder.name
        }
    }
}


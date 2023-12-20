//
//  Constants.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/19/23.
//

import Foundation

// MARK: - Text for placeholder

struct TextFieldPlaceholder {
    static let name = "name"
    static let email = "email"
    static let password = "password"
}

// MARK: - Button title text

struct ButtonTitle {
    static let login = "Login"
    static let register = "Register"
    static let logout = "Logout"
}

// MARK: - Label title text

struct LabelTitle {
    static let email = "Email"
    static let password = "Password"
    static let login = "LoGin"
    static let register = "RegiStar"
}

// MARK: - Alert title text

struct AlertTitle {
    static let warning = "Warning"
    static let unexpected = "Oops"
    static let confirm = "Confirm"
}

// MARK: - Alert message text

struct AlertMessage {
    static let name = "Name"
    static let email = "Email"
    static let password = "Password"
    static let unknown = "Something went wrong 😕"
    static let userExists = "User already exists 😕"
    static let loginFailed = "Username and/or password are incorrect 😕"
    static let confirmPassword = "Please enter your password to confirm it's you:"
    static let notAllowed = "You are not allowed to change password ⛔️"
}

// MARK: - TabBar item title text

struct TabBarItemText {
    static let cocktails = "Cocktails"
    static let favorites = "Favorites"
    static let profile = "Profile"
}

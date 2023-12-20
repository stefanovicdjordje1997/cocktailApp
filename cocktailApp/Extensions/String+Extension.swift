//
//  String+Extension.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/19/23.
//

import Foundation

extension String {
    
    func isValidName() -> Bool {
        return matchesRegex("^[A-Za-z]+$")
    }
    
    func isValidEmail() -> Bool {
        return matchesRegex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }
    
    func isValidPassword() -> Bool {
        return matchesRegex("^(?=.*[A-Za-z])(?=.*\\d).{6,}$")
    }
    
    func matchesRegex(_ pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: utf16.count)
            return regex.firstMatch(in: self, options: [], range: range) != nil
        } catch {
            return false
        }
    }
}

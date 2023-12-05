//
//  UIViewController+Extension.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

//
//  UIViewController+Extension.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import UIKit

extension UIViewController {
    
    static var identifier: String {
            return String(describing: self)
        }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func navigateToViewController(fromStoryboard storyboard: UIStoryboard, withIdentifier identifier: String) {
        //let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController = viewController
            }
        }
    }
}

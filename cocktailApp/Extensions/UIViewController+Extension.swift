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
    
    func getMainGradient(view: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [UIColor.primaryDark.cgColor, UIColor.primaryLight.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        // Set the frame to the layer
        gradientLayer.frame = view.frame
        
        return gradientLayer
    }
}

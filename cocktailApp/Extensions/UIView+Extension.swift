//
//  UIView+Extensioon.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/7/23.
//

import UIKit

extension UIView {
    
    static var identifier: String {
            return String(describing: self)
        }
    
    func setMainGradient() {
        let gradientLayer = getGradient(startColor: .primaryDark, endColor: .primaryLight)
        gradientLayer.frame = CGRect(x: .zero, y: .zero, width: frame.size.width, height: frame.size.height)
        layer.insertSublayer(gradientLayer, at: .zero)
    }
    
    func setGreenGradient() {
        let gradientLayer = getGradient(startColor: .greenDark, endColor: .greenLight)
        gradientLayer.frame = CGRect(x: .zero, y: .zero, width: frame.size.width, height: frame.size.height)
        layer.insertSublayer(gradientLayer, at: .zero)
    }
    
    func setBrownGradient() {
        let gradientLayer = getGradient(startColor: .brownDark, endColor: .brownLight)
        gradientLayer.frame = CGRect(x: .zero, y: .zero, width: frame.size.width, height: frame.size.height)
        layer.insertSublayer(gradientLayer, at: .zero)
    }

    private func getGradient(startColor: UIColor, endColor: UIColor) -> CAGradientLayer {
        // Creating a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        return gradientLayer
    }
}


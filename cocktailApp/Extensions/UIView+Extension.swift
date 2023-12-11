//
//  UIView+Extensioon.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/7/23.
//

import UIKit

extension UIView {
    
    func setMainGradient() {
        let gradientLayer = getMainGradient()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func getMainGradient() -> CAGradientLayer {
        // Creating a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [UIColor.primaryDark.cgColor, UIColor.primaryLight.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        return gradientLayer
    }
}


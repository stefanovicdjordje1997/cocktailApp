//
//  UIButton+Extension.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/19/23.
//

import UIKit

extension UIButton {
    
    func setupButton(title: String, backgroundColor: UIColor, tintColor: UIColor) {
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        titleLabel?.font = UIFont.customFontRegularNormal
    }
}

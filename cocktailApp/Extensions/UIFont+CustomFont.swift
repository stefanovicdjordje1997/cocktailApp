//
//  UIFont+CustomFont.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/7/23.
//

import UIKit

extension UIFont {
    static var customFont: UIFont {
        return UIFont(name: "Caveat-Regular", size: 19) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    static var customBoldFont: UIFont {
        return UIFont(name: "Caveat-Bold", size: 19) ?? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }
}

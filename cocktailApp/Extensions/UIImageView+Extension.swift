//
//  UIImage+Extension.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(with drink: Drink) {
        if let url = URL(string: drink.image ?? "") {
            kf.setImage(with: url)
        } else {
            image = UIImage(systemName: "photo")
            contentMode = .scaleAspectFit
            tintColor = .gray
        }
    }
}

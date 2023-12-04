//
//  CocktailCollectionViewCell.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/30/23.
//

import UIKit

class CocktailCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "CocktailCollectionViewCell"
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    var isFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell() {
        drinkNameLabel.text = "Cocktail"
        addToFavoritesButton.setImage(UIImage(named: "favoritesOff"), for: .normal)
        layer.cornerRadius = 4
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        print("addToFavoritesButton clicked")
        let buttonName = isFavorite ? "favoritesOff" : "favoritesOn"
        addToFavoritesButton.setImage(UIImage(named: buttonName), for: .normal)
        isFavorite = !isFavorite
    }
}

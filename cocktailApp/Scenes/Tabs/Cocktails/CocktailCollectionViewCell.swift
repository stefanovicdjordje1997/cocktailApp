//
//  CocktailCollectionViewCell.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/30/23.
//

import UIKit
import Kingfisher

class CocktailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CocktailCollectionViewCell"
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    var isFavorite: Bool = false
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Set up
    
    func setupCell(with drink: Drink) {
        drinkNameLabel.text = drink.strDrink
        drinkImageView.setImage(with: drink)
        addToFavoritesButton.setImage(UIImage(named: "favoritesOff"), for: .normal)
        
        //Settig layer
        layer.cornerRadius = 4
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
    }
    
    // MARK: - Actions
    
    @IBAction func addToFavorites(_ sender: Any) {
        print("addToFavoritesButton clicked")
        let buttonName = isFavorite ? "favoritesOff" : "favoritesOn"
        addToFavoritesButton.setImage(UIImage(named: buttonName), for: .normal)
        isFavorite = !isFavorite
    }
}

//
//  CocktailCollectionViewCell.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/30/23.
//

import UIKit
import Kingfisher
import RealmSwift

protocol CellDelegate {
    func didTap(cell: CocktailCollectionViewCell, drink: Drink?)
}

class CocktailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var cellDelegate: CellDelegate?
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!

    private var drinkInstance: Drink?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Set up
    
    func setupCell(with drink: Drink) {
        drinkInstance = drink
        
        guard var tempDrink = drinkInstance else { return }
        
        //Set the isFavorite property
        tempDrink.isFavorite = RealmManager.instance.getDrink(drink: tempDrink)?.isFavorite
        
        //Set up cell values
        drinkNameLabel.text = drink.name
        drinkImageView.setImage(with: drink)
        //Set the corresponding button icon
        addToFavoritesButton.setImage(UIImage(named: tempDrink.isFavorite == true ? "favoritesOn" : "favoritesOff"), for: .normal)
        
        //Setting layer
        layer.cornerRadius = 4
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
    }
    
    private func updateDrinkRealm(_ drink: Drink?) {
        guard var drink = drink else { return }
        
        if drink.isFavorite != true {
            //Drink is no more a favorite one, set isFavorite to false
            RealmManager.instance.setFavorite(with: drink, isFavorite: false)
        } else {
            //Drink is now favorite, check if it has categoty, if not set it to other
            if RealmManager.instance.getDrink(drink: drink)?.category == "" {
                drink.category = .other
                RealmManager.instance.setCategory(with: drink)
            }
            //Set isFavorite to true
            RealmManager.instance.setFavorite(with: drink, isFavorite: true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addToFavorites(_ sender: Any) {
        //Change the state of isFavorite property
        drinkInstance?.isFavorite?.toggle()
        
        //Set isFavorite and category of the drink in realm
        updateDrinkRealm(drinkInstance)
        
        //Set up the button image
        let buttonImageName = drinkInstance?.isFavorite == true ? "favoritesOn" : "favoritesOff"
        addToFavoritesButton.setImage(UIImage(named: buttonImageName), for: .normal)
        
        cellDelegate?.didTap(cell: self, drink: drinkInstance)
    }
}

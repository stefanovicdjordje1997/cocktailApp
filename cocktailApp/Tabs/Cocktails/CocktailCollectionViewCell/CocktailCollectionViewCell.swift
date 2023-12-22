//
//  CocktailCollectionViewCell.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/30/23.
//

import UIKit
import Kingfisher
import RealmSwift

protocol DrinkDelegate {
    func didTapFavorite(drinkId: String)
}

class CocktailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var drinkDelegate: DrinkDelegate?
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!

    private var drinkInstance: Drink?
    private var user: User?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Set up
    
    func setupCell(with drink: Drink) {
        drinkInstance = drink
        
        //Set the isFavorite property
        drinkInstance?.isFavorite = RealmManager.instance.isFavoriteDrink(drinkId: drink.id)
        
        //Set up cell values
        drinkNameLabel.text = drink.name
        drinkImageView.setImage(with: drink)
        //Set the corresponding button icon
        addToFavoritesButton.setImage(UIImage(named: drinkInstance?.isFavorite == true ? "favoritesOn" : "favoritesOff"), for: .normal)
        
        //Setting layer
        layer.cornerRadius = 4
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
    }
    
    // MARK: - Actions
    
    @IBAction func addToFavorites(_ sender: Any) {
        //Change the state of isFavorite property
        drinkInstance?.isFavorite?.toggle()
        
        //Make sure drinkInstance is not nil
        guard let drink = drinkInstance else { return }
        
        //Update drink in Realm
        RealmManager.instance.updateFavorites(drinkId: drink.id)
        
        //Set up the button image
        let buttonImageName = drinkInstance?.isFavorite == true ? "favoritesOn" : "favoritesOff"
        addToFavoritesButton.setImage(UIImage(named: buttonImageName), for: .normal)
        
        drinkDelegate?.didTapFavorite(drinkId: drinkInstance?.id ?? "")
    }
}

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
    func didTap(cell: CocktailCollectionViewCell, drink: Drink)
}

class CocktailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CocktailCollectionViewCell"
    var cellDelegate: CellDelegate?
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!

    private var drinkInstance = Drink()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Set up
    
    func setupCell(with drink: Drink) {
        drinkInstance = drink
        
        //Set the isFavorite property
        drinkInstance.isFavorite = RealmManager.instance.getDrink(drink: drinkInstance)?.isFavorite
        
        //Set up cell values
        drinkNameLabel.text = drink.strDrink
        drinkImageView.setImage(with: drink)
        //Set the corresponding button icon
        addToFavoritesButton.setImage(UIImage(named: drinkInstance.isFavorite == true ? "favoritesOn" : "favoritesOff"), for: .normal)
        
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
        //Set up the button image
        let isFavorite = drinkInstance.isFavorite ?? false
        let buttonImageName = isFavorite ? "favoritesOff" : "favoritesOn"
        addToFavoritesButton.setImage(UIImage(named: buttonImageName), for: .normal)
        
        if isFavorite {
            //Already a favorite, set isFavorite to false
            RealmManager.instance.setFavorite(with: drinkInstance, isFavorite: false)
        } else {
            //Not a favorite, check if exists in Realm, if not add it
            if !RealmManager.instance.contains(drink: drinkInstance) {
                //Check if strAlcoholic is already set. This may happen when the drink is fetched from search
                if drinkInstance.strAlcoholic == nil {
                    //Doesn't have strAlcoholic, set it
                    setDrinkCategory(drinkName: drinkInstance.strDrink)
                }
                //Add drink to Realm
                RealmManager.instance.addDrink(favoriteDrink: RealmDrink(drink: drinkInstance))
            }
            //Drink alredy exists in Realm, set isFavorite to true
            RealmManager.instance.setFavorite(with: drinkInstance, isFavorite: true)
        }
        //Change the state of button when it's clicked
        drinkInstance.isFavorite?.toggle()
        cellDelegate?.didTap(cell: self, drink: drinkInstance)
    }
    
    // MARK: - Api
    
    //This function will fetch drink from API with category type and set it's strAlcoholic property
    func setDrinkCategory(drinkName: String) {
        let semaphore = DispatchSemaphore(value: 0)
        ApiManager.searchDrinks(input: drinkName) { [weak self] result in
            switch result {
                
            case .success(let apiDrinks):
                self?.drinkInstance.strAlcoholic = apiDrinks[0].strAlcoholic
            case .failure(_):
                break
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
}

//
//  DrinkDetailsViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/20/23.
//

import UIKit

protocol DrinkDetailsDelegate: Any {
    func didFetchFilteredDrinks(filteredDrinks: [Drink], filterText: String)
}

class DrinkDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var instructionsHeaderLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ingredientsHeaderLabel: UILabel!
    @IBOutlet weak var glassTypeButton: UIButton!
    @IBOutlet weak var glassTypeLabel: UILabel!
    @IBOutlet weak var glassTypeImageView: UIImageView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var alcoholicLabel: UILabel!
    @IBOutlet weak var alcoholicImageView: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    var selectedDrinkId: String = ""
    var delegate: DrinkDelegate?
    var drinkDetails: DrinkDetails?
    var drinkDetailsDelegate: DrinkDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchingDrinkData()
        
    }
    
    func fetchingDrinkData() {
        ApiManager.fetchDrinkDetails(drinkId: selectedDrinkId) { [weak self] result in
            switch result {
                
            case .success(let apiDrink):
                self?.drinkDetails = apiDrink
                self?.prepareView(drink: (self?.drinkDetails)!)
                
            case .failure(let error):
                self?.showAlert(title: AlertTitle.unexpected, message: AlertMessage.unknown)
            }
        }
    }
    
    func prepareView(drink: DrinkDetails) {
        DispatchQueue.main.async {
            //Setup drink image
            self.drinkImageView.setImage(with: drink)
            
            //Setup drink name
            self.drinkNameLabel.text = drink.name
            self.drinkNameLabel.font = .customFontBoldExtraExtraLarge
            
            //Setup favorites button
            let isFavorite = RealmManager.instance.isFavoriteDrink(drinkId: self.selectedDrinkId )
            self.drinkDetails?.isFavorite = isFavorite
            self.favoritesButton.setImage(UIImage(named: isFavorite ? "favoritesOn" : "favoritesOff"), for: .normal)
            
            //Setup alcoholic image
            self.alcoholicImageView.image = UIImage(systemName: "a.square.fill")
            self.alcoholicImageView.tintColor = .primaryDark
            
            //Setup alcoholic label
            self.alcoholicLabel.text = LabelText.alcoholic
            self.alcoholicLabel.font = .customFontBoldNormal
            
            //Setup category image
            self.categoryImageView.image = UIImage(systemName: "book.pages.fill")
            self.categoryImageView.tintColor = .primaryDark
            
            //Setup category label
            self.categoryLabel.text = LabelText.category
            self.categoryLabel.font = .customFontBoldNormal
            
            //Setup category button
            self.categoryButton.setupButton(title: drink.category ?? "", backgroundColor: .primaryDark, tintColor: .white)
            
            //Setup glass type image
            self.glassTypeImageView.image = UIImage(systemName: "wineglass.fill")
            self.glassTypeImageView.tintColor = .primaryDark
            
            //Setup glass type label
            self.glassTypeLabel.text = LabelText.glassType
            self.glassTypeLabel.font = .customFontBoldNormal
            
            //Setup glass type button
            self.glassTypeButton.setupButton(title: drink.glassType ?? "", backgroundColor: .primaryDark, tintColor: .white)
            
            //Setup ingredients header label
            self.ingredientsHeaderLabel.text = LabelText.ingredients
            self.ingredientsHeaderLabel.font = .customFontBoldExtraLarge
            
            //Setup ingredients label
            self.ingredientsLabel.text = drink.getIngredients().joined(separator: "\n")
            self.ingredientsLabel.font = .customFontRegularNormal
            
            //Setup instructions header label
            self.instructionsHeaderLabel.text = LabelText.instructions
            self.instructionsHeaderLabel.font = .customFontBoldExtraLarge
            
            //Setup instructions label
            self.instructionsLabel.text = drink.instructions
            self.instructionsLabel.font = .customFontRegularNormal
        }
    }
    
    func filterDrinks(category: String, input: String) {
        ApiManager.filterDrinks(categoryType: category, input: input) { [weak self] result in
            switch result {
                
            case .success(let apiDrinks):
                self?.drinkDetailsDelegate?.didFetchFilteredDrinks(filteredDrinks: apiDrinks, filterText: input)
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                
            case .failure(_):
                self?.showAlert(title: AlertTitle.unexpected, message: AlertMessage.unknown)
            }
        }
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        //Change the state of isFavorite property
        drinkDetails?.isFavorite?.toggle()
        
        //Make sure drinkInstance is not nil
        guard let drink = drinkDetails else { return }
        
        //Update drink in Realm
        RealmManager.instance.updateFavorites(drinkId: drink.id)
        
        //Set up the button image
        let buttonImageName = drinkDetails?.isFavorite == true ? "favoritesOn" : "favoritesOff"
        favoritesButton.setImage(UIImage(named: buttonImageName), for: .normal)
        
        delegate?.didTapFavorite(drinkId: selectedDrinkId)
    }
    
    @IBAction func navigateToCategory(_ sender: Any) {
        filterDrinks(category: "c", input: drinkDetails?.category ?? "")
    }
    
    @IBAction func naigateToGlassType(_ sender: Any) {
        filterDrinks(category: "g", input: drinkDetails?.glassType ?? "")
    }
}


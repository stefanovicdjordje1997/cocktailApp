//
//  Drink.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import Foundation

enum Category: String {
    case alcoholic = "Alcoholic"
    case nonAlcoholic = "Non Alcoholic"
    case optionalAlcohol = "Optional Alcohol"
}

// MARK: - DrinkWrapper

struct DrinkWrapper: Decodable {
    var drinks: [Drink]
}

// MARK: - Drink

struct Drink: Decodable {
    var strDrink: String
    var strDrinkThumb: String?
    var idDrink: String
    var isFavorite: Bool? = false
    var strAlcoholic: Category.RawValue?
    
    // MARK: - Drink constructors
    
    init(strDrink: String = "", strDrinkThumb: String? = nil, idDrink: String = "", isFavorite: Bool? = nil, strAlcoholic: Category? = nil) {
        self.strDrink = strDrink
        self.strDrinkThumb = strDrinkThumb
        self.idDrink = idDrink
        self.isFavorite = isFavorite
        self.strAlcoholic = strAlcoholic?.rawValue
    }
    
    init(favoriteDrink: RealmDrink) {
        self.strDrink = favoriteDrink.name
        self.strDrinkThumb = favoriteDrink.image
        self.idDrink = favoriteDrink.id
        self.isFavorite = true
        self.strAlcoholic = favoriteDrink.category
    }
}

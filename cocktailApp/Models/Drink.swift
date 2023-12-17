//
//  Drink.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import Foundation

enum Category: String {
    case alcoholic = "Alcoholic"
    case nonAlcoholic = "Non alcoholic"
    case optionalAlcohol = "Optional alcohol"
}

// MARK: - DrinkWrapper

struct DrinkWrapper: Decodable {
    var drinks: [Drink]
}

// MARK: - Drink

struct Drink: Decodable {
    var name: String
    var image: String?
    var id: String
    var isFavorite: Bool? = false
    var category: Category.RawValue?
    
    enum CodingKeys: String, CodingKey {
            case name = "strDrink"
            case image = "strDrinkThumb"
            case id = "idDrink"
            case isFavorite
            case category = "strAlcoholic"
        }
    
    // MARK: - Drink constructors
    // TODO: - Make it work without this constructor, use guards instead in CocktailCollectionViewCell
    init(strDrink: String = "", strDrinkThumb: String? = nil, idDrink: String = "", isFavorite: Bool? = nil, strAlcoholic: Category? = nil) {
        self.name = strDrink
        self.image = strDrinkThumb
        self.id = idDrink
        self.isFavorite = isFavorite
        self.category = strAlcoholic?.rawValue
    }
    
    init(favoriteDrink: RealmDrink) {
        self.name = favoriteDrink.name
        self.image = favoriteDrink.image
        self.id = favoriteDrink.id
        self.isFavorite = true
        self.category = favoriteDrink.category
    }
}

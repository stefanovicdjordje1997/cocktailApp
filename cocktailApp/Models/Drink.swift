//
//  Drink.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import Foundation

enum Category: String, Decodable {
    case alcoholic = "Alcoholic"
    case nonAlcoholic = "Non alcoholic"
    case optionalAlcohol = "Optional alcohol"
    case other = "Other"
}

// MARK: - DrinkWrapper

struct DrinkWrapper: Decodable {
    var drinks: [Drink]
}

// MARK: - Drink

struct Drink: Decodable, Equatable {
    var name: String
    var image: String?
    var id: String
    var isFavorite: Bool? = false
    var category: Category?
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case image = "strDrinkThumb"
        case id = "idDrink"
        case isFavorite
        case category = "strAlcoholic"
    }
    
    init(favoriteDrink: RealmDrink) {
        self.name = favoriteDrink.name
        self.image = favoriteDrink.image
        self.id = favoriteDrink.id
        self.isFavorite = true
        self.category = Category(rawValue: favoriteDrink.category)
    }
    
    static func == (lhs: Drink, rhs: Drink) -> Bool {
            return lhs.id == rhs.id
        }
}

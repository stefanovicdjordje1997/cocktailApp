//
//  Drink.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import Foundation

struct DrinkWrapper: Decodable {
    var drinks: [Drink]
}

struct Drink: Decodable {
    var strDrink: String
    var strDrinkThumb: String?
    var idDrink: String
}

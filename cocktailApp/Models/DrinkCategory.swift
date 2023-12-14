//
//  DrinkCategory.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/8/23.
//

import Foundation

// MARK: - DrinkCategoryWrapper

struct DrinkCategoryWrapper: Decodable {
    var drinks: [DrinkCategory]
}

// MARK: - DrinkCategory

struct DrinkCategory: Decodable {
    var strAlcoholic: String?
    var strCategory: String?
    var strIngredient1: String?
    var strGlass: String?
}

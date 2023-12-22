//
//  DrinkDetails.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/20/23.
//

import Foundation

struct DrinkDetailsWrapper: Decodable {
    var drinks: [DrinkDetails]
}

struct DrinkDetails: Decodable {
    var id: String
    var name: String
    var category: String
    var alcoholic: String
    var glassType: String
    var instructions: String
    var image: String?
    var isFavorite: Bool? = false
    private var ingredient1: String?
    private var ingredient2: String?
    private var ingredient3: String?
    private var ingredient4: String?
    private var ingredient5: String?
    private var ingredient6: String?
    private var ingredient7: String?
    private var ingredient8: String?
    private var ingredient9: String?
    private var ingredient10: String?
    private var ingredient11: String?
    private var ingredient12: String?
    private var ingredient13: String?
    private var ingredient14: String?
    private var ingredient15: String?
    private var measure1: String?
    private var measure2: String?
    private var measure3: String?
    private var measure4: String?
    private var measure5: String?
    private var measure6: String?
    private var measure7: String?
    private var measure8: String?
    private var measure9: String?
    private var measure10: String?
    private var measure11: String?
    private var measure12: String?
    private var measure13: String?
    private var measure14: String?
    private var measure15: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case image = "strDrinkThumb"
        case id = "idDrink"
        case alcoholic = "strAlcoholic"
        case instructions = "strInstructions"
        case glassType = "strGlass"
        case category = "strCategory"
        case isFavorite
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case measure1 = "strMeasure1"
        case measure2 = "strMeasure2"
        case measure3 = "strMeasure3"
        case measure4 = "strMeasure4"
        case measure5 = "strMeasure5"
        case measure6 = "strMeasure6"
        case measure7 = "strMeasure7"
        case measure8 = "strMeasure8"
        case measure9 = "strMeasure9"
        case measure10 = "strMeasure10"
        case measure11 = "strMeasure11"
        case measure12 = "strMeasure12"
        case measure13 = "strMeasure13"
        case measure14 = "strMeasure14"
        case measure15 = "strMeasure15"
    }
    //Array of ingredients with possibly nil values
    var ingredients: [String?] {
        [ingredient1, ingredient2, ingredient3, ingredient4, ingredient5,
         ingredient6, ingredient7, ingredient8, ingredient9, ingredient10,
         ingredient11, ingredient12, ingredient13, ingredient14, ingredient15]
    }
    //Array of measures with possibly nil values
    var measures: [String?] {
        [measure1, measure2, measure3, measure4, measure5,
         measure6, measure7, measure8, measure9, measure10,
         measure11, measure12, measure13, measure14, measure15]
    }
    
    func getIngredients() -> [String] {
        var ingredientsWithMeasures: [String] = []
        for i in 0..<ingredients.count {
            guard let ingredient = ingredients[i] else { continue }
            if let measure = measures[i] {
                let trimmedMeasure = measure.trimmingCharacters(in: .whitespaces)
                ingredientsWithMeasures.append("\(ingredient) (\(trimmedMeasure))")
            } else {
                ingredientsWithMeasures.append(ingredient)
            }
        }

        return ingredientsWithMeasures
    }
}

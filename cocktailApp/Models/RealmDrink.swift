//
//  FavoriteDrink.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/11/23.
//

import RealmSwift

//MARK: - RealmDrink

class RealmDrink: Object {
    @Persisted var name: String
    @Persisted var image: String?
    @Persisted var id: String
    @Persisted var category: String
    @Persisted var isFavorite: Bool
    
    //MARK: - Constructor
    
    convenience init(drink: Drink) {
        self.init()
        self.name = drink.name 
        self.image = drink.image ?? ""
        self.id = drink.id 
        self.category = drink.category?.rawValue ?? ""
        self.isFavorite = drink.isFavorite ?? false
    }
}

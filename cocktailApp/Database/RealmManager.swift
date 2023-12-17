//
//  RealmManager.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/12/23.
//

import RealmSwift

class RealmManager {
    
    //MARK: - Properties
    
    static var instance = RealmManager()
    private var realm: Realm
    
    //MARK: - Private constructor
    
    private init() {
        realm = try! Realm()
    }
    
    // MARK: - Public Methods

    func addDrink(realmDrink: RealmDrink) {
        try! realm.write {
            realm.add(realmDrink)
        }
    }

    func getDrinks() -> Results<RealmDrink> {
        return realm.objects(RealmDrink.self)
    }
    
    func getFavoriteDrinks() -> Results<RealmDrink> {
        return getDrinks().filter("isFavorite == true")
    }
    
    func getAlcoholicDrinks() -> Results<RealmDrink> {
        return getDrinks().filter("category == 'Alcoholic'")
    }

    func deleteDrink(favoriteDrink: RealmDrink) {
        try! realm.write {
            realm.delete(favoriteDrink)
        }
    }
    
    func contains(drink: Drink) -> Bool {
        return getDrinks().contains(where: { $0.id == drink.id })
    }
    
    func getDrink(drink: Drink) -> RealmDrink? {
        return getDrinks().filter("id == %@", drink.id as Any).first
    }
    
    func setFavorite(with drink: Drink, isFavorite: Bool) {
        try! realm.write {
            getDrinks().filter("id == %@", drink.id as Any).first?.isFavorite = isFavorite
        }
    }
    
    func setCategory(with drink: Drink) {
        try! realm.write {
            getDrinks().filter("id == %@", drink.id as Any).first?.category = drink.category
        }
    }
}

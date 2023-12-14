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

    func addDrink(favoriteDrink: RealmDrink) {
        try! realm.write {
            realm.add(favoriteDrink)
        }
    }

    func getDrinks() -> Results<RealmDrink> {
        return realm.objects(RealmDrink.self)
    }
    
    func getFavoriteDrinks() -> Results<RealmDrink> {
        return realm.objects(RealmDrink.self).filter("isFavorite == true")
    }

    func deleteDrink(favoriteDrink: RealmDrink) {
        try! realm.write {
            realm.delete(favoriteDrink)
        }
    }
    
    func contains(drink: Drink) -> Bool {
        return realm.objects(RealmDrink.self).filter("id == %@", drink.idDrink as Any).first != nil
    }
    
    func getDrink(drink: Drink) -> RealmDrink? {
        if contains(drink: drink) {
            return realm.objects(RealmDrink.self).filter("id == %@", drink.idDrink as Any).first
        }
        return nil
    }
    
    func setFavorite(with drink: Drink, isFavorite: Bool) {
        try! realm.write {
            realm.objects(RealmDrink.self).filter("id == %@", drink.idDrink as Any).first?.isFavorite = isFavorite
        }
    }
}

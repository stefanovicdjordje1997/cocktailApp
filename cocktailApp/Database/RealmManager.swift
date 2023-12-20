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
    
    // MARK: - Public Drink methods

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
    
    func containsDrink(drink: Drink) -> Bool {
        return getDrinks().contains(where: { $0.id == drink.id })
    }
    
    func getDrink(drink: Drink) -> RealmDrink? {
        return getDrinks().filter("id == %@", drink.id as Any).first
    }
    
    func setFavorite(with drink: Drink, isFavorite: Bool) {
        try! realm.write {
            getDrink(drink: drink)?.isFavorite = isFavorite
        }
    }
    
    func setCategory(with drink: Drink) {
        try! realm.write {
            getDrink(drink: drink)?.category = drink.category?.rawValue ?? ""
        }
    }
    
    // MARK: - Public User methods
    
    func addUser(user: User) {
        try! realm.write {
            realm.add(user)
        }
    }
    
    func getUsers() -> Results<User> {
        return realm.objects(User.self)
    }
    
    func containsUser(user: User) -> Bool {
        return getUsers().contains(where: { $0.email == user.email })
    }
    
    func isLoginSuccessful(email: String, password: String) -> Bool {
        guard let user = getUsers().filter("email == %@ AND password == %@", email, password).first else { return false}
        try! realm.write {
            user.isLoggedIn = true
        }
        return true
    }
    
    func isLoggedIn() -> Bool {
        return getUsers().contains(where: { $0.isLoggedIn == true })
    }
    
    func logoutUser() {
        try! realm.write {
            getUsers().filter("isLoggedIn == true").first?.isLoggedIn = false
        }
    }
    
    func getLoggedInUser() -> User? {
        return getUsers().filter("isLoggedIn == true")[0]
    }
}

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
    
    // MARK: - Drink methods
    
    func addFavoriteDrink(realmDrink: RealmDrink) {
        try! realm.write {
            getLoggedInUser()?.favoriteDrinks.append(realmDrink.id)
        }
    }
    
    func removeFavoriteDrink(realmDrink: RealmDrink) {
        try! realm.write {
            if let user = getLoggedInUser(),
               let index = user.favoriteDrinks.firstIndex(where: { $0 == realmDrink.id }) {
                user.favoriteDrinks.remove(at: index)
            }
        }
    }

    private func getDrinks() -> Results<RealmDrink> {
        return realm.objects(RealmDrink.self)
    }
    
    func getFavoriteDrinks() -> Results<RealmDrink> {
        return getDrinks().filter("id IN %@", getLoggedInUser()?.favoriteDrinks as Any)
    }
    
    func getAlcoholicDrinks() -> Results<RealmDrink> {
        return getDrinks().filter("category == 'Alcoholic'")
    }
    
    func isFavoriteDrink(drink: Drink) -> Bool {
        guard let user = getLoggedInUser() else {
            return false
        }
        
        let favoriteDrinks = user.favoriteDrinks
        let isFavorite = favoriteDrinks.contains { id in
            return id == drink.id
        }
        
        return isFavorite
    }
    
    // MARK: - User methods
    
    func addUser(user: User) {
        try! realm.write {
            realm.add(user)
        }
    }
    
    private func getUsers() -> Results<User> {
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
    
    func changeUserPassword(password: String) {
        try! realm.write {
            getLoggedInUser()?.password = password
        }
    }
    
    func changeUserName(name: String) {
        try! realm.write {
            getLoggedInUser()?.name = name
        }
    }

}

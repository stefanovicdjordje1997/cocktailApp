//
//  User.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/19/23.
//

import RealmSwift

class User: Object {
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var password: String
    @Persisted var isLoggedIn: Bool
    @Persisted var favoriteDrinks = List<String>()
    
    convenience init(name: String, email: String, password: String, isLoggedIn: Bool) {
        self.init()
        self.name = name
        self.email = email
        self.password = password
        self.isLoggedIn = isLoggedIn
    }
}

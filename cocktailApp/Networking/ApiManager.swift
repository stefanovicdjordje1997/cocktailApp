//
//  ApiManager.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import Foundation
import RealmSwift

class ApiManager {
    
    // MARK: - Base url
    
    static let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    // MARK: - Fetch drinks
    
    static func fetchDrinks(alcoholic: Category, completionHandler: @escaping (Result<[Drink], Error>) -> Void) {
        let endpoint = "filter.php?a=\(alcoholic.rawValue)"
        //Create URL
        guard let url = URL(string: baseUrl + endpoint) else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
            return
        }
        //Create URL session
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(DrinkErrors.apiError))
                return
            }
            if let data {
                //Decode response
                if let decodedResponse = try? JSONDecoder().decode(DrinkWrapper.self, from: data) {
                    var drinks = decodedResponse.drinks
                    //Set value category propertie and save drinks to Realm
                    saveToRealm(drinks: &drinks, alcoholic: alcoholic)
                    completionHandler(.success(drinks))
                } else {
                    completionHandler(.failure(DrinkErrors.decodingError))
                }
            } else {
                completionHandler(.failure(NetworkErrors.noDataError))
            }
        }
        task.resume()
        
    }
    
    // MARK: - Search drinks
    
    static func searchDrinks(input: String, completionHandler: @escaping (Result<[Drink], Error>) -> Void) {
        let endpoint = "search.php?s=\(input)"
        //Create URL
        guard let url = URL(string: baseUrl + endpoint) else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
            return
        }
        //Create URL session
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(DrinkErrors.apiError))
                return
            }
            if let data {
                //Decode response
                if let decodedResponse = try? JSONDecoder().decode(DrinkWrapper.self, from: data) {
                    var drink = decodedResponse.drinks
                    saveToRealm(drinks: &drink)
                    completionHandler(.success(drink))
                } else {
                    completionHandler(.failure(DrinkErrors.decodingError))
                }
            } else {
                completionHandler(.failure(NetworkErrors.noDataError))
            }
        }
        task.resume()
    }
    
    // MARK: - Fetch drink categories
    
    static func fetchCategories(input: String, completionHandler: @escaping (Result<[DrinkCategory], Error>) -> Void) {
        let endpoint = "list.php?\(input)=list"
        //Create URL
        guard let url = URL(string: baseUrl + endpoint) else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
            return
        }
        //Create URL session
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(DrinkErrors.apiError))
                return
            }
            if let data {
                //Decode response
                if let decodedResponse = try? JSONDecoder().decode(DrinkCategoryWrapper.self, from: data) {
                    completionHandler(.success(decodedResponse.drinks))
                } else {
                    completionHandler(.failure(DrinkErrors.decodingError))
                }
            } else {
                completionHandler(.failure(NetworkErrors.noDataError))
            }
        }
        task.resume()
    }
    
    // MARK: - Filter drinks
    
    static func filterDrinks(categoryType: String, input: String, completionHandler: @escaping (Result<[Drink], Error>) -> Void) {
        let endpoint = "filter.php?\(categoryType)=\(input)"
        //Create URL
        guard let url = URL(string: baseUrl + endpoint) else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
            return
        }
        //Create URL session
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(DrinkErrors.apiError))
                return
            }
            if let data {
                //Decode response
                if let decodedResponse = try? JSONDecoder().decode(DrinkWrapper.self, from: data) {
                    var drink = decodedResponse.drinks
                    saveToRealm(drinks: &drink, alcoholic: .other)
                    completionHandler(.success(drink))
                } else {
                    completionHandler(.failure(DrinkErrors.decodingError))
                }
            } else {
                completionHandler(.failure(NetworkErrors.noDataError))
            }
        }
        task.resume()
    }
    
    // MARK: - Fetch drink by name
    
    static func fetchDrinkByName(name: String, completionHandler: @escaping (Result<Drink, Error>) -> Void)  {
        let endpoint = "search.php?s=\(name)"
        //Create URL
        guard let url = URL(string: baseUrl + endpoint) else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
            return
        }
        //Create URL session
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(DrinkErrors.apiError))
                return
            }
            if let data {
                //Decode response
                if let decodedResponse = try? JSONDecoder().decode(DrinkWrapper.self, from: data) {
                    completionHandler(.success(decodedResponse.drinks[0]))
                } else {
                    completionHandler(.failure(DrinkErrors.decodingError))
                }
            } else {
                completionHandler(.failure(NetworkErrors.noDataError))
            }
        }
        task.resume()
    }
    
    // MARK: - Save to realm function
    
    private static func saveToRealm(drinks: inout [Drink], alcoholic: Category? = nil) {
        let realm = try! Realm()
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
        for i in 0..<drinks.count {
            //Set the category property
            if drinks[i].category == nil {
                drinks[i].category = alcoholic
            }
            //Check if the drink exists in Realm, and if not add it
            if !realm.objects(RealmDrink.self).contains(where: {$0.id == drinks[i].id}) {
                try! realm.write {
                    realm.add(RealmDrink(drink: drinks[i]))
                }
            }
        }
    }
}

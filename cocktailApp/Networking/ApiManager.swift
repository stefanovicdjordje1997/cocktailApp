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
        if let url = URL(string: baseUrl + endpoint) {
            
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
                        //Set values for isFavorite and category properties and save drinks to Realm
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
        } else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
        }
    }
    
    // MARK: - Search drinks
    
    static func searchDrinks(input: String, completionHandler: @escaping (Result<[Drink], Error>) -> Void) {
        let endpoint = "search.php?s=\(input)"
        //Create URL
        if let url = URL(string: baseUrl + endpoint) {
            
            //Create URL session
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completionHandler(.failure(DrinkErrors.apiError))
                    return
                }
                if let data {
                    //Decode response
                    if let decodedResponse = try? JSONDecoder().decode(DrinkWrapper.self, from: data) {
                        completionHandler(.success(decodedResponse.drinks))
                    } else {
                        completionHandler(.failure(DrinkErrors.decodingError))
                    }
                } else {
                    completionHandler(.failure(NetworkErrors.noDataError))
                }
            }
            task.resume()
        } else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
        }
    }
    
    // MARK: - Fetch drink categories
    
    static func fetchCategories(input: String, completionHandler: @escaping (Result<[DrinkCategory], Error>) -> Void) {
        let endpoint = "list.php?\(input)=list"
        //Create URL
        if let url = URL(string: baseUrl + endpoint) {
            
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
        } else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
        }
    }
    
    // MARK: - Filter drinks
    
    static func filterDrinks(categoryType: String, input: String, completionHandler: @escaping (Result<[Drink], Error>) -> Void) {
        let endpoint = "filter.php?\(categoryType)=\(input)"
        //Create URL
        if let url = URL(string: baseUrl + endpoint) {
            
            //Create URL session
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completionHandler(.failure(DrinkErrors.apiError))
                    return
                }
                if let data {
                    //Decode response
                    if let decodedResponse = try? JSONDecoder().decode(DrinkWrapper.self, from: data) {
                        completionHandler(.success(decodedResponse.drinks))
                    } else {
                        completionHandler(.failure(DrinkErrors.decodingError))
                    }
                } else {
                    completionHandler(.failure(NetworkErrors.noDataError))
                }
            }
            task.resume()
        } else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
        }
    }
    
    // MARK: - Fetch drink by name
    
    static func fetchDrinkByName(name: String, completionHandler: @escaping (Result<Drink, Error>) -> Void)  {
        let endpoint = "search.php?s=\(name)"
        //Create URL
        if let url = URL(string: baseUrl + endpoint) {
            
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
        } else {
            completionHandler(.failure(NetworkErrors.invalidUrlError))
        }
    }
    
    // MARK: - Save to realm function
    
    private static func saveToRealm(drinks: inout [Drink], alcoholic: Category) {
        let realm = try! Realm()
        for i in 0..<drinks.count {
            //Set the category property
            drinks[i].strAlcoholic = alcoholic.rawValue
            //Set the favorite property
            if realm.objects(RealmDrink.self).filter("id == %@", drinks[i].idDrink as Any).first?.isFavorite == true {
                drinks[i].isFavorite = true
            } else {
                drinks[i].isFavorite = false
            }
            //Check if the drink exists in Realm, and if not add it
            if realm.objects(RealmDrink.self).filter("id == %@", drinks[i].idDrink as Any).first == nil {
                try! realm.write {
                    realm.add(RealmDrink(drink: drinks[i]))
                }
            }
        }
    }
}

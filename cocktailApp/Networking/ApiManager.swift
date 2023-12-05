//
//  ApiManager.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import Foundation

class ApiManager {
    
    // MARK: - Base url
    
    static let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    // MARK: - Fetch drinks
    
    static func fetchDrinks(completionHandler: @escaping (Result<[Drink], Error>) -> Void) {
        let endpoint = "filter.php?a=Alcoholic"
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
}

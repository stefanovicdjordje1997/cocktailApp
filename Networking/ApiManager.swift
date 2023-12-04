//
//  ApiManager.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/4/23.
//

import Foundation

class ApiManager {
    static let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    static func fetchDrinks(completionHandler: @escaping ([Drink]) -> Void) {
        let endpoint = "filter.php?a=Alcoholic"
        //Create URL
        if let url = URL(string: baseUrl + endpoint) {
            
            //Create URL session
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    print("Error fetching")
                    return
                }
                if let data {
                    //Decode response
                    let drinkWrapper = try? JSONDecoder().decode(DrinkWrapper.self, from: data)
                    completionHandler(drinkWrapper?.drinks ?? [])
                    //print(drinks)
                } else {
                    print("Error: No data")
                }
            }
            task.resume()
            
        } else {
            print("Error creating url")
        }
        
        

    }
}

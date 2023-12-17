//
//  ViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/27/23.
//

import UIKit

class SplashViewController: UIViewController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        showViewController(fromStoryboard: "Main", withIdentifier: "TabBarController")
        
    }
    
    //MARK: - Functions
    
    func showViewController(fromStoryboard storyboardName: String, withIdentifier identifier: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController = viewController
            }
        }
    }
    
    func loadData() {
        //Load Non Alcoholic data
        ApiManager.fetchDrinks(alcoholic: .nonAlcoholic) { result in }
        //Load Optional Alcohol data
        ApiManager.fetchDrinks(alcoholic: .optionalAlcohol) { result in }
    }
}


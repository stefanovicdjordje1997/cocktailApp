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
        
        //Show TabBarController after SplashScreen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController = viewController
            }
        }
    }
    
    //MARK: - Functions
    
    func loadData() {
        //Load Non Alcoholic data
        ApiManager.fetchDrinks(alcoholic: .nonAlcoholic) { result in }
        //Load Optional Alcohol data
        ApiManager.fetchDrinks(alcoholic: .optionalAlcohol) { result in }
    }
}


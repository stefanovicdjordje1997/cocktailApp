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
        if RealmManager.instance.isLoggedIn() {
            navigateToViewController(fromStoryboard: UIStoryboard.main, withIdentifier: TabBarController.identifier)
        } else {
            navigateToViewController(fromStoryboard: UIStoryboard.authentication, withIdentifier: LoginViewController.identifier)
        }
    }
    
    // MARK: - Functions
    
    func loadData() {
        //Load Non Alcoholic data
        ApiManager.fetchDrinks(alcoholic: .nonAlcoholic) { result in }
        //Load Optional Alcohol data
        ApiManager.fetchDrinks(alcoholic: .optionalAlcohol) { result in }
    }
}


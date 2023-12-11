//
//  TabBarController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/28/23.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupNavBar()
    }
    
    // MARK: - TabBar
    
    func setupTabBar() {
        //Set up the tabBar color
        let appearance = UITabBarAppearance()
        
        
        
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .primaryDark
        appearance.stackedLayoutAppearance.normal.iconColor = .white.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.caveatRegularSmall]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.caveatRegularSmall]
        
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
        
        UIBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.caveatRegularLarge], for: .normal)
        
        //Set uo the tabBar border
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.borderColor
        
        //Set up the tabBar icons
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        
        // Customize the font for tabBar items
            let customFontAttribute = [NSAttributedString.Key.font: UIFont.caveatRegularLarge]
            let customSelectedFontAttribute = [NSAttributedString.Key.font: UIFont.caveatBoldLarge]

            if let tabBarItems = tabBar.items {
                for item in tabBarItems {
                    item.setTitleTextAttributes(customFontAttribute, for: .normal)
                    item.setTitleTextAttributes(customSelectedFontAttribute, for: .selected)
                }
            }
        
        if let item1 = tabBar.items?[0] {
            item1.image = UIImage(systemName: "wineglass")
            item1.title = "Cocktails"
            item1.selectedImage = UIImage(systemName: "wineglass.fill")
        }
        
        if let item2 = tabBar.items?[1] {
            item2.image = UIImage(systemName: "heart")
            item2.title = "Favorites"
            item2.selectedImage = UIImage(systemName: "heart.fill")
        }
        
        if let item3 = tabBar.items?[2] {
            item3.image = UIImage(systemName: "person")
            item3.title = "Profile"
            item3.selectedImage = UIImage(systemName: "person.fill")
        }
    }
    
    // MARK: - NavBar
    
    func setupNavBar() {
        //Set up up the navigationBar
        let attributes = [NSAttributedString.Key.font: UIFont.caveatBoldLarge, NSAttributedString.Key.foregroundColor: UIColor.black]
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .primaryLight
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.caveatBoldLarge]
        appearance.titleTextAttributes = attributes
        appearance.buttonAppearance.normal.titleTextAttributes = attributes
        
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
}

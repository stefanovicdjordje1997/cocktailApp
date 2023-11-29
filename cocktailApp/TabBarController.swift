//
//  TabBarController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/28/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }
    
    func setupTabBar() {
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.gray.cgColor
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        
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

}

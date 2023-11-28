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
            item1.selectedImage = UIImage(systemName: "wineglass.fill")
        }
        
        if let item2 = tabBar.items?[1] {
            item2.selectedImage = UIImage(systemName: "heart.fill")
        }
        
        if let item3 = tabBar.items?[2] {
            item3.selectedImage = UIImage(systemName: "person.fill")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

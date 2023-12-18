//
//  FavoritesViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/11/23.
//

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    var drinkCategories: [(category: Category, drinks: [Drink])] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        populateDrinkCategories()
        setupBackgroundView()
        favoritesCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backgroundView.setMainGradient()
    }
    
    // MARK: - Set up
    
    func setupCollectionView() {
        //Set up the collectionView
        favoritesCollectionView.register(UINib(nibName: CocktailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CocktailCollectionViewCell.identifier)
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        
        //Setting the favoritesCollectionView background to be transparent
        favoritesCollectionView.backgroundColor = UIColor.clear
    }
    
    func populateDrinkCategories() {
        let favoriteDrinks = RealmManager.instance.getFavoriteDrinks()
        drinkCategories = []

        for favoriteDrink in favoriteDrinks {
            //Create a Drink object from the FavoriteDrink
            let drink = Drink(favoriteDrink: favoriteDrink)

            //Determine the category based on strAlcoholic
            guard let category = Category(rawValue: favoriteDrink.category ?? "") else { continue }

            //Check if the category already exists in drinkCategories
            if let index = drinkCategories.firstIndex(where: { $0.category == category }) {
                //Category exists, append the drink to its drinks array
                drinkCategories[index].drinks.append(drink)
            } else {
                //Category doesn't exist, create a new category and add the drink
                drinkCategories.append((category: category, drinks: [drink]))
            }
        }
    }
    
    func setupBackgroundView() {
        if drinkCategories.isEmpty {
            let emptyView  = Bundle.main.loadNibNamed(CocktailsEmptyView.identifier, owner: self)?.first as? CocktailsEmptyView
            emptyView?.setupLabel(withMessage: "No favorite cocktails yet 🍸")
            self.favoritesCollectionView.backgroundView = emptyView
        } else {
            self.favoritesCollectionView.backgroundView = nil
        }
    }
}

// MARK: - FavoritesViewController

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return drinkCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return drinkCategories[section].drinks.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailCollectionViewCell.identifier, for: indexPath) as! CocktailCollectionViewCell
        
        cell.cellDelegate = self
        
        let drink = drinkCategories[indexPath.section].drinks[indexPath.item]
        cell.setupCell(with: drink)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = favoritesCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        
        header.setupLabel(with: drinkCategories[indexPath.section].category.rawValue)
        return header
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 12
        return CGSize(width: width, height: 1.5 * width)
    }
    
    
}

// MARK: - CellDelegaate

extension FavoritesViewController: CellDelegate {
    
    func didTap(cell: CocktailCollectionViewCell, drink: Drink?) {
         
        if let indexPath = favoritesCollectionView.indexPath(for: cell) {
            let section = indexPath.section
            let item = indexPath.item
            
            //Update drinkCategories
            drinkCategories[section].drinks.remove(at: item)
            
            //Delete the item or section from the collection view
            favoritesCollectionView.performBatchUpdates({
                if drinkCategories[section].drinks.isEmpty {
                    //If the section is now empty, delete the entire section
                    drinkCategories.remove(at: section)
                    favoritesCollectionView.deleteSections(IndexSet([section]))
                } else {
                    //If there are remaining items in the section, delete only the item
                    favoritesCollectionView.deleteItems(at: [IndexPath(item: item, section: section)])
                }
            }, completion: nil)
        }
        
        setupBackgroundView()
    }
}

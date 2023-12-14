//
//  CocktailsViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 11/30/23.
//

import UIKit
import NVActivityIndicatorView

class CocktailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var viewLabel: UIView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var cocktailsCollectionView: UICollectionView!
    
    let search = UISearchController(searchResultsController: nil)
    var searchButton = UIButton(type: .custom)
    var filterButton = UIButton(type: .custom)
    var searchBarButtonItem = UIBarButtonItem()
    var filterBarButtonItem = UIBarButtonItem()
    var drinks: [Drink] = []
    var previousFavoriteDrinksCount = 0
    var drinksFromSearch: [Drink] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.search.searchBar.text?.isEmpty == false && self.drinksFromSearch.isEmpty {
                    let emptyView  = Bundle.main.loadNibNamed(CocktailsEmptyView.identifier, owner: self)?.first as? CocktailsEmptyView
                    emptyView?.setupLabel(withMessage: "No cocktails found 😕")
                    self.cocktailsCollectionView.backgroundView = emptyView
                } else {
                    self.cocktailsCollectionView.backgroundView = nil
                }
            }
        }
    }
    let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),type: .orbit, color: .primaryDark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupValues()
        setupCollectionView()
        fetchingDrinkData()
        configureTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.setMainGradient()
        reloadDrinkData()
    }
    
    // MARK: - Set up
    
    func setupValues() {
        setupLabel()
        setupNavBarButtons()
        setupLoader()
        setupSearchController()
        previousFavoriteDrinksCount = RealmManager.instance.getFavoriteDrinks().count
    }
    
    func setupLabel() {
        //Creating an NSAttributedString with the desired background color
        let attributedString = NSMutableAttributedString(string: "Alcoholic" )
        let range = NSMakeRange(0, attributedString.length)
        
        //Setting the background color for the text
        attributedString.addAttribute(.backgroundColor, value: UIColor.filterColor, range: range)
        
        //Assigning the attributed string to the label
        resultsLabel.attributedText = attributedString
        
        //Setting the border
        viewLabel.layer.borderWidth = 0.5
        viewLabel.layer.borderColor = UIColor.borderColor
    }
    
    func setupCollectionView() {
        //Set up the collectionView
        cocktailsCollectionView.register(UINib(nibName: CocktailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CocktailCollectionViewCell.identifier)
        cocktailsCollectionView.dataSource = self
        cocktailsCollectionView.delegate = self
        
        //Setting the cocktailsCollectionView to be transparent
        cocktailsCollectionView.backgroundColor = UIColor.clear
    }
    
    func setupNavBarButtons() {
        //Setting up buttons on navBar
        setupBarButton(barButtonItem: &filterBarButtonItem, button: &filterButton, buttonIcon: "line.3.horizontal.decrease.circle")
        setupBarButton(barButtonItem: &searchBarButtonItem, button: &searchButton, buttonIcon: "magnifyingglass.circle")
        searchButton.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(openFilterMenu), for: .touchUpInside)
    }
    
    func setupBarButton(barButtonItem: inout UIBarButtonItem, button: inout UIButton, buttonIcon: String) {
        //Setting up the barButtons on the right side of the tabBar
        button.setImage(UIImage(systemName: buttonIcon), for: .normal)
        button.tintColor = .black
        barButtonItem = UIBarButtonItem(customView: button)
        
        if var rightBarButtonItems = navigationItem.rightBarButtonItems {
            rightBarButtonItems += [barButtonItem]
            navigationItem.rightBarButtonItems = rightBarButtonItems
        } else {
            navigationItem.rightBarButtonItems = [barButtonItem]
        }
    }
    
    func setupLoader() {
        loader.center = view.center
        view.addSubview(loader)
        loader.startAnimating()
    }
    
    func setupSearchController() {
        search.delegate = self
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Type in cocktail name"
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.setShowsCancelButton(false, animated: false)
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    func showDefaultDrinks() {
        //Showing drinks that are already loaded from api
        if resultsLabel.text != "Alcoholic" {
            cocktailsCollectionView.showAnimation()
            fetchingDrinkData()
        }
        drinksFromSearch = []
        resultsLabel.text = "Alcoholic"
        cocktailsCollectionView.showAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.cocktailsCollectionView.reloadData()
        }
    }
    
    func reloadDrinkData() {
        //Reload data only if drink is removed from favorites on the favorites tab
        if RealmManager.instance.getFavoriteDrinks().count < previousFavoriteDrinksCount {
            cocktailsCollectionView.reloadData()
        }
        previousFavoriteDrinksCount = RealmManager.instance.getFavoriteDrinks().count
    }
    
    // MARK: - Actions
    
    @objc func toggleSearchBar() {
        //Showing and hiding the searchBar from navigationBar
        if self.navigationItem.searchController == nil {
            //Setting the searchController
            navigationItem.searchController = search
            DispatchQueue.main.async {
                self.navigationItem.searchController?.searchBar.becomeFirstResponder()
            }
            
        } else {
            //Show default drinks only if the search bar isn't empty
            if search.searchBar.text?.isEmpty == false {
                showDefaultDrinks()
            }
            //Setting the searchController to nil will make search bar dissappear
            self.navigationItem.searchController = nil
        }
    }
    
    @objc func openFilterMenu() {
        let filterViewController = FilterViewController.instantiate()
        filterViewController.filterDelegate = self
        navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    @objc func handleTap() {
        //Hide the keyboard by resigning the first responder status from the search bar
        search.searchBar.resignFirstResponder()
        }
    
    // MARK: - Api
    
    func fetchingDrinkData() {
        ApiManager.fetchDrinks(alcoholic: .alcoholic) { [weak self] result in
            switch result {
                
            case .success(let apiDrinks):
                self?.drinks = apiDrinks
                self?.cocktailsCollectionView.showAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self?.cocktailsCollectionView.reloadData()
                }
                
            case .failure(_):
                self?.showAlert(title: "Oops", message: "Something went wrong 😕")
            }
            DispatchQueue.main.async {
                self?.loader.stopAnimating()
            }
        }
    }
    
    @objc func searchDrinks(input: String) {
        ApiManager.searchDrinks(input: input) { [weak self] result in
            switch result {
                
            case .success(let apiDrinks):
                self?.drinksFromSearch = apiDrinks
                self?.cocktailsCollectionView.showAnimation()
                
            case .failure(_):
                DispatchQueue.main.async {
                    self?.drinksFromSearch = []
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.loader.stopAnimating()
                self?.cocktailsCollectionView.reloadData()
            }
        }
    }
}

// MARK: - CollectionView

extension CocktailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search.searchBar.text?.isEmpty == false ? drinksFromSearch.count : drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailCollectionViewCell.identifier, for: indexPath) as! CocktailCollectionViewCell
        cell.cellDelegate = self
        cell.setupCell(with: search.searchBar.text?.isEmpty == false ? drinksFromSearch[indexPath.row] : drinks[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 12
        return CGSize(width: width, height: 1.5 * width)
    }
}

// MARK: - SearchController

extension CocktailsViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    //Search when there are 3 characters or more
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //if searchText.count > 2 {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(searchDrinks), with: searchText, afterDelay: 0.5)
            resultsLabel.text = "Search: " + searchText
        //}
        
        if searchText.isEmpty {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            showDefaultDrinks()
        }
    }
}

// MARK: - FilterDelegate

extension CocktailsViewController: FilterDelegate {
    
    func getFilteredDrinks(filteredDrinks: [Drink], filterLabel: String) {
        self.cocktailsCollectionView.showAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.drinks = filteredDrinks
            self.resultsLabel.text = filterLabel
            self.cocktailsCollectionView.scrollToItem(at: IndexPath(item: .zero, section: .zero), at: .top, animated: true)
            self.cocktailsCollectionView.reloadData()
        }
    }
}

extension CocktailsViewController: CellDelegate {
    
    func didTap(cell: CocktailCollectionViewCell, drink: Drink) {
        previousFavoriteDrinksCount = RealmManager.instance.getFavoriteDrinks().count
    }
}

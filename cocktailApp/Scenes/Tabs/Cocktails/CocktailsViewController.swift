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
    var drinksFromSearch: [Drink] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.search.searchBar.text?.isEmpty == false && self.drinksFromSearch.isEmpty {
                    let emptyView  = Bundle.main.loadNibNamed(CocktailsEmptyView.identifier, owner: self)?.first as? UIView
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Set up
    
    func setupValues() {
        setupLabel()
        setupTabBarButtons()
        setupLoader()
        setupSearchController()
        backgroundView.layer.insertSublayer(getGradientLayer(), at: 0)
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
    
    func setupTabBarButtons() {
        //Setting up buttons on tabBar
        setupBarButton(barButtonItem: &filterBarButtonItem, button: &filterButton, buttonIcon: "line.3.horizontal.decrease.circle")
        setupBarButton(barButtonItem: &searchBarButtonItem, button: &searchButton, buttonIcon: "magnifyingglass.circle")
        searchButton.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
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
    
    func getGradientLayer() -> CAGradientLayer {
        // Creating a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [UIColor.primaryDark.cgColor, UIColor.primaryLight.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        // Set the frame to the layer
        gradientLayer.frame = view.frame
        
        return gradientLayer
    }
    
    func showDefaultDrinks() {
        //Showing drinks loaded from api
        drinksFromSearch = []
        resultsLabel.text = "Alcoholic"
        cocktailsCollectionView.showAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.cocktailsCollectionView.reloadData()
        }
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
    
    @objc func handleTap() {
        //Hide the keyboard by resigning the first responder status from the search bar
        search.searchBar.resignFirstResponder()
        }
    
    // MARK: - Api
    
    func fetchingDrinkData() {
        ApiManager.fetchDrinks { [weak self] result in
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

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
    @IBOutlet weak var alcoholicLabel: UILabel!
    @IBOutlet weak var cocktailsCollectionView: UICollectionView!
    
    var searchButton = UIButton(type: .custom)
    var filterButton = UIButton(type: .custom)
    var searchBarButtonItem = UIBarButtonItem()
    var filterBarButtonItem = UIBarButtonItem()
    var drinks: [Drink] = []
    let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),type: .orbit, color: .primaryDark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupValues()
        setupCollectionView()
        fetchingDrinkData()
    }
    
    // MARK: - Set up
    
    func setupValues() {
        setupLabel()
        setupTabBarButtons()
        setupLoader()
    }
    
    func setupLabel() {
        //Creating an NSAttributedString with the desired background color
        let attributedString = NSMutableAttributedString(string: "Alcoholic" )
        let range = NSMakeRange(0, attributedString.length)

        //Setting the background color for the text
        attributedString.addAttribute(.backgroundColor, value: UIColor.filterColor, range: range)

        //Assigning the attributed string to the label
        alcoholicLabel.attributedText = attributedString
        
        //Setting the border
        viewLabel.layer.borderWidth = 0.5
        viewLabel.layer.borderColor = UIColor.borderColor
    }
    
    func setupTabBarButtons() {
        //Setting up buttons on tabBar
        setupBarButton(barButtonItem: &filterBarButtonItem, button: &filterButton, buttonIcon: "line.3.horizontal.decrease.circle")
        setupBarButton(barButtonItem: &searchBarButtonItem, button: &searchButton, buttonIcon: "magnifyingglass.circle")
    }
    
    func setupBarButton( barButtonItem: inout UIBarButtonItem, button: inout UIButton, buttonIcon: String) {
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
    
    // MARK: - Api
    
    func fetchingDrinkData() {
        ApiManager.fetchDrinks() { [weak self] apiDrinks in
            self?.drinks = apiDrinks
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.loader.stopAnimating()
                self?.cocktailsCollectionView.reloadData()
            }
        }
    }
}

// MARK: - CollectionView

extension CocktailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        //Set up the collectionView
        cocktailsCollectionView.register(UINib(nibName: CocktailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CocktailCollectionViewCell.identifier)
        cocktailsCollectionView.dataSource = self
        cocktailsCollectionView.delegate = self
        
        //Setting the cocktailsCollectionView to be transparent
        cocktailsCollectionView.backgroundColor = UIColor.clear

        //Adding the gradient layer as a sublayer to the background view
        backgroundView.layer.insertSublayer(getGradientLayer(), at: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailCollectionViewCell.identifier, for: indexPath) as! CocktailCollectionViewCell
        cell.setupCell(with: drinks[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 12
        return CGSize(width: width, height: 1.5 * width)
    }
}

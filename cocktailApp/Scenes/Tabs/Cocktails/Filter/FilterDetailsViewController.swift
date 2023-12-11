//
//  FilterDetailsViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/8/23.
//

import UIKit

//MARK: - Protocol

protocol FilterDetailsDelegare {
    func getFilteredDrinksDetails(filteredDrinksDtails: [Drink], filterTextDetails: String)
}

class FilterDetailsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var filterTableView: UITableView!
    
    var categoryType = ""
    class var identifier: String { "FilterDetailsViewController" }
    
    class func instantiate(navBatTitle: String, categoryType: String) -> FilterDetailsViewController {
        let storyboard = UIStoryboard(name: "Filter", bundle: nil)
        let filterDetailsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! FilterDetailsViewController
        filterDetailsViewController.title = navBatTitle
        filterDetailsViewController.fetchCategoriesData(category: categoryType)
        filterDetailsViewController.categoryType = categoryType
        return filterDetailsViewController
    }
    var drinkCategories: [DrinkCategory] = []
    var filterDetailsDelegate: FilterDetailsDelegare?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        backgroundView.setMainGradient()
        
    }
    
    // MARK: - Set upd
    
    func setupTableView() {
        filterTableView.register(UINib(nibName: FilterTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FilterTableViewCell.identifier)
        filterTableView.backgroundColor = UIColor.clear
        filterTableView.layoutMargins = UIEdgeInsets.zero
        filterTableView.separatorInset = UIEdgeInsets.zero
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.reloadData()
    }
    
    func getCategoryName(index: Int) -> String {
        //Return category name which is not nil
        switch drinkCategories[index] {
            
            case let drinkCategory where drinkCategory.strAlcoholic != nil:
                return drinkCategory.strAlcoholic ?? ""
            
            case let drinkCategory where drinkCategory.strCategory != nil:
                return drinkCategory.strCategory ?? ""
            
            case let drinkCategory where drinkCategory.strIngredient1 != nil:
                return drinkCategory.strIngredient1 ?? ""
            
            case let drinkCategory where drinkCategory.strGlass != nil:
                return drinkCategory.strGlass ?? ""
            
            default:
                return ""
            }
    }
    
    // MARK: - Api
    
    func fetchCategoriesData(category: String) {
        ApiManager.fetchCategories(input: category) { [weak self] result in
            switch result {
                
            case .success(let apiDrinks):
                self?.drinkCategories = apiDrinks
                
                DispatchQueue.main.async {
                    self?.filterTableView.reloadData()
                }
                
            case .failure(_):
                self?.showAlert(title: "Oops", message: "Something went wrong 😕")
            }
        }
    }
    
    func filterDrinks(category: String, input: String) {
        ApiManager.filterDrinks(categoryType: category, input: input) { [weak self] result in
            switch result {
                
            case .success(let apiDrinks):
                self?.filterDetailsDelegate?.getFilteredDrinksDetails(filteredDrinksDtails: apiDrinks, filterTextDetails: input)
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(_):
                self?.showAlert(title: "Oops", message: "Something went wrong 😕")
            }
        }
    }
}

// MARK: - TableView

extension FilterDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filterTableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as! FilterTableViewCell
        cell.setupCell(with: getCategoryName(index: indexPath.row), showDisclosureIndicator: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Create label for table header
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        label.text = "Filter cocktails by \(self.title ?? "")"
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterDrinks(category: categoryType, input: getCategoryName(index: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

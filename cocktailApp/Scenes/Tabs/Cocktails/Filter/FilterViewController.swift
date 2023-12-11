//
//  FilterViewController.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/7/23.
//

import UIKit

//MARK: - Protocol

protocol FilterDelegate {
    func getFilteredDrinks(filteredDrinks: [Drink], filterLabel: String)
}

class FilterViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var filterTableView: UITableView!
    
    let filters = ["Alcoholic or not", "Category", "Glass", "Ingredient"]
    class var identifier: String  { "FilterViewController" }
    class func instantiate() -> FilterViewController {
        let storyboard = UIStoryboard(name: "Filter", bundle: nil)
        let filterViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! FilterViewController
        filterViewController.title = "Filter"
        
        return filterViewController
    }
    var filterDelegate: FilterDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTableView()
        backgroundView.setMainGradient()
        
    }
  
    // MARK: - Set up
    
    func setupTableView() {
        filterTableView.register(UINib(nibName: FilterTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FilterTableViewCell.identifier)
        filterTableView.backgroundColor = UIColor.clear
        filterTableView.layoutMargins = UIEdgeInsets.zero
        filterTableView.separatorInset = UIEdgeInsets.zero
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.reloadData()
    }
}

// MARK: - TableView

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = filterTableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as! FilterTableViewCell
        cell.setupCell(with: filters[indexPath.row], showDisclosureIndicator: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Create label for table header
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        label.text = "Filter cocktails by"
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get the categoty label based on the selected category from the filters
        let category = switch indexPath.row {
            
            case 0:
                "a"
            
            case 1:
                "c"
            
            case 2:
                "g"
            
            case 3:
                "i"
            
            default:
                ""
        }
        
        let filterDetailsViewController = FilterDetailsViewController.instantiate(navBatTitle: filters[indexPath.row], categoryType: category)
        filterDetailsViewController.filterDetailsDelegate = self
        self.navigationController?.pushViewController(filterDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - FilterDetailsDelegare

extension FilterViewController: FilterDetailsDelegare {
    func getFilteredDrinksDetails(filteredDrinksDtails: [Drink], filterTextDetails: String) {
        filterDelegate?.getFilteredDrinks(filteredDrinks: filteredDrinksDtails, filterLabel: filterTextDetails)
    }
}

//
//  CocktailsEmptyView.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/6/23.
//

import UIKit

class CocktailsEmptyView: UIView {
    
    // MARK: - Properties
    
    static let identifier = "CocktailsEmptyView"
    
    @IBOutlet weak var warrningMessageLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }
    
    // MARK: - Set up
    
    func setupLabel() {
        warrningMessageLabel.text = "No cocktails found 😕"
        warrningMessageLabel.textColor = .primaryDark
        warrningMessageLabel.font = UIFont.systemFont(ofSize: 22)
    }
}

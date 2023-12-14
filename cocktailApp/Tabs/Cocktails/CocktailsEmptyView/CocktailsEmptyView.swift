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
    }
    
    // MARK: - Set up
    
    func setupLabel(withMessage message: String) {
           warrningMessageLabel.text = message
           warrningMessageLabel.textColor = .primaryDark
           warrningMessageLabel.font = UIFont.customFontRegularExtraLarge
       }
}

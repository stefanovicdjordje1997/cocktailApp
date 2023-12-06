//
//  CocktailsEmptyView.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/6/23.
//

import UIKit

class CocktailsEmptyView: UIView {

    @IBOutlet weak var warrningMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }
    
    func setupLabel() {
        warrningMessageLabel.text = "No cocktails found 😕"
        warrningMessageLabel.textColor = .primaryDark
    }
}

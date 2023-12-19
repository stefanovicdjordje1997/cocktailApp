//
//  FilterTableViewCell.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/7/23.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(with title: String, showDisclosureIndicator: Bool) {
        categoryTitleLabel.text = title
        layoutMargins = UIEdgeInsets.zero
        accessoryType = showDisclosureIndicator ? .disclosureIndicator : .none
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
}

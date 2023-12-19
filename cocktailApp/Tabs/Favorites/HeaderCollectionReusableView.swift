//
//  HeaderCollectionReusableView.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/14/23.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    //MARK: - Properties
    
    @IBOutlet weak var headerLabel: UILabel!
    
    //MARK: - Set up
    
    func setupLabel(with text: String) {
        //Creating an NSAttributedString with the desired background color and text
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSMakeRange(0, attributedString.length)
        
        //Setting the background color for the text
        attributedString.addAttribute(.backgroundColor, value: UIColor.filterColor, range: range)
        
        //Assigning the attributed string to the label
        headerLabel.attributedText = attributedString
    }
}

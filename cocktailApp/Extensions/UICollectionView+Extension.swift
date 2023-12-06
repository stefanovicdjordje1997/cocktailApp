//
//  UICollectionView+Extension.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/5/23.
//

import UIKit

extension UICollectionView {
    func showAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: {
                
                // Fade out
                self.alpha = 0.0
                self.visibleCells.forEach { $0.alpha = 0.0 }
            }) { (_) in
                // Animation completion block
                UIView.animate(withDuration: 0.25, animations: {
                    
                    // Fade in
                    self.alpha = 1.0
                    self.visibleCells.forEach { $0.alpha = 1.0 }
                })
            }
        }
    }
}

//
//  UIFont+CustomFont.swift
//  cocktailApp
//
//  Created by Djordje Stefanovic on 12/7/23.
//

import UIKit

enum AppFonts: String {
    case caveatRegular = "Caveat-Regular"
    case caveatBold = "Caveat-Bold"
}

enum FontSize: CGFloat {
    case extraLarge = 22.0
    case large = 19.0
    case normal = 17.0
    case small = 15.0
    case extraSmall = 14.0
}

extension UIFont {
    
    static var customFontRegularExtraLarge: UIFont {
        return UIFont(name: AppFonts.caveatRegular.rawValue, size: FontSize.extraLarge.rawValue) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    static var customFontBoldLargeExtraLarge: UIFont {
        return UIFont(name: AppFonts.caveatBold.rawValue, size: FontSize.extraLarge.rawValue) ?? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }
    
    static var customFontRegularLarge: UIFont {
        return UIFont(name: AppFonts.caveatRegular.rawValue, size: FontSize.large.rawValue) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    static var customFontBoldLarge: UIFont {
        return UIFont(name: AppFonts.caveatBold.rawValue, size: FontSize.large.rawValue) ?? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }
    
    static var customFontRegularNormal: UIFont {
        return UIFont(name: AppFonts.caveatRegular.rawValue, size: FontSize.normal.rawValue) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    static var customFontBoldNormal: UIFont {
        return UIFont(name: AppFonts.caveatBold.rawValue, size: FontSize.normal.rawValue) ?? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }
    
    static var customFontRegularSmall: UIFont {
        return UIFont(name: AppFonts.caveatRegular.rawValue, size: FontSize.small.rawValue) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    static var customFontBoldSmall: UIFont {
        return UIFont(name: AppFonts.caveatBold.rawValue, size: FontSize.small.rawValue) ?? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }
    
    static var customFontRegularExtraSmall: UIFont {
        return UIFont(name: AppFonts.caveatRegular.rawValue, size: FontSize.extraSmall.rawValue) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    static var customFontBoldExtraSmall: UIFont {
        return UIFont(name: AppFonts.caveatBold.rawValue, size: FontSize.extraSmall.rawValue) ?? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }
}

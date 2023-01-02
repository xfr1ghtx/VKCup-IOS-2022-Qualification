//
//  InterestTagStyle.swift
//  VKCup
//

import UIKit

enum InterestTagStyle {
    case selected, unselected
    
    
    static var textColor: UIColor? {
        return .appWhite
    }
    
    static var font: UIFont? {
        return .appSemibold
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .selected:
            return .appOrange
        case .unselected:
            return .appGray17
        }
    }
    
    var dividerColor: UIColor? {
        switch self {
        case .selected:
            return .clear
        case .unselected:
            return .appGray27
        }
    }
    

}

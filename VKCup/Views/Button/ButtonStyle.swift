//
//  ButtonStyle.swift
//  VKCup
//

import UIKit

enum ButtonStyle {
    case primary, secondary
    
    var backgroundColor: UIColor? {
        switch self {
        case .primary:
            return .appWhite
        case .secondary:
            return .appGray12
        }
    }
    
    var highlightedBackgroundColor: UIColor? {
        switch self {
        case .primary:
            return .appGray
        case .secondary:
            return .appDarkGray
        }
    }
    
    var textColor: UIColor? {
        switch self {
        case .primary:
            return .appBlack
        case .secondary:
            return .appWhite
        }
    }
    
    var font: UIFont? {
        switch self {
        case .primary:
            return .appMedium
        case .secondary:
            return .appSemibold
        }
    }
    
    var titleEdgeInsets: UIEdgeInsets {
        switch self {
        case .primary:
            return UIEdgeInsets(top: 29, left: 51, bottom: 29, right: 51)
        case .secondary:
            return UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 13)
        }
    }
}

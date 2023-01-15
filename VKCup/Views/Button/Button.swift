//
//  Button.swift
//  VKCup
//

import UIKit

final class Button: UIButton {
    // MARK: - Properties
    
    private let style: ButtonStyle
    
    override var isHighlighted: Bool{
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Lifecycle methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height / 2
    }
    
    // MARK: - Inits
    
    init(style: ButtonStyle = .primary) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.style = .primary
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        contentEdgeInsets = style.titleEdgeInsets
        backgroundColor = style.backgroundColor
        setTitleColor(style.textColor, for: .normal)
        titleLabel?.font = style.font
    }
    
    // MARK: - Private methods
    
    private func updateAppearance() {
        backgroundColor = isHighlighted ? style.highlightedBackgroundColor : style.backgroundColor
    }
}

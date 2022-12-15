//
//  InterestSelector.swift
//  VKCup
//

import UIKit

final class InterestSelector: UIView {
    // MARK: - Public properties
    
    var isSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Private properties
    
    private let firstLine = UIView()
    private let secondLine = UIView()
    
    // MARK: - Inits
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupFirstLine()
        setupSecondLine()
    }
    
    private func setupFirstLine() {
        addSubview(firstLine)
        
        firstLine.backgroundColor = .appWhite
        firstLine.layer.cornerRadius = 1
        firstLine.layer.borderWidth = 0
        firstLine.frame = CGRect(x: 0, y: 8, width: 18, height: 2)
    }
    
    private func setupSecondLine() {
        addSubview(secondLine)
        
        secondLine.backgroundColor = .appWhite
        secondLine.layer.cornerRadius = 1
        secondLine.layer.borderWidth = 0
        secondLine.frame = CGRect(x: 8 , y: 0, width: 2, height: 18)
    }
    
    // MARK: - Actions
    
    private func updateAppearance() {
        isSelected ? moveToCheck() : moveToCross()
    }
    
    // MARK: - Private methods
    
    private func moveToCross() {
        UIView.animate(withDuration: 0.3) {
            self.firstLine.transform = .identity
            self.firstLine.bounds = CGRect(x: 0, y: 0, width: 18, height: 2)
            self.secondLine.transform = .identity
        }
    }
    
    private func moveToCheck() {
        let translationFirstMatrix = CGAffineTransform(translationX: -5.6, y: 3.5)
        let rotationFirstMatrix = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        let firstMatrix = rotationFirstMatrix.concatenating(translationFirstMatrix)
        
        let translationSecondMatrix = CGAffineTransform(translationX: 2.2, y: 0)
        let rotationSecondMatrix = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        let secondMatrix = rotationSecondMatrix.concatenating(translationSecondMatrix)
        
        UIView.animate(withDuration: 0.3) {
            self.firstLine.transform = firstMatrix
            self.firstLine.bounds = CGRect(x: 0, y: 0, width: 8, height: 2)
            self.secondLine.transform = secondMatrix
        }
    }
}

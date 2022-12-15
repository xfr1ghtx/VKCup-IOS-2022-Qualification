//
//  InterestTagView.swift
//  VKCup
//

import UIKit
import SnapKit

final class InterestTagView: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "InterestTagViewCell"
    
    override var isSelected: Bool {
        didSet{
            updateAppearance()
        }
    }
    
    // MARK: - Private properties
    
    private let container = UIStackView()
    private let label = UILabel()
    private let divider = UIView()
    private let selector = InterestSelector()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        isSelected = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        isSelected = false
    }
    
    // MARK: - Public methods
    
    func configure(_ text: String?) {
        label.text = text
    }
    
    // MARK: - Actions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateAppearance()
    }
    
    private func updateAppearance() {
        isSelected ? setSelected() : setUnselected()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupSuperview()
        setupContainer()
        setupLabel()
        setupDivider()
        setupSelector()
    }
    
    private func setupSuperview() {
        layer.cornerRadius = 12
    }
    
    private func setupContainer() {
        container.axis = .horizontal
        container.spacing = 11
        container.alignment = .center
        
        addSubview(container)
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(11)
        }
    }
    
    private func setupLabel() {
        label.text = "Test"
        label.font = InterestTagStyle.font
        label.textColor = InterestTagStyle.textColor
        container.addArrangedSubview(label)
    }
    
    private func setupDivider() {
        divider.layer.cornerRadius = 0.5
        
        container.addArrangedSubview(divider)
        divider.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(1)
        }
    }
    
    private func setupSelector() {
        container.addArrangedSubview(selector)
        selector.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
    }
    
    // MARK: - Private methods
    
    private func setUnselected() {
        selector.isSelected = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.backgroundColor = InterestTagStyle.unselected.backgroundColor
            self?.divider.backgroundColor = InterestTagStyle.unselected.dividerColor
        }
    }
    
    private func setSelected() {
        selector.isSelected = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.backgroundColor = InterestTagStyle.selected.backgroundColor
            self?.divider.backgroundColor = InterestTagStyle.selected.dividerColor
        }
    }
    
}

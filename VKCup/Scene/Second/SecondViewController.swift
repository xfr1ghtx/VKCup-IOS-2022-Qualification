//
//  SecondViewController.swift
//  VKCup
//

import UIKit
import SnapKit

final class SecondViewController: UIViewController {
    // MARK: - Private properties
    
    private let mainLabel = UILabel()
    private let tagsLabel = UILabel()
    
    private var viewModel: SecondViewModel
    
    // MARK: - Init
    
    init(viewModel: SecondViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupSuperView()
        setupMainLabel()
        setupTagsLabel()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .appBlack
    }
    
    private func setupMainLabel() {
        view.addSubview(mainLabel)
        
        mainLabel.font = .appMedium
        mainLabel.textColor = .appWhite
        mainLabel.numberOfLines = 0
        mainLabel.text = "Пользователь выбрал следующие интересы:"
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupTagsLabel() {
        view.addSubview(tagsLabel)
        
        tagsLabel.font = .appSemibold
        tagsLabel.textColor = .appWhite
        tagsLabel.numberOfLines = 0
        tagsLabel.text = viewModel.getInterests()
        tagsLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
    }
    
    
    
}

//
//  ShowInterestViewController.swift
//  VKCup
//

import UIKit
import SnapKit

final class ShowInterestViewController: UIViewController {
    // MARK: - Private properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainLabel = UILabel()
    private let tagsLabel = UILabel()
    private let backButton = Button(style: .primary)
    
    private var viewModel: ShowInterestViewModel
    
    // MARK: - Init
    
    init(viewModel: ShowInterestViewModel) {
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
    
    // MARK: - Actions
    
    @objc
    private func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupSuperView()
        setupMainLabel()
        setupScrollView()
        setupTagsLabel()
        setupBackButton()
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
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupTagsLabel() {
        contentView.addSubview(tagsLabel)
        
        tagsLabel.font = .appSemibold
        tagsLabel.textColor = .appWhite
        tagsLabel.numberOfLines = 0
        tagsLabel.text = viewModel.getInterests()
        tagsLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        backButton.setTitle("Назад", for: .normal)
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(34)
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    
    
}

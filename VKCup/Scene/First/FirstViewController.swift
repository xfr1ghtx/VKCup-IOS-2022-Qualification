//
//  FirstViewController.swift
//  VKCup
//

import UIKit
import SnapKit

class FirstViewController: UIViewController {
    // MARK: - Private properties
    
    private let container = UIStackView()
    private let headerContainer = UIStackView()
    private let headerLabel = UILabel()
    private let laterButton = Button(style: .secondary)
    
    lazy private var interestCollection: UICollectionView = {
        let layout = FlowLayout(minimumInteritemSpacing: 8, minimumLineSpacing: 8)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let continueButton = Button(style: .primary)
    private var buttonBottomConstraint: Constraint?
    
    private let viewModel: FirstViewModel

    
    // MARK: - Inits
    
    init(viewModel: FirstViewModel) {
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
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Bind to viewmodel
    
    private func bindToViewModel() {
        viewModel.onWillShowButton = { [weak self] in
            self?.showContinueButton()
        }
        
        viewModel.onWillHideButton = { [weak self] in
            self?.hideContinueButton()
        }
        
        viewModel.onWillShowNextScreen = { [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        
        viewModel.onDidUpdateData = { [weak self] in
            self?.interestCollection.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func goToNextScreen() {
        viewModel.showNextScreen()
    }
    
    // MARK: - Private methods
    
    private func showContinueButton() {
        buttonBottomConstraint?.update(offset: -34)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideContinueButton() {
        buttonBottomConstraint?.update(offset: 120)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupSuperView()
        setupContainer()
        setupHeaderContainer()
        setupHeaderLabel()
        setupLaterButton()
        setupInterestCollection()
        setupContinueButton()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .appBlack
    }
    
    private func setupContainer() {
        view.addSubview(container)
        
        container.spacing = 24
        container.axis = .vertical
        container.distribution = .fill
        
        container.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupHeaderContainer() {
        headerContainer.axis = .horizontal
        headerContainer.spacing = 12
        headerContainer.distribution = .fill
        headerContainer.alignment = .center
        container.addArrangedSubview(headerContainer)
    }
    
    private func setupHeaderLabel() {
        headerLabel.font = .appRegular
        headerLabel.textColor = .appGray48
        headerLabel.text = "Отметьте то, что вам интересно, чтобы настроить Дзен"
        headerLabel.numberOfLines = 0
        headerContainer.addArrangedSubview(headerLabel)
    }
    
    private func setupLaterButton() {
        laterButton.setTitle("Позже", for: .normal)
        laterButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
        headerContainer.addArrangedSubview(laterButton)
        laterButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }
    
    private func setupInterestCollection() {
        interestCollection.register(InterestTagView.self, forCellWithReuseIdentifier: InterestTagView.identifier)
        interestCollection.isUserInteractionEnabled = true
        interestCollection.backgroundColor = .clear
        interestCollection.showsVerticalScrollIndicator = false
        interestCollection.allowsMultipleSelection = true
        interestCollection.dataSource = self
        interestCollection.delegate = self
        interestCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 134, right: 0)
        
        container.addArrangedSubview(interestCollection)
        container.setCustomSpacing(20, after: interestCollection)
    }
    
    private func setupContinueButton() {
        continueButton.setTitle("Продолжить", for: .normal)
        continueButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            buttonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(120).constraint
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestTagView.identifier, for: indexPath) as? InterestTagView else {
            return InterestTagView()
        }
        
        let title = viewModel.getTitleForInterestFor(indexPath.item)
        cell.configure(title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getInterestsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.addSelectedInterests(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.removeSelectedInterests(index: indexPath.item)
    }
    
    
}


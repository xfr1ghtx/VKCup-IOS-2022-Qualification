//
//  PickInterestViewController.swift
//  VKCup
//

import UIKit
import SnapKit

class PickInterestViewController: UIViewController {
    // MARK: - Private properties
    
    private let container = UIStackView()
    private let headerContainer = UIStackView()
    private let headerLabel = UILabel()
    private let laterButton = Button(style: .secondary)
    
    lazy private var interestCollection: UICollectionView = {
        let layout = InterestTagsLayout(minimumInteritemSpacing: 8, minimumLineSpacing: 8)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 134, right: 0)
        return collectionView
    }()
    private let continueButtonContainer = PassthroughView(frame: .zero)
    private let continueButton = Button(style: .primary)
    private var buttonBottomConstraint: Constraint?
    
    private let viewModel: PickInterestViewModel

    
    // MARK: - Inits
    
    init(viewModel: PickInterestViewModel) {
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
        viewModel.onDidAddInterest = { [weak self] indexPath, needShowButton in
            if needShowButton {
                self?.showContinueButton()
            }
            self?.scrollToPressedTag(with: indexPath)
        }
        
        viewModel.onDidRemoveLastInterest = { [weak self] in
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
    private func handleContinueButton() {
        viewModel.tapOnContinueButton()
    }
    
    @objc
    private func handleLaterButton() {
        viewModel.tapOnLaterButton()
    }
    
    // MARK: - Private methods
    
    private func scrollToPressedTag(with indexPath: IndexPath) {
        guard let cell = interestCollection.cellForItem(at: indexPath) else {
            return
        }
        interestCollection.scrollRectToVisible(cell.frame, animated: true)
    }
    
    private func showContinueButton() {
        buttonBottomConstraint?.update(inset: 34)
        continueButtonContainer.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.continueButtonContainer.layoutIfNeeded()
        }
    }
    
    private func hideContinueButton() {
        buttonBottomConstraint?.update(offset: 120)
        UIView.animate(withDuration: 0.3) {
            self.continueButtonContainer.layoutIfNeeded()
        } completion: { _ in
            self.continueButtonContainer.isHidden = true
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
        laterButton.addTarget(self, action: #selector(handleLaterButton), for: .touchUpInside)
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
        
        container.addArrangedSubview(interestCollection)
        container.setCustomSpacing(0, after: interestCollection)
    }
    
    private func setupContinueButton() {
        view.addSubview(continueButtonContainer)
        continueButtonContainer.backgroundColor = .clear
        continueButtonContainer.isHidden = true
        continueButtonContainer.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(174)
        }
        
        
        continueButton.setTitle("Продолжить", for: .normal)
        continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        continueButtonContainer.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            buttonBottomConstraint = make.bottom.equalToSuperview().offset(120).constraint
            make.centerX.equalToSuperview()
        }
        
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PickInterestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        viewModel.addSelectedInterests(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.removeSelectedInterests(indexPath: indexPath)
    }
}

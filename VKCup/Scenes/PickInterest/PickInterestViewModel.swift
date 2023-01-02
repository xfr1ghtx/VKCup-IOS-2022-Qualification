//
//  PickInterestViewModel.swift
//  VKCup
//

import UIKit

final class PickInterestViewModel {
    // MARK: - Public properties
    
    var onDidAddInterest: ((IndexPath, Bool) -> Void)?
    var onDidRemoveLastInterest: (() -> Void)?
    var onWillShowNextScreen: ((UIViewController) -> Void)?
    var onDidUpdateData: (() -> Void)?
    
    
    // MARK: - Private properties
    
    private var interests: [Interest] = [] {
        didSet {
            onDidUpdateData?()
        }
    }
    private var selectedInterests: [Interest] = []
    
    private let repository: JSONFileRepository
    
    init() {
        repository = JSONFileRepository()
        getAllInterests()
    }
    
    // MARK: - Public methods
    
    func tapOnContinueButton() {
        let viewModel = ShowInterestViewModel(interests: selectedInterests)
        let viewController = ShowInterestViewController(viewModel: viewModel)
        onWillShowNextScreen?(viewController)
    }
    
    func tapOnLaterButton() {
        let viewModel = ShowInterestViewModel(interests: [])
        let viewController = ShowInterestViewController(viewModel: viewModel)
        onWillShowNextScreen?(viewController)
    }
    
    func getInterestsCount() -> Int {
        return interests.count
    }
    
    func getTitleForInterestFor(_ index: Int) -> String? {
        return interests[index].title
    }
    
    func addSelectedInterests(indexPath: IndexPath) {
        selectedInterests.isEmpty ? onDidAddInterest?(indexPath, true) : onDidAddInterest?(indexPath, false)
        selectedInterests.append(interests[indexPath.item])

    }
    
    func removeSelectedInterests(indexPath: IndexPath) {
        guard let index = selectedInterests.firstIndex(of: interests[indexPath.item]) else { return }
        selectedInterests.remove(at: index)
        if selectedInterests.isEmpty {
            onDidRemoveLastInterest?()
        }
    }
    
    // MARK: - Private methods
    
    private func getAllInterests(){
        repository.list { interests, error in
            if error != nil {
                self.interests = []
            }
            
            if let interests = interests {
                self.interests = interests
            }
        }
    }
}

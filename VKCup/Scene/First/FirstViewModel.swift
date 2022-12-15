//
//  FirstViewModel.swift
//  VKCup
//

import UIKit

final class FirstViewModel {
    // MARK: - Public properties
    
    var onWillShowButton: (() -> Void)?
    var onWillHideButton: (() -> Void)?
    var onWillShowNextScreen: ((UIViewController) -> Void)?
    var onDidUpdateData: (() -> Void)?
    
    
    // MARK: - Private properties
    
    private var interests: [Interest] = [] {
        didSet {
            onDidUpdateData?()
        }
    }
    private var selectedInterests: [Interest] = []
    
    init() {
        interests = self.getAllInterests()
    }
    
    // MARK: - Public methods
    
    func showNextScreen() {
        let viewModel = SecondViewModel(interests: selectedInterests)
        let viewController = SecondViewController(viewModel: viewModel)
        onWillShowNextScreen?(viewController)
    }
    
    func getInterestsCount() -> Int {
        return interests.count
    }
    
    func getTitleForInterestFor(_ index: Int) -> String? {
        return interests[index].title
    }
    
    func addSelectedInterests(index: Int) {
        if selectedInterests.isEmpty {
            onWillShowButton?()
        }
        selectedInterests.append(interests[index])
    }
    
    func removeSelectedInterests(index: Int) {
        if let index = selectedInterests.firstIndex(of: interests[index]) {
            selectedInterests.remove(at: index)
        }
        
        if selectedInterests.isEmpty {
            onWillHideButton?()
        }
    }
    
    // MARK: - Private methods
    
    private func getAllInterests() -> [Interest] {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json")  else { return [] }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return [] }
        
        guard let jsonResult = try? JSONDecoder().decode([Interest].self, from: data) else { return [] }
        
        return jsonResult
    }
}

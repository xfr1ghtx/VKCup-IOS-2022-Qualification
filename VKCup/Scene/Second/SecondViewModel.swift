//
//  SecondViewModel.swift
//  VKCup
//

import Foundation

final class SecondViewModel {
    // MARK: - Private properties
    
    private let selectedInterests: [Interest]
    
    //MARK: - Init
    
    init(interests: [Interest]) {
        selectedInterests = interests
    }
    
    // MARK: - Public methods
    
    func getInterests() -> String {
        var resultString = ""
        
        guard !selectedInterests.isEmpty else { return "Никакие :(" }
        
        selectedInterests.forEach { interest in
            resultString += interest.title
            resultString += " \n"
        }
        
        return resultString
    }
}

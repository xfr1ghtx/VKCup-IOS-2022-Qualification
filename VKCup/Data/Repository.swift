//
//  Repository.swift
//  VKCup
//

import Foundation

enum JSONFileRepositoryError: LocalizedError {
    case invalidFilePath, invalidContentsOfFile, invalidDecodeFromJSON
    
    var errorDescription: String? {
        switch self {
        case .invalidFilePath:
            return "Не удалось получить путь до нужного файла"
        case .invalidContentsOfFile:
            return "Не удалось получить содержимое файла"
        case .invalidDecodeFromJSON:
            return "Не удалось декодировать JSON"
        }
    }
}

protocol Repository {
    associatedtype T
    
    func list(completionHandler: ([T]?, Error?) -> Void)
}

struct JSONFileRepository: Repository {
    typealias T = Interest
    
    func list(completionHandler: ([Interest]?, Error?) -> Void) {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json")  else
        {
            completionHandler(nil, JSONFileRepositoryError.invalidFilePath)
            return
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else
        {
            completionHandler(nil, JSONFileRepositoryError.invalidContentsOfFile)
            return
        }
        
        guard let result = try? JSONDecoder().decode([Interest].self, from: data) else
        {
            completionHandler(nil, JSONFileRepositoryError.invalidDecodeFromJSON)
            return
        }
        
        completionHandler(result, nil)
    }
}

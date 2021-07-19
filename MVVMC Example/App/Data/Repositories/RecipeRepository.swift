//
//  RecipeRepository.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import Foundation
import Combine


final class RecipeRepository: RecipeRepositoryProtocol {
    
    private let dataStore: RecipeDataStoreProtocol
    
    init(dataStore: RecipeDataStoreProtocol) { self.dataStore = dataStore }

    func fetchRecipes() -> AnyPublisher<Array<Recipe>, DataFetchError> {
        dataStore
            .fetchRecipes()
            .mapError(mapToDataFetchError)
            .map { (data) -> [Recipe] in data.map { $0.recipe } }
            .eraseToAnyPublisher()
    }

    private func mapToDataFetchError(networkingError: NetworkingError) -> DataFetchError {
        switch networkingError {
        case .noIntertnet:
            return DataFetchError.noInternet
        default:
            return DataFetchError.dataFetchFailure
        }
    }

}


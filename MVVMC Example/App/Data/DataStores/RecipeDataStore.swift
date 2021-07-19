//
//  RecipeDataStore.swift
//  Task2
//
//  Created by Osama Bashir on 2/19/21.
//

import Foundation
import Combine

protocol RecipeDataStoreProtocol {
    func fetchRecipes() -> AnyPublisher<Array<RecipeDataModel>,NetworkingError>
}

final class RecipeDataStore: RecipeDataStoreProtocol {
    let networkManager: Networking

    init(networkManager: Networking) { self.networkManager = networkManager }

    func fetchRecipes() -> AnyPublisher<Array<RecipeDataModel>,NetworkingError> { networkManager.get(from: RecipeListEndpoint()) }
}


//
//  AppDIContainer.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import Foundation
// App level DI Container that contains app level dependencies
final class AppDIContainer {
    
    private lazy var networkManager: Networking = { NetworkManager() }()
    
    /// makes RecipeDIContainer
    ///
    /// - Returns: Returns RecipeDIContainer
    func makeRecipeDIContainer() -> RecipeDIContainer {
        let recipeDataStore: RecipeDataStoreProtocol = RecipeDataStore(networkManager: networkManager)
        return RecipeDIContainer(recipeDataStore: recipeDataStore)
    }
}

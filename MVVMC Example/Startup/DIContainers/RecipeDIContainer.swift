//
//  RecipeDIContainer.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

// DIContainer for all Recipe module dependencies
final class RecipeDIContainer {
    
    private let recipeDataStore: RecipeDataStoreProtocol

    init(recipeDataStore: RecipeDataStoreProtocol) {
        self.recipeDataStore = recipeDataStore
    }
}


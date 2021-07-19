//
//  RecipeUseCase.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import Foundation
import Combine

protocol RecipeUseCaseProtocol {
    func getRecipes() -> AnyPublisher<[Recipe], DataFetchError>
}

// Contains the buisness logic related to recipe module
final class RecipeUseCase: RecipeUseCaseProtocol {
    
    private let recipeRepository: RecipeRepositoryProtocol
    
    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
    }
    
    /// fetch recipes from recipe repo and returns the result
    /// - Parameter onSuccess: closure to return Recipe array in the case of success
    /// - Parameter onFailure: closure to return error message in the case of failure
    func getRecipes() -> AnyPublisher<[Recipe], DataFetchError> { recipeRepository.fetchRecipes()
    }
    
}


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

extension RecipeDIContainer: RecipeListCoordinatorDependencies {

    func makeRecipeRepository() -> RecipeRepositoryProtocol {
        RecipeRepository(dataStore: recipeDataStore)
    }
    /// creates RecipeListUseCase
    ///
    /// - Returns: Returns RecipeUseCaseProtocol
    private func makeRecipeListUseCase() -> RecipeUseCaseProtocol {
         RecipeUseCase(recipeRepository: makeRecipeRepository())
    }
   
    /// creates RecipeListViewModel
    ///
    /// - Returns: Returns RecipeListViewModelProtocol
    private func makeRecipeListViewModel() -> RecipeListViewModelProtocol {
        RecipeListViewModel(useCase: makeRecipeListUseCase())
    }
    
    /// creates RecipeListCoordinator
    ///
    /// - Parameter navigation: take navigation of type AppNavigation
    /// - Returns: Returns RecipeListCoordinator
    func makeRecipeListCoordinator(navigation: AppNavigation) -> RecipeListCoordinator {
        RecipeListCoordinator(dependencies: self, navigation: navigation)
    }
    
    /// creates RecipeListViewController
    ///
    /// - Returns: Returns RecipeListViewController
    func makeRecipeListViewController() -> RecipeListViewController {
        let storyboard = UIStoryboard(storyboard: .main)
        let recipeViewController: RecipeListViewController = storyboard.initialViewController()
        recipeViewController.viewModel = makeRecipeListViewModel()
        return recipeViewController
    }
    
    
}

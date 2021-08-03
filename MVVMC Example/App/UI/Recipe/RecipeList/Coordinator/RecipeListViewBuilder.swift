//
//  RecipeListViewBuilder.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 03.08.21.
//

import UIKit

final class RecipeListViewBuilder {
    let recipeUseCase: RecipeUseCaseProtocol

    init(recipeUseCase: RecipeUseCaseProtocol) {
        self.recipeUseCase = recipeUseCase
    }

    func buildViewController(actions: RecipeListActions) -> RecipeListViewController {
        let storyboard = UIStoryboard(storyboard: .recipe)
        let recipeViewController: RecipeListViewController = storyboard.initialViewController()
        let viewModel = RecipeListViewModel(recipeUseCase: recipeUseCase, actions: actions)
        recipeViewController.viewModel = viewModel

        return recipeViewController
    }
}

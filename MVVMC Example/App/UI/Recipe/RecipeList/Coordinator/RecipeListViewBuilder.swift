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
        let viewModel = RecipeListViewModel(recipeUseCase: recipeUseCase, actions: actions)
        let recipeViewController = RecipeListViewController(viewModel: viewModel)

        return recipeViewController
    }
}

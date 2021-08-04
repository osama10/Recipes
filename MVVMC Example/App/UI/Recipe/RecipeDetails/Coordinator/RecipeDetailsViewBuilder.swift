//
//  RecipeDetailsViewBuilder.swift
//  MVVMC Example
//
//  Created by Carolina Rocha on 03.08.21.
//

import UIKit

final class RecipeDetailsViewBuilder {
    private let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    func build(actions: RecipeDetailsViewActions) -> RecipeDetailsViewController {
        let viewModel = RecipeDetailsViewModel(recipe: recipe, actions: actions)
        let viewController = RecipeDetailsViewController(viewModel: viewModel)

        return viewController
    }
}

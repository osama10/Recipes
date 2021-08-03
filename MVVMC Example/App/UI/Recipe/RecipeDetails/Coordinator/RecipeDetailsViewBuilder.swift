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
        let storyboard = UIStoryboard(storyboard: .recipe)
        let viewController: RecipeDetailsViewController = storyboard.instantiateViewController()
        let viewModel = RecipeDetailsViewModel(recipe: recipe, actions: actions)
        viewController.viewModel = viewModel
        return viewController
    }
}

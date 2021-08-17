//
//  ActionsViewBuilder.swift
//  MVVMC Example
//
//  Created by Fatma Dagdevir on 16.08.21.
//

import UIKit

final class ActionsViewBuilder {
    private let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    func build(actions: ActionsViewControllerActions) -> ActionsViewController {
        let viewModel = ActionsViewModel(recipe: recipe, actions: actions)
        let viewController = ActionsViewController(viewModel: viewModel)

        return viewController
    }
}


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

    func build() -> ActionsViewController {
        let viewModel = ActionsViewModel(recipe: recipe)
        let viewController = ActionsViewController(viewModel: viewModel)

        return viewController
    }
}


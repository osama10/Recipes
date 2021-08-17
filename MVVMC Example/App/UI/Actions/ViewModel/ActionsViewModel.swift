//
//  ActionsViewModel.swift
//  MVVMC Example
//
//  Created by Fatma Dagdevir on 16.08.21.
//

import Foundation

final class ActionsViewModel {
    private let recipe: Recipe

    private weak var actions: ActionsViewControllerActions?

    init(recipe: Recipe, actions: ActionsViewControllerActions) {
        self.recipe = recipe
        self.actions = actions
    }

    func rateButtonTapped() {
        actions?.didTapRateButton()
    }
}

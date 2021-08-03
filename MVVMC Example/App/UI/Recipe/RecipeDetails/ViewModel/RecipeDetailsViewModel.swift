//
//  RecipeDetailsViewModel.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 03.08.21.
//

import Foundation

protocol RecipeDetailsViewModelOutput {
    var title: String { get }
    var image: URL? { get }
    var headline: String { get }
}

protocol RecipeDetailsViewModelInput {
    func didTapBackButton()
}

protocol RecipeDetailsViewModelProtocol: RecipeDetailsViewModelInput, RecipeDetailsViewModelOutput {
    
}

final class RecipeDetailsViewModel: RecipeDetailsViewModelProtocol {
    var title: String { recipe.title }
    var image: URL? { URL(string: recipe.image) }
    var headline: String { recipe.headline }
    
    private let recipe: Recipe
    private weak var actions: RecipeDetailsViewActions?
    
    init(recipe: Recipe, actions: RecipeDetailsViewActions) {
        self.recipe = recipe
        self.actions = actions
    }
    
    func didTapBackButton() {
        actions?.didTapBackButton()
    }
}

//
//  RecipeDetailsViewModel.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 03.08.21.
//

import Foundation
import Combine

protocol RecipeDetailsViewModelOutput {
    var title: PassthroughSubject<String, Never> { get }
    var image: PassthroughSubject<URL?, Never> { get }
    var headline: PassthroughSubject<String, Never> { get }
}

protocol RecipeDetailsViewModelInput {
    func viewDidLoad()
    func didTapBackButton()
    func didTapActionsButton()
}

protocol RecipeDetailsViewModelProtocol: RecipeDetailsViewModelInput, RecipeDetailsViewModelOutput {
    
}

final class RecipeDetailsViewModel: RecipeDetailsViewModelProtocol {
    var title: PassthroughSubject<String, Never> = PassthroughSubject()
    var image: PassthroughSubject<URL?, Never> = PassthroughSubject()
    var headline: PassthroughSubject<String, Never> = PassthroughSubject()
    
    private let recipe: Recipe
    private weak var actions: RecipeDetailsViewActions?
    
    init(recipe: Recipe, actions: RecipeDetailsViewActions) {
        self.recipe = recipe
        self.actions = actions
    }
    
    func didTapBackButton() {
        actions?.didTapBackButton()
    }

    func didTapActionsButton() {
        actions?.didTapActionsButton(recipe: recipe)
    }

    func viewDidLoad() {
        title.send(recipe.title)
        headline.send(recipe.headline)
        image.send(URL(string: recipe.image))
    }
}

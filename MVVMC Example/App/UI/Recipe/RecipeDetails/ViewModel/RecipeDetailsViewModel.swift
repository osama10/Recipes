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
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func didTapBackButton() {
        
    }
    
}

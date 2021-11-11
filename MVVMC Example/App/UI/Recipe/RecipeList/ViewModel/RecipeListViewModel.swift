//
//  RecipeListViewModel.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import Foundation
import Combine

enum ViewState {
    case initial
    case loading
    case loaded
    case failed(String?)
}

/// Receiving the input/event coming from the associated view
/// It's better to keep the naming consistent with the view
protocol RecipeListViewModelInput {
    func viewDidLoad()
    func didSelect(recipeViewModel: RecipeCellViewModel)
}

protocol RecipeListViewModelOutput {
    var recipesViewModel: [RecipeCellViewModel] { get }
    var viewStateUpdated: ((ViewState) -> Void)? { get set }
}

protocol RecipeListViewModelProtocol:  RecipeListViewModelInput, RecipeListViewModelOutput {

}

final class RecipeListViewModel: RecipeListViewModelProtocol {

    enum CellType {
        case date(DateCellViewModel)
        case recipe(RecipeCellViewModel)
    }

    private let recipeUseCase: RecipeUseCaseProtocol
    private var recipes = [Recipe]()
    private var cancelSubscription = Set<AnyCancellable>()
    private weak var actions: RecipeListActions?

    var viewStateUpdated: ((ViewState) -> Void)?

    init(recipeUseCase: RecipeUseCaseProtocol, actions: RecipeListActions) {
        self.recipeUseCase = recipeUseCase
        self.actions = actions
    }
}

// MARK: - Input protocol
extension RecipeListViewModel {
    func viewDidLoad() {

        viewStateUpdated?(.loading)
        recipeUseCase.getRecipes().receive(on: RunLoop.main).sink { result in

            switch result {
            case .failure(let error):
                self.viewStateUpdated?(.failed(error.localizedDescription))
            case .finished:
                self.viewStateUpdated?(.loaded)
            }
        } receiveValue: { recipes in
            self.recipes = recipes
        }.store(in: &cancelSubscription)
    }
    
    func didSelect(recipeViewModel: RecipeCellViewModel) {
        actions?.didTapRecipe(recipe: recipeViewModel.recipe)
    }
}

// MARK: - Output protocol
extension RecipeListViewModel {
    var recipesViewModel: [RecipeCellViewModel] {
        recipes.map({RecipeCellViewModel(recipe: $0)})
    }
}


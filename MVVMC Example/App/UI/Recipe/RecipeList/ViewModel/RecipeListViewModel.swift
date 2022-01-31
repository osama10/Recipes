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
    func didTapRow(at indexPath: IndexPath)
}

protocol RecipeListViewModelOutput {
    var numberOfRows: Int { get }
    var viewState: Published<ViewState>.Publisher { get }
    func cellType(at indexPath: IndexPath) -> RecipeListViewModel.CellType
}

protocol RecipeListViewModelProtocol:  RecipeListViewModelInput, RecipeListViewModelOutput {

}

final class RecipeListViewModel: RecipeListViewModelProtocol {
    var viewState: Published<ViewState>.Publisher {
        $viewStatePublisher
    }

    enum CellType {
        case date(DateCellViewModel)
        case recipe(RecipeCellViewModel)
    }

    private let recipeUseCase: RecipeUseCaseProtocol
    private var recipes = [Recipe]()
    private var cancelSubscription = Set<AnyCancellable>()
    private weak var actions: RecipeListActions?

    @Published private var viewStatePublisher = ViewState.initial

    init(recipeUseCase: RecipeUseCaseProtocol, actions: RecipeListActions) {
        self.recipeUseCase = recipeUseCase
        self.actions = actions
    }
}

// MARK: - Input protocol
extension RecipeListViewModel {
    func viewDidLoad() {

        viewStatePublisher = .loading
        recipeUseCase.getRecipes().receive(on: RunLoop.main).sink { result in

            switch result {
            case .failure(let error):
                self.viewStatePublisher = .failed(error.localizedDescription)
            case .finished:
                self.viewStatePublisher = .loaded
            }
        } receiveValue: { recipes in
            self.recipes = recipes
        }.store(in: &cancelSubscription)
    }
    
    func didTapRow(at indexPath: IndexPath) {
        guard case .recipe = cellType(at: indexPath) else { return }
        actions?.didTapRecipe(recipe: recipes[indexPath.row - 1])
    }
}

// MARK: - Output protocol
extension RecipeListViewModel {
    var numberOfRows: Int {
        recipes.count + 1
    }

    func cellType(at indexPath: IndexPath) -> CellType {
        indexPath.row == 0
            ? .date(DateCellViewModel())
            : .recipe(RecipeCellViewModel(recipe: recipes[indexPath.row - 1]))
    }
}


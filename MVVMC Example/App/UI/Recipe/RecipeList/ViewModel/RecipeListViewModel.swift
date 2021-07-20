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
    var viewStateUpdated: ((ViewState) -> Void)? { get set }

    func dateCellViewModel() -> DateCellViewModel
    func recipeCellViewModel(at indexPath: IndexPath) -> RecipeCellViewModel
}

protocol RecipeListViewModelProtocol: RecipeListViewModelInput, RecipeListViewModelOutput {

}

final class RecipeListViewModel: RecipeListViewModelProtocol {
    private let recipeUseCase: RecipeUseCaseProtocol
    private var recipes = [Recipe]()
    private var cancelSubscription = Set<AnyCancellable>()

    var viewStateUpdated: ((ViewState) -> Void)?

    init(recipeUseCase: RecipeUseCaseProtocol) {
        self.recipeUseCase = recipeUseCase
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
    
    func didTapRow(at indexPath: IndexPath) {

    }
}

// MARK: - Output protocol
extension RecipeListViewModel {
    var numberOfRows: Int {
        recipes.count + 1
    }

    func dateCellViewModel() -> DateCellViewModel {
        DateCellViewModel()
    }

    func recipeCellViewModel(at indexPath: IndexPath) -> RecipeCellViewModel {
        RecipeCellViewModel(recipe: recipes[indexPath.row - 1])
    }
}


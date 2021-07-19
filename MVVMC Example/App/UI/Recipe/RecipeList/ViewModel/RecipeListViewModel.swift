//
//  RecipeListViewModel.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import Foundation
import Combine

// Output of the viewModel used in View
protocol RecipeListViewModelOutput {
    
    var error: PassthroughSubject<String, Never> { get }
    var loader: PassthroughSubject<Bool, Never> { get }
    var reload: PassthroughSubject<Void, Never> { get }
    var totalRows: Int { get }
    var title: String { get }
    var dateCellViewModel: DateCellViewModel { get }
    
    func recipeViewModel(atIndex index: Int) -> RecipeCellViewModel
}

// input from the View to ViewModel
protocol RecipeListViewModelInput {
    var viewDidLoadTrigger: PassthroughSubject<Void, Never> { get }
}

protocol RecipeListViewModelProtocol: RecipeListViewModelInput, RecipeListViewModelOutput { }

final class RecipeListViewModel: RecipeListViewModelProtocol {
    
    var error: PassthroughSubject<String, Never> = PassthroughSubject()
    var loader: PassthroughSubject<Bool, Never> = PassthroughSubject()
    var reload: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    var totalRows: Int { recipes.count + 1 }
    var title: String { "Recipe List" }
    var dateCellViewModel: DateCellViewModel { DateCellViewModel() }
    
    var viewDidLoadTrigger: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    private var recipes = [Recipe]() { didSet { reload.send() } }
    private let useCase: RecipeUseCaseProtocol
    private var subscriptionStores = Set<AnyCancellable>()
    
    init(useCase: RecipeUseCaseProtocol) {
        self.useCase = useCase
        subscriptions()
    }
    
    /// creates viewModel for RecipeTableViewCell
    ///
    /// - Parameter index: Index of the cell
    /// - Returns viewModel for the RecipeCellViewModel
    func recipeViewModel(atIndex index: Int) -> RecipeCellViewModel {
        let recipe = recipes[index - 1]
        let viewModel = RecipeCellViewModel(recipe: recipe)
        return viewModel
    }
    
    /// call by viewController to let viewModel know that it's loaded
    private func viewDidLoad() {
        loader.send(true)
        getRecipes()
    }
    
    private func getRecipes() {
        useCase
            .getRecipes()
            .receive(on: RunLoop.main)
            .sink { (completion) in
                switch completion {
                case .failure(let dataFetchEror):
                    self.failure(dataFetchEror: dataFetchEror)
                default: print("Finishes \(completion)")
                }
            } receiveValue: { self.success(data: $0) }
            .store(in: &subscriptionStores)
    }
    
    private func subscriptions() {
        viewDidLoadTrigger
            .sink(receiveValue: viewDidLoad)
            .store(in: &subscriptionStores)
    }
    
    /// handles success of getRecipes call
    private func success(data: [Recipe]) {
        loader.send(false)
        recipes = data
    }
    
    /// handles failure of getRecipes call
    private func failure(dataFetchEror: DataFetchError) {
        loader.send(false)
        switch dataFetchEror {
        case .noInternet: error.send(Constants.ErrorMessage.noInternet)
        default: error.send(Constants.ErrorMessage.somethingWentWrong)
        }
    }
}

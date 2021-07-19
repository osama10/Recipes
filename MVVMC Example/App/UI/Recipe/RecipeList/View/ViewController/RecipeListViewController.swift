//
//  ViewController.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import UIKit
import Combine

class RecipeListViewController: UIViewController, AlertsPresentable {
    
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: RecipeListViewModelProtocol!
    private var subscriptionsStore = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.viewDidLoadTrigger.send()
    }
    
    /// setup table view
    private func setupTableView() {
        tableView.setdelegateAndDatasource(for: self)
        tableView.register(RecipeTableViewCell.self)
        tableView.register(DateTableViewCell.self)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    /// binds view model to View
    private func bindViewModel() {
        /// show error
        viewModel
            .error
            .sink { [weak self] in self?.showAlert(with: "Error", and: $0) }
            .store(in: &subscriptionsStore)
        /// show and hide loader
        viewModel
            .loader
            .sink { ($0) ? LoadingView.show() : LoadingView.hide() }
            .store(in: &subscriptionsStore)
        /// reloads table view
        viewModel
            .reload
            .sink { [weak self] in self?.tableView.reloadData() }
            .store(in: &subscriptionsStore)
        /// title of the View
        title = viewModel.title
    }
    
}

extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewCell(indexPath: indexPath)
    }
    
    /// return appropriate UITableViewCelll based on indexPath
    ///
    /// - Parameter indexPath: for checking the row
    /// - Returns UITableViewCell
    private func tableViewCell(indexPath: IndexPath) -> UITableViewCell {
        (indexPath.row == 0)
            ? dateCell(viewModel: viewModel.dateCellViewModel, indexPath: indexPath)
            : recipeCell(viewModel: viewModel.recipeViewModel(atIndex: indexPath.row), indexPath: indexPath)
    }
    
    /// return  RecipeTableViewCell
    ///
    /// - Parameter indexPath: for checking deque
    /// - Parameter viewModel: contains data for the cell
    /// - Returns RecipeTableViewCell
    private func recipeCell(viewModel: RecipeCellViewModel, indexPath: IndexPath) -> RecipeTableViewCell {
        let cell = tableView.dequeResuseableCell(for: indexPath) as RecipeTableViewCell
        cell.setupData(viewModel: viewModel)
        return cell
    }
    
    /// return  DateTableViewCell
    ///
    /// - Parameter indexPath: for checking deque
    /// - Parameter viewModel: contains data for the cell
    /// - Returns DateTableViewCell
    private func dateCell(viewModel: DateCellViewModel, indexPath: IndexPath) -> DateTableViewCell {
        let cell = tableView.dequeResuseableCell(for: indexPath) as DateTableViewCell
        cell.setupData(viewModel: viewModel)
        return cell
    }
    
}



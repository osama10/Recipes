//
//  ViewController.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import UIKit
import Combine

class RecipeListViewController: UITableViewController, AlertsPresentable {

    private let viewModel: RecipeListViewModel
    private var disposables: Set<AnyCancellable> = []

    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel

        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    /// setup table view
    private func setupTableView() {
        tableView.register(RecipeTableViewCell.self)
        tableView.register(DateTableViewCell.self)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func bindViewModel() {
        viewModel.viewState.sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .initial:
                break
            case .loading:
                //show loading
                break
            case .loaded:
                self.tableView.reloadData()
            case .failed(let message):
                self.showAlert(with: "Error", and: message)
            }
        }.store(in: &disposables)
    }
 }

extension RecipeListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         tableViewCell(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// return appropriate UITableViewCelll based on indexPath
    ///
    /// - Parameter indexPath: for checking the row
    /// - Returns UITableViewCell
    private func tableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.cellType(at: indexPath)

        switch cellType {
        case .date(let dateViewModel): return dateCell(viewModel: dateViewModel, indexPath: indexPath)
        case .recipe(let recipeViewModel): return recipeCell(viewModel: recipeViewModel, indexPath: indexPath)
        }
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



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
    private var dataSource: UITableViewDiffableDataSource<Section, RecipeCellViewModel>!

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
        configureDataSource()
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, RecipeCellViewModel>(tableView: tableView) { [weak self] tableView, indexPath, recipeViewModel in
            return self?.recipeCell(viewModel: recipeViewModel, indexPath: indexPath)
        }
    }
    
    func createSnapshot(for recipes: [RecipeCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecipeCellViewModel>()
        snapshot.appendSections([.recipe])
        snapshot.appendItems(recipes, toSection: .recipe)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func bindViewModel() {
        viewModel.viewStateUpdated = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .initial:
                break
            case .loading:
                //show loading
                break
            case .loaded:
                self.createSnapshot(for: self.viewModel.recipesViewModel)
            case .failed(let message):
                self.showAlert(with: "Error", and: message)
            }
        }
    }
 }

extension RecipeListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipeViewModel = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didSelect(recipeViewModel: recipeViewModel)
        tableView.deselectRow(at: indexPath, animated: true)
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

extension RecipeListViewController {
    enum Section {
        case recipe
    }
}

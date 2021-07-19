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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    /// setup table view
    private func setupTableView() {
        tableView.setdelegateAndDatasource(for: self)
        tableView.register(RecipeTableViewCell.self)
        tableView.register(DateTableViewCell.self)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
 }

extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
            ? dateCell(viewModel: DateCellViewModel(), indexPath: indexPath)
            : recipeCell(viewModel: RecipeCellViewModel(recipe: Recipe(title: "", image: "", headline: "")), indexPath: indexPath)
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



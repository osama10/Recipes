import UIKit

protocol RecipesDataSourceProtocol: AnyObject {
    var sectionCount: Int { get }
    func registerCells(in tableView: UITableView)
    func setup(tableView: UITableView)
    func update(for recipes: [RecipeCellViewModel])
    func item(at indexPath: IndexPath) -> RecipeCellViewModel?
}

extension RecipesDataSourceProtocol {
    func registerCells(in tableView: UITableView) {
        tableView.register(RecipeTableViewCell.self)
        tableView.register(DateTableViewCell.self)
    }
}
enum RecipeSection {
    case recipe
}

@available(iOS 13.0, *)
final class RecipesDiffableDataSource: NSObject, RecipesDataSourceProtocol {

    private var dataSource: UITableViewDiffableDataSource<RecipeSection, RecipeCellViewModel>?

    var sectionCount: Int {
        dataSource?.snapshot().sectionIdentifiers.count ?? 0
    }

    func setup(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model in
            let cell = tableView.dequeResuseableCell(for: indexPath) as RecipeTableViewCell
            cell.setupData(viewModel: model)
            return cell
        })
        tableView.dataSource = dataSource
    }

    func update(for recipes: [RecipeCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<RecipeSection, RecipeCellViewModel>()
        snapshot.appendSections([.recipe])
        snapshot.appendItems(recipes, toSection: .recipe)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    func item(at indexPath: IndexPath) -> RecipeCellViewModel? {
        return dataSource?.itemIdentifier(for: indexPath)
    }
}

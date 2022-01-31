//
//  RecipeDetailCoordinator.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 03.08.21.
//

import UIKit

protocol RecipeDetailsViewActions: AnyObject {
    func didTapBackButton()
    func didTapActionsButton(recipe: Recipe)
}

final class RecipeDetailsCoordinator: BaseCoordinator {
    struct Dependency {
        private let builder: RecipeDetailsViewBuilder
        let sourceController: ViewNavigationProvider
        
        init(builder: RecipeDetailsViewBuilder,
             sourceController: ViewNavigationProvider) {
            self.builder = builder
            self.sourceController = sourceController
        }
        
        func buildViewController(actions: RecipeDetailsViewActions) -> RecipeDetailsViewController {
            builder.build(actions: actions)
        }
    }
    
    private let dependency: Dependency
    private lazy var detailViewController: RecipeDetailsViewController =  {
        dependency.buildViewController(actions: self)
    }()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
    }
    
    override func start() {
        dependency
            .sourceController
            .pushViewController(detailViewController, animated: true)
    }
}

extension RecipeDetailsCoordinator: RecipeDetailsViewActions {
    func didTapBackButton() {
        _ = dependency
            .sourceController
            .popViewController(animated: true)
        
        finish()
    }

    func didTapActionsButton(recipe: Recipe) {
        let viewBuilder = ActionsViewBuilder(recipe: recipe)
        let dependency = ActionsCoordinator.Dependency(builder: viewBuilder, sourceController: detailViewController)
        let coordinator = ActionsCoordinator(dependency: dependency)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

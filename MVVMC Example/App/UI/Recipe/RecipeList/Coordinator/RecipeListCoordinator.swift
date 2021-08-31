//
//  RecipeListCoordinator.swift
//  MVVMC Example
//
//  Created by Abbas Ali Awan on 03.08.21.
//

import Foundation
import UIKit

protocol RecipeListActions: AnyObject {
    func didTapRecipe(recipe: Recipe)
}

final class RecipeListCoordinator: BaseCoordinator {
    struct Dependency {
        private let builder: RecipeListViewBuilder
        let sourceController: UINavigationController
        
        init(builder: RecipeListViewBuilder, parentViewController: UINavigationController) {
            self.builder = builder
            self.sourceController = parentViewController
        }

        func buildViewController(actions: RecipeListActions) -> RecipeListViewController {
            builder.buildViewController(actions: actions)
        }
    }

    private let dependency: Dependency
  
    private lazy var controller: RecipeListViewController = {
        dependency.buildViewController(actions: self)
    }()
    
    override func start() {
        dependency
            .sourceController
            .pushViewController(controller, animated: true)
    }

    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
    }
}

extension RecipeListCoordinator: RecipeListActions {
    func didTapRecipe(recipe: Recipe) {
        let builder = RecipeDetailsViewBuilder(recipe: recipe)
        let dependency = RecipeDetailsCoordinator.Dependency(builder: builder, sourceController: dependency.sourceController)
        let coordinator = RecipeDetailsCoordinator(dependency: dependency)
        childCoordinators.append(coordinator) 
        coordinator.start()
    }
}

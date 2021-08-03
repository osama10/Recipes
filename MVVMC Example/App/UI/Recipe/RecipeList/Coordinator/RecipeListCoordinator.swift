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

final class RecipeListCoordinator: BaseCoordinator<UINavigationController> {
    struct Dependency {
        private let builder: RecipeListViewBuilder
        let rootViewController: UINavigationController

        init(builder: RecipeListViewBuilder, rootViewController: UINavigationController) {
            self.builder = builder
            self.rootViewController = rootViewController
        }

        func buildViewController(actions: RecipeListActions) -> RecipeListViewController {
            builder.buildViewController(actions: actions)
        }
    }

    private let dependency: Dependency

    override func start() {
        let controller = dependency.buildViewController(actions: self)
        rootViewController.pushViewController(controller, animated: true)
    }

    init(dependency: Dependency) {
        self.dependency = dependency
        super.init(rootViewController: dependency.rootViewController)
    }
}

extension RecipeListCoordinator: RecipeListActions {
    func didTapRecipe(recipe: Recipe) {
        let builder = RecipeDetailsViewBuilder(recipe: recipe)
        let dependency = RecipeDetailsCoordinator.Dependency(builder: builder, rootViewController: rootViewController)
        let coordinator = RecipeDetailsCoordinator(dependency: dependency)
        childCoordinator = coordinator
        coordinator.start()
    }
}

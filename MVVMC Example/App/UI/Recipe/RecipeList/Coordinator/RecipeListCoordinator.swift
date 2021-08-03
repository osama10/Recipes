//
//  RecipeListCoordinator.swift
//  MVVMC Example
//
//  Created by Abbas Ali Awan on 03.08.21.
//

import Foundation
import UIKit

final class RecipeListCoordinator: BaseCoordinator<UINavigationController> {

    struct Dependency {
        private let builder: RecipeListBuilder
        let rootViewController: UINavigationController

        init(builder: RecipeListBuilder, rootViewController: UINavigationController) {
            self.builder = builder
            self.rootViewController = rootViewController
        }

        func buildViewController() -> RecipeListViewController {
            builder.buildViewController()
        }
    }

    private let dependency: Dependency

    override func start() {
        let controller = dependency.buildViewController()

        rootViewController.pushViewController(controller, animated: true)
    }

    init(dependency: Dependency) {
        self.dependency = dependency

        super.init(rootViewController: dependency.rootViewController)
    }
}

final class RecipeListBuilder {
    let recipeUseCase: RecipeUseCaseProtocol

    init(recipeUseCase: RecipeUseCaseProtocol) {
        self.recipeUseCase = recipeUseCase
    }

    func buildViewController() -> RecipeListViewController {
        let storyboard = UIStoryboard(storyboard: .recipe)
        let recipeViewController: RecipeListViewController = storyboard.initialViewController()
        let viewModel = RecipeListViewModel(recipeUseCase: recipeUseCase)
        recipeViewController.viewModel = viewModel

        return recipeViewController
    }
}

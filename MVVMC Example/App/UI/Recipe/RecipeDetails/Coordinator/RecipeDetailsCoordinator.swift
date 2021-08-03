//
//  RecipeDetailCoordinator.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 03.08.21.
//

import UIKit

final class RecipeDetailsCoordinator: BaseCoordinator<UINavigationController> {
    struct Dependency {
        private let builder: RecipeDetailsViewBuilder
        let rootViewController: UINavigationController
        
        init(builder: RecipeDetailsViewBuilder, rootViewController: UINavigationController) {
            self.builder = builder
            self.rootViewController = rootViewController
        }
        
        func buildViewController() -> RecipeDetailsViewController {
            builder.build()
        }
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init(rootViewController: dependency.rootViewController)
    }
    
    override func start() {
        let viewController = dependency.buildViewController()
        rootViewController.pushViewController(viewController, animated: true)
    }
}

final class RecipeDetailsViewBuilder {
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func build() -> RecipeDetailsViewController {
        let storyboard = UIStoryboard(storyboard: .recipe)
        let viewController: RecipeDetailsViewController = storyboard.instantiateViewController()
        let viewModel = RecipeDetailsViewModel(recipe: recipe)
        viewController.viewModel = viewModel
        return viewController
    }
}

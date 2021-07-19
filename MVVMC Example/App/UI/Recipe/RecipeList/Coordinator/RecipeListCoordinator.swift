//
//  RecipeListCoordinator.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

// Dependency to create RecipeListViewController
protocol RecipeListCoordinatorDependencies {
    func makeRecipeListViewController() -> RecipeListViewController
}

final class RecipeListCoordinator: Coordinator {
    
    let dependencies: RecipeListCoordinatorDependencies
    private weak var navigation: UINavigationController?
    private weak var recipeListVC: RecipeListViewController?
    
    init(dependencies: RecipeListCoordinatorDependencies, navigation: AppNavigation) {
        self.dependencies = dependencies
        self.navigation = navigation
    }
    
    /// push RecipeListViewController to app's navgation
    func start() {
        let vc = dependencies.makeRecipeListViewController()
        navigation?.pushViewController(vc, animated: true)
        recipeListVC = vc
    }
}

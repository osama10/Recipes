//
//  AppCoordinator.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    let tabBar = HFTabBarController()
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        prepareForLaunch()
        window.makeKeyAndVisible()
    }
    
    private func prepareForLaunch() {
        tabBar.viewControllers = [recipeListView(), dateView()]
        window.rootViewController = tabBar
    }
    
    private func recipeListView() -> UIViewController {
        let useCase = RecipeUseCase(recipeRepository: RecipeRepository(dataStore: RecipeDataStore(networkManager: NetworkManager())))
        let parentViewController = HFNavigationController()
        let dependancy = RecipeListCoordinator.Dependency(builder: RecipeListViewBuilder(recipeUseCase: useCase), parentViewController: parentViewController)
        let coordinator = RecipeListCoordinator(dependency: dependancy)
        childCoordinators.append(coordinator)
        coordinator.start()
        parentViewController.tabBarItem.title = "Recipe List"
        return parentViewController
    }

    private func dateView() -> UIViewController {
        let dateView = DateViewController()
        dateView.tabBarItem.title = "Date"
        return dateView
    }
}

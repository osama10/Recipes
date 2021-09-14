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
        tabBar.viewControllers = [recipeListView(), dateAndTimeView()]
        window.rootViewController = tabBar
    }
    
    private func recipeListView() -> UIViewController {
        let useCase = RecipeUseCase(recipeRepository: RecipeRepository(dataStore: RecipeDataStore(networkManager: NetworkManager())))
        let navController = HFNavigationController()
        let dependancy = RecipeListCoordinator.Dependency(builder: RecipeListViewBuilder(recipeUseCase: useCase), sourceController: navController)
        let coordinator = RecipeListCoordinator(dependency: dependancy)
        childCoordinators.append(coordinator)
        coordinator.start()
        navController.tabBarItem.title = "Recipe List"
        return navController
    }

    private func dateView() -> UIViewController {
        let dateView = DateViewController()
        dateView.tabBarItem.title = "Date"
        return dateView
    }

    private func dateAndTimeView() -> UIViewController {
        let navController = HFNavigationController()
        let builder = DateAndTimeContainerViewBuilder(childViewControllers: [dateView(), dateView()])
        let dependancy = DateAndTimeContainerCoordinator.Dependency(builder: builder, sourceController: navController)
        let coordinator = DateAndTimeContainerCoordinator(dependancy: dependancy)
        childCoordinators.append(coordinator)
        coordinator.start()

        navController.tabBarItem.title = "Date & time"
        return navController
    }
}

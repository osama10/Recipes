//
//  AppCoordinator.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

final class AppCoordinator: BaseCoordinator<UITabBarController> {
    private let window: UIWindow
    let tabBar = HFTabBarController()
    
    init(window: UIWindow) {
        self.window = window

        super.init(rootViewController: tabBar)
    }
    
    override func start() {
        prepareForLaunch()
        window.makeKeyAndVisible()
    }
    
    private func prepareForLaunch() {
        tabBar.viewControllers = [recipeListView()]
        window.rootViewController = tabBar
    }
    
    private func recipeListView() -> UIViewController {
        let useCase = RecipeUseCase(recipeRepository: RecipeRepository(dataStore: RecipeDataStore(networkManager: NetworkManager())))
        let parentViewController = HFNavigationController()
        let dependancy = RecipeListCoordinator.Dependency(builder: RecipeListViewBuilder(recipeUseCase: useCase), rootViewController: parentViewController)
        let coordinator = RecipeListCoordinator(dependency: dependancy)
        childCoordinator = coordinator
        childCoordinator?.start()
        return parentViewController
    }
}

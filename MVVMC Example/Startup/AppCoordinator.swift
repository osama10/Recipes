//
//  AppCoordinator.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

final class AppCoordinator: BaseCoordinator<UINavigationController> {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window

        super.init(rootViewController: HFNavigationController())
    }
    
    override func start() {
        prepareForLaunch()
        window.makeKeyAndVisible()
    }
    
    private func prepareForLaunch() {
        let useCase = RecipeUseCase(recipeRepository: RecipeRepository(dataStore: RecipeDataStore(networkManager: NetworkManager())))
        let dependancy = RecipeListCoordinator.Dependency(builder: RecipeListBuilder(recipeUseCase: useCase), rootViewController: rootViewController)
        let coordinator = RecipeListCoordinator(dependency: dependancy)
        childCoordinator = coordinator
        childCoordinator?.start()
        window.rootViewController = rootViewController
    }
}

//
//  AppCoordinator.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        prepareForLaunch()
        window.makeKeyAndVisible()
    }
    
    private func prepareForLaunch() {
        let navigation = AppNavigation()
        window.rootViewController = navigation
        let storyboard = UIStoryboard(storyboard: .recipe)
        let recipeViewController: RecipeListViewController = storyboard.initialViewController()
        navigation.pushViewController(recipeViewController, animated: true)
    }
}

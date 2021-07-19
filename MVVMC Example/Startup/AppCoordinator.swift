//
//  AppCoordinator.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

// App level coordinator use for starting the app
final class AppCoordinator: Coordinator {
    
    private let navigation: AppNavigation
    private let appDIContainer: AppDIContainer
    
    init(navigation: AppNavigation, appDIContainer: AppDIContainer) {
        self.navigation = navigation
        self.appDIContainer = appDIContainer
    }
    
    /// start app by calling recipeListCoordinator's Start method
    func start() {
        let recipeDIContainer = appDIContainer.makeRecipeDIContainer()
        let recipeListCoordinator = recipeDIContainer.makeRecipeListCoordinator(navigation: navigation)
        recipeListCoordinator.start()
    }
}

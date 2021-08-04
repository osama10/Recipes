//
//  RecipeDetailCoordinator.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 03.08.21.
//

import UIKit

protocol RecipeDetailsViewActions: AnyObject {
    func didTapBackButton()
}

final class RecipeDetailsCoordinator: BaseCoordinator<UINavigationController> {
    struct Dependency {
        private let builder: RecipeDetailsViewBuilder
        let rootViewController: UINavigationController
        
        init(builder: RecipeDetailsViewBuilder, rootViewController: UINavigationController) {
            self.builder = builder
            self.rootViewController = rootViewController
        }
        
        func buildViewController(actions: RecipeDetailsViewActions) -> RecipeDetailsViewController {
            builder.build(actions: actions)
        }
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init(rootViewController: dependency.rootViewController)
    }
    
    override func start() {
        let viewController = dependency.buildViewController(actions: self)
        parentViewController.pushViewController(viewController, animated: true)
    }
}

extension RecipeDetailsCoordinator: RecipeDetailsViewActions {
    func didTapBackButton() {
        parentViewController.popViewController(animated: true)
    }
}

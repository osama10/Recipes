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
        private let builder: RecipeListViewBuilder
        let rootViewController: UINavigationController

        init(builder: RecipeListViewBuilder, rootViewController: UINavigationController) {
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


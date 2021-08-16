//
//  ActionsCoordinator.swift
//  MVVMC Example
//
//  Created by Fatma Dagdevir on 16.08.21.
//

import UIKit

final class ActionsCoordinator: BaseCoordinator<UINavigationController> {
    struct Dependency {
        private let builder: ActionsViewBuilder
        let rootViewController: UINavigationController

        init(builder: ActionsViewBuilder, rootViewController: UINavigationController) {
            self.builder = builder
            self.rootViewController = rootViewController
        }

        func buildViewController() -> ActionsViewController {
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
        let actionSheetController = DynamicActionSheetController.create(
            from: dependency.rootViewController,
            rootViewController: viewController,
            style: .noTopGap
        )
        actionSheetController.dismissalDelegate = self
    }
}

// MARK: - DynamicActionSheetControllerDismissalDelegate
extension ActionsCoordinator: DynamicActionSheetControllerDismissalDelegate {
    func manuallyDismissedDynamicActionSheetController() {
        parentViewController.popViewController(animated: true)
    }
}


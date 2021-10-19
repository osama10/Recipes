//
//  ActionsCoordinator.swift
//  MVVMC Example
//
//  Created by Fatma Dagdevir on 16.08.21.
//

import UIKit

protocol ActionsViewControllerActions: AnyObject {
    func didTapRateButton()
}

final class ActionsCoordinator: BaseCoordinator {
    struct Dependency {
        private let builder: ActionsViewBuilder
        let sourceController: UIViewController
        
        init(builder: ActionsViewBuilder,
             sourceController: UIViewController) {
            self.builder = builder
            self.sourceController = sourceController
        }

        func buildViewController(actions: ActionsViewControllerActions) -> ActionsViewController {
            builder.build(actions: actions)
        }
    }

    private let dependency: Dependency

    private lazy var viewController: ActionsViewController = {
        dependency.buildViewController(actions: self)
    }()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
    }

    override func start() {
        
        let actionSheetController = DynamicActionSheetController.create(
            from: dependency.sourceController,
            rootViewController: viewController,
            style: .noTopGap
        )
       
        actionSheetController.dismissalDelegate = self
    }
}

// MARK: - DynamicActionSheetControllerDismissalDelegate
extension ActionsCoordinator: DynamicActionSheetControllerDismissalDelegate {
    func manuallyDismissedDynamicActionSheetController() {
        finish()
    }
}

// MARK: ActionsViewControllerActions
extension ActionsCoordinator: ActionsViewControllerActions {
    func didTapRateButton() {
        let coordinator = DateViewCoordinator(flow: .rateIt, sourceController: viewController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

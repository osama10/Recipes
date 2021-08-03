//
//  BaseCoordinator.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 20.07.21.
//

import Foundation
import UIKit

class BaseCoordinator<T: UIViewController>: Coordinator {
    weak var parentCoordinator: Coordinator?

    let rootViewController: T

    var childCoordinator: Coordinator? {
        didSet {
            childCoordinator?.parentCoordinator = self
        }
    }

    // MARK: - Lifecycle
    init(rootViewController: T) {
        self.rootViewController = rootViewController
    }

    // MARK: - Cooordinator
    func start() {
        assertionFailure("Child coordinator must override this")
    }
    
    func didFinishChild() {
        childCoordinator = nil
    }
}

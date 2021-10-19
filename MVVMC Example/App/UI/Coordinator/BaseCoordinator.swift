//
//  BaseCoordinator.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 20.07.21.
//

import Foundation
import UIKit

class BaseCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    
    // MARK: - Lifecycle
    init() {
        
    }
    
    // MARK: - Cooordinator
    func start() {
        assertionFailure("Child coordinator must override this")
    }
    
    func add(_ coordinator: Coordinator) {
        guard (childCoordinators.filter{ $0 === coordinator }.count == 0)
        else { return }
        childCoordinators.append(coordinator)
    }
    
    func finish() {
        childCoordinators.removeAll()
        parentCoordinator?.didFinishChildCoordinator(self)
    }
    
    func didFinishChildCoordinator(_ coordinator: Coordinator) {
        for (index, child) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

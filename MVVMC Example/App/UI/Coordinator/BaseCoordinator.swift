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

    var childCoordinator: Coordinator? {
        didSet {
            childCoordinator?.parentCoordinator = self
        }
    }
    
    func start() {
        assertionFailure("Child coordinator must override this")
    }
    
    func didFinishChild() {
        childCoordinator = nil
    }
    
}

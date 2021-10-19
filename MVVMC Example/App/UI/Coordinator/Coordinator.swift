//
//  File.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 20.07.21.
//

import Foundation

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get  }
    
    func start()
    
    func add(_ coordinator: Coordinator)
    func finish()
    func didFinishChildCoordinator(_ coordinator: Coordinator)
}

protocol DeepLinkCoordinator: AnyObject {
    func goToDeepLink(_ url: URL)
}

typealias ActualCoordinator = Coordinator & DeepLinkCoordinator

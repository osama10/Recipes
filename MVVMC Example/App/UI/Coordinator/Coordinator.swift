//
//  File.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 20.07.21.
//

import Foundation

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinator: Coordinator? { get }
    
    func start()
    func didFinishChild()
    
}

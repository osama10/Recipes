//
//  ViewNavigationProvider.swift
//  MVVMC Example
//
//  Created by Abbas Ali Awan on 09.11.21.
//

import UIKit

protocol ViewNavigationProvider {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool) -> UIViewController?
    func popToRootViewController(animated: Bool) -> [UIViewController]?
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
    var topViewController: UIViewController? { get }
    var visibleViewController: UIViewController? { get }
    var viewControllers: [UIViewController] { get set }
    var delegate: UINavigationControllerDelegate? { get set }
}

extension UINavigationController: ViewNavigationProvider {}

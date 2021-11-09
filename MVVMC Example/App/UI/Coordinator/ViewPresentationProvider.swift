//
//  ViewPresentationProvider.swift
//  MVVMC Example
//
//  Created by Abbas Ali Awan on 09.11.21.
//

import UIKit

protocol ViewPresentationProvider {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController: ViewPresentationProvider {}

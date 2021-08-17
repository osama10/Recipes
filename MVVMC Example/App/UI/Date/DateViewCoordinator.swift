//
//  DateViewCoordinator.swift
//  MVVMC Example
//
//  Created by Abbas Ali Awan on 17.08.21.
//

import UIKit

final class DateViewCoordinator: BaseCoordinator<UINavigationController> {

    override func start() {
        parentViewController.pushViewController(dateView(), animated: true)
    }

    private func dateView() -> UIViewController {
        let dateView = DateViewController()
        dateView.tabBarItem.title = "Date"
        return dateView
    }
}

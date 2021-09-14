//
//  DateAndTimeContainerViewBuilder.swift
//  MVVMC Example
//
//  Created by Marian Keriacos on 14.09.21 w37.
//

import Foundation
import UIKit
final class DateAndTimeContainerViewBuilder {
    private let childViewControllers: [UIViewController]

    init(childViewControllers: [UIViewController]) {
        self.childViewControllers = childViewControllers
    }

    func build() -> DateAndTimeContainerViewController {
        let viewModel = DateAndTimeContainerViewModel()

        let dateAndTimeViewController = DateAndTimeContainerViewController(viewModel: viewModel, childViews: childViewControllers)
        dateAndTimeViewController.title = "Date & Time"
        dateAndTimeViewController.tabBarItem.title = "Date & Time"
        return dateAndTimeViewController
    }
}

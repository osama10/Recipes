//
//  DateAndTimeContainerCoordinator.swift
//  MVVMC Example
//
//  Created by Marian Keriacos on 14.09.21 w37.
//

import Foundation
import UIKit

final class DateAndTimeContainerCoordinator: BaseCoordinator {
    struct Dependency {
        private let builder: DateAndTimeContainerViewBuilder
        let sourceController: UINavigationController

        init(builder: DateAndTimeContainerViewBuilder,
             sourceController: UINavigationController) {
            self.builder = builder
            self.sourceController = sourceController
        }

        func buildViewController() -> DateAndTimeContainerViewController {
            builder.build()
        }
    }

    private let dependancy: Dependency

    init(dependancy: Dependency) {
        self.dependancy = dependancy
        super.init()
    }

    override func start() {
        dependancy
            .sourceController
            .pushViewController(dependancy.buildViewController(), animated: true)
    }
}

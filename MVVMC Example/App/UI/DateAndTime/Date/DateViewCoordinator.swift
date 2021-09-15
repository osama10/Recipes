//
//  DateViewCoordinator.swift
//  MVVMC Example
//
//  Created by Abbas Ali Awan on 17.08.21.
//

import UIKit

final class DateViewCoordinator: BaseCoordinator {
    enum Flow {
        case date
        case rateIt
    }
    
    private let flow: Flow

    let sourceController: UIViewController
    
    init(flow: Flow, sourceController: UIViewController) {
        self.flow = flow
        self.sourceController = sourceController
        super.init()
    }
    
    override func start() {
        switch flow {
        case .date:
            sourceController.present(dateView(), animated: true, completion: nil)
        case .rateIt:
            sourceController.present(dateView(), animated: true, completion: nil)

        }
    }

    private func dateView() -> UIViewController {
        let dateView = DateViewController()
        dateView.tabBarItem.title = "Date"
        return dateView
    }
}

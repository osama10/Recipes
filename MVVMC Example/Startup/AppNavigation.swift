//
//  AppNavigation.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

class AppNavigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationBar.barTintColor = .themeColor
        navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(.avenirBold, size: .standard(.h1))]
        navigationBar.backgroundColor = .themeColor
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

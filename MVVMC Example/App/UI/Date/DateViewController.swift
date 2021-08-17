//
//  DateViewController.swift
//  MVVMC Example
//
//  Created by Carolina Rocha on 17.08.21.
//

import UIKit

class DateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let label = UILabel()
        label.text = Date().description
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

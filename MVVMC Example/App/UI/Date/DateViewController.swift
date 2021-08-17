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
        let label = UILabel(frame: CGRect(x: 160, y: 384, width: 130, height: 21))
        label.text = Date().description
        view.addSubview(label)
    }
}

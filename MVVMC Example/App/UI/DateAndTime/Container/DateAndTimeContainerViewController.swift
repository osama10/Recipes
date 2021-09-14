//
//  DateAndTimeContainerViewController.swift
//  MVVMC Example
//
//  Created by Marian Keriacos on 14.09.21 w37.
//

import Foundation
import UIKit

class DateAndTimeContainerViewController: UIViewController {

    let segmentedControl: UISegmentedControl
    let containerView = UIView()
    let childViews: [UIView]

    init(childViews: [UIView]) {
        self.childViews = childViews
        segmentedControl = UISegmentedControl(items: ["date", "time"])
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        self.view.addSubview(segmentedControl)
        self.view.addSubview(containerView)
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }

    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let selectedView = childViews[selectedIndex]
        containerView.addSubview(selectedView)
    }
}

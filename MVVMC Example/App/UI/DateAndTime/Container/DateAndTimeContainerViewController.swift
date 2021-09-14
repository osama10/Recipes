//
//  DateAndTimeContainerViewController.swift
//  MVVMC Example
//
//  Created by Marian Keriacos on 14.09.21 w37.
//

import Foundation
import UIKit

final class DateAndTimeContainerViewController: UIViewController {

    private let segmentedControl: UISegmentedControl
    private let containerView = UIView()
    private let childViews: [UIViewController]
    private var viewModel: DateAndTimeContainerViewModelProtocol

    init(viewModel: DateAndTimeContainerViewModelProtocol, childViews: [UIViewController]) {
        self.viewModel = viewModel
        self.childViews = childViews
        segmentedControl = UISegmentedControl(items: viewModel.titles)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.indexUpdate = { [weak self] lastIndex, newIndex in
            guard let self = self, newIndex < self.childViews.count else {
                return
            }

            if lastIndex >= 0 {
                let lastSelectedView = self.childViews[lastIndex]
                lastSelectedView.willMove(toParent: nil)
                lastSelectedView.view.removeFromSuperview()
                lastSelectedView.removeFromParent()
            }

            let newSelectedView = self.childViews[newIndex]
            self.addChild(newSelectedView)
            self.containerView.addSubview(newSelectedView.view)
            newSelectedView.didMove(toParent: self)
        }

        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .white
        self.view.addSubview(segmentedControl)
        self.view.addSubview(containerView)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 31).isActive = true
        containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedValueChanged(segmentedControl)
    }

    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        viewModel.didSelectSegment(at: sender.selectedSegmentIndex)
    }
}

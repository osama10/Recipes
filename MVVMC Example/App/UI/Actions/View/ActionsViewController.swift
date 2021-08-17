//
//  ActionsViewController.swift
//  MVVMC Example
//
//  Created by Fatma Dagdevir on 16.08.21.
//

import UIKit

final class ActionsViewController: UIViewController, DynamicActionSheetViewController {
    var contentHeight: CGFloat = 300
    var dynamicActionSheetDelegate: DynamicActionSheetViewControllerDelegate?

    private lazy var rateButton: UIButton = {
        let rateButton = UIButton()
        rateButton.setTitle("Rate Recipe", for: .normal)
        rateButton.translatesAutoresizingMaskIntoConstraints = false
        rateButton.backgroundColor = .themeColor
        rateButton.layer.cornerRadius = 4
        rateButton.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        rateButton.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
        return rateButton
    }()

    private lazy var ingredientsButton: UIButton = {
        let ingredientsButton = UIButton()
        ingredientsButton.setTitle("Show Ingredients", for: .normal)
        ingredientsButton.translatesAutoresizingMaskIntoConstraints = false
        ingredientsButton.backgroundColor = .themeColor
        ingredientsButton.layer.cornerRadius = 4
        ingredientsButton.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        return ingredientsButton
    }()

    private lazy var cookbookButton: UIButton = {
        let cookbookButton = UIButton()
        cookbookButton.setTitle("Add to cookbook ", for: .normal)
        cookbookButton.translatesAutoresizingMaskIntoConstraints = false
        cookbookButton.backgroundColor = .themeColor
        cookbookButton.layer.cornerRadius = 4
        cookbookButton.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        return cookbookButton
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rateButton, ingredientsButton, cookbookButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let viewModel: ActionsViewModel

    init(viewModel: ActionsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.addSubview(stackView)
        view.backgroundColor = .white

        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
    }

    @objc private func rateButtonTapped() {
        viewModel.rateButtonTapped()
    }
}


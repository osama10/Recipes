//
//  RecipeDetailsViewController.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 20.07.21.
//

import UIKit

final class RecipeDetailsViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var recipeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    private lazy var recipeHeadline: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    private lazy var actionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show Actions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .themeColor
        button.layer.cornerRadius = 4
        button.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()

    private let viewModel: RecipeDetailsViewModel

    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setActions()
    }

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(recipeTitle)
        view.addSubview(recipeHeadline)
        view.addSubview(actionsButton)
        view.backgroundColor = .white

        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true

        recipeTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        recipeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        recipeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true

        recipeHeadline.topAnchor.constraint(equalTo: recipeTitle.bottomAnchor, constant: 10).isActive = true
        recipeHeadline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        recipeHeadline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true

        actionsButton.topAnchor.constraint(equalTo: recipeHeadline.bottomAnchor, constant: 30).isActive = true
        actionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }

    private func bindViewModel() {
        recipeTitle.text = viewModel.title
        recipeHeadline.text = viewModel.headline
        imageView.sd_setImage(with: viewModel.image, completed: nil)
    }

    private func setActions() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBackButton))
        self.actionsButton.addTarget(self, action: #selector(actionsButtonTapped), for: .touchUpInside)
    }

    @objc func didTapBackButton() {
        viewModel.didTapBackButton()
    }
    @objc func actionsButtonTapped() {
        viewModel.didTapActionsButton()
    }
}

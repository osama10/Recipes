//
//  RecipeDetailsViewController.swift
//  MVVMC Example
//
//  Created by Osama Bashir on 20.07.21.
//

import UIKit

final class RecipeDetailsViewController: UIViewController {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeHeadline: UILabel!
    
    var viewModel: RecipeDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setActions()
    }
    
    private func bindViewModel() {
        recipeTitle.text = viewModel.title
        recipeHeadline.text = viewModel.headline
        recipeImage.sd_setImage(with: viewModel.image, completed: nil)
    }

    private func setActions() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBackButton))
    }

    @objc func didTapBackButton() {
        viewModel.didTapBackButton()
    }
}

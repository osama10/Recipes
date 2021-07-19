//
//  RecipeTableViewCell.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
   
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var headlinesLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    /// setup cell's view
    private func setupCell() {
        backgroundColor = .clear
        cardView.cardView(backgroundColor: .white, borderColor: .white, borderWidth: 2.0, cornerRadius: 15)
        recipeImageView.round()
        titleLabel.font = UIFont(.avenirBold, size: .standard(.h2))
        headlinesLabel.font = UIFont(.avenirRegular, size: .standard(.text))
    }

    /// populate cell's view with data
    ///
    /// - Parameter viewModel: contains data for the cell
    func setupData(viewModel: RecipeCellViewModel) {
        titleLabel.text = viewModel.recipe.title
        headlinesLabel.text = viewModel.recipe.headline
        recipeImageView.sd_setImage(with: URL(string: viewModel.recipe.image), placeholderImage: #imageLiteral(resourceName: "food_placeholder"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImageView.sd_cancelCurrentImageLoad()
    }
}

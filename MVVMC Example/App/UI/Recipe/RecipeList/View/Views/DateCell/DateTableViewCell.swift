//
//  DateTableViewCell.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

class DateTableViewCell: UITableViewCell, NibLoadableView, ReusableView{

    @IBOutlet private weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        isUserInteractionEnabled = true
    }
    
    /// setup cell's view
    private func setupCell() {
        dateLabel.font = UIFont(.avenirBold, size: .standard(.h1))
    }
    
    /// populate cell's view with data
    ///
    /// - Parameter viewModel: contains data for the cell
    func setupData(viewModel: DateCellViewModel) {
        dateLabel.text = viewModel.date
    }
    
}

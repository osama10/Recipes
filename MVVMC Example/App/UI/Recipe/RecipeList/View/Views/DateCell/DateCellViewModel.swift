//
//  DateCellViewModel.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import Foundation

struct DateCellViewModel {
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: Date())
    }
}

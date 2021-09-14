//
//  DateAndTimeContainerViewModel.swift
//  MVVMC Example
//
//  Created by Marian Keriacos on 14.09.21 w37.
//

import Foundation

protocol DateAndTimeContainerViewModelInputs {
    func didSelectSegment(at index: Int)
}

protocol DateAndTimeContainerViewModelOutputs {
    typealias ChangeIndex = ((Int, Int) -> Void)
    var indexUpdate: ChangeIndex? { get set }

    var titles: [String] { get }
}

protocol DateAndTimeContainerViewModelProtocol: DateAndTimeContainerViewModelInputs, DateAndTimeContainerViewModelOutputs {}

final class DateAndTimeContainerViewModel: DateAndTimeContainerViewModelProtocol {
    // Output
    var indexUpdate: ChangeIndex?
    let titles =  ["Date", "Time"]

    // Private
    private var selectedIndex = -1

    // Input
    func didSelectSegment(at index: Int) {
        guard selectedIndex != index else {
            return
        }

        let lastIndex = selectedIndex
        selectedIndex = index

        indexUpdate?(lastIndex, selectedIndex)
    }
}

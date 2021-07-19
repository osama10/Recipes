//
//  DataFetchingError.swift
//  Task2
//
//  Created by Osama Bashir on 2/18/21.
//

import Foundation

enum DataFetchError: String, Error {
    case noInternet = "Your are not connected to internet. please connect to internet and try again"
    case dataFetchFailure
}

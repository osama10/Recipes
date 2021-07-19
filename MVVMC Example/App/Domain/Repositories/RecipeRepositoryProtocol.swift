//
//  RecipeRepositoryProtocol.swift
//  Task2
//
//  Created by Osama Bashir on 2/19/21.
//

import Foundation
import Combine

protocol RecipeRepositoryProtocol {
    func fetchRecipes() -> AnyPublisher<Array<Recipe>,DataFetchError>
}

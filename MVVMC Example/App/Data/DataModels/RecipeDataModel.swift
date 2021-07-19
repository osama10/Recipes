//
//  RecipeDataModel.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import Foundation

struct RecipeDataModel: Codable {
    let calories, carbs, welcomeDescription: String
    let difficulty: Int
    let fats, headline, id: String
    let image: String
    let name, proteins: String
    let thumbnail: String
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case calories, carbs
        case welcomeDescription = "description"
        case difficulty, fats, headline, id, image, name, proteins, thumbnail, time
    }

}

extension RecipeDataModel {
    var recipe: Recipe { Recipe(title: name, image: image, headline: headline) }
}

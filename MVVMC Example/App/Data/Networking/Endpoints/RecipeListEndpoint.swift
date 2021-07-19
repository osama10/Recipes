//
//  RecipeListEndpoint.swift
//  Task2
//
//  Created by Osama Bashir on 2/18/21.
//

import Foundation

struct  RecipeListEndpoint: EndpointProtocol {

    let absoluteURL: String
    let params: [String : String]
    let headers: [String : String]

    init(absoluteURL: String = Constants.API.recipeListEndPoint, params: [String : String] = [:], headers: [String : String] = [:]) {
        self.absoluteURL =  absoluteURL
        self.params = params
        self.headers = headers
    }

}

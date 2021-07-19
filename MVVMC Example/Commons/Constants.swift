//
//  Constants.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import Foundation

struct Constants {

    struct API {
        static let baseURL  = "https://hf-mobile-app.s3-eu-west-1.amazonaws.com"
        static let recipeListEndPoint = "/ios/recipes.json"
    }
    
    struct ErrorMessage {
        static let somethingWentWrong = "Ooops! Something went wrong. Please try later."
        static let noInternet = "You are not connected to internet"
    }
}

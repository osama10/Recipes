//
//  Networking.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import Foundation
import Combine

enum NetworkingError: Int, Error {
    
    case noIntertnet = -1009
    case resourceNotFound = 404
    case badRequest = 400
    case tooManyRequests = 429
    case serverError = 500
    case unableToDecode
    case unknown
    
    var errorMesage: String {
        switch self {
        case .noIntertnet:
            return "You are not connected to internet"
        case .resourceNotFound, .badRequest, .unknown, .serverError, .unableToDecode, .tooManyRequests:
            return "Ooops! Something went wrong. Please try later."
        }
    }

}

protocol EndpointProtocol {
    var baseURL: String { get }
    var absoluteURL: String { get }
    var params: [String: String] { get }
    var headers: [String: String] { get }
}

extension EndpointProtocol {
    var baseURL: String { Constants.API.baseURL }
}

protocol Networking {
    func get<T:Decodable>(from endpoint: EndpointProtocol) -> AnyPublisher<T, NetworkingError>
}


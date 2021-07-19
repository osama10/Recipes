//
//  NetworkManager.swift
//  Task2
//
//  Created by Osama Bashir on 10/25/20.
//

import Combine
import Foundation

final class NetworkManager: Networking {

    func get<T>(from endpoint: EndpointProtocol) -> AnyPublisher<T, NetworkingError> where T : Decodable {
        guard let urlRequest = performRequest(for: endpoint) else {
            return Fail(error: NetworkingError.unknown)
                .eraseToAnyPublisher()
        }
        return loadData(from: urlRequest)
    }

    // MARK: - Request building
    private func performRequest(for endpoint: EndpointProtocol) -> URLRequest? {
        let requestURL = endpoint.baseURL + endpoint.absoluteURL
        guard var urlComponents = URLComponents(string: requestURL) else {
            return nil
        }

        urlComponents.queryItems = endpoint.params.compactMap({ param -> URLQueryItem in
            return URLQueryItem(name: param.key, value: param.value)
        })

        guard let url = urlComponents.url else { return nil }

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadRevalidatingCacheData,
                                    timeoutInterval: 30)

        endpoint.headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

        return urlRequest
    }

    private func loadData<T>(from urlRequest: URLRequest) -> AnyPublisher<T, NetworkingError> where T : Decodable {
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError{ NetworkingError(rawValue: $0.code.rawValue) ?? NetworkingError.unknown }
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{ $0 as? NetworkingError ?? NetworkingError.unableToDecode }
            .eraseToAnyPublisher()
    }

}


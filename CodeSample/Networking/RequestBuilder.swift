//
//  RequestBuilder.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

protocol RequestBuilding {
    func buildUrlRequest<R: Resource>(
        for resource: R,
        using authorizationProvider: AuthorizationProviding
    ) async throws -> URLRequest
}

final class RequestBuilder: RequestBuilding {
    private let host: String
    
    init(host: String) {
        self.host = host
    }
    
    func buildUrlRequest<R: Resource>(
        for resource: R,
        using authorizationProvider: AuthorizationProviding
    ) async throws -> URLRequest {
        guard let requestURL = buildUrl(for: resource) else {
            throw NetworkError.failedToBuildRequest
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = resource.httpRequestMethod.rawValue
        request.httpBody = resource.body
        switch resource.authorizationNeeds {
        case .none:
            break
        case .standard:
            await request.authorize(
                with: try authorizationProvider.getAuthorizationToken()
            )
        }
        return request
    }
    
    private func buildUrl<R: Resource>(for resource: R) -> URL? {
        guard var urlComponents = URLComponents(string: host) else { return nil }
        urlComponents.path.append("/\(resource.path)")
        urlComponents.percentEncodedQueryItems = queryItems(for: resource)
        let url = urlComponents.url
        return url
    }
    
    //TODO: Make sure it's all good here
    private func queryItems<R: Resource>(for resource: R) -> [URLQueryItem]? {
        var items = [URLQueryItem]()
        if let query = resource.query {
            let resourceItems = query.compactMap { key, value -> URLQueryItem? in
                guard let value = value else { return nil }
                return URLQueryItem(
                    name: key,
                    value: value
                )
            }
            items.append(contentsOf: resourceItems)
        }
        return items.isEmpty ? nil : items
    }
}

private extension URLRequest {
    mutating func authorize(with accessToken: String) {
        setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
}

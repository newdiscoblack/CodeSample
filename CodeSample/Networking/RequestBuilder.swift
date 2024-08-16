//
//  RequestBuilder.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

protocol RequestBuilding {
    func buildUrlRequest<R: Resource>(
        for resource: R
    ) async throws -> URLRequest
}

final class RequestBuilder: RequestBuilding {
    private let host: String
    private let keychain: KeychainStoring
    
    init(
        host: String,
        keychain: KeychainStoring
    ) {
        self.host = host
        self.keychain = keychain
    }
    
    func buildUrlRequest<R: Resource>(
        for resource: R
    ) async throws -> URLRequest {
        guard let requestUrl = buildUrl(for: resource) else {
            throw NetworkError.failedToBuildRequest
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = resource.httpRequestMethod.rawValue
        request.httpBody = resource.body
        switch resource.authorizationNeeds {
        case .none:
            break
        case .standard:
            guard let authorizationToken: String = try keychain.readFromKeychain(
                keychainKey: .authorization
            ) else {
                print("Couldn't authorize the request.")
                break
            }
            request.authorize(with: authorizationToken)
        }
        if resource.body != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        print(request.cURL()) //TODO: Remove?
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

extension URLRequest {
    func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(url?.absoluteString ?? "")\' \(newLine)"

        var cURL = "curl "
        var header = ""
        var data = ""

        if let httpHeaders = allHTTPHeaderFields, !httpHeaders.keys.isEmpty {
            for (key, value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }

        if let bodyData = httpBody, let bodyString = String(data: bodyData, encoding: .utf8),
           !bodyString.isEmpty
        {
            data = "--data '\(bodyString)'"
        }

        cURL += method + url + header + data

        return cURL
    }
}

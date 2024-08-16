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
    private let authorizationProvider: AuthorizationProviding
    
    init(
        host: String,
        authorizationProvider: AuthorizationProviding
    ) {
        self.host = host
        self.authorizationProvider = authorizationProvider
    }
    
    func buildUrlRequest<R: Resource>(
        for resource: R
    ) async throws -> URLRequest {
        guard let requestUrl = buildUrl(for: resource) else {
            throw RequestBuilderError.failedToBuildTheRequest
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = resource.httpRequestMethod.rawValue
        request.httpBody = resource.body
        switch resource.authorizationNeeds {
        case .none:
            break
        case .standard:
            guard let authorizationToken = authorizationProvider
                .getStandardAuthorizationToken() else {
                throw RequestBuilderError.failedToAuthorizeTheRequest
            }
            request.authorize(with: authorizationToken)
        }
        if resource.body != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        print(request.cURL())
        return request
    }
    
    private func buildUrl<R: Resource>(for resource: R) -> URL? {
        guard var urlComponents = URLComponents(string: host) else { return nil }
        urlComponents.path.append("/\(resource.path)")
        let url = urlComponents.url
        return url
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

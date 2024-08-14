//
//  NetworkClient.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

protocol NetworkHandling {
    func request<R: Resource, APIModel: Decodable>(
        resource: R
    ) async throws -> APIModel
}

final class NetworkClient: NetworkHandling {
    private let authorizationProvider: AuthorizationProviding
    private let networkSession: NetworkSession
    private let requestBuilder: RequestBuilding
    private let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init(
        authorizationProvider: AuthorizationProviding,
        networkSession: NetworkSession = URLSession.shared,
        requestBuilder: RequestBuilding
    ) {
        self.authorizationProvider = authorizationProvider
        self.networkSession = networkSession
        self.requestBuilder = requestBuilder
    }
    
    func request<R: Resource, APIModel: Decodable>(
        resource: R
    ) async throws -> APIModel {
        let data = try await requestData(resource: resource)
        return try decoder.decode(APIModel.self, from: data)
    }
    
    @discardableResult
    private func requestData<R: Resource>(resource: R) async throws -> Data {
        let urlRequest = try await requestBuilder.buildUrlRequest(
            for: resource,
            using: authorizationProvider
        )
        let (data, urlResponse) = try await networkSession.data(
            for: urlRequest
        )
        guard let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        switch statusCode {
        case 200 ..< 300:
            return data
        default:
            throw NetworkError.defaultError
        }
    }
}

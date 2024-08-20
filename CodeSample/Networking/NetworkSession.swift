//
//  NetworkSession.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

protocol NetworkSession {
    func data(
        for request: URLRequest
    ) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {
    public func data(
        for request: URLRequest
    ) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}

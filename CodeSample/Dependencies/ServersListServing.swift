//
//  ServersListServing.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

protocol ServersListServing {
    func fetchServersList() async throws -> [Server]
}

extension NetworkClient: ServersListServing {
    func fetchServersList() async throws -> [Server] {
        return try await request(resource: FetchServersList())
    }
}

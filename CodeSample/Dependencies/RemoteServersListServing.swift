//
//  RemoteServersListServing.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

protocol RemoteServersListServing {
    func fetchServersList() async throws -> [ApiServer]
}

extension NetworkClient: RemoteServersListServing {
    func fetchServersList() async throws -> [ApiServer] {
        return try await request(resource: FetchServersList())
    }
}

//
//  ServersInteractor.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import Foundation

protocol ServersInteracting {
    func logOut()
}

final class ServersInteractor: ServersInteracting {
    private let authorizer: Authorizing
    private let coordinator: ServersCoordinating
    private let serversListService: ServersListServing
    
    init(
        authorizer: Authorizing,
        coordinator: ServersCoordinating,
        serversListService: ServersListServing
    ) {
        self.authorizer = authorizer
        self.coordinator = coordinator
        self.serversListService = serversListService
        Task {
            let servers: [Server]? = try? await serversListService.fetchServersList()
            print("servers: ", servers)
        }
    }
    
    func logOut() {
        authorizer.logOut()
    }
}

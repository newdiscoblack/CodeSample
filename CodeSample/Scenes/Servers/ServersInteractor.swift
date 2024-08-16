//
//  ServersInteractor.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import Foundation

enum Sort {
    case byDistance
    case alphabetically
}

protocol ServersInteracting {
    func populateServersList()
    func showFilters()
    func sort(_ type: Sort)
    func logOut()
}

final class ServersInteractor: ServersInteracting {
    private let authorizer: Authorizing
    private let serversListService: ServersListServing
    private let viewModel: ServersViewModel
    
    init(
        authorizer: Authorizing,
        serversListService: ServersListServing,
        viewModel: ServersViewModel
    ) {
        self.authorizer = authorizer
        self.serversListService = serversListService
        self.viewModel = viewModel
    }
    
    @MainActor
    func populateServersList() {
        Task {
            let servers = try? await serversListService.fetchServersList()
            viewModel.servers = servers ?? []
        }
    }
    
    func showFilters() {
        viewModel.shouldShowFilters.toggle()
    }
    
    func sort(_ type: Sort) {
        viewModel.servers.sort {
            switch type {
            case .byDistance:
                $0.distance < $1.distance
            case .alphabetically:
                $0.name < $1.name
            }
        }
    }
    
    func logOut() {
        authorizer.logOut()
    }
}

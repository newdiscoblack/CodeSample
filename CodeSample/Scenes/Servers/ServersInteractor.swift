//
//  ServersInteractor.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import Foundation

enum Sort: Equatable {
    case byDistance
    case alphabetically
}

protocol ServersInteracting {
    func populateServersList()
    func refreshServersList()
    func showFilters()
    func sort(_ type: Sort)
    func logOut()
}

final class ServersInteractor: ServersInteracting {
    private let authorizer: Authorizing
    private let storedServersListService: StoredServersListServing
    private let remoteServersListService: RemoteServersListServing
    private let viewModel: ServersViewModel
    
    init(
        authorizer: Authorizing,
        storedServersListService: StoredServersListServing,
        remoteServersListService: RemoteServersListServing,
        viewModel: ServersViewModel
    ) {
        self.authorizer = authorizer
        self.storedServersListService = storedServersListService
        self.remoteServersListService = remoteServersListService
        self.viewModel = viewModel
    }
    
    @MainActor
    func populateServersList() {
        if let storedServersList = fetchStoredServersList() {
            viewModel.servers = storedServersList
        } else {
            refreshServersList()
        }
    }
    
    @MainActor
    func refreshServersList() {
        Task {
            if let remoteServersList = await fetchRemoteServersList() {
                viewModel.servers = remoteServersList
                if let existingSortingMethod = viewModel.selectedSortingMethod {
                    sort(existingSortingMethod)
                }
                storeNewServersList(remoteServersList)
            }
        }
    }
    
    func showFilters() {
        viewModel.shouldShowFilters.toggle()
    }
    
    func sort(_ method: Sort) {
        viewModel.selectedSortingMethod = method
        viewModel.servers.sort {
            switch method {
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
    
    private func fetchStoredServersList() -> [Server]? {
        guard let storedServersList = try? storedServersListService
            .fetchServersList(), !storedServersList.isEmpty else { return nil }
        return storedServersList
    }
    
    private func fetchRemoteServersList() async -> [Server]? {
        do {
            return try await remoteServersListService.fetchServersList()
        } catch {
            viewModel.error = error
            return nil
        }
    }
    
    private func storeNewServersList(_ serversList: [Server]) {
        storedServersListService.storeNewServersList(
            serversList.map { StorableServer(server: $0) }
        )
    }
}

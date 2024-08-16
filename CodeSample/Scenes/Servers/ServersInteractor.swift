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
    
    init(
        authorizer: Authorizing,
        coordinator: ServersCoordinating
    ) {
        self.authorizer = authorizer
        self.coordinator = coordinator
    }
    
    func logOut() {
        authorizer.logOut()
    }
}

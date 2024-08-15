//
//  RootViewInteractor.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Foundation

protocol RootViewInteracting {
    func onAppear()
}

final class RootViewInteractor: RootViewInteracting {
    private let authorizer: Authorizing
    private let coordinator: RootCoordinating
    
    init(
        authorizer: Authorizing,
        coordinator: RootCoordinating
    ) {
        self.authorizer = authorizer
        self.coordinator = coordinator
    }
    
    func onAppear() {
        authorizer.didRestoreAuthorization()
        ? coordinator.coordinate(to: .serversList)
        : coordinator.coordinate(to: .login)
    }
}

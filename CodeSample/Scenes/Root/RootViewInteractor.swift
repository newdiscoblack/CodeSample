//
//  RootViewInteractor.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import Combine
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
        authorizer.restoreAuthorizationStatus()
    }
    
    private var isAuthorizedCancellable: AnyCancellable?
    func onAppear() {
        isAuthorizedCancellable = authorizer
            .isAuthorized
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] isAuthorized in
                    isAuthorized
                    ? self?.coordinator.coordinate(to: .serversList)
                    : self?.coordinator.coordinate(to: .login)
                }
            )
    }
}

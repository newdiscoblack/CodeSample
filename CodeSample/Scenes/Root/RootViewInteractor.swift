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
    private let viewModel: RootViewModel
    
    init(
        authorizer: Authorizing,
        coordinator: RootCoordinating,
        viewModel: RootViewModel
    ) {
        self.authorizer = authorizer
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    private var isAuthorizedCancellable: AnyCancellable?
    func onAppear() {
        isAuthorizedCancellable = authorizer
            .isAuthorized
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] isAuthorized in
                    self?.viewModel.animation.toggle()
                    isAuthorized
                    ? self?.coordinator.coordinate(to: .serversList)
                    : self?.coordinator.coordinate(to: .login)
                }
            )
    }
}

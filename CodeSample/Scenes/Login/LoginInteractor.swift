//
//  LoginInteractor.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

protocol LoginInteracting {
    func logIn() async
}

final class LoginInteractor: LoginInteracting {
    private let authorizer: Authorizing
    private let coordinator: LoginCoordinating
    private let viewModel: LoginViewModel
    
    init(
        authorizer: Authorizing,
        coordinator: LoginCoordinating,
        viewModel: LoginViewModel
    ) {
        self.authorizer = authorizer
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    @MainActor
    func logIn() async {
        do {
            try await authorizer.logInWith(
                username: viewModel.username,
                password: viewModel.password
            )
            coordinator.coordinate(to: .serversList)
        } catch {
            viewModel.error = error
        }
    }
}

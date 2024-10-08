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
    private let viewModel: LoginViewModel
    
    init(
        authorizer: Authorizing,
        viewModel: LoginViewModel
    ) {
        self.authorizer = authorizer
        self.viewModel = viewModel
    }
    
    @MainActor
    func logIn() async {
        do {
            try await authorizer.logInWith(
                username: viewModel.username,
                password: viewModel.password
            )
        } catch {
            viewModel.error = error
        }
    }
}

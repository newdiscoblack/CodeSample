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
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    func logIn() async {
        try? await Task.sleep(for: .seconds(3))
    }
}

//
//  ViewFactory+buildLoginView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI

extension ViewFactory {
    @ViewBuilder func buildLoginView(
        coordinator: LoginCoordinating
    ) -> some View {
        let viewModel = LoginViewModel()
        let interactor = LoginInteractor(
            authorizer: appDependencies.authorizer,
            coordinator: coordinator,
            viewModel: viewModel
        )
        LoginView(viewModel: viewModel, interactor: interactor)
    }
}

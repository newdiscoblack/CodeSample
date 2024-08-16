//
//  ViewFactory+buildRootView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI

extension ViewFactory {
    @ViewBuilder func buildRootView(
        coordinator: RootCoordinating
    ) -> some View {
        let viewModel = RootViewModel()
        let interactor = RootViewInteractor(
            authorizer: appDependencies.authorizer,
            coordinator: coordinator,
            viewModel: viewModel
        )
        RootView(
            viewModel: viewModel,
            interactor: interactor
        )
    }
}

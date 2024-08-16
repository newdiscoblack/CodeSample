//
//  ViewFactory+buildServersView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import SwiftUI

extension ViewFactory {
    @ViewBuilder func buildServersView() -> some View {
        let viewModel = ServersViewModel()
        let interactor = ServersInteractor(
            authorizer: appDependencies.authorizer,
            serversListService: appDependencies.networkClient,
            viewModel: viewModel
        )
        ServersView(
            viewModel: viewModel,
            interactor: interactor
        )
    }
}


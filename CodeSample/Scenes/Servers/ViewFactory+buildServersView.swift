//
//  ViewFactory+buildServersView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import SwiftUI

extension ViewFactory {
    @ViewBuilder func buildServersView(
        coordinator: ServersCoordinating
    ) -> some View {
        let interactor = ServersInteractor(
            authorizer: appDependencies.authorizer,
            coordinator: coordinator,
            serversListService: appDependencies.networkClient
        )
        ServersView(interactor: interactor)
    }
}


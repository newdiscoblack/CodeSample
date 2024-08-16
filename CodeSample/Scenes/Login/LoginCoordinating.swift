//
//  LoginCoordinating.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

enum LoginDestination {
    case serversList
}

protocol LoginCoordinating {
    func coordinate(to destination: LoginDestination)
}

extension RootCoordinator: LoginCoordinating {
    func coordinate(to destination: LoginDestination) {
        switch destination {
        case .serversList:
            guard let navigationController else { return }
            ServersCoordinator(
                navigationController: navigationController,
                viewFactory: viewFactory
            ).start()
        }
    }
}


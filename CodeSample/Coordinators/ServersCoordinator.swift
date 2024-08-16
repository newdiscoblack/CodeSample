//
//  ServersCoordinator.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import UIKit

enum ServersDestination {
    
}

protocol ServersCoordinating {
    func coordinate(to destination: ServersDestination)
}

final class ServersCoordinator: Coordinator, ServersCoordinating {
    private let viewFactory: ViewFactory
    
    init(
        navigationController: UINavigationController,
        viewFactory: ViewFactory
    ) {
        self.viewFactory = viewFactory
        super.init(navigationController: navigationController)
    }
    
    func start() {
        setAsRoot(viewFactory.buildServersView(coordinator: self))
    }
    
    func coordinate(to destination: ServersDestination) {
        
    }
}

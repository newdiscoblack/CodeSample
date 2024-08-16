//
//  RootCoordinator.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI
import UIKit

enum RootDestination {
    case login
    case serversList
}

protocol RootCoordinating {
    func coordinate(to destination: RootDestination)
}

final class RootCoordinator: Coordinator, RootCoordinating {
    private let rootController: UIViewController
    
    private let alwaysStoredNavigationController = UINavigationController()
    let viewFactory: ViewFactory
    
    init(
        rootController: UIViewController,
        appDependencies: AppDependencies
    ) {
        self.viewFactory = .init(appDependencies: appDependencies)
        self.rootController = rootController
        
        super.init(navigationController: alwaysStoredNavigationController)
    }
    
    func start() {
        rootController.addChildController(
            UIHostingController(
                rootView: viewFactory.buildRootView(coordinator: self)
            )
        )
        guard let navigationController else { return }
        navigationController.navigationBar.isHidden = true
        rootController.addChildController(navigationController)
    }
    
    func coordinate(to destination: RootDestination) {
        switch destination {
        case .login:
            setAsRoot(viewFactory.buildLoginView(coordinator: self))
        case .serversList:
            setAsRoot(viewFactory.buildServersView())
        }
    }
}

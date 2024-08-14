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
            UIHostingController(rootView: viewFactory.buildRootView())
        )
        guard let navigationController else { return }
        navigationController.navigationBar.isHidden = true
    }
    
    func coordinate(to destination: RootDestination) {
        //TODO: Root coordinating
    }
}

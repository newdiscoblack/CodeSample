//
//  RootCoordinator.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI
import UIKit

final class RootCoordinator: Coordinator {
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
            UIHostingController(rootView: viewFactory.buildContentView())
        )
        guard let navigationController else { return }
        navigationController.navigationBar.isHidden = true
        rootController.addChildController(navigationController)
    }
}

extension ViewFactory {
    @ViewBuilder func buildContentView() -> some View {
        ContentView()
    }
}

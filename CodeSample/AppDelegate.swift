//
//  AppDelegate.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI

@UIApplicationMain
final class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var appDependencies = AppDependencies()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        presentRootView()
        return true
    }
    
    private func presentRootView() {
        let rootViewController = UIViewController()
        RootCoordinator(
            rootController: rootViewController,
            appDependencies: appDependencies
        ).start()
        window = UIWindow()
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
    }
}

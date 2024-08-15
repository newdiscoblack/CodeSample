//
//  Coordinator.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI
import UIKit
import Combine

class Coordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setAsRoot<T: View>(_ view: T) {
        let controller = UIHostingController(rootView: view)
        setAsRoot(controller)
    }
    
    func setAsRoot(_ controller: UIViewController) {
        navigationController?.setViewControllers([controller], animated: false)
    }
}

//
//  UIViewController+addChildController.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import UIKit

extension UIViewController {
    func addChildController(_ controller: UIViewController) {
        addChildController(controller, into: view)
    }
    
    func addChildController(
        _ controller: UIViewController,
        into container: UIView
    ) {
        addChild(controller)
        container.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),
            controller.view.topAnchor.constraint(
                equalTo: container.topAnchor
            ),
            controller.view.trailingAnchor.constraint(
                equalTo: container.trailingAnchor
            ),
            controller.view.bottomAnchor.constraint(
                equalTo: container.bottomAnchor
            )
        ])
        controller.didMove(toParent: self)
    }
}

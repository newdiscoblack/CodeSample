//
//  Server.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 19/08/2024.
//

import Foundation

protocol Server {
    var id: UUID { get }
    var name: String { get }
    var distance: Int { get }
}

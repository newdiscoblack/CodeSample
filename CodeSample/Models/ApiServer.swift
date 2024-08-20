//
//  ApiServer.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import Foundation

struct ApiServer: Decodable, Identifiable, Equatable, Server {
    var id: UUID { UUID() }
    let name: String
    let distance: Int
}

//
//  Server.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import Foundation

struct Server: Decodable, Identifiable {
    var id: UUID { UUID() }
    let name: String
    let distance: Int
}

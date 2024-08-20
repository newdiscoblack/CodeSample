//
//  StorableServer.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 19/08/2024.
//

import Foundation
import SwiftData

@Model
final class StorableServer: Server {
    @Attribute(.unique) var id: UUID
    let name: String
    let distance: Int
    
    init(
        id: UUID = UUID(),
        name: String,
        distance: Int
    ) {
        self.id = id
        self.name = name
        self.distance = distance
    }
    
    convenience init(server: any Server) {
        self.init(
            id: server.id,
            name: server.name,
            distance: server.distance
        )
    }
}

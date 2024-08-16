//
//  ServersViewModel.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import Foundation

final class ServersViewModel: ObservableObject {
    @Published var servers: [Server] = []
    @Published var shouldShowFilters: Bool = false
}

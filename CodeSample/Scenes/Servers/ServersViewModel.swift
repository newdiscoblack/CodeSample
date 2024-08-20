//
//  ServersViewModel.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import Foundation

@Observable
final class ServersViewModel {
    var servers: [Server] = []
    var shouldShowFilters: Bool = false
    var selectedSortingMethod: Sort?
    var error: Error?
}

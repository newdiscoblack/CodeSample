//
//  StoredServersListServing.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 19/08/2024.
//

import SwiftData

protocol StoredServersListServing {
    func fetchServersList() throws -> [StorableServer]?
    func storeNewServersList(_ serversList: [StorableServer])
}

extension AppDatabaseService: StoredServersListServing {
    func fetchServersList() throws -> [StorableServer]? {
        let descriptor = FetchDescriptor<StorableServer>()
        return try modelContext?.fetch(descriptor)
    }
    
    func storeNewServersList(_ serversList: [StorableServer]) {
        do {
            try modelContext?.delete(model: StorableServer.self)
            serversList.forEach {
                modelContext?.insert($0)
            }
        } catch {
            print("storeNewServersList error: ", error)
        }
    }
}

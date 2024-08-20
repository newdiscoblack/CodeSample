//
//  AppDatabaseService.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 19/08/2024.
//

import SwiftData

final class AppDatabaseService {
    private(set) var modelContainer: ModelContainer?
    private(set) var modelContext: ModelContext?
    
    init() {
        do {
            let schema = Schema([StorableServer.self])
            let modelConfiguration = ModelConfiguration(schema: schema)
            
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            if let modelContainer {
                modelContext = ModelContext(modelContainer)
            }
        } catch {
            print("AppDatabaseService error: ", error)
        }
    }
}

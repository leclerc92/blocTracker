//
//  blockTrackerApp.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI
import SwiftData

@main
struct blockTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [SessionModel.self,BlocModel.self], inMemory: true)
    }
}

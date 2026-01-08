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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [SessionModel.self, BlocModel.self, UnlockedBadgeModel.self])
    }
}

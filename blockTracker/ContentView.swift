//
//  ContentView.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        MainTabView()
    }

}

#Preview {
    ContentView()
}

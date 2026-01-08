//
//  MainTabView.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    enum Tab {
        case stats,sessions,badges,new
    }
    
    @State private var selectedTab: Tab = .stats
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            StatsView().tabItem {
                Image(systemName: "chart.bar")
                Text("Statistiques")
            }.tag(Tab.stats)
            
            SessionListView().tabItem {
                Image(systemName: "list.bullet")
                Text("Sessions")
            }.tag(Tab.sessions)
            
            BadgesView().tabItem {
                Image(systemName: "trophy")
                Text("Badges")
            }.tag(Tab.badges)
            
            ActiveSessionView().tabItem {
                Image(systemName: "plus.circle")
                Text("Nouvelle session")
            }.tag(Tab.new)
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(previewContainer)
}

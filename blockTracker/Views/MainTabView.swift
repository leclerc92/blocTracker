//
//  MainTabView.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI

struct MainTabView: View {
    
    enum Tab {
        case stats,sessions,badges,new
    }
    
    @State private var selectedTab: Tab = .stats
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Text("Statistiques").tabItem {
                Image(systemName: "chart.bar")
                Text("Statistiques")
            }.tag(Tab.stats)
            
            Text("Sessions").tabItem {
                Image(systemName: "list.bullet")
                Text("Sessions")
            }.tag(Tab.sessions)
            
            Text("Badges").tabItem {
                Image(systemName: "trophy")
                Text("Badges")
            }.tag(Tab.badges)
            
            Text("Session en cours").tabItem {
                Image(systemName: "plus.circle")
                Text("Nouvelle session")
            }.tag(Tab.new)
        }
    }
}

#Preview {
    MainTabView()
}

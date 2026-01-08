//
//  MainTabView.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    // Définition des onglets
    enum Tab {
        case stats, sessions, badges, new
    }
    
    @State private var appState = AppState()
    
    // Configuration du look de la TabBar (Le "Secret" pour le look Pro)
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        // 1. Fond noir translucide (Glass effect sombre)
        appearance.backgroundColor = UIColor(Color.black.opacity(0.8))
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        
        // 2. Couleur des icônes non sélectionnées (Gris discret)
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor.gray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        // 3. Couleur de l'icône sélectionnée (Gérée par le .tint en SwiftUI, mais on configure le reste ici)
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        // Application du style
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        
        // Petite astuce pour le binding avec @Environment
        @Bindable var state = appState
        
        TabView(selection: $state.selectedTab) {
            
            // Onglet 1 : Stats (A venir)
            StatsView()
                .tabItem {
                    // Astuce : utilise les variants .fill pour donner du poids
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(Tab.stats)
            
            // Onglet 2 : Historique
            SessionListView()
                .tabItem {
                    Label("Journal", systemImage: "list.bullet.clipboard.fill")
                }
                .tag(Tab.sessions)
            
            // Onglet 3 : Go Grimper ! (Mis en avant)
            ActiveSessionView()
                .tabItem {
                    Label("Grimper", systemImage: "figure.climbing")
                }
                .tag(Tab.new)
            
            // Onglet 4 : Badges
            BadgesView() // Assure-toi que cette vue existe ou crée une vue vide
                .tabItem {
                    Label("Trophées", systemImage: "trophy.fill")
                }
                .tag(Tab.badges)
        }
        // LA touche finale : Ta couleur Néon pour l'onglet actif
        .tint(Color.climbingAccent)
        .environment(appState)
    }
}

#Preview {
    // Pour la preview, on doit injecter l'environnement manuellement
    MainTabView()
        .environment(AppState())
        .modelContainer(previewContainer)
}

//
//  BadgesListView.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


import SwiftUI
import SwiftData

struct BadgesListView: View {
    
    // Récupérer UNIQUEMENT les badges débloqués depuis la DB
    @Query private var unlockedBadges: [UnlockedBadgeModel]
    
    @State private var selectedBadge: Badge?
    
    // Layout de la grille
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Header Stats
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Ma collection")
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)
                                Text("\(unlockedBadges.count) / \(BadgeRegistry.allBadges.count) débloqués")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Itération sur les catégories pour structurer l'affichage
                        ForEach(BadgeCategory.allCases, id: \.self) { category in
                            let badgesInCategory = BadgeRegistry.badges(for: category)
                            
                            if !badgesInCategory.isEmpty {
                                Section {
                                    LazyVGrid(columns: columns, spacing: 24) {
                                        ForEach(badgesInCategory) { badge in
                                            // Vérifier si ce badge spécifique est dans la liste des unlocked
                                            let unlockedModel = unlockedBadges.first { $0.badgeId == badge.id }
                                            let isUnlocked = unlockedModel != nil
                                            
                                            Button {
                                                selectedBadge = badge
                                            } label: {
                                                BadgeItemView(badge: badge, isUnlocked: isUnlocked)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.horizontal)
                                } header: {
                                    HStack {
                                        Text(category.rawValue)
                                            .font(.headline)
                                            .foregroundStyle(category.color)
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                                    .padding(.bottom, 8)
                                }
                            }
                        }
                        
                        // Espace en bas pour le scroll
                        Color.clear.frame(height: 50)
                    }
                }
            }
            .navigationTitle("Trophées")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            
            // Affichage de la modal au clic
            .sheet(item: $selectedBadge) { badge in
                // On retrouve la date si débloqué
                let unlockedDate = unlockedBadges.first { $0.badgeId == badge.id }?.unlockedAt
                BadgeDetailSheet(badge: badge, unlockedDate: unlockedDate)
            }
        }
    }
}

#Preview {
    BadgesListView()
        
}

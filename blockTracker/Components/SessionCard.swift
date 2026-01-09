//
//  SessionCard.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import SwiftUI

struct SessionCard: View {
    var session: SessionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // 1. En-tête : Date et Score principal
            HeaderView(date: session.date, score: session.sessionScore)
            
            // 2. Ligne de stats (Grille horizontale)
            HStack(spacing: 0) {
                StatItem(label: "NIV. MOYEN", value: String(format: "%.1f", session.averageBlocLevel))
                Divider().frame(height: 30).background(Color.white.opacity(0.1)) // Séparateur subtil
                StatItem(label: "MIN - MAX", value: "\(session.minBlocLevel) - \(session.maxBlocLevel)")
                Divider().frame(height: 30).background(Color.white.opacity(0.1))
                StatItem(label: "RÉUSSIS", value: "\(session.completedBlocCount)/\(session.blocs.count)")
            }
        }
        .padding(20)
        .background(Color.cardBackground) // Le fameux gris foncé
        .cornerRadius(20) // Arrondi plus prononcé style iOS moderne
    }
}

// --- SOUS-COMPOSANTS (Pour garder le code propre) ---

// Le Header avec le Score mis en avant
private struct HeaderView: View {
    var date: Date
    var score: Double
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(date.formatted(Date.French.weekday).uppercased())
                    .font(.fitness(.caption, weight: .bold))
                    .foregroundStyle(Color.climbingAccent) // Touche de couleur

                Text(date.formatted(Date.French.longDate))
                    .font(.fitness(.title3, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            // Score style "Ring" ou "Badge"
            HStack(spacing: 4) {
                Text(String(format: "%.1f", score))
                    // CORRECTION ICI : On appelle directement size: 32
                    .font(.fitness(size: 32, weight: .black))
                    .foregroundStyle(Color.climbingAccent)
                
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(Color.climbingAccent)
            }
        }
    }
}

// Un item de statistique unique
private struct StatItem: View {
    var label: String
    var value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.fitness(.title3, weight: .semibold)) // Valeur bien visible
                .foregroundStyle(.white)
            
            Text(label)
                .font(.fitness(.caption2, weight: .medium)) // Label discret
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity) // Pour distribuer l'espace équitablement
    }
}

#Preview {
    
    let session:SessionModel = SessionModel(date:Date())
    SessionCard(session:session)
}

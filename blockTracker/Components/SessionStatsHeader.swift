//
//  SessionStatsHeader.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


import SwiftUI

import SwiftUI

struct SessionStatsHeader: View {
    let session: SessionModel
    
    // Calcul du taux de réussite
    private var completionRate: Double {
        guard !session.blocs.isEmpty else { return 0 }
        return Double(session.completedBlocCount) / Double(session.blocs.count)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            // 1. SECTION PRINCIPALE : ANNEAU + SCORE
            HStack(spacing: 20) {
                // L'anneau façon "Apple Watch"
                ZStack {
                    Circle()
                        .stroke(Color.climbingAccent.opacity(0.15), lineWidth: 15)
                    
                    Circle()
                        .trim(from: 0, to: completionRate)
                        .stroke(
                            Color.climbingAccent,
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        // Petit effet "Glow" néon sur l'anneau
                        .shadow(color: .climbingAccent.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    VStack(spacing: 0) {
                        Text("\(Int(completionRate * 100))%")
                            .font(.fitness(.title3, weight: .bold))
                            .foregroundStyle(.white)
                        Text("RÉUSSI")
                            .font(.fitness(size: 10, weight: .bold))
                            .foregroundStyle(Color.climbingAccent)
                    }
                }
                .frame(width: 110, height: 110)
                
                // Le Score et résumé textuel
                VStack(alignment: .leading, spacing: 6) {
                    Text("SCORE TOTAL")
                        .font(.fitness(.caption, weight: .bold))
                        .foregroundStyle(.gray)
                    
                    Text(String(format: "%.1f", session.sessionScore))
                        .font(.fitness(size: 48, weight: .black)) // Très gros impact
                        .foregroundStyle(.white)
                    
                    Text("\(session.completedBlocCount) blocs sur \(session.blocs.count)")
                        .font(.fitness(.subheadline))
                        .foregroundStyle(Color.climbingAccent)
                }
                Spacer()
            }
            
            // 2. GRID DE STATS SECONDAIRES
            // On utilise une grille simple 3 colonnes
            HStack(spacing: 12) {
                StatBox(
                    label: "NIVEAU MOY.",
                    value: String(format: "%.1f", session.averageBlocLevel),
                    icon: "chart.bar.fill",
                    color: .cyan // Bleu Néon
                )
                
                StatBox(
                    label: "MIN - MAX",
                    value: "\(session.minBlocLevel) - \(session.maxBlocLevel)",
                    icon: "arrow.up.arrow.down",
                    color: .purple // Violet Néon
                )
                
                StatBox(
                    label: "DÉVERS",
                    value: "\(session.totalOverhangBlocCount)",
                    icon: "angle", // Ou une icône plus parlante
                    color: .orange // Orange Néon
                )
            }
        }
        .padding(24)
        .background(Color.cardBackground) // Gris foncé
        .cornerRadius(24) // Arrondi moderne
    }
}

// Sous-vue pour les petites cases carrées
struct StatBox: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
                .frame(height: 24)
            
            Text(value)
                .font(.fitness(.title3, weight: .bold)) // Gros chiffres
                .foregroundStyle(.white)
            
            Text(label)
                .font(.fitness(size: 10, weight: .bold))
                .foregroundStyle(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.black.opacity(0.3)) // Fond plus sombre que la carte
        .cornerRadius(12)
    }
}

#Preview {
    let session = SessionModel(date: Date())
    let bloc1 = BlocModel(level: 5, completed: true, session: session)
    let bloc2 = BlocModel(level: 8, completed: true, overhang: true, session: session)
    let bloc3 = BlocModel(level: 6, completed: false, session: session)
    let bloc4 = BlocModel(level: 7, completed: true, overhang: true, session: session)
    session.blocs.append(contentsOf: [bloc1, bloc2, bloc3, bloc4])
    
    return SessionStatsHeader(session: session)
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
}

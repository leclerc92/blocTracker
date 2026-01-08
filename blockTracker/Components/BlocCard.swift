//
//  BlocCad.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import SwiftUI

struct BlocCard: View {
    
    let bloc: BlocModel
    var editButton: (() -> Void)?
    
    // Couleur dynamique selon l'état
    private var statusColor: Color {
        bloc.completed ? .climbingAccent : .gray
    }
    
    var body: some View {
        HStack(spacing: 16) {
            
            // 1. Badge Niveau (Visuel fort)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(statusColor.opacity(0.2)) // Fond translucide
                    .stroke(statusColor, lineWidth: 2) // Bordure colorée
                    .frame(width: 56, height: 56)
                
                Text("\(bloc.level)")
                    .font(.fitness(size: 24, weight: .black))
                    .foregroundStyle(statusColor)
            }
            
            // 2. Informations centrales
            VStack(alignment: .leading, spacing: 6) {
                // Badges
                HStack(spacing: 6) {
                    if bloc.overhang {
                        Text("DÉVERS")
                            .font(.fitness(size: 10, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.orange.opacity(0.2))
                            .foregroundStyle(.orange)
                            .cornerRadius(4)
                    }
                    
                    // Indicateur d'essais
                    HStack(spacing: 2) {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption2)
                        Text("\(bloc.attempts) essai\(bloc.attempts > 1 ? "s" : "")")
                            .font(.fitness(.caption2, weight: .medium))
                    }
                    .foregroundStyle(.gray)
                }
                
                // Petit texte d'état
                Text(bloc.completed ? "Validé" : "Non validé")
                    .font(.fitness(.caption, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            // 3. Score et Action
            VStack(alignment: .trailing, spacing: 4) {
                // Bouton Edit discret
                if let editButton = editButton {
                    Button(action: editButton) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.gray.opacity(0.5))
                    }
                }
                
                // Score
                Text(String(format: "%.1f pts", bloc.score))
                    .font(.fitness(.headline, weight: .bold))
                    .foregroundStyle(Color.climbingAccent)
            }
        }
        .padding(16)
        .background(Color.cardBackground) // Gris foncé
        .cornerRadius(16)
        // Pas d'ombre portée en mode "Liste sombre", le contraste suffit
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            let session = SessionModel(date: Date())
            let b1 = BlocModel(level: 6, completed: true, overhang: true, session: session)
            let b2 = BlocModel(level: 7, completed: false, session: session)
            
            BlocCard(bloc: b1, editButton: {})
            BlocCard(bloc: b2, editButton: {})
        }
        .padding()
    }
}

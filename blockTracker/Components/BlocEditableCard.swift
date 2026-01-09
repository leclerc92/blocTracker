//
//  BlocEditableCard.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI

struct BlocEditableCard: View {
    
    @Bindable var bloc: BlocModel
    var onDelete: (() -> Void)?
    var onValidate: (() -> Void)?
    
    // Binding pour le slider (Int <-> Double)
    private var levelBinding: Binding<Double> {
        Binding(
            get: { Double(bloc.level) },
            set: { bloc.level = Int($0) }
        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 1. En-tête : Titre et bouton Supprimer
            HStack {
                Text("MODIFICATION")
                    .font(.fitness(.caption, weight: .bold))
                    .foregroundStyle(.gray)
                Spacer()
                if let onDelete {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.red)
                            .padding(8)
                            .background(Color.red.opacity(0.15))
                            .clipShape(Circle())
                    }
                }
            }
            
            // 2. Le Slider de Niveau (Gros focus)
            VStack(spacing: 10) {
                HStack {
                    Text("NIVEAU")
                        .font(.fitness(.subheadline, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\(bloc.level)")
                        .font(.fitness(size: 32, weight: .black))
                        .foregroundStyle(Color.climbingAccent)
                }
                
                Slider(value: levelBinding, in: BLOC_CONSTANTS.LEVEL_RANGE, step: 1)
                    .tint(Color.climbingAccent)
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            // 3. Stepper Essais (Custom Design)
            HStack {
                Label("Essais", systemImage: "arrow.clockwise")
                    .font(.fitness(.body))
                    .foregroundStyle(.white)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Button("-") { if bloc.attempts > 1 { bloc.attempts -= 1 } }
                        .frame(width: 40, height: 32)
                        .background(Color.white.opacity(0.1))
                    
                    Text("\(bloc.attempts)")
                        .font(.fitness(.body, weight: .bold))
                        .frame(width: 40, height: 32)
                        .background(Color.white.opacity(0.1))
                        .border(Color.black.opacity(0.5), width: 1) // Séparateur visuel
                    
                    Button("+") { if bloc.attempts < BLOC_CONSTANTS.ATTEMPT_MAX { bloc.attempts += 1 } }
                        .frame(width: 40, height: 32)
                        .background(Color.white.opacity(0.1))
                }
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // 4. Les Toggles style "Boutons" (Plus rapide à cliquer)
            HStack(spacing: 12) {
                ToggleButton(
                    title: "DÉVERS",
                    icon: "arrow.up.right",
                    isOn: $bloc.overhang,
                    activeColor: .orange
                )
                
                ToggleButton(
                    title: "RÉUSSI",
                    icon: "checkmark",
                    isOn: $bloc.completed,
                    activeColor: .climbingAccent
                )
            }
            
            // 5. Bouton Valider (Large)
            if let onValidate {
                Button(action: onValidate) {
                    Text("Enregistrer")
                        .font(.fitness(.headline, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
            }
        }
        .padding(20)
        .background(Color(red: 0.16, green: 0.16, blue: 0.18)) // Fond légèrement plus clair pour le mode edit
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10) // Grosse ombre pour donner l'impression que ça "pop"
    }
}

// Petit helper pour les boutons toggle jolis
struct ToggleButton: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    let activeColor: Color
    
    var body: some View {
        Button(action: { withAnimation(.spring()) { isOn.toggle() } }) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.fitness(.caption, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isOn ? activeColor : Color.white.opacity(0.1))
            .foregroundStyle(isOn ? .black : .white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        BlocEditableCard(bloc: BlocModel(session: SessionModel(date: Date())), onDelete: {}, onValidate: {})
            .padding()
    }
}

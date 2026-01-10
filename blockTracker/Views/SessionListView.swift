//
//  SessionListView.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI
import SwiftData

struct SessionListView: View {
    
    @Environment(AppState.self) private var appState
    @Query(sort: \SessionModel.startDate, order: .reverse) private var sessions: [SessionModel]
    
    var body: some View {
        @Bindable var appState = appState
        
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if sessions.isEmpty {
                    EmptyStateView(message: "Ajoute ta première session dans l'onglet Grimper !")
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            
                            // Titre manuel pour plus de contrôle (optionnel, sinon use navigationTitle)
                            HStack {
                                Text("Mes Sessions")
                                    .font(.fitness(.largeTitle, weight: .bold))
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding(.top)
                            .padding(.horizontal)

                            ForEach(sessions) { session in
                                NavigationLink(value: session) {
                                    SessionCard(session: session)
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: SessionModel.self) { session in
                SessionDetailView(session: session)
            }
        }
    }
}

// Petit bonus : Animation au clic comme sur l'App Store ou Fitness
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}


#Preview {
    SessionListView()
        .modelContainer(previewContainer)
}

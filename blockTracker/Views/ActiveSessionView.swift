//
//  ActiveSessionView.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI
import SwiftData

struct ActiveSessionView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    @Query(sort: \SessionModel.startDate) private var allSessions: [SessionModel]

    @State private var activeSession: SessionModel?

    @State private var newlyEarnedBadges: [Badge] = []
    @State private var showBadgeAlert = false
    
    @State private var averageSessionsScore:Double = 0.0
 
    
    
    var body: some View {
        ZStack {
            // 1. Fond Noir immersif
            Color.black.ignoresSafeArea()
            
            if activeSession == nil {
                // État vide (Nouvelle session)
                EmptyStateView(
                    message: "Prêt à grimper ?\nLance une nouvelle session !",
                    onButtonTap: { startNewSession() }
                )
            } else {
                // Session En Cours
                VStack(spacing: 0) {
                    
                    // 2. Header "Live"
                    LiveSessionHeader(
                        date: activeSession?.startDate ?? Date(),
                        onFinish: saveSession,
                        activeSessionScore: activeSession?.sessionScore ?? 0,
                        averageSessionsScore: averageSessionsScore
                    )
                    
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            if let session = activeSession {
                                ForEach(session.blocs.sorted(by: { $0.date > $1.date }), id: \.id) { bloc in
                                    if bloc.validated {
                                        // Mode Lecture
                                        BlocCard(
                                            bloc: bloc,
                                            editButton: { setEditableBlock(bloc: bloc) }
                                        )
                                        .transition(.opacity.combined(with: .scale))
                                    } else {
                                        // Mode Édition
                                        BlocEditableCard(
                                            bloc: bloc,
                                            onDelete: { deleteBloc(bloc: bloc) },
                                            onValidate: { validateBloc(bloc: bloc) }
                                        )
                                        .transition(.move(edge: .top).combined(with: .opacity))
                                    }
                                }
                            }
                            
                        }
                        .padding(.bottom, 100) // Marge pour le scroll
                        
                        
                        
                }
                    Spacer()
                    // 3. Gros bouton d'action "Ajouter"
                    Button(action: addBloc) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                            Text("AJOUTER UN BLOC")
                                .font(.fitness(.headline, weight: .heavy))
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.climbingAccent)
                        .cornerRadius(16)
                        .shadow(color: .climbingAccent.opacity(0.3), radius: 10, y: 0)
                    }
                    .padding(.horizontal)
                    .padding(20)
                }
            }

            // Popup de badges en overlay complet (en dehors du ScrollView)
            if showBadgeAlert {
                NewBadgePopup(badges: newlyEarnedBadges, onDismiss: {
                    // Quand l'utilisateur ferme le popup, on navigue enfin
                    if let session = activeSession {
                        closeAndNavigate(session: session)
                    }
                })
                .zIndex(100)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: activeSession?.blocs.count)
        .animation(.easeInOut, value: activeSession?.blocs)
        .onAppear {
            checkActiveSession()
            getSessionsStats()
        }

    }
    
    // MARK: - Actions
    func startNewSession() {
        withAnimation {
            activeSession = SessionModel(date: Date())
            addBloc()
            guard let session =  activeSession else {
                print("StartNewSession - error activeSessionCreation")
                return
            }
            modelContext.insert(session)
        }
    }
    
    func addBloc() {
        guard let session = activeSession else { return }
        
        withAnimation(.snappy) {
            let newBloc = BlocModel(session: session)
            session.blocs.insert(newBloc, at: 0)
        }
        try? modelContext.save()
    }
    
    func saveSession() {
        guard let session = activeSession else { return }
        
        session.endDate = Date()
        
        
        do {
            try modelContext.save()
        } catch {
            print("Erreur de sauvegarde: \(error)")
        }
        
        // 2. Calcul des Stats et Badges (allSessions fourni par @Query)
        let stats = StatsService.computeStats(from: allSessions)
        let newBadges = BadgeService(modelContext: modelContext).checkAndUnlockBadges(stats: stats)
        
        if !newBadges.isEmpty {
            // CAS A : On a gagné un truc -> On montre l'alerte
            self.newlyEarnedBadges = newBadges
            withAnimation(.spring()) {
                self.showBadgeAlert = true
            }
        } else {
            closeAndNavigate(session: session)
        }
    }


    func closeAndNavigate(session: SessionModel) {
        withAnimation {
            appState.sessionToShow = session
            appState.selectedTab = .sessions
            
            activeSession = nil
            
            // Reset des états d'alerte
            showBadgeAlert = false
            newlyEarnedBadges = []
        }
    }
    
    func setEditableBlock(bloc: BlocModel) {
        bloc.validated = false
    }
    
    func validateBloc(bloc: BlocModel) {
        bloc.validated = true
    }
    
    func deleteBloc(bloc: BlocModel) {
        guard let session = activeSession else { return }
        withAnimation {
            session.blocs.removeAll { $0.id == bloc.id }
        }
    }
    
    func checkActiveSession() {
        activeSession = allSessions.first { $0.endDate == nil }
    }
    
    func getSessionsStats() {
        if !allSessions.isEmpty {
            averageSessionsScore = StatsService.computeStats(from: allSessions).globalAverageScore
        }
    }

}

// MARK: - Sous-Composant Header "Live"
struct LiveSessionHeader: View {
    var date: Date
    var onFinish: () -> Void
    var activeSessionScore:Double
    var averageSessionsScore:Double
        
    @State private var isPulsing = false
    
    var body: some View {
        
        HStack {
            // Indicateur "En cours"
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .opacity(isPulsing ? 1 : 0.3)
                    .scaleEffect(isPulsing ? 1.2 : 1.0)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("SESSION EN COURS")
                        .font(.fitness(size: 10, weight: .bold))
                        .foregroundStyle(.red)
                    
                    Text(date.formatted(Date.French.timeOnly))
                        .font(.fitness(.title3, weight: .bold))
                        .foregroundStyle(.white)
                    
                    
                    HStack{
                        Text("Score : " + String(format:"%.1f pts",activeSessionScore))
                            .foregroundStyle(.white)
                        
                        if activeSessionScore < averageSessionsScore {
                            Text("↘")
                                .foregroundStyle(.white)
                        } else {
                            Text("↗")
                                .foregroundStyle(.white)
                        }
                        
                    }
                    
                    
                }
            }
            
            Spacer()
            
            Button(action: onFinish) {
                Text("Terminer")
                    .font(.fitness(.subheadline, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.cardBackground.opacity(0.8)) // Légèrement transparent
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
        
    }
}


#Preview {
    ActiveSessionView()
        .environment(AppState())
}

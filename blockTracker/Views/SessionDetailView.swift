//
//  SessiondetailView.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct SessionDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let session: SessionModel
    
    @State var editionBloc: BlocModel?
    @State private var showDeleteAlert = false

    @State private var newlyEarnedBadges: [Badge] = []
    @State private var showBadgeAlert = false
    
    var body: some View {
        ZStack {
            // 1. FOND NOIR GLOBAL
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    SessionStatsHeader(session: session)
                    
                    VStack(spacing: 16) {
                        
                        HStack {
                            Text("Détail des blocs")
                                .font(.fitness(.headline))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.horizontal)

                        ForEach(session.blocs) { bloc in
                            if bloc.id == editionBloc?.id {
                                BlocEditableCard(
                                    bloc: bloc,
                                    onDelete: { removeEditionBloc(bloc: bloc) },
                                    onValidate: { validateEditionBloc(bloc: bloc) }
                                )
                            } else {
                                BlocCard(bloc: bloc, editButton: { setEditionBloc(bloc: bloc) })
                            }
                        }
                    }
                    .padding(.bottom, 40) // Espace pour scroller jusqu'en bas
                }
                .padding(.vertical)
            }

            // Popup de badges en overlay complet
            if showBadgeAlert {
                NewBadgePopup(badges: newlyEarnedBadges, onDismiss: {
                    showBadgeAlert = false
                    newlyEarnedBadges = []
                })
                .zIndex(100)
            }
        }
        // Configuration de la barre de navigation
        .navigationTitle(session.date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "fr_FR"))))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar) // Force le texte blanc en haut
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive, action: { showDeleteAlert = true }) {
                    Image(systemName: "trash") // Plus discret qu'un gros bouton
                        .foregroundStyle(.red)
                }
            }
        }
        .alert("Supprimer la session ?", isPresented: $showDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) { removeSession() }
        } message: {
            Text("Cette action est irréversible et supprimera tous les blocs associés.")
        }
    }
    
    // ... Tes fonctions (setEditionBloc, removeSession, etc.) restent identiques ...
    func setEditionBloc(bloc:BlocModel) {
        editionBloc = bloc
    }
    
    func validateEditionBloc(bloc:BlocModel) {
        editionBloc = nil
        try? modelContext.save()

        // Vérifier les nouveaux badges après modification
        checkForNewBadges()
    }
    
    func removeEditionBloc(bloc:BlocModel) {
        editionBloc = nil
        session.blocs.removeAll { $0.id == bloc.id }
        modelContext.delete(bloc)
        try? modelContext.save()

        // Vérifier les nouveaux badges après suppression
        checkForNewBadges()
    }

    func checkForNewBadges() {
        // Récupérer toutes les sessions pour calculer les stats globales
        let descriptor = FetchDescriptor<SessionModel>(sortBy: [SortDescriptor(\.date)])
        let allSessions = (try? modelContext.fetch(descriptor)) ?? []

        // Calculer les stats et vérifier les badges
        let stats = StatsService.computeStats(from: allSessions)
        let badgeService = BadgeService(modelContext: modelContext)

        let newBadges = badgeService.checkAndUnlockBadges(stats: stats)

        if !newBadges.isEmpty {
            self.newlyEarnedBadges = newBadges
            withAnimation(.spring()) {
                self.showBadgeAlert = true
            }
        }
    }

    func removeSession() {
        modelContext.delete(session)
        try? modelContext.save()

        // Recalculer les badges après suppression de la session
        // Note: Cela vérifie s'il y a de nouveaux badges à débloquer
        // Les badges déjà débloqués restent débloqués même si les conditions ne sont plus remplies
        let descriptor = FetchDescriptor<SessionModel>(sortBy: [SortDescriptor(\.date)])
        let allSessions = (try? modelContext.fetch(descriptor)) ?? []

        let stats = StatsService.computeStats(from: allSessions)
        let badgeService = BadgeService(modelContext: modelContext)
        _ = badgeService.checkAndUnlockBadges(stats: stats)

        dismiss()
    }
}

#Preview {
    let session = SessionModel(date: Date())
    let bloc1 = BlocModel(level: 5, completed: true, session: session)
    let bloc2 = BlocModel(level: 8, overhang: true, session: session)
    let bloc3 = BlocModel(level: 6, overhang: true, session: session)
    let bloc4 = BlocModel(level: 7, overhang: true, session: session)
    let bloc5 = BlocModel(level: 7, overhang: true, session: session)
    session.blocs.append(contentsOf: [bloc1, bloc2, bloc3, bloc4, bloc5])
    
    return NavigationStack {
        SessionDetailView(session: session)
    }
}

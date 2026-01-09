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

    @Query(sort: \SessionModel.date) private var allSessions: [SessionModel]

    let session: SessionModel
    
    @State var editionBloc: BlocModel?
    @State private var showDeleteAlert = false
    @State private var isEditingDate = false

    @State private var newlyEarnedBadges: [Badge] = []
    @State private var showBadgeAlert = false
    
    var body: some View {
        ZStack {
            // 1. FOND NOIR GLOBAL
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {

                    // Section de date éditable
                    VStack(spacing: 12) {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isEditingDate.toggle()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "calendar")
                                    .font(.fitness(.body, weight: .semibold))
                                    .foregroundStyle(Color.climbingAccent)

                                Text(session.date.formatted(Date.French.longDate))
                                    .font(.fitness(.headline))
                                    .foregroundStyle(.white)

                                Spacer()

                                Image(systemName: isEditingDate ? "chevron.up" : "chevron.down")
                                    .font(.fitness(.caption, weight: .bold))
                                    .foregroundStyle(.gray)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)

                        if isEditingDate {
                            DatePicker(
                                "Date de la session",
                                selection: Binding(
                                    get: { session.date },
                                    set: { newDate in
                                        session.date = newDate
                                        try? modelContext.save()
                                    }
                                ),
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                            .colorScheme(.dark)
                            .tint(Color.climbingAccent)
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal)

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
        .navigationTitle(session.date.formatted(Date.French.shortDate))
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
        // Calculer les stats et vérifier les badges (allSessions fourni par @Query)
        let stats = StatsService.computeStats(from: allSessions)
        let newBadges = BadgeService(modelContext: modelContext).checkAndUnlockBadges(stats: stats)

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

        // Recalculer les badges après suppression de la session (allSessions fourni par @Query)
        let stats = StatsService.computeStats(from: allSessions)
        _ = BadgeService(modelContext: modelContext).checkAndUnlockBadges(stats: stats)

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

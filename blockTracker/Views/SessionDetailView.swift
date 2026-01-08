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
        }
        // Configuration de la barre de navigation
        .navigationTitle(session.date.formatted(date: .numeric, time: .omitted))
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
    }
    
    func removeEditionBloc(bloc:BlocModel) {
        editionBloc = nil
        session.blocs.removeAll { $0.id == bloc.id }
        modelContext.delete(bloc)
        try? modelContext.save()
    }
    
    func removeSession() {
        modelContext.delete(session)
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

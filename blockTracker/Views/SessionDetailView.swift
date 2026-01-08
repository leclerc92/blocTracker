//
//  SessiondetailView.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import SwiftUI
import SwiftData

struct SessionDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let session:SessionModel
    @State var editionBloc:BlocModel?
    @State private var showDeleteAlert = false
    
    var body: some View {
        
        VStack {
            
            SessionStatsHeader(session:session)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(session.blocs) { bloc in
                        if bloc.id == editionBloc?.id {
                            BlocEditableCard(bloc: bloc,onDelete:{removeEditionBloc(bloc: bloc)},onValidate: {validateEditionBloc(bloc: bloc)})
                        } else {
                            BlocCard(bloc: bloc,editButton:{setEditionBloc(bloc: bloc)})
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Session du \(session.date.formatted(date: .numeric, time: .omitted))")
        .toolbar {
            ToolbarItem {
                Button(action: {showDeleteAlert = true}) {
                    Label("supprimer", systemImage: "trash.fill")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.2))
                        .foregroundStyle(.red)
                        .clipShape(Capsule())
                }
                .alert("Supprimer la session ?", isPresented: $showDeleteAlert) {
                    Button("Annuler", role: .cancel) { }
                    Button("Supprimer", role: .destructive) {
                        removeSession()
                    }
                } message: {
                    Text("Cette action est irréversible.")
                }
            }
        }

    }
    
    
    func setEditionBloc(bloc:BlocModel) {
        editionBloc = bloc
    }
    
    func validateEditionBloc(bloc:BlocModel) {
        editionBloc = nil
    }
    
    func removeEditionBloc(bloc:BlocModel) {
        editionBloc = nil
        session.blocs.removeAll { $0.id == bloc.id }
        modelContext.delete(bloc)
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

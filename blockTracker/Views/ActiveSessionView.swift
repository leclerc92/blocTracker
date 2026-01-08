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
    
    @State private var activeSession: SessionModel?
    @State private var editingBloc:BlocModel? = nil
    @State private var validateBlocIds:Set<PersistentIdentifier> = []
    
    var body: some View {

                if activeSession == nil {
                    EmptyStateView(message: "Ajouter une nouvelle session !", onButtonTap: {activeSession = createSession()})
                } else {
                    
                    VStack {
                        
                        HStack {
                            Button(action: saveSession) {
                                Label("Terminer", systemImage: "checkmark")
                                    .font(.headline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.green.opacity(0.2))
                                    .foregroundStyle(.green)
                                    .clipShape(Capsule())
                            }
                            
                            Spacer()
                            
                            Button(action: addBloc) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .padding()
                        
                        if let activeSession = activeSession {
                            Text("Session du \(activeSession.date.formatted(date: .numeric, time: .omitted))")
                        }
                        
                        ScrollView {
                            if let blocs = activeSession?.blocs {
                                ForEach(blocs) { bloc in
                                    
                                    if validateBlocIds.contains(bloc.id) {
                                        BlocCard(bloc: bloc, editButton: {setEditableBlock(blocId: bloc.id)})
                                    } else {
                                        BlocEditableCard(bloc: bloc,onDelete: {deleteBloc(bloc:bloc)}, onValidate: {validateBloc(bloc:bloc)})
                                    }
                                }
                            }
                        }
                        
            }

        }
        
    }
    
    
    func createSession() -> SessionModel {
        
        let session:SessionModel = SessionModel(date: Date())
        session.blocs.append(BlocModel(session: session))
    
        return session
    }
    
    func addBloc(){
        guard let session = activeSession else {
            print("activeSession is nil")
            return
        }
        session.blocs.insert(BlocModel(session:session),at:0)
    }
    
    func saveSession() {
        
        guard let session = activeSession else {
            print("activeSession is nil")
            return
        }
        
        modelContext.insert(session)
        
        appState.sessionToShow = session
        appState.selectedTab = .sessions
   
        activeSession = nil
        validateBlocIds.removeAll()
    }
    
    func setEditableBlock(blocId:PersistentIdentifier) {
        validateBlocIds.remove(blocId)
    }
    
    func validateBloc(bloc:BlocModel) {
        validateBlocIds.insert(bloc.id)
    }
    
    func deleteBloc(bloc:BlocModel) {
        guard let activeSession else {
            print("activeSession is nil")
            return
        }
        activeSession.blocs.removeAll { $0.id == bloc.id }
    }
}



#Preview {
    ActiveSessionView()
}

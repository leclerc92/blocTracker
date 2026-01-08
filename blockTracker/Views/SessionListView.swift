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
    @Query private var sessions: [SessionModel]
    
    var body: some View {
        
        @Bindable var appState = appState
        
        NavigationStack {
            if sessions.isEmpty {
                EmptyStateView(message: "Aucune session enregistrée..", onButtonTap: {})
            } else {
                
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(sessions) { session in
                            NavigationLink(value: session) {
                                SessionCard(session: session)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
                .navigationDestination(for: SessionModel.self) { session in
                    SessionDetailView(session: session)
                }
                .navigationDestination(item: $appState.sessionToShow) { session in
                    SessionDetailView(session: session)
                }
            }
            
        }
    }
}


#Preview {
    SessionListView()
        .modelContainer(previewContainer)
}

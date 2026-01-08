//
//  EmptyStateView.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI

struct EmptyStateView: View {
    
    var message:String
    var onButtonTap: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .font(.largeTitle)
                .foregroundColor(.secondary)
                .padding()
            
            Button(action: onButtonTap ) {
                   Label("Ajouter une session", systemImage: "plus.circle")
                    .padding(20)
            }
            .buttonStyle(.glass)
            
            
        }
    }
}


#Preview {
    EmptyStateView(message: "Ajouter une nouvelle session ! ", onButtonTap: {print("bouton cliqué")})
}

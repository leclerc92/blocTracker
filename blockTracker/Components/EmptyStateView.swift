//
//  EmptyStateView.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI

struct EmptyStateView: View {
    
    var message: String
    var onButtonTap: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            // 1. L'illustration centrale (Icone avec effet de halo)
            ZStack {
                // Le halo lumineux
                Circle()
                    .fill(Color.climbingAccent.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .blur(radius: 20)
                
                // Cercles concentriques décoratifs
                Circle()
                    .stroke(Color.climbingAccent.opacity(0.3), lineWidth: 1)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "figure.climbing")
                    .font(.system(size: 50))
                    .foregroundStyle(Color.climbingAccent)
            }
            .padding(.bottom, 10)
            
            // 2. Les textes
            VStack(spacing: 8) {
                Text("C'est calme ici...")
                    .font(.fitness(.title2, weight: .bold))
                    .foregroundStyle(.white)
                
                Text(message)
                    .font(.fitness(.body))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            if let onButtonTap {
                Button(action: onButtonTap) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                        Text("Nouvelle Session")
                            .font(.fitness(.headline, weight: .bold))
                    }
                    .foregroundStyle(.black) 
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.climbingAccent)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea()) // S'assure que le fond est bien noir
    }
}

#Preview {
    EmptyStateView(
        message: "Enregistre ta première session de grimpe pour suivre ta progression.",
        onButtonTap: { print("Action") }
    )
}

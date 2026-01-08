//
//  SessionCard.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import SwiftUI

struct SessionCard: View {
    
    var session: SessionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            
            
            HStack {
                
                Text("Session du \(session.date.formatted(date: .numeric, time: .omitted))")
                        
                Spacer()
                
                Image(systemName: "star.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.primary)
                Text(String(format: "%.2f", session.blocsScore))
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            Divider()
            
            VStack(alignment: .center, spacing: 10) {
                
                HStack {
                    Text("Niveau moyen : ")
                    Spacer()
                    Text(String(format: "%.1f", session.averageBlocLevel))
                }
                
                
                HStack {
                    Text("Niveau min - max : ")
                    Spacer()
                    Text("\(session.minBlocLevel)")
                    Text("-")
                    Text("\(session.maxBlocLevel)")
                    
                }
                
                
                HStack {
                    Text("blocs terminés : ")
                    Spacer()
                    Text("\(session.completedBlocCount)")
                    Text("/")
                    Text("\(session.blocs.count)")
                    
                }
                
                
            }
        }
        .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal)
    }
}

#Preview {
    
    let session:SessionModel = SessionModel(date:Date())
    SessionCard(session:session)
}

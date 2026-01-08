//
//  BlocCad.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import SwiftUI

struct BlocCard: View {
    
    let bloc:BlocModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Image(systemName: "star.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.primary)
                        
                Text("score")
                    .font(.headline)
                        
                Spacer()
                        
                Text(String(format: "%.2f", bloc.score))
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            Divider()
            
            VStack(alignment: .center, spacing: 10) {
                
                HStack {
                    Text("Niveau : ")
                    Spacer()
                    Text("\(bloc.level)")
                }
                
                HStack {
                    Text("Essais : ")
                    Spacer()
                    Text("\(bloc.attempts)")
                }
                
                Divider()
                
                HStack {
                    
                    if bloc.overhang {
                        Text("Devers")
                            .font(.caption.bold())
                            .foregroundStyle(Color.orange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.orange.opacity(0.15))
                            .clipShape(Capsule())
                    }
                    
                    if bloc.completed {
                        Text("Terminé")
                            .font(.caption.bold())
                            .foregroundStyle(Color.green)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.green.opacity(0.15))
                            .clipShape(Capsule())
                    }

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
    
    VStack {
        
        let bloc1:BlocModel = BlocModel(session:SessionModel(date:Date()))
        BlocCard(bloc: bloc1)
        
        let bloc2:BlocModel = BlocModel(completed: true, overhang:true, session:SessionModel(date:Date()))
        BlocCard(bloc: bloc2)
    }

}

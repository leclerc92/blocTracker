//
//  BlocEditableCard.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import SwiftUI

struct BlocEditableCard: View {
    
    @Bindable var bloc:BlocModel
    var onDelete: (() -> Void)?
    var onValidate: (() -> Void)?
    
    private var level:Binding<Double>{
        Binding(
            get: { Double(self.bloc.level)},
            set: { newValue in
                bloc.level = Int(newValue)
            }
        )
    }
    
    var body: some View {
    
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                        Image(systemName: "figure.climbing")
                            .font(.title2)
                            .foregroundStyle(.primary)
                        
                        Text("Niveau")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(bloc.level)")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                    }
            Slider(value: level, in: 1...16, step: 1)
                .tint(.primary)
            
            Divider()
            
            
            Stepper(value: $bloc.attempts, in: 1...10){
                HStack{
                    Label("Nombre d'essais", systemImage: "arrow.clockwise")
                    Spacer()
                    Text("\(bloc.attempts)")
                    Spacer()
                }
            }
            
            
            Divider()
            
            HStack(spacing:10) {
                
                Toggle(isOn: $bloc.completed) {
                    Label("Terminé", systemImage: "checkmark")
                }
                
                Toggle(isOn: $bloc.overhang) {
                    Label("Devers", systemImage: "line.diagonal.trianglehead.up.right")
                }
            }
            
            Divider()
            
            HStack {
                
                if let onValidate = onValidate {
                    Button(action: onValidate) {
                        Label("valider", systemImage: "checkmark")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.green.opacity(0.2))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                    }
                }
                
                Spacer()
                
                if let onDelete = onDelete {
                    Button(action: onDelete) {
                        Label("supprimer", systemImage: "trash.fill")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.2))
                            .foregroundStyle(.red)
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
    
    @Previewable @State var bloc:BlocModel = {
        let session:SessionModel = SessionModel(date:Date())
        return BlocModel(session:session)
    }()
    
    VStack {
        BlocEditableCard(bloc: bloc)
        BlocEditableCard(bloc: bloc, onDelete: {}, onValidate: {})
    }
}

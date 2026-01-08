//
//  PreviewData.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    let container = try! ModelContainer(
        for: SessionModel.self, BlocModel.self, UnlockedBadgeModel.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    
    
    for _ in 1...10 {
        let session = SessionModel(date: Date())
        
        for _ in 1...5 {
            let bloc = BlocModel(level: Int.random(in: 1..<16), session: session)
            session.blocs.append(bloc)
        }
        
        container.mainContext.insert(session)

    }
    
    
    return container
}()

//
//  sessionModel.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import Foundation
import SwiftData

@Model
class SessionModel {
    
    var date: Date
    
    @Relationship(deleteRule: .cascade, inverse: \BlocModel.session)
    var blocs: [BlocModel]
    
    
    init(date: Date, blocs: [BlocModel] = []) {
        self.date = date
        self.blocs = blocs
    }
}


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
    
    var startDate: Date
    var endDate: Date?
    
    var sessionScore: Double {
        blocs.map(\.score).reduce(0, +)
    }
    
    var minBlocLevel: Int {
        blocs.map(\.level).min() ?? 0
    }
    
    var maxBlocLevel: Int {
        blocs.map(\.level).max() ?? 0
    }
    
    var averageBlocLevel: Double {
        guard blocs.count > 0 else { return 0.0 }
        return Double(blocs.map(\.level).reduce(0, +)) / Double(blocs.count)
    }
    
    var completedBlocCount: Int {
        blocs.filter(\.completed).count
    }
    
    var totalOverhangBlocCount: Int {
        blocs.filter(\.overhang).count
    }
    
    var duration: TimeInterval {
        guard let end = endDate else { return 0 }
        return end.timeIntervalSince(startDate)
    }
    
    
    @Relationship(deleteRule: .cascade, inverse: \BlocModel.session)
    var blocs: [BlocModel]
    
    
    init(date: Date, blocs: [BlocModel] = []) {
        self.startDate = date
        self.blocs = blocs
    }
}


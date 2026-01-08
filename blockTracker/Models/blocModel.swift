//
//  blocModel.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import Foundation
import SwiftData

@Model
class BlocModel {
    
    var level: Int
    var completed: Bool
    var attempts: Int
    var overhang: Bool
    var session: SessionModel
    
    var score:Double {
        0.0
    }
    
    init(level: Int = 3, completed: Bool = false, attempts: Int = 1, overhang: Bool = false, session: SessionModel) {
        self.level = level
        self.completed = completed
        self.attempts = attempts
        self.overhang = overhang
        self.session = session
    }
    
}

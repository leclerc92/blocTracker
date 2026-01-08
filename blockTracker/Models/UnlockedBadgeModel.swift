//
//  UnlockedBadge.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


import Foundation
import SwiftData

@Model
class UnlockedBadgeModel {
    var badgeId: String
    var unlockedAt: Date
    
    init(badge: Badge) {
        self.badgeId = badge.id
        self.unlockedAt = Date()
    }
}

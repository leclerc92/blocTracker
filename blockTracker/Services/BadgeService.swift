//
//  BadgeService.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


import Foundation
import SwiftData

@Observable
class BadgeService {
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func checkAndUnlockBadges(stats: GlobalStatsData) -> [Badge] {
        // D'abord, révoquer les badges qui ne satisfont plus leurs conditions
        revokeBadgesIfNeeded(stats: stats)

        let alreadyUnlocked = fetchUnlockedBadgeIds()
        var newlyUnlocked: [Badge] = []

        for badge in BadgeRegistry.allBadges {
            guard !alreadyUnlocked.contains(badge.id) else { continue }

            if badge.condition(stats) {
                let unlockedBadge = UnlockedBadgeModel(badge: badge)
                modelContext.insert(unlockedBadge)
                newlyUnlocked.append(badge)
            }
        }

        if !newlyUnlocked.isEmpty {
            try? modelContext.save()
        }

        return newlyUnlocked
    }

    /// Révoque les badges débloqués qui ne satisfont plus leurs conditions
    private func revokeBadgesIfNeeded(stats: GlobalStatsData) {
        let descriptor = FetchDescriptor<UnlockedBadgeModel>()
        let unlockedBadges = (try? modelContext.fetch(descriptor)) ?? []

        var badgesToRevoke: [UnlockedBadgeModel] = []

        for unlockedBadge in unlockedBadges {
            // Trouver le badge correspondant dans le registre
            if let badge = BadgeRegistry.badge(withId: unlockedBadge.badgeId) {
                // Si la condition n'est plus remplie, le badge doit être révoqué
                if !badge.condition(stats) {
                    badgesToRevoke.append(unlockedBadge)
                }
            }
        }

        // Supprimer les badges révoqués
        if !badgesToRevoke.isEmpty {
            for badge in badgesToRevoke {
                modelContext.delete(badge)
            }
            try? modelContext.save()
        }
    }
    
    private func fetchUnlockedBadgeIds() -> Set<String> {
        let descriptor = FetchDescriptor<UnlockedBadgeModel>()
        let unlocked = (try? modelContext.fetch(descriptor)) ?? []
        return Set(unlocked.map(\.badgeId))
    }
}

import Foundation

extension Badge {
    static let performanceBadges: [Badge] = {
        
        var badges: [Badge] = []
        
        // 1. LES BADGES "MANUELS" (Spéciaux)
        badges.append(contentsOf: [
            Badge(
                id: "perfect_session",
                name: "Sans faute",
                description: "Termine une session avec 100% de réussite",
                icon: "star.fill",
                category: .performance,
                condition: { $0.hasPerfectSession }
            )
        ])
        
        // 2. GÉNÉRATION AUTOMATIQUE : NIVEAU 1 à 16
        // Icone : Cercle plein (Ex: 5.circle.fill)
        let levelBadges = (1...16).map { level in
            Badge(
                id: "level_complete_\(level)",
                name: "Niveau \(level)",
                description: "Valide un bloc de cette difficulté",
                icon: "\(level).circle.fill", // SF Symbol dynamique !
                category: .performance,
                condition: { stats in stats.completedLevels.contains(level) }
            )
        }
        badges.append(contentsOf: levelBadges)

        // 3. GÉNÉRATION AUTOMATIQUE : FLASH 1 à 16
        // Icone : Carré plein pour différencier (Ex: 5.square.fill)
        let flashBadges = (1...16).map { level in
            Badge(
                id: "level_flash_\(level)",
                name: "Flash \(level) ⚡",
                description: "Réussi du premier essai",
                icon: "\(level).square.fill", // Forme différente pour le Flash
                category: .performance,
                condition: { stats in stats.flashedLevels.contains(level) }
            )
        }
        badges.append(contentsOf: flashBadges)

        // 4. GÉNÉRATION AUTOMATIQUE : DÉVERS 1 à 16
        // Icone : Cercle vide ou autre (SF Symbols n'a pas de triangles numérotés, on reprend le cercle)
        // On différencie par le nom et la description.
        let overhangBadges = (1...16).map { level in
            Badge(
                id: "level_overhang_\(level)",
                name: "Dévers \(level) ⛰️",
                description: "Valide un dévers de cette difficulté",
                icon: "\(level).circle", // Cercle vide pour le style "Technique"
                category: .performance,
                condition: { stats in stats.overhangLevels.contains(level) }
            )
        }
        badges.append(contentsOf: overhangBadges)
        
        return badges
    }()
}

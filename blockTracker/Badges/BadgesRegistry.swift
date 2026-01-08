import Foundation

struct BadgeRegistry {
    
    /// Tous les badges de l'app
    static let allBadges: [Badge] = {
        Badge.sessionBadges +
        Badge.blocBadges +
        Badge.performanceBadges
    }()
    
    /// Badges par catégorie
    static func badges(for category: BadgeCategory) -> [Badge] {
        allBadges.filter { $0.category == category }
    }
    
    /// Trouver un badge par ID
    static func badge(withId id: String) -> Badge? {
        allBadges.first { $0.id == id }
    }
}

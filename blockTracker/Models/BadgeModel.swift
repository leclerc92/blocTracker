import Foundation
import SwiftUI

struct Badge: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let category: BadgeCategory
    let condition: (GlobalStatsData) -> Bool
    
    // Hashable sans la closure
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Badge, rhs: Badge) -> Bool {
        lhs.id == rhs.id
    }
}

enum BadgeCategory: String, CaseIterable {
    case sessions = "Sessions"
    case blocs = "Blocs"
    case performance = "Performance"
    case special = "Spécial"
}

extension BadgeCategory {
    var color: Color {
        switch self {
        case .sessions: return .blue       // Bleu pour l'assiduité
        case .blocs: return .green         // Vert pour le volume
        case .performance: return .purple  // Violet/Or pour la perf
        case .special: return .orange      // Orange pour le fun
        }
    }
}

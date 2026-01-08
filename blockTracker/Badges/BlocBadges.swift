import Foundation

extension Badge {
    static let blocBadges: [Badge] = [
        Badge(
            id: "first_bloc",
            name: "Premier bloc",
            description: "Valide ton premier bloc",
            icon: "checkmark.circle.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 1 }
        ),
        Badge(
            id: "hundred_blocs",
            name: "Centurion",
            description: "Valide 100 blocs",
            icon: "100.circle.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 100 }
        ),
        Badge(
            id: "overhang_master",
            name: "Roi du dévers",
            description: "Réussis 20 blocs en dévers",
            icon: "arrow.up.right.circle.fill",
            category: .special,
            condition: { $0.totalOverhangCompleted >= 20 }
        ),
    ]
}

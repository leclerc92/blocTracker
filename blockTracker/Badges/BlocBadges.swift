import Foundation

extension Badge {
    static let blocBadges: [Badge] = [
        // BADGES NOMBRE TOTAL DE BLOCS COMPLÉTÉS
        Badge(
            id: "first_bloc",
            name: "Premier bloc",
            description: "Valide ton premier bloc",
            icon: "checkmark.circle.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 1 }
        ),
        Badge(
            id: "ten_blocs",
            name: "Débutant",
            description: "Valide 10 blocs",
            icon: "10.circle.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 10 }
        ),
        Badge(
            id: "fifty_blocs",
            name: "Grimpeur",
            description: "Valide 50 blocs",
            icon: "50.circle.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 50 }
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
            id: "two_hundred_blocs",
            name: "Bicentenaire",
            description: "Valide 200 blocs",
            icon: "200.circle.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 200 }
        ),
        Badge(
            id: "three_hundred_blocs",
            name: "Tricentenaire",
            description: "Valide 300 blocs",
            icon: "flame.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 300 }
        ),
        Badge(
            id: "four_hundred_blocs",
            name: "Athlète",
            description: "Valide 400 blocs",
            icon: "bolt.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 400 }
        ),
        Badge(
            id: "five_hundred_blocs",
            name: "Champion",
            description: "Valide 500 blocs",
            icon: "star.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 500 }
        ),
        Badge(
            id: "thousand_blocs",
            name: "Légende vivante",
            description: "Valide 1000 blocs",
            icon: "crown.fill",
            category: .blocs,
            condition: { $0.totalCompletedBlocs >= 1000 }
        ),

        // BADGES BLOCS EN DÉVERS
        Badge(
            id: "first_overhang",
            name: "Premier dévers",
            description: "Réussis ton premier bloc en dévers",
            icon: "arrow.up.right",
            category: .special,
            condition: { $0.totalOverhangCompleted >= 1 }
        ),
        Badge(
            id: "five_overhang",
            name: "Amateur de dévers",
            description: "Réussis 5 blocs en dévers",
            icon: "arrow.up.right.circle",
            category: .special,
            condition: { $0.totalOverhangCompleted >= 5 }
        ),
        Badge(
            id: "ten_overhang",
            name: "Habitué du dévers",
            description: "Réussis 10 blocs en dévers",
            icon: "arrow.up.right.circle.fill",
            category: .special,
            condition: { $0.totalOverhangCompleted >= 10 }
        ),
        Badge(
            id: "fifty_overhang",
            name: "Expert dévers",
            description: "Réussis 50 blocs en dévers",
            icon: "angle",
            category: .special,
            condition: { $0.totalOverhangCompleted >= 50 }
        ),
        Badge(
            id: "hundred_overhang",
            name: "Maître du dévers",
            description: "Réussis 100 blocs en dévers",
            icon: "triangle.fill",
            category: .special,
            condition: { $0.totalOverhangCompleted >= 100 }
        ),
        Badge(
            id: "two_hundred_overhang",
            name: "Roi du dévers",
            description: "Réussis 200 blocs en dévers",
            icon: "pyramid.fill",
            category: .special,
            condition: { $0.totalOverhangCompleted >= 200 }
        ),
    ]
}

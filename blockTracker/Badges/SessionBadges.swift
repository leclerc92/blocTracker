import Foundation

extension Badge {
    static let sessionBadges: [Badge] = [
        // BADGES NOMBRE DE SESSIONS
        Badge(
            id: "first_session",
            name: "Première grimpe",
            description: "Termine ta première session",
            icon: "figure.climbing",
            category: .sessions,
            condition: { $0.totalSessions >= 1 }
        ),
        Badge(
            id: "ten_sessions",
            name: "Habitué",
            description: "Termine 10 sessions",
            icon: "calendar",
            category: .sessions,
            condition: { $0.totalSessions >= 10 }
        ),
        Badge(
            id: "thirty_sessions",
            name: "Assidu",
            description: "Termine 30 sessions",
            icon: "medal.fill",
            category: .sessions,
            condition: { $0.totalSessions >= 30 }
        ),
        Badge(
            id: "fifty_sessions",
            name: "Vétéran",
            description: "Termine 50 sessions",
            icon: "crown.fill",
            category: .sessions,
            condition: { $0.totalSessions >= 50 }
        ),
        Badge(
            id: "hundred_sessions",
            name: "Légende",
            description: "Termine 100 sessions",
            icon: "trophy.fill",
            category: .sessions,
            condition: { $0.totalSessions >= 100 }
        ),

        // BADGES SESSION AVEC X BLOCS
        Badge(
            id: "session_10_blocs",
            name: "Marathon",
            description: "Réalise une session de 10 blocs",
            icon: "10.circle.fill",
            category: .sessions,
            condition: { $0.maxBlocsInSession >= 10 }
        ),
        Badge(
            id: "session_20_blocs",
            name: "Ultra-Marathon",
            description: "Réalise une session de 20 blocs",
            icon: "20.circle.fill",
            category: .sessions,
            condition: { $0.maxBlocsInSession >= 20 }
        ),
        Badge(
            id: "session_30_blocs",
            name: "Machine",
            description: "Réalise une session de 30 blocs",
            icon: "30.circle.fill",
            category: .sessions,
            condition: { $0.maxBlocsInSession >= 30 }
        ),
        Badge(
            id: "session_40_blocs",
            name: "Infatigable",
            description: "Réalise une session de 40 blocs",
            icon: "40.circle.fill",
            category: .sessions,
            condition: { $0.maxBlocsInSession >= 40 }
        ),
        Badge(
            id: "session_50_blocs",
            name: "Surhumain",
            description: "Réalise une session de 50 blocs",
            icon: "50.circle.fill",
            category: .sessions,
            condition: { $0.maxBlocsInSession >= 50 }
        ),

        // BADGES SESSION AVEC NIVEAU MOYEN
        Badge(
            id: "session_avg_5",
            name: "Niveau 5",
            description: "Session avec niveau moyen 5+",
            icon: "5.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 5.0 }
        ),
        Badge(
            id: "session_avg_6",
            name: "Niveau 6",
            description: "Session avec niveau moyen 6+",
            icon: "6.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 6.0 }
        ),
        Badge(
            id: "session_avg_7",
            name: "Niveau 7",
            description: "Session avec niveau moyen 7+",
            icon: "7.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 7.0 }
        ),
        Badge(
            id: "session_avg_8",
            name: "Niveau 8",
            description: "Session avec niveau moyen 8+",
            icon: "8.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 8.0 }
        ),
        Badge(
            id: "session_avg_9",
            name: "Niveau 9",
            description: "Session avec niveau moyen 9+",
            icon: "9.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 9.0 }
        ),
        Badge(
            id: "session_avg_10",
            name: "Top 10",
            description: "Session avec niveau moyen 10+",
            icon: "10.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 10.0 }
        ),
        Badge(
            id: "session_avg_11",
            name: "Élite 11",
            description: "Session avec niveau moyen 11+",
            icon: "11.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 11.0 }
        ),
        Badge(
            id: "session_avg_12",
            name: "Pro 12",
            description: "Session avec niveau moyen 12+",
            icon: "12.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 12.0 }
        ),
        Badge(
            id: "session_avg_13",
            name: "Expert 13",
            description: "Session avec niveau moyen 13+",
            icon: "13.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 13.0 }
        ),
        Badge(
            id: "session_avg_14",
            name: "Master 14",
            description: "Session avec niveau moyen 14+",
            icon: "14.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 14.0 }
        ),
        Badge(
            id: "session_avg_15",
            name: "Champion 15",
            description: "Session avec niveau moyen 15+",
            icon: "15.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 15.0 }
        ),
        Badge(
            id: "session_avg_16",
            name: "Légende 16",
            description: "Session avec niveau moyen 16+",
            icon: "16.circle",
            category: .sessions,
            condition: { $0.maxAverageLevelInSession >= 16.0 }
        ),
    ]
}

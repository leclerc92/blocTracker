import Foundation

extension Badge {
    static let sessionBadges: [Badge] = [
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
            id: "fifty_sessions",
            name: "Vétéran",
            description: "Termine 50 sessions",
            icon: "crown.fill",
            category: .sessions,
            condition: { $0.totalSessions >= 50 }
        ),
    ]
}

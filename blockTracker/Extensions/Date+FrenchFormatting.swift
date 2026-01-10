//
//  Date+FrenchFormatting.swift
//  blockTracker
//
//  Created by claude on 08/01/2026.
//

import Foundation

extension Date {
    /// Formatage des dates en français
    enum French {
        /// Format: "14:30"
        static let timeOnly = Date.FormatStyle()
            .hour()
            .minute()
            .locale(Locale(identifier: "fr_FR"))

        /// Format: "8 janvier 2026"
        static let longDate = Date.FormatStyle()
            .day()
            .month(.wide)
            .year()
            .locale(Locale(identifier: "fr_FR"))

        /// Format: "8/1/2026"
        static let shortDate = Date.FormatStyle()
            .day()
            .month()
            .year()
            .locale(Locale(identifier: "fr_FR"))

        /// Format: "jeudi"
        static let weekday = Date.FormatStyle()
            .weekday(.wide)
            .locale(Locale(identifier: "fr_FR"))

        /// Format: "8 janv" (pour graphiques)
        static let dayMonth = Date.FormatStyle()
            .day()
            .month(.defaultDigits)
            .locale(Locale(identifier: "fr_FR"))
    }
}

// MARK: - Formatage de Durées (Temps écoulé)
extension TimeInterval {
    /// Convertit le temps (secondes) en format "HH:MM" (ex: "01:30")
    var formattedHHMM: String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}

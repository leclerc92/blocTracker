//
//  Theme.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import SwiftUI

extension Color {
    // Le fond des cartes style Fitness
    static let cardBackground = Color(red: 0.11, green: 0.11, blue: 0.12)
    // Une couleur d'accent pour l'escalade (ex: Jaune Électrique ou Bleu Cyan)
    static let climbingAccent = Color(red: 0.85, green: 0.96, blue: 0.23)
    // Gris pour les textes secondaires
    static let textSecondary = Color.gray
}

extension Font {
    // Version 1 : Pour les styles standards (ex: .fitness(.title))
    static func fitness(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        return .system(style, design: .rounded).weight(weight)
    }
    
    // Version 2 (Celle qui manquait) : Pour une taille précise (ex: .fitness(size: 32))
    static func fitness(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .rounded)
    }
}

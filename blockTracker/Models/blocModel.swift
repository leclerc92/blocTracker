//
//  blocModel.swift
//  blockTracker
//
//  Created by clement leclerc on 07/01/2026.
//

import Foundation
import SwiftData

@Model
class BlocModel {
    
    var level: Int
    var completed: Bool
    var attempts: Int
    var overhang: Bool
    var session: SessionModel
    
    var score:Double {
        calculateBlocScore()
    }
    
    init(level: Int = 3, completed: Bool = false, attempts: Int = 1, overhang: Bool = false, session: SessionModel) {
        self.level = level
        self.completed = completed
        self.attempts = max(1, attempts)
        self.overhang = overhang
        self.session = session
    }
    
    func calculateBlocScore() -> Double {
            
            // 1. BASE DE DIFFICULTÉ (Exponentielle)
            // Niveau 4 = 60 pts, Niveau 10 = 315 pts
            // Cela représente l'intensité physique intrinseque du bloc
            let baseIntensity = pow(Double(self.level), 1.8) * 5.0
            
            // 2. FACTEUR DE STYLE
            // Le dévers demande plus d'énergie physique (gainage, bras)
            let styleMultiplier = self.overhang ? 1.25 : 1.0
            
            let rawScore = baseIntensity * styleMultiplier
            
            if completed {
                // --- SCÉNARIO RÉUSSITE (PERFORMANCE) ---
                // On donne 100% des points + un bonus de réussite
                // Si validé au 1er essai (Flash) -> Petit bonus d'efficacité
                // Si validé en 10 essais -> On a quand même réussi, donc score plein
                
                let successBonus = 1.2 // Bonus fixe de 20% parce que c'est fini
                
                // Petit bonus si fait en peu d'essais (Efficiency)
                // 1 essai = x1.1, 10 essais = x1.0
                let efficiencyBonus = max(1.0, 1.1 - (Double(attempts - 1) * 0.01))
                
                return rawScore * successBonus * efficiencyBonus
                
            } else {
                // --- SCÉNARIO ÉCHEC (EFFORT / TRAINING LOAD) ---
                // Ici, le score reflète l'énergie dépensée sans la récompense finale.
                
                // Base : Tu as travaillé le bloc, tu reçois 30% des points juste pour avoir essayé ce niveau.
                let baseEffort = 0.30
                
                // Acharnement : Chaque essai ajoute 5% de points d'effort
                // Exemple : 5 essais = 25% de plus.
                // On plafonne l'effort total à 80% du score de base pour que
                // l'échec ne rapporte jamais plus que la réussite.
                let attemptLoad = min(0.50, Double(attempts) * 0.05)
                
                let totalEffortFactor = baseEffort + attemptLoad
                
                return rawScore * totalEffortFactor
            }
        }
    
}

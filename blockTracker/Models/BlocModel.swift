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
    var validated: Bool
    var date: Date
    
    var score:Double {
        calculateBlocScore()
    }
    
    init(level: Int = 3, completed: Bool = false, attempts: Int = 1, overhang: Bool = false, session: SessionModel, validated: Bool = false, date:Date = Date()) {
        self.level = level
        self.completed = completed
        self.attempts = max(1, attempts)
        self.overhang = overhang
        self.session = session
        self.validated = validated
        self.date = date
    }
    
    func calculateBlocScore() -> Double {
            
            // 1. BASE DE DIFFICULTÉ (Exponentielle)
            // Niveau 4 = 60 pts, Niveau 10 = 315 pts
            // Cela représente l'intensité physique intrinseque du bloc
        let baseIntensity = pow(Double(self.level), SCORE_CONSTANTS.INTENSITY_POW) * SCORE_CONSTANTS.INTENSITY_FACTOR
            
            // 2. FACTEUR DE STYLE
            // Le dévers demande plus d'énergie physique (gainage, bras)
        let styleMultiplier = self.overhang ? SCORE_CONSTANTS.STYLE_FACTOR : SCORE_CONSTANTS.STYLE_BASE
            
            let rawScore = baseIntensity * styleMultiplier
            
            if completed {
                // --- SCÉNARIO RÉUSSITE (PERFORMANCE) ---
                // On donne 100% des points + un bonus de réussite
                // Si validé au 1er essai (Flash) -> Petit bonus d'efficacité
                // Si validé en 10 essais -> On a quand même réussi, donc score plein
                
                let successBonus = SCORE_CONSTANTS.SUCCES_BONUS // Bonus fixe de 20% parce que c'est fini
                
                // Petit bonus si fait en peu d'essais (Efficiency)
                // 1 essai = x1.1, 10 essais = x1.0
                let efficiencyBonus = max(SCORE_CONSTANTS.BASE_EFFICIENCY, SCORE_CONSTANTS.BASE_EFFICIENCY - (Double(attempts - 1) * SCORE_CONSTANTS.EFFICIENCY_FACTOR))
                
                return rawScore * successBonus * efficiencyBonus
                
            } else {
                // --- SCÉNARIO ÉCHEC (EFFORT / TRAINING LOAD) ---
                // Ici, le score reflète l'énergie dépensée sans la récompense finale.
                // Acharnement : Chaque essai ajoute 5% de points d'effort
                // Exemple : 5 essais = 25% de plus.
                // On plafonne l'effort total à 80% du score de base pour que
                // l'échec ne rapporte jamais plus que la réussite.
                let attemptLoad = min(SCORE_CONSTANTS.BASE_ATTEMPT, Double(attempts) * SCORE_CONSTANTS.ATTEMPT_FACTOR)
                
                let totalEffortFactor = SCORE_CONSTANTS.BASE_EFFORT + attemptLoad
                
                return rawScore * totalEffortFactor
            }
        }
    
}

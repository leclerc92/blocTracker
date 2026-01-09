//
//  StatsService.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


// StatsService.swift

struct StatsService {
    
    /// Calcule toutes les statistiques à partir d'une liste de sessions
    static func computeStats(from sessions: [SessionModel]) -> GlobalStatsData {
        
        guard !sessions.isEmpty else { return GlobalStatsData() }
        
        var stats = GlobalStatsData()
        
        stats.totalSessions = sessions.count
        
        // Moyenne des scores de toutes les sessions
        let allScores = sessions.map { $0.sessionScore }
        stats.globalAverageScore = allScores.reduce(0, +) / Double(sessions.count)
        
        // Moyenne des niveaux de toutes les sessions
        let allLevels = sessions.map { $0.averageBlocLevel }
        stats.globalAverageLevel = allLevels.reduce(0, +) / Double(sessions.count)
        
        // Niveau Max jamais atteint (on cherche le bloc le plus dur de toute l'histoire)
        // On aplatit tous les blocs de toutes les sessions
        let allBlocs = sessions.flatMap { $0.blocs }
        stats.maxLevelCompleted = allBlocs.map { $0.level }.max() ?? 0
        
        // Moyenne de blocs par session
        stats.averageBlocsPerSession = allBlocs.count / sessions.count
        
        // Taux de réussite global
        let totalCompleted = allBlocs.filter { $0.completed }.count
        stats.totalCompletedBlocs = totalCompleted
        stats.globalSuccessRate = allBlocs.isEmpty ? 0 : Double(totalCompleted) / Double(allBlocs.count) * 100

        // Ratio Dévers
        let totalOverhang = allBlocs.filter { $0.overhang }.count
        stats.overhangRatio = allBlocs.isEmpty ? 0 : Double(totalOverhang) / Double(allBlocs.count)

        // Total flash blocs (completed avec 1 essai)
        stats.totalFlashBlocs = allBlocs.filter { $0.completed && $0.attempts == 1 }.count

        // Total overhang complétés
        stats.totalOverhangCompleted = allBlocs.filter { $0.completed && $0.overhang }.count

        // Perfect session (au moins une session avec 100% de réussite)
        stats.hasPerfectSession = sessions.contains { session in
            !session.blocs.isEmpty && session.blocs.allSatisfy { $0.completed }
        }

        // Records de sessions
        stats.maxBlocsInSession = sessions.map { $0.blocs.count }.max() ?? 0
        stats.maxAverageLevelInSession = sessions.map { $0.averageBlocLevel }.max() ?? 0.0

        // Niveaux complétés (Simplement terminé)
        let completed = allBlocs.filter { $0.completed }
        stats.completedLevels = Set(completed.map { $0.level })
        
        // Niveaux Flashés (Terminé + 1 essai)
        let flashed = completed.filter { $0.attempts == 1 }
        stats.flashedLevels = Set(flashed.map { $0.level })
        
        // Niveaux Dévers (Terminé + Overhang = true)
        let overhanged = completed.filter { $0.overhang }
        stats.overhangLevels = Set(overhanged.map { $0.level })
        
        // --- CALCULS TEMPORELS (Pour les graphiques) ---
        // On trie les sessions par date pour que le graph soit dans l'ordre
        let sortedSessions = sessions.sorted { $0.date < $1.date }
        
        stats.scoreHistory = sortedSessions.map { session in
            ChartDataPoint(date: session.date, value: session.sessionScore)
        }
        
        stats.levelHistory = sortedSessions.map { session in
            ChartDataPoint(date: session.date, value: session.averageBlocLevel)
        }
        
        return stats
    }
}

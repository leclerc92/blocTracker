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
        let allScores = sessions.map { $0.blocsScore }
        stats.globalAverageScore = allScores.reduce(0, +) / Double(sessions.count)
        
        // Moyenne des niveaux de toutes les sessions
        let allLevels = sessions.map { $0.averageBlocLevel }
        stats.globalAverageLevel = allLevels.reduce(0, +) / Double(sessions.count)
        
        // Niveau Max jamais atteint (on cherche le bloc le plus dur de toute l'histoire)
        // On aplatit tous les blocs de toutes les sessions
        let allBlocs = sessions.flatMap { $0.blocs }
        stats.maxLevelAchieved = allBlocs.map { $0.level }.max() ?? 0
        
        // Moyenne de blocs par session
        stats.averageBlocsPerSession = allBlocs.count / sessions.count
        
        // Taux de réussite global
        let totalCompleted = allBlocs.filter { $0.completed }.count
        stats.globalSuccessRate = allBlocs.isEmpty ? 0 : Double(totalCompleted) / Double(allBlocs.count) * 100
        
        // Ratio Dévers
        let totalOverhang = allBlocs.filter { $0.overhang }.count
        stats.overhangRatio = allBlocs.isEmpty ? 0 : Double(totalOverhang) / Double(allBlocs.count)
        
        // --- CALCULS TEMPORELS (Pour les graphiques) ---
        // On trie les sessions par date pour que le graph soit dans l'ordre
        let sortedSessions = sessions.sorted { $0.date < $1.date }
        
        stats.scoreHistory = sortedSessions.map { session in
            ChartDataPoint(date: session.date, value: session.blocsScore)
        }
        
        stats.levelHistory = sortedSessions.map { session in
            ChartDataPoint(date: session.date, value: session.averageBlocLevel)
        }
        
        return stats
    }
}

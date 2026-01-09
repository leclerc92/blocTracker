//
//  GlobalStatsData.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


import Foundation

struct GlobalStatsData {
    
    var totalSessions: Int = 0
    var globalAverageScore: Double = 0.0
    var globalAverageLevel: Double = 0.0
    var averageBlocsPerSession: Int = 0
    var globalSuccessRate: Double = 0.0
    var totalCompletedBlocs: Int = 0
    var maxLevelCompleted: Int = 0
    var overhangRatio: Double = 0.0
    var totalFlashBlocs: Int = 0
    var hasPerfectSession: Bool = false
    var totalOverhangCompleted: Int = 0

    // Records de sessions
    var maxBlocsInSession: Int = 0
    var maxAverageLevelInSession: Double = 0.0

    var completedLevels: Set<Int> = []
    var flashedLevels: Set<Int> = []
    var overhangLevels: Set<Int> = []

    
 
    var scoreHistory: [ChartDataPoint] = []
    var levelHistory: [ChartDataPoint] = []
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

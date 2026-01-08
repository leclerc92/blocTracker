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
    var maxLevelAchieved: Int = 0
    var globalSuccessRate: Double = 0.0
    var averageBlocsPerSession: Int = 0
    var overhangRatio: Double = 0.0
    
    var scoreHistory: [ChartDataPoint] = []
    var levelHistory: [ChartDataPoint] = []
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

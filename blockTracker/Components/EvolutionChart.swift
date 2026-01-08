//
//  EvolutionChart.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


import SwiftUI
import Charts

struct ScoreEvolutionChart: View {
    // Données fictives pour le graph
    struct DataPoint: Identifiable {
        let id = UUID()
        let day: String
        let score: Double
    }
    
    let data: [DataPoint] = [
        .init(day: "Lun", score: 120),
        .init(day: "Mer", score: 145),
        .init(day: "Ven", score: 138),
        .init(day: "Dim", score: 160),
        .init(day: "Mar", score: 175),
        .init(day: "Jeu", score: 168),
        .init(day: "Sam", score: 190)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PROGRESSION SCORE")
                .font(.fitness(.caption, weight: .bold))
                .foregroundStyle(.gray)
            
            Chart {
                ForEach(data) { point in
                    // La ligne fluide
                    LineMark(
                        x: .value("Jour", point.day),
                        y: .value("Score", point.score)
                    )
                    .interpolationMethod(.catmullRom) // Courbe lissée
                    .foregroundStyle(Color.climbingAccent)
                    .symbol {
                        Circle()
                            .fill(Color.climbingAccent)
                            .frame(width: 8, height: 8)
                    }
                    
                    // Le dégradé sous la courbe
                    AreaMark(
                        x: .value("Jour", point.day),
                        y: .value("Score", point.score)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.climbingAccent.opacity(0.3), Color.climbingAccent.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .chartYAxis(.hidden) // On cache l'axe Y pour le look épuré
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisValueLabel().foregroundStyle(Color.gray)
                }
            }
            .frame(height: 180)
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(20)
    }
}

// --- 2. LE GRAPHIQUE DONUT (Dévers vs Dalle) ---
struct StyleDistributionChart: View {
    var overhangPercentage: Double // Ex: 0.4 pour 40%
    
    var body: some View {
        HStack(spacing: 20) {
            // Le Donut Chart
            Chart {
                SectorMark(
                    angle: .value("Type", overhangPercentage),
                    innerRadius: .ratio(0.6),
                    angularInset: 2
                )
                .foregroundStyle(Color.orange) // Couleur Dévers
                .cornerRadius(5)
                
                SectorMark(
                    angle: .value("Type", 1.0 - overhangPercentage),
                    innerRadius: .ratio(0.6),
                    angularInset: 2
                )
                .foregroundStyle(Color.gray.opacity(0.3)) // Couleur Reste
                .cornerRadius(5)
            }
            .frame(width: 80, height: 80)
            
            // La Légende
            VStack(alignment: .leading, spacing: 8) {
                Label {
                    Text("Dévers (\(Int(overhangPercentage * 100))%)")
                        .font(.fitness(.caption, weight: .bold))
                        .foregroundStyle(.white)
                } icon: {
                    Circle().fill(Color.orange).frame(width: 8)
                }
                
                Label {
                    Text("Dalle / Vertical")
                        .font(.fitness(.caption, weight: .bold))
                        .foregroundStyle(.gray)
                } icon: {
                    Circle().fill(Color.gray.opacity(0.5)).frame(width: 8)
                }
            }
            Spacer()
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(20)
    }
}

struct LevelEvolutionChart: View {
    struct LevelDataPoint: Identifiable {
        let id = UUID()
        let date: String
        let level: Double
    }
    
    // Données fictives : Le niveau grimpe doucement
    let data: [LevelDataPoint] = [
        .init(date: "S1", level: 5.2),
        .init(date: "S2", level: 5.4),
        .init(date: "S3", level: 5.3),
        .init(date: "S4", level: 5.8),
        .init(date: "S5", level: 6.0),
        .init(date: "S6", level: 6.2)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("NIVEAU MOYEN / SÉANCE")
                    .font(.fitness(.caption, weight: .bold))
                    .foregroundStyle(.gray)
                Spacer()
                // Petit indicateur de la tendance actuelle
                Text("+1.0")
                    .font(.fitness(.caption, weight: .bold))
                    .foregroundStyle(.purple)
                    .padding(4)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Chart {
                ForEach(data) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Niveau", point.level)
                    )
                    .interpolationMethod(.monotone) // Courbe plus douce
                    .foregroundStyle(Color.purple) // Distinction visuelle (Violet pour la difficulté)
                    .symbol {
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 8, height: 8)
                            .overlay(
                                Circle().stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
                
                // Règle pour montrer l'objectif (optionnel mais sympa)
                RuleMark(y: .value("Objectif", 7.0))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Obj. 7.0")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
            }
            // On affiche l'échelle Y pour le niveau car c'est une donnée précise (5, 6, 7...)
            .chartYScale(domain: 4...8)
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine().foregroundStyle(Color.gray.opacity(0.1))
                    AxisValueLabel().foregroundStyle(Color.gray)
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisValueLabel().foregroundStyle(Color.gray)
                }
            }
            .frame(height: 180)
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(20)
    }
}

// --- 3. TUILE KPI STANDARD (Carrée) ---
struct KPIBox: View {
    let title: String
    let value: String
    let unit: String?
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                    .padding(8)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
                
                Spacer()
            }
            
            Spacer()
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.fitness(size: 30, weight: .bold)) // Gros Chiffre
                    .foregroundStyle(.white)
                
                if let unit = unit {
                    Text(unit)
                        .font(.fitness(.caption, weight: .semibold))
                        .foregroundStyle(.gray)
                }
            }
            
            Text(title.uppercased())
                .font(.fitness(size: 10, weight: .bold))
                .foregroundStyle(.gray)
        }
        .padding(16)
        .frame(height: 140) // Hauteur fixe pour faire des carrés
        .background(Color.cardBackground)
        .cornerRadius(20)
    }
}

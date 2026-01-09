//
//  EvolutionChart.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


import SwiftUI
import Charts

struct ScoreEvolutionChart: View {
    
    // On reçoit maintenant les vraies données
    let data: [ChartDataPoint]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PROGRESSION SCORE")
                .font(.fitness(.caption, weight: .bold))
                .foregroundStyle(.gray)
            
            if data.isEmpty {
                // État vide si pas assez de sessions
                ContentUnavailableView("Pas assez de données", systemImage: "chart.xyaxis.line")
                    .frame(height: 180)
            } else {
                Chart {
                    ForEach(data) { point in
                        // La ligne fluide
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Score", point.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.climbingAccent)
                        
                        // Le point avec la valeur affichée
                        PointMark(
                            x: .value("Date", point.date),
                            y: .value("Score", point.value)
                        )
                        .foregroundStyle(Color.climbingAccent)
                        .annotation(position: .top) { // <--- C'est ici qu'on affiche la valeur
                            Text(String(format: "%.0f", point.value))
                                .font(.fitness(size: 10, weight: .bold))
                                .foregroundStyle(Color.gray)
                                .padding(.bottom, 4)
                        }
                        
                        // Le dégradé sous la courbe
                        AreaMark(
                            x: .value("Date", point.date),
                            y: .value("Score", point.value)
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
                .chartYAxis(.hidden)
                // Formatage de l'axe X pour afficher "Lun 12", "Jeu 14"...
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisValueLabel(format: Date.French.dayMonth)
                            .foregroundStyle(Color.gray)
                    }
                }
                .frame(height: 180)
            }
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
    
    let data: [ChartDataPoint]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("NIVEAU MOYEN / SÉANCE")
                    .font(.fitness(.caption, weight: .bold))
                    .foregroundStyle(.gray)
                Spacer()
                
                // Petit calcul de tendance (Dernier - Premier)
                if let first = data.first?.value, let last = data.last?.value {
                    let diff = last - first
                    Text(diff >= 0 ? String(format: "+%.1f", diff) : String(format: "%.1f", diff))
                        .font(.fitness(.caption, weight: .bold))
                        .foregroundStyle(Color.purple)
                        .padding(4)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            if data.isEmpty {
                ContentUnavailableView("Données insuffisantes", systemImage: "chart.line.uptrend.xyaxis")
                    .frame(height: 180)
            } else {
                Chart {
                    ForEach(data) { point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Niveau", point.value)
                        )
                        .interpolationMethod(.monotone)
                        .foregroundStyle(Color.purple)
                        .symbol {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 8, height: 8)
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        }
                    }
                    
                }
                // Échelle Y dynamique (Niveau 1 à 16 par exemple)
                .chartYScale(domain: .automatic(includesZero: false))
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisGridLine().foregroundStyle(Color.gray.opacity(0.1))
                        AxisValueLabel().foregroundStyle(Color.gray)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                        AxisValueLabel(format: Date.French.dayMonth)
                            .foregroundStyle(Color.gray)
                    }
                }
                .frame(height: 180)
            }
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

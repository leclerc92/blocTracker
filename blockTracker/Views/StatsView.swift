import SwiftUI
import SwiftData

struct StatsView: View {
    
    @Query(sort: \SessionModel.date, order: .forward) private var sessions: [SessionModel]
    
    private var data: GlobalStatsData {
            StatsService.computeStats(from: sessions)
    }
    
    // État pour les graphiques défilants
    @State private var selectedChart = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // 1. CARROUSEL DE GRAPHIQUES (Style Apple Fitness)
                        VStack(spacing: 8) {
                            TabView(selection: $selectedChart) {
                                ScoreEvolutionChart(data: data.scoreHistory)
                                    .tag(0)
                                    .padding(.horizontal) // Padding interne pour ne pas coller aux bords
                                
                                LevelEvolutionChart(data:data.levelHistory)
                                    .tag(1)
                                    .padding(.horizontal)
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never)) // On gère nous-même les points
                            .frame(height: 220) // Hauteur fixe pour le carrousel
                            
                            // Indicateur de page personnalisé (Dots)
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(selectedChart == 0 ? Color.white : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                Circle()
                                    .fill(selectedChart == 1 ? Color.white : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        
                        // 2. GRID KPI (Mise à jour avec Niveau Moyen)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            
                            KPIBox(
                                title: "Score Moyen",
                                value: String(format: "%.0f", data.globalAverageScore),
                                unit: "pts",
                                icon: "star.fill",
                                color: .climbingAccent
                            )
                            
                            KPIBox(
                                title: "Niveau Moyen",
                                value: String(format: "%.1f", data.globalAverageLevel),
                                unit: "/ 16",
                                icon: "figure.stairs",
                                color: .purple // Assorti au graphique de niveau
                            )
                            
                            KPIBox(
                                title: "Total Sessions",
                                value: "\(data.totalSessions)",
                                unit: nil,
                                icon: "calendar",
                                color: .blue
                            )
                            
                            KPIBox(
                                title: "Niveau Max",
                                value: "\(data.maxLevelAchieved)",
                                unit: nil,
                                icon: "trophy.fill",
                                color: .yellow
                            )
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("ANALYSE TECHNIQUE")
                                    .font(.fitness(.caption, weight: .bold))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                            
                            // Style Distribution
                            StyleDistributionChart(overhangPercentage: data.overhangRatio)
                            
                            HStack {
                                Label("Blocs validés", systemImage: "checkmark.circle.fill")
                                    .font(.fitness(.subheadline, weight: .bold))
                                    .foregroundStyle(.green)
                                Spacer()
                                Text(String(format: "%.1f",data.globalSuccessRate) + "%")
                                    .font(.fitness(.headline, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .padding(20)
                            .background(Color.cardBackground)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal)
                        
                        Color.clear.frame(height: 50)
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
        }
    }
}

#Preview {
    StatsView()
}

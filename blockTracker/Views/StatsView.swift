import SwiftUI

struct StatsView: View {
    
    // Données fictives
    private let mockTotalSessions = 42
    private let mockAvgScore = 185.5
    private let mockAvgLevel = 6.2 // NOUVEAU
    private let mockMaxGrade = 14
    private let mockCompletionRate = 78
    private let mockOverhangRate = 0.65
    private let mockAvgBlocsPerSession = 12
    
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
                                ScoreEvolutionChart()
                                    .tag(0)
                                    .padding(.horizontal) // Padding interne pour ne pas coller aux bords
                                
                                LevelEvolutionChart() // NOUVEAU COMPOSANT
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
                                value: String(format: "%.0f", mockAvgScore),
                                unit: "pts",
                                icon: "star.fill",
                                color: .climbingAccent
                            )
                            
                            // NOUVELLE TUILE : NIVEAU MOYEN
                            KPIBox(
                                title: "Niveau Moyen",
                                value: String(format: "%.1f", mockAvgLevel),
                                unit: "/ 16",
                                icon: "figure.stairs",
                                color: .purple // Assorti au graphique de niveau
                            )
                            
                            KPIBox(
                                title: "Total Sessions",
                                value: "\(mockTotalSessions)",
                                unit: nil,
                                icon: "calendar",
                                color: .blue
                            )
                            
                            KPIBox(
                                title: "Niveau Max",
                                value: "\(mockMaxGrade)",
                                unit: nil,
                                icon: "trophy.fill",
                                color: .yellow
                            )
                        }
                        .padding(.horizontal)
                        
                        // 3. RESTE DE LA VUE (Analyses)
                        VStack(spacing: 16) {
                            HStack {
                                Text("ANALYSE TECHNIQUE")
                                    .font(.fitness(.caption, weight: .bold))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                            
                            // Style Distribution
                            StyleDistributionChart(overhangPercentage: mockOverhangRate)
                            
                            // Taux de réussite (Simplifié pour l'exemple)
                            HStack {
                                Label("Blocs validés", systemImage: "checkmark.circle.fill")
                                    .font(.fitness(.subheadline, weight: .bold))
                                    .foregroundStyle(.green)
                                Spacer()
                                Text("\(mockCompletionRate)%")
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
            .navigationTitle("Statistiques")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
        }
    }
}

#Preview {
    StatsView()
}

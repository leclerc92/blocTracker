import SwiftUI

struct SessionStatsHeader: View {
    
    let session: SessionModel
    
    private var completionRate: Double {
        guard session.blocs.count > 0 else { return 0 }
        return Double(session.completedBlocCount) / Double(session.blocs.count)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            // MARK: - Anneau principal + Score
            HStack(spacing: 30) {
                
                // Anneau de progression
                ZStack {
                    // Cercle de fond
                    Circle()
                        .stroke(Color.green.opacity(0.2), lineWidth: 12)
                        .frame(width: 100, height: 100)
                    
                    // Cercle de progression
                    Circle()
                        .trim(from: 0, to: completionRate)
                        .stroke(
                            Color.green,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut(duration: 0.8), value: completionRate)
                    
                    // Texte central
                    VStack(spacing: 2) {
                        Text("\(Int(completionRate * 100))%")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Text("réussi")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Score principal
                VStack(alignment: .leading, spacing: 8) {
                    Text("Score total")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(String(format: "%.1f", session.blocsScore))
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text("\(session.completedBlocCount)/\(session.blocs.count) blocs terminés")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // MARK: - Stats secondaires en grille
            HStack(spacing: 12) {
                StatBox(
                    title: "Niveau moyen",
                    value: String(format: "%.1f", session.averageBlocLevel),
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
                
                StatBox(
                    title: "Min - Max",
                    value: "\(session.minBlocLevel) - \(session.maxBlocLevel)",
                    icon: "arrow.up.arrow.down",
                    color: .purple
                )
                
                StatBox(
                    title: "Dévers",
                    value: "\(session.totalOverhangBlocCount)",
                    icon: "arrow.up.right",
                    color: .orange
                )
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

// MARK: - Composant StatBox réutilisable
struct StatBox: View {
    
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

#Preview {
    let session = SessionModel(date: Date())
    let bloc1 = BlocModel(level: 5, completed: true, session: session)
    let bloc2 = BlocModel(level: 8, completed: true, overhang: true, session: session)
    let bloc3 = BlocModel(level: 6, completed: false, session: session)
    let bloc4 = BlocModel(level: 7, completed: true, overhang: true, session: session)
    session.blocs.append(contentsOf: [bloc1, bloc2, bloc3, bloc4])
    
    return SessionStatsHeader(session: session)
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
}
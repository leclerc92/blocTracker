//
//  BadgeItemView.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


import SwiftUI

struct BadgeItemView: View {
    let badge: Badge
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // 1. Fond (Hexagone)
                HexagonShape()
                    .fill(
                        isUnlocked
                        ? LinearGradient(
                            colors: [badge.category.color, badge.category.color.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [Color.gray.opacity(0.15), Color.gray.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 80, height: 90)
                    // Lueur externe si débloqué
                    .shadow(color: isUnlocked ? badge.category.color.opacity(0.5) : .clear, radius: 8, x: 0, y: 0)
                    .overlay(
                        HexagonShape()
                            .stroke(
                                isUnlocked ? .white.opacity(0.3) : .white.opacity(0.05),
                                lineWidth: 2
                            )
                    )
                
                // 2. Icône
                Image(systemName: badge.icon)
                    .font(.system(size: 30))
                    .foregroundStyle(isUnlocked ? .white : .gray.opacity(0.3))
            }
            .saturation(isUnlocked ? 1.0 : 0.0) // Grayscale total si bloqué
            
            // 3. Nom du badge
            Text(badge.name)
                .font(.caption.bold())
                .foregroundStyle(isUnlocked ? .white : .gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 35, alignment: .top)
        }
        .scaleEffect(isUnlocked ? 1.0 : 0.95) // Légèrement plus petit si bloqué
        .opacity(isUnlocked ? 1.0 : 0.6)
        .animation(.spring, value: isUnlocked)
    }
}

// Forme Hexagone réutilisable
struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let x = rect.midX
        let y = rect.midY
        let side = width / 2
        
        let angle = CGFloat.pi / 3
        for i in 0..<6 {
            let currentAngle = angle * CGFloat(i) - CGFloat.pi / 2
            let point = CGPoint(
                x: x + side * cos(currentAngle),
                y: y + side * sin(currentAngle)
            )
            if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}
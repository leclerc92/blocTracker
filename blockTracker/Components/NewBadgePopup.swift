//
//  NewBadgePopup.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import SwiftUI

struct NewBadgePopup: View {
    let badges: [Badge]
    let onDismiss: () -> Void

    @State private var isAnimating = false
    @State private var glowAnimation = false

    var body: some View {
        ZStack {
            // Fond ultra-flouté type iOS
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .overlay(
                    .ultraThinMaterial.opacity(0.5)
                )
                .onTapGesture { withAnimation { onDismiss() } }

            // Card principale
            VStack(spacing: 0) {
                // Header avec icône système
                VStack(spacing: 8) {
                    // Icon circulaire animé
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.climbingAccent.opacity(0.8),
                                        Color.climbingAccent.opacity(0.3)
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 60, height: 60)
                            .scaleEffect(glowAnimation ? 1.1 : 1.0)
                            .opacity(glowAnimation ? 0.8 : 1.0)

                        Image(systemName: "trophy.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.black)
                            .symbolEffect(.bounce, value: isAnimating)
                    }
                    .padding(.bottom, 4)

                    Text("Nouveau trophée !")
                        .font(.fitness(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Tu viens de débloquer")
                        .font(.fitness(.subheadline))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.top, 35)
                .padding(.bottom, 40)

                // Badge principal avec glow effect
                if let firstBadge = badges.first {
                    ZStack {
                        // Glow pulsant
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        firstBadge.category.color.opacity(0.6),
                                        firstBadge.category.color.opacity(0.2),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 70
                                )
                            )
                            .frame(width: 140, height: 140)
                            .scaleEffect(glowAnimation ? 1.2 : 1.0)
                            .blur(radius: 15)

                        // Badge
                        BadgeItemView(badge: firstBadge, isUnlocked: true)
                            .scaleEffect(1.8)
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .rotation3DEffect(
                                .degrees(isAnimating ? 0 : -180),
                                axis: (x: 0, y: 1, z: 0)
                            )
                    }
                    .frame(height: 140)
                    .padding(.bottom, 30)

                    // Nom du badge
                    VStack(spacing: 8) {
                        Text(firstBadge.name)
                            .font(.fitness(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)

                        // Catégorie pill
                        HStack(spacing: 4) {
                            Circle()
                                .fill(firstBadge.category.color)
                                .frame(width: 6, height: 6)

                            Text(firstBadge.category.rawValue.uppercased())
                                .font(.fitness(.caption2, weight: .bold))
                                .foregroundStyle(firstBadge.category.color)
                                .tracking(1)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(firstBadge.category.color.opacity(0.15))
                        )

                        Text(firstBadge.description)
                            .font(.fitness(.callout))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.horizontal, 28)
                            .padding(.top, 4)
                    }
                    .padding(.bottom, 25)
                }

                // Badge multiple indicator
                if badges.count > 1 {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.climbingAccent)

                        Text("\(badges.count - 1) autre\(badges.count > 2 ? "s" : "") trophée\(badges.count > 2 ? "s" : "") !")
                            .font(.fitness(.subheadline, weight: .semibold))
                            .foregroundStyle(Color.climbingAccent)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.climbingAccent.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.climbingAccent.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.bottom, 25)
                }

                // Bouton d'action
                Button(action: { withAnimation(.spring()) { onDismiss() } }) {
                    HStack(spacing: 8) {
                        Text("Continuer")
                            .font(.fitness(.headline, weight: .bold))

                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(Color.climbingAccent)
                            .shadow(color: Color.climbingAccent.opacity(0.4), radius: 12, x: 0, y: 6)
                    )
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: 360)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.13))
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.6), radius: 40, x: 0, y: 20)
            )
            .padding(30)
            .scaleEffect(isAnimating ? 1 : 0.7)
            .opacity(isAnimating ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimating = true
            }

            // Animation de glow continue
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowAnimation = true
            }
        }
    }
}

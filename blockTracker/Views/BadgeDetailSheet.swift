//
//  BadgeDetailSheet.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//


import SwiftUI

struct BadgeDetailSheet: View {
    let badge: Badge
    let unlockedDate: Date?
    @Environment(\.dismiss) var dismiss

    var isUnlocked: Bool { unlockedDate != nil }

    @State private var isAppearing = false

    var body: some View {
        ZStack {
            // Fond dégradé dynamique selon la catégorie
            LinearGradient(
                colors: isUnlocked
                    ? [Color.black, badge.category.color.opacity(0.15), Color.black]
                    : [Color.black, Color.gray.opacity(0.1), Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Drag indicator
                Capsule()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 20)

                // Catégorie badge
                HStack(spacing: 6) {
                    Circle()
                        .fill(badge.category.color)
                        .frame(width: 8, height: 8)

                    Text(badge.category.rawValue.uppercased())
                        .font(.fitness(.caption, weight: .bold))
                        .foregroundStyle(badge.category.color)
                        .tracking(1.2)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(badge.category.color.opacity(0.15))
                        .overlay(
                            Capsule()
                                .stroke(badge.category.color.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.bottom, 30)

                // Badge central avec animation
                ZStack {
                    // Glow effect si débloqué
                    if isUnlocked {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [badge.category.color.opacity(0.4), .clear],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 200, height: 200)
                            .blur(radius: 20)
                            .opacity(isAppearing ? 1 : 0)
                    }

                    BadgeItemView(badge: badge, isUnlocked: isUnlocked)
                        .scaleEffect(2.2)
                        .scaleEffect(isAppearing ? 1 : 0.8)
                        .opacity(isAppearing ? 1 : 0)
                }
                .frame(height: 200)
                .padding(.bottom, 35)

                // Titre
                Text(badge.name)
                    .font(.fitness(size: 32, weight: .bold))
                    .foregroundStyle(isUnlocked ? .white : .gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 12)

                // Description
                Text(badge.description)
                    .font(.fitness(.body))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal, 32)
                    .padding(.bottom, 25)

                // Date card
                if let date = unlockedDate {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar.badge.checkmark")
                            .font(.system(size: 20))
                            .foregroundStyle(badge.category.color)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Débloqué le")
                                .font(.fitness(.caption2))
                                .foregroundStyle(.white.opacity(0.6))

                            Text(date.formatted(Date.French.longDate))
                                .font(.fitness(.subheadline, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(badge.category.color.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 24)
                } else {
                    HStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.gray)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Statut")
                                .font(.fitness(.caption2))
                                .foregroundStyle(.white.opacity(0.4))

                            Text("Non débloqué")
                                .font(.fitness(.subheadline, weight: .semibold))
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(30)
        .presentationBackground(.clear)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAppearing = true
            }
        }
    }
}
//
//  DataManagementService.swift
//  blockTracker
//
//  Created by Claude Code on 08/01/2026.
//

import Foundation
import SwiftData

@Observable
class DataManagementService {

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Export

    /// Exporte toutes les données SwiftData au format JSON
    func exportToJSON() -> Result<Data, DataManagementError> {
        do {
            // Fetch toutes les sessions (triées par date)
            let sessionDescriptor = FetchDescriptor<SessionModel>(
                sortBy: [SortDescriptor(\.startDate)]
            )
            let sessions = try modelContext.fetch(sessionDescriptor)

            // Fetch tous les badges débloqués
            let badgeDescriptor = FetchDescriptor<UnlockedBadgeModel>()
            let badges = try modelContext.fetch(badgeDescriptor)

            // Conversion vers DTOs
            let sessionDTOs = sessions.map { session in
                SessionDTO(
                    id: session.persistentModelID.hashValue.description,
                    date: session.startDate,
                    blocs: session.blocs.map { bloc in
                        BlocDTO(
                            id: bloc.persistentModelID.hashValue.description,
                            level: bloc.level,
                            completed: bloc.completed,
                            attempts: bloc.attempts,
                            overhang: bloc.overhang
                        )
                    }
                )
            }

            let badgeDTOs = badges.map { badge in
                UnlockedBadgeDTO(
                    id: badge.persistentModelID.hashValue.description,
                    badgeId: badge.badgeId,
                    unlockedAt: badge.unlockedAt
                )
            }

            // Structure d'export
            let exportData = ExportData(
                version: "1.0",
                exportDate: Date(),
                data: DataPayload(
                    sessions: sessionDTOs,
                    unlockedBadges: badgeDTOs
                )
            )

            // Encodage JSON
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

            let jsonData = try encoder.encode(exportData)

            return .success(jsonData)

        } catch {
            return .failure(.exportFailed(error.localizedDescription))
        }
    }

    // MARK: - Import

    /// Importe des données JSON et remplace toutes les données existantes
    func importFromJSON(_ data: Data) -> Result<Void, DataManagementError> {
        do {
            // Décodage JSON
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let exportData = try decoder.decode(ExportData.self, from: data)

            // Validation de version
            guard exportData.version == "1.0" else {
                return .failure(.incompatibleVersion)
            }

            // SUPPRESSION de toutes les données existantes
            try deleteAllData()

            // IMPORT des sessions avec leurs blocs
            for sessionDTO in exportData.data.sessions {
                // Créer la session
                let session = SessionModel(date: sessionDTO.date, blocs: [])
                modelContext.insert(session)

                // Créer les blocs avec référence parent
                for blocDTO in sessionDTO.blocs {
                    let bloc = BlocModel(
                        level: blocDTO.level,
                        completed: blocDTO.completed,
                        attempts: blocDTO.attempts,
                        overhang: blocDTO.overhang,
                        session: session
                    )
                    session.blocs.append(bloc)
                }
            }

            // SAUVEGARDE (transaction atomique)
            try modelContext.save()

            // RECALCUL des badges depuis les sessions importées
            try recalculateBadges()

            return .success(())

        } catch let error as DecodingError {
            return .failure(.invalidJSON)
        } catch {
            return .failure(.importFailed(error.localizedDescription))
        }
    }

    // MARK: - Private Helpers

    /// Supprime toutes les données SwiftData
    private func deleteAllData() throws {
        // Supprimer toutes les sessions (cascade delete supprime automatiquement les blocs)
        let sessionDescriptor = FetchDescriptor<SessionModel>()
        let sessions = try modelContext.fetch(sessionDescriptor)
        sessions.forEach { modelContext.delete($0) }

        // Supprimer tous les badges
        let badgeDescriptor = FetchDescriptor<UnlockedBadgeModel>()
        let badges = try modelContext.fetch(badgeDescriptor)
        badges.forEach { modelContext.delete($0) }
    }

    /// Recalcule tous les badges basés sur les sessions actuelles
    private func recalculateBadges() throws {
        // Fetch toutes les sessions
        let sessionDescriptor = FetchDescriptor<SessionModel>()
        let allSessions = try modelContext.fetch(sessionDescriptor)

        // Calculer les statistiques
        let stats = StatsService.computeStats(from: allSessions)

        // Débloquer les badges appropriés
        let badgeService = BadgeService(modelContext: modelContext)
        _ = badgeService.checkAndUnlockBadges(stats: stats)
    }
}

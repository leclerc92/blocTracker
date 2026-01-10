//
//  DataTransferObjects.swift
//  blockTracker
//
//  Created by Claude Code on 08/01/2026.
//

import Foundation

// MARK: - Export Container

/// Structure principale pour l'export JSON
struct ExportData: Codable {
    let version: String
    let exportDate: Date
    let data: DataPayload
}

/// Payload contenant toutes les données à exporter
struct DataPayload: Codable {
    let sessions: [SessionDTO]
    let unlockedBadges: [UnlockedBadgeDTO]
}

// MARK: - Session DTO

/// Data Transfer Object pour SessionModel
struct SessionDTO: Codable {
    let id: String
    let startDate: Date
    let endDate: Date?  
    let blocs: [BlocDTO]
}

// MARK: - Bloc DTO

/// Data Transfer Object pour BlocModel
struct BlocDTO: Codable {
    let id: String
    let level: Int
    let completed: Bool
    let attempts: Int
    let overhang: Bool
    let validate: Bool
    let date: Date
}

// MARK: - Badge DTO

/// Data Transfer Object pour UnlockedBadgeModel
struct UnlockedBadgeDTO: Codable {
    let id: String
    let badgeId: String
    let unlockedAt: Date
}

// MARK: - Errors

/// Erreurs de gestion des données
enum DataManagementError: LocalizedError {
    case exportFailed(String)
    case importFailed(String)
    case invalidJSON
    case incompatibleVersion
    case corruptedData
    case fileAccessError

    var errorDescription: String? {
        switch self {
        case .exportFailed(let details):
            return "Erreur d'export : \(details)"
        case .importFailed(let details):
            return "Erreur d'import : \(details)"
        case .invalidJSON:
            return "Fichier invalide. Veuillez sélectionner un fichier d'export blockTracker valide."
        case .incompatibleVersion:
            return "Version de fichier incompatible. Veuillez mettre à jour l'application."
        case .corruptedData:
            return "Les données du fichier sont corrompues."
        case .fileAccessError:
            return "Impossible d'accéder au fichier."
        }
    }
}

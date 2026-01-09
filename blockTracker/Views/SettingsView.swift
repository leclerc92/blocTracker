//
//  SettingsView.swift
//  blockTracker
//
//  Created by Claude Code on 08/01/2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {

    @Environment(\.modelContext) private var modelContext

    // État pour les modals
    @State private var showShareSheet = false
    @State private var showDocumentPicker = false
    @State private var showConfirmImport = false

    // État pour les résultats
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Données d'export
    @State private var exportFileURL: URL?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // Section : Données
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Données")
                                .font(.fitness(.title3, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            VStack(spacing: 12) {
                                // Bouton Export
                                Button(action: handleExport) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.fitness(.body, weight: .semibold))
                                            .foregroundColor(.climbingAccent)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Exporter les données")
                                                .font(.fitness(.body, weight: .semibold))
                                                .foregroundColor(.white)

                                            Text("Sauvegarder toutes vos sessions")
                                                .font(.fitness(.caption, weight: .regular))
                                                .foregroundColor(.textSecondary)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    .padding()
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                }

                                // Bouton Import
                                Button(action: { showConfirmImport = true }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.down")
                                            .font(.fitness(.body, weight: .semibold))
                                            .foregroundColor(.climbingAccent)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Importer les données")
                                                .font(.fitness(.body, weight: .semibold))
                                                .foregroundColor(.white)

                                            Text("Restaurer depuis un backup")
                                                .font(.fitness(.caption, weight: .regular))
                                                .foregroundColor(.textSecondary)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    .padding()
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }

                        Spacer()
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Réglages")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .sheet(isPresented: $showShareSheet) {
                if let url = exportFileURL {
                    ShareSheet(items: [url])
                }
            }
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker(onPick: handleImport)
            }
            .alert("Confirmation", isPresented: $showConfirmImport) {
                Button("Annuler", role: .cancel) { }
                Button("Remplacer", role: .destructive) {
                    showDocumentPicker = true
                }
            } message: {
                Text("Cette action remplacera toutes vos données actuelles. Continuer ?")
            }
            .alert("Résultat", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    // MARK: - Handlers

    private func handleExport() {
        let service = DataManagementService(modelContext: modelContext)

        let result = service.exportToJSON()

        switch result {
        case .success(let jsonData):
            // Générer le nom de fichier avec la date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: Date())
            let filename = "blockTracker_backup_\(dateString).json"

            // Créer le fichier temporaire
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(filename)

            do {
                try jsonData.write(to: tempURL)
                self.exportFileURL = tempURL
                self.showShareSheet = true
            } catch {
                self.alertMessage = "Erreur lors de la création du fichier : \(error.localizedDescription)"
                self.showAlert = true
            }

        case .failure(let error):
            self.alertMessage = error.localizedDescription
            self.showAlert = true
        }
    }

    private func handleImport(fileURL: URL) {
        // Tenter l'accès au fichier (avec asCopy: true, le fichier est déjà accessible)
        let needsAccess = fileURL.startAccessingSecurityScopedResource()
        defer {
            if needsAccess {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }

        do {
            // Lire le fichier
            let data = try Data(contentsOf: fileURL)

            // Importer via le service
            let service = DataManagementService(modelContext: modelContext)
            let result = service.importFromJSON(data)

            switch result {
            case .success:
                self.alertMessage = "✅ Données importées avec succès !\n\nToutes vos sessions ont été restaurées."
                self.showAlert = true

            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }

        } catch {
            self.alertMessage = "Erreur lors de la lecture du fichier : \(error.localizedDescription)"
            self.showAlert = true
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .modelContainer(previewContainer)
}

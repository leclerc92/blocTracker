# Plan d'implémentation : Export/Import JSON

## Objectif

Ajouter une fonctionnalité d'export/import JSON pour sauvegarder et restaurer toutes les données SwiftData de l'application blockTracker.

## Vue d'ensemble

- **Emplacement UI** : Nouvel onglet "Réglages" (5ème tab)
- **Export** : Partage d'un fichier JSON via share sheet iOS
- **Import** : Sélection de fichier JSON via document picker, remplacement complet des données
- **Format** : JSON structuré avec version, date d'export, sessions (avec blocs imbriqués), badges débloqués

## Architecture de la solution

### Structure JSON

```json
{
  "version": "1.0",
  "exportDate": "2026-01-08T14:30:00Z",
  "data": {
    "sessions": [
      {
        "id": "UUID",
        "date": "2026-01-08T14:30:00Z",
        "blocs": [
          {
            "id": "UUID",
            "level": 5,
            "completed": true,
            "attempts": 2,
            "overhang": false
          }
        ]
      }
    ],
    "unlockedBadges": [
      {
        "id": "UUID",
        "badgeId": "first_session",
        "unlockedAt": "2026-01-08T14:30:00Z"
      }
    ]
  }
}
```

**Points clés** :
- Seulement les propriétés persistées (pas les propriétés calculées comme `score`, `blocsScore`)
- Structure imbriquée préserve la relation parent-child SessionModel → BlocModel
- Dates au format ISO 8601 (timezone-aware)
- Champ `version` pour compatibilité future

### Modèles de données (DTOs Codable)

Créer des structs Codable pour la sérialisation :
- `ExportData` : Conteneur principal avec version, exportDate, data
- `DataPayload` : sessions + unlockedBadges
- `SessionDTO` : id, date, blocs[]
- `BlocDTO` : id, level, completed, attempts, overhang
- `UnlockedBadgeDTO` : id, badgeId, unlockedAt

### Service layer

`DataManagementService` (pattern `@Observable` avec `ModelContext`) :

**Export** :
1. Fetch toutes les sessions, blocs, badges depuis SwiftData
2. Convertir en DTOs (préserver la hiérarchie sessions → blocs)
3. Encoder en JSON avec `JSONEncoder` (`.iso8601` pour les dates)
4. Retourner `Data` pour partage

**Import** :
1. Décoder JSON avec validation de version
2. **Supprimer toutes les données existantes** (sessions, badges)
3. Recréer les SessionModel avec leurs BlocModel (relation parent-child)
4. Sauvegarder (transaction atomique)
5. **Recalculer tous les badges** via `BadgeService.checkAndUnlockBadges()`

**Note importante** : Ne pas importer les badges directement. Après import des sessions, recalculer les badges depuis zéro pour garantir la cohérence avec les données.

### UI Components

**SettingsView** :
- ScrollView avec sections "Données"
- Bouton "Exporter les données" (icône `square.and.arrow.up`) → ShareSheet
- Bouton "Importer les données" (icône `square.and.arrow.down`) → Alert de confirmation → DocumentPicker
- Gestion d'état : `@State` pour show/hide modals, error alerts
- Theme : `.cardBackground`, `.climbingAccent`, `.fitness()` fonts

**ShareSheet** : Wrapper UIActivityViewController
**DocumentPicker** : Wrapper UIDocumentPickerViewController avec Coordinator

**MainTabView** : Ajouter 5ème tab "Réglages" avec icône `gearshape.fill`

## Étapes d'implémentation

### Phase 1 : Modèles et Service (Foundation)

**1. Créer `/Users/clementleclerc/programmation/ios/blockTracker/blockTracker/Models/DataTransferObjects.swift`**
   - Définir tous les DTOs Codable
   - Ajouter enum `DataManagementError: LocalizedError` avec messages en français

**2. Créer `/Users/clementleclerc/programmation/ios/blockTracker/blockTracker/Services/DataManagementService.swift`**
   - Structure : `@Observable class` avec `private var modelContext: ModelContext`
   - Méthode `exportToJSON() -> Result<Data, DataManagementError>`
     - Fetch avec `FetchDescriptor<SessionModel>()` et `FetchDescriptor<UnlockedBadgeModel>()`
     - Mapper vers DTOs (préserver hiérarchie sessions.blocs)
     - Encoder avec `JSONEncoder` (`.iso8601`, `.prettyPrinted`, `.sortedKeys`)
   - Méthode `importFromJSON(_ data: Data) -> Result<Void, DataManagementError>`
     - Decoder avec `JSONDecoder` (`.iso8601`)
     - Valider version == "1.0"
     - DELETE toutes les sessions (cascade delete supprime blocs) et badges
     - Recréer sessions + blocs avec relation parent-child
     - `try modelContext.save()`
     - Recalculer badges : `StatsService.computeStats()` puis `BadgeService.checkAndUnlockBadges()`

### Phase 2 : UI Components

**3. Créer `/Users/clementleclerc/programmation/ios/blockTracker/blockTracker/Components/ShareSheet.swift`**
   - `UIViewControllerRepresentable` wrapper pour `UIActivityViewController`
   - Propriété `let items: [Any]` (URL du fichier temporaire)

**4. Créer `/Users/clementleclerc/programmation/ios/blockTracker/blockTracker/Components/DocumentPicker.swift`**
   - `UIViewControllerRepresentable` wrapper pour `UIDocumentPickerViewController`
   - Coordinator pour gérer callback `didPickDocumentsAt`
   - Filter par `.json` : `UIDocumentPickerViewController(forOpeningContentTypes: [.json])`
   - Closure `let onPick: (URL) -> Void`

### Phase 3 : Vue Réglages

**5. Créer `/Users/clementleclerc/programmation/ios/blockTracker/blockTracker/Views/SettingsView.swift`**

Structure :
```swift
NavigationStack {
    ZStack {
        Color.black.ignoresSafeArea()
        ScrollView {
            VStack(spacing: 20) {
                // Section Données
                VStack(alignment: .leading, spacing: 12) {
                    Text("Données").font(.fitness(.title3, weight: .bold))

                    // Bouton Export
                    Button(action: handleExport) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Exporter les données")
                            Spacer()
                        }
                    }

                    // Bouton Import
                    Button(action: { showConfirmImport = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Importer les données")
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)
            }
            .padding()
        }
    }
    .navigationTitle("Réglages")
    .navigationBarTitleDisplayMode(.large)
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
```

Handlers :
- `handleExport()` :
  - Appeler `DataManagementService.exportToJSON()`
  - Créer fichier temporaire `blockTracker_backup_YYYY-MM-DD.json`
  - Écrire data, set `exportFileURL`, show `ShareSheet`
- `handleImport(fileURL: URL)` :
  - Accéder security-scoped resource
  - Lire `Data(contentsOf: fileURL)`
  - Appeler `DataManagementService.importFromJSON()`
  - Afficher résultat (succès/erreur)

@Environment :
- `@Environment(\.modelContext) private var modelContext`

### Phase 4 : Intégration TabView

**6. Modifier `/Users/clementleclerc/programmation/ios/blockTracker/blockTracker/Views/MainTabView.swift`**

Changements :
1. Ligne 15 : Ajouter `settings` au Tab enum
   ```swift
   enum Tab {
       case stats, sessions, badges, new, settings
   }
   ```

2. Après le tab "Trophées" (ligne 78), ajouter :
   ```swift
   // Onglet 5 : Réglages
   SettingsView()
       .tabItem {
           Label("Réglages", systemImage: "gearshape.fill")
       }
       .tag(Tab.settings)
   ```

## Gestion des erreurs

**Cas d'erreur à gérer** :

1. **Export échoue** : Alert "Erreur d'export : [détail]"
2. **Import JSON invalide** : Alert "Fichier invalide. Veuillez sélectionner un fichier d'export blockTracker valide."
3. **Version incompatible** : Alert "Version de fichier incompatible."
4. **Base de données vide (export)** : Exporter JSON avec arrays vides (valide)
5. **Import échoue en cours** : Transaction rollback automatique (SwiftData), aucune donnée perdue

**Transaction safety** :
- Import = DELETE + INSERT + SAVE en une seule transaction
- Si erreur avant `save()`, aucun changement persisté
- Après `save()` réussi, recalculer badges (non-transactionnel mais réversible)

## Points critiques

### Relations parent-child

**CRITIQUE** : Lors de l'import, toujours créer BlocModel avec référence au SessionModel parent :

```swift
for sessionDTO in exportData.data.sessions {
    let session = SessionModel(date: sessionDTO.date, blocs: [])
    modelContext.insert(session)

    for blocDTO in sessionDTO.blocs {
        let bloc = BlocModel(
            level: blocDTO.level,
            completed: blocDTO.completed,
            attempts: blocDTO.attempts,
            overhang: blocDTO.overhang,
            session: session  // ← ESSENTIEL
        )
        session.blocs.append(bloc)
    }
}
```

### Recalcul des badges

**CRITIQUE** : Après import, toujours recalculer les badges depuis les sessions importées :

```swift
// Après save() réussi
let allSessions = try modelContext.fetch(FetchDescriptor<SessionModel>())
let stats = StatsService.computeStats(from: allSessions)
let _ = BadgeService(modelContext: modelContext).checkAndUnlockBadges(stats: stats)
```

Cela garantit que les badges correspondent exactement aux achievements dans les données importées.

## Fichiers critiques

**Nouveaux fichiers** :
1. `Models/DataTransferObjects.swift` - DTOs et error enum
2. `Services/DataManagementService.swift` - Logique core
3. `Views/SettingsView.swift` - UI principale
4. `Components/ShareSheet.swift` - Wrapper share sheet
5. `Components/DocumentPicker.swift` - Wrapper document picker

**Fichiers à modifier** :
1. `Views/MainTabView.swift` - Ajouter 5ème tab (2 changements mineurs)

## Vérification

### Tests manuels end-to-end

1. **Export base vide** :
   - Lancer app nouvelle installation
   - Aller dans Réglages → Exporter
   - Vérifier JSON avec `sessions: [], unlockedBadges: []`

2. **Export avec données** :
   - Créer 2-3 sessions avec plusieurs blocs
   - Débloquer quelques badges
   - Exporter
   - Vérifier structure JSON : sessions imbriquent blocs, badges présents

3. **Import données complètes** :
   - Exporter données existantes (backup)
   - Supprimer toutes les sessions manuellement
   - Importer le backup
   - Vérifier : toutes sessions restaurées, blocs corrects, badges recalculés

4. **Import remplace données** :
   - Base avec 5 sessions
   - Importer backup avec 2 sessions
   - Vérifier : seulement 2 sessions présentes (remplacement confirmé)

5. **Import fichier invalide** :
   - Créer fichier .json avec contenu invalide
   - Tenter import
   - Vérifier : alerte d'erreur, données actuelles intactes

6. **Scénario complet (réinstallation)** :
   - Exporter données complètes
   - Supprimer app (simulation perte données)
   - Réinstaller app
   - Importer backup
   - Vérifier : toutes données restaurées, statistiques correctes, badges recalculés

### Validation des propriétés calculées

Après import, vérifier que les propriétés calculées fonctionnent :
- `SessionModel.blocsScore` = somme des scores des blocs
- `BlocModel.score` = calculé via formule (pas sérialisé)
- Statistiques globales correctes dans StatsView
- Graphiques affichent les données importées

### Performance

Tester avec dataset conséquent :
- 50+ sessions
- 500+ blocs
- Vérifier temps d'export/import acceptable (< 5 secondes)

## Conventions et style

- **Langue** : UI en français ("Exporter", "Importer", "Réglages")
- **Theme** : Fond noir, `.cardBackground` pour cartes, `.climbingAccent` pour boutons primaires
- **Fonts** : `.fitness()` pour tous les textes
- **Nommage** : camelCase pour fichiers (sauf Models : lowercase), PascalCase pour types
- **Commentaires** : En français si présents, mais minimiser (code auto-explicatif préféré)

## Extensions futures (hors scope)

- Fusion de données (vs remplacement)
- Import sélectif de sessions
- Backups automatiques
- Sync iCloud
- Migration de schéma entre versions

---

**Résumé** : Implémentation simple et robuste, suivant les patterns existants (BadgeService), avec gestion d'erreurs complète et garantie d'intégrité des données via transactions atomiques et recalcul systématique des badges post-import.

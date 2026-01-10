# Plan d'Amélioration - blockTracker

**Date**: 9 janvier 2026
**Version actuelle**: 1.0
**Statut**: MVP Production-Ready avec améliorations recommandées

---

## Résumé Exécutif

blockTracker est une application iOS de suivi d'escalade/bloc bien architecturée, construite avec SwiftUI et SwiftData. Le projet contient **3 659 lignes de code Swift** réparties sur **36 fichiers**, avec une architecture propre et moderne.

**Note globale: 7.5/10**

### Points Forts ✅
- Architecture claire avec séparation des responsabilités
- Patterns SwiftUI modernes (Observable, SwiftData)
- Algorithme de scoring sophistiqué et bien pensé
- Interface utilisateur polie avec design cohérent
- Système de badges complet (81 badges)

### Points Faibles ❌
- **Aucun test** (gap critique)
- Gestion d'erreurs limitée
- Accessibilité incomplète
- Pas de synchronisation/sauvegarde
- Préoccupations de performance avec gros volumes

---

## 1. Problèmes Critiques (À Traiter en Priorité)

### 1.1 Absence de Tests ⚠️ CRITIQUE

**Problème**: Aucun test unitaire, d'intégration ou UI trouvé dans le projet.

**Impact**:
- Impossible de garantir la stabilité du code
- Risque élevé de régression lors de modifications
- Algorithme de scoring non validé formellement

**Solution**:
```
📁 Créer structure de tests:
   - blockTrackerTests/
     - Models/
       - BlocModelTests.swift (test scoring algorithm)
       - SessionModelTests.swift (test computed properties)
     - Services/
       - StatsServiceTests.swift
       - BadgeServiceTests.swift
       - DataManagementServiceTests.swift
     - Badges/
       - BadgeConditionsTests.swift
```

**Tâches**:
1. Créer target de tests dans Xcode
2. Tester l'algorithme de score avec cas limites
3. Tester les conditions des badges
4. Tester import/export JSON
5. Tester les statistiques globales
6. **Objectif**: 80% de couverture de code

**Effort estimé**: 3-5 jours

---

### 1.2 Gestion d'Erreurs Insuffisante ⚠️ CRITIQUE

**Problème**: Utilisation excessive de `try?` qui masque les erreurs.

**Fichiers concernés**:
- `DataManagementService.swift`: lignes 47, 89, 118
- `BadgeService.swift`: ligne 57
- `SessionDetailView.swift`: ligne 87
- Multiples autres occurrences

**Impact**:
- Échecs silencieux sans feedback utilisateur
- Impossible de déboguer en production
- Expérience utilisateur dégradée

**Solution**:
```swift
// ❌ AVANT
try? modelContext.save()

// ✅ APRÈS
do {
    try modelContext.save()
} catch {
    logger.error("Failed to save session: \(error)")
    showErrorAlert = true
    errorMessage = "Impossible de sauvegarder la session"
}
```

**Tâches**:
1. Créer enum `AppError` personnalisé
2. Remplacer tous les `try?` par `do-catch`
3. Ajouter logging avec `os.Logger`
4. Créer composant `ErrorAlert` réutilisable
5. Ajouter états d'erreur dans AppState

**Effort estimé**: 2-3 jours

---

### 1.3 Validation de Données Manquante ⚠️ HAUTE

**Problème**: Pas de validation des entrées utilisateur et données importées.

**Cas problématiques**:
- Niveaux hors bornes (devrait être 1-16)
- Sessions avec 0 blocs
- Dates invalides ou futures
- Tentatives négatives ou extrêmes
- Import de JSON malformé

**Solution**:
```swift
// Créer Models/Validation/DataValidator.swift
struct DataValidator {
    static func validateLevel(_ level: Int) throws {
        guard (1...16).contains(level) else {
            throw ValidationError.invalidLevel(level)
        }
    }

    static func validateAttempts(_ attempts: Int) throws {
        guard (1...99).contains(attempts) else {
            throw ValidationError.invalidAttempts(attempts)
        }
    }

    static func validateSession(_ session: SessionModel) throws {
        guard !session.blocs.isEmpty else {
            throw ValidationError.emptySession
        }
    }
}
```

**Tâches**:
1. Créer système de validation centralisé
2. Valider lors de la création/modification de blocs
3. Valider lors de l'import JSON
4. Empêcher la sauvegarde de sessions vides
5. Ajouter feedback visuel de validation

**Effort estimé**: 2 jours

---

### 1.4 Accessibilité VoiceOver Absente ⚠️ HAUTE

**Problème**: Aucun label d'accessibilité, app inutilisable pour malvoyants.

**Impact**: Exclut des utilisateurs, non conforme aux guidelines Apple.

**Solution**:
```swift
// Exemple pour BlocCard.swift
VStack {
    Text("Niveau \(bloc.level)")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("Bloc niveau \(bloc.level), \(bloc.completed ? "réussi" : "échoué"), \(bloc.attempts) tentatives")
.accessibilityHint("Double-tap pour voir les détails")

// Exemple pour BadgeItemView.swift
HexagonShape()
    .accessibilityLabel("\(badge.name), \(isUnlocked ? "débloqué" : "verrouillé")")
    .accessibilityHint(badge.description)
```

**Tâches**:
1. Audit complet accessibilité VoiceOver
2. Ajouter labels à tous les composants interactifs
3. Tester graphiques avec accessibilité (Charts)
4. Ajouter traits d'accessibilité appropriés
5. Tester avec VoiceOver activé

**Effort estimé**: 2-3 jours

---

## 2. Problèmes de Performance (Priorité Haute)

### 2.1 Requêtes SwiftData Non Optimisées

**Problème**: `@Query` sans prédicats charge toutes les données.

**Fichiers concernés**:
- `StatsView.swift`: ligne 22 - charge toutes les sessions
- `SessionListView.swift`: ligne 15 - idem
- `BadgesListView.swift`: ligne 18 - charge tous les badges

**Impact**: Ralentissements avec 1000+ sessions.

**Solution**:
```swift
// SessionListView.swift
@Query(
    sort: \SessionModel.date,
    order: .reverse,
    limit: 50 // Pagination
) private var sessions: [SessionModel]

// Ajouter pagination
@State private var pageSize = 50
@State private var currentPage = 0
```

**Tâches**:
1. Ajouter pagination aux listes
2. Implémenter "Load More" ou scroll infini
3. Ajouter filtres par date (semaine, mois, année)
4. Utiliser prédicats pour filtrage
5. Mesurer performance avec test data (1000+ sessions)

**Effort estimé**: 2 jours

---


### 2.3 Badge Checking Inefficace

**Problème**: Boucle sur 81 badges à chaque vérification.

**Fichier**: `BadgeService.swift`: ligne 28

**Solution**:
```swift
// BadgeService.swift - Ajouter dirty flag
class BadgeService {
    private var dirtyBadges: Set<Int> = []

    func markBadgesDirty(for change: DataChange) {
        // Marquer seulement les badges affectés
        switch change {
        case .sessionAdded:
            dirtyBadges.formUnion(sessionBadgeIds)
        case .levelCompleted(let level):
            dirtyBadges.insert(badgeIdForLevel(level))
        }
    }

    func checkDirtyBadges(stats: GlobalStatsData) -> [Badge] {
        // Vérifier seulement les badges marqués
    }
}
```

**Tâches**:
1. Implémenter système de dirty flags
2. Optimiser vérification avec early exit
3. Profiler temps de vérification

**Effort estimé**: 1 jour

---

## 3. Dette Technique (Priorité Moyenne)



---

### 3.2 Code Dupliqué

**Problème**: Logique de vérification de badges dupliquée.

**Fichiers**:
- `ActiveSessionView.swift`: lignes 164-175
- `SessionDetailView.swift`: lignes 180-191

**Solution**:
```swift
// Créer Views/Helpers/BadgeCheckingHelper.swift
struct BadgeCheckingHelper {
    static func checkAndShowBadges(
        context: ModelContext,
        sessions: [SessionModel],
        currentBadges: inout [Badge],
        showPopup: Binding<Bool>
    ) {
        let stats = StatsService.computeStats(from: sessions)
        let badgeService = BadgeService(modelContext: context)
        let newBadges = badgeService.checkAndUnlockBadges(stats: stats)

        if !newBadges.isEmpty {
            currentBadges = newBadges
            showPopup.wrappedValue = true
        }
    }
}
```

**Autres duplications**:
- Formatage de dates (créer extension Date)
- Formatage de graphiques
- Styles de cartes

**Tâches**:
1. Identifier toutes les duplications (>5 lignes similaires)
2. Extraire en fonctions/helpers réutilisables
3. Créer extensions pour patterns communs

**Effort estimé**: 2 jours

---

---

### 3.4 Documentation Manquante

**Problème**: Pas de documentation header sur les fichiers.

**Solution**:
```swift
//
//  BlocModel.swift
//  blockTracker
//
//  Modèle représentant un bloc d'escalade individuel.
//  Contient l'algorithme de scoring sophistiqué basé sur:
//  - Difficulté exponentielle (niveau 1-16)
//  - Style (dévers = bonus 1.25x)
//  - Réussite et efficacité
//  - Tentatives d'échec (récompense l'effort)
//
//  Created by [Author] on [Date]
//

/// Modèle SwiftData représentant un problème de bloc d'escalade
@Model
final class BlocModel {
    /// Niveau de difficulté (1-16)
    var level: Int

    /// Indique si le bloc est réussi
    var completed: Bool

    /// Nombre de tentatives (minimum 1)
    var attempts: Int

    // ...
}
```

**Tâches**:
1. Ajouter headers à tous les fichiers
2. Documenter classes et structs publics
3. Documenter fonctions complexes
4. Ajouter commentaires inline pour code non évident

**Effort estimé**: 2 jours

---

## 4. Fonctionnalités Manquantes (Priorité Moyenne)

### 4.1 Synchronisation iCloud

**Besoin**: Synchroniser données entre appareils de l'utilisateur.

**Solution**:
```swift
// blockTrackerApp.swift
WindowGroup {
    ContentView()
        .modelContainer(for: [SessionModel.self, BlocModel.self]) {
            // Activer iCloud sync
            container.enableCloudSync()
        }
}
```

**Tâches**:
1. Activer CloudKit dans Xcode
2. Configurer iCloud container
3. Tester sync entre appareils
4. Gérer conflits de merge
5. Ajouter indicateur de sync UI

**Effort estimé**: 3-4 jours

---

### 4.2 Filtrage Temporel des Statistiques

**Besoin**: Voir stats par semaine, mois, année.

**Solution**:
```swift
// StatsView.swift - Ajouter Picker
enum StatsPeriod: String, CaseIterable {
    case week = "Semaine"
    case month = "Mois"
    case year = "Année"
    case all = "Tout"
}

@State private var selectedPeriod: StatsPeriod = .month

Picker("Période", selection: $selectedPeriod) {
    ForEach(StatsPeriod.allCases, id: \.self) { period in
        Text(period.rawValue).tag(period)
    }
}
.pickerStyle(.segmented)

// Filtrer sessions par période
var filteredSessions: [SessionModel] {
    let cutoffDate = selectedPeriod.cutoffDate
    return sessions.filter { $0.date >= cutoffDate }
}
```

**Tâches**:
1. Créer Picker de période
2. Implémenter filtrage par date
3. Mettre à jour graphiques
4. Ajouter comparaison période précédente

**Effort estimé**: 1-2 jours

---

### 4.3 Sauvegarde/Restauration Automatique

**Besoin**: Protection contre perte de données.

**Solution**:
```swift
// Services/BackupService.swift
class BackupService {
    func scheduleAutomaticBackup() {
        // Backup quotidien via BackgroundTasks
    }

    func createBackup() async throws {
        let exporter = DataManagementService()
        let data = try exporter.exportData(sessions: sessions)
        // Sauvegarder dans iCloud Drive
    }

    func restoreFromBackup(url: URL) async throws {
        // Restaurer depuis backup
    }
}
```

**Tâches**:
1. Implémenter service de backup
2. Ajouter backup automatique quotidien
3. Créer UI de restauration
4. Tester scénario de perte de données

**Effort estimé**: 2-3 jours

---

### 4.4 Session Pause/Resume

**Besoin**: Pouvoir mettre une session en pause.

**Solution**:
```swift
// SessionModel.swift - Ajouter propriétés
@Model
final class SessionModel {
    // ... existing ...
    var isPaused: Bool = false
    var pausedAt: Date?
    var totalPauseDuration: TimeInterval = 0
}

// ActiveSessionView.swift - Ajouter bouton pause
Button {
    if session.isPaused {
        session.resume()
    } else {
        session.pause()
    }
} label: {
    Image(systemName: session.isPaused ? "play.fill" : "pause.fill")
}
```

**Tâches**:
1. Ajouter propriétés pause à SessionModel
2. Créer UI pause/resume
3. Calculer durée effective sans pauses
4. Persister état lors du kill app

**Effort estimé**: 1 jour

---



## 6. Corrections de Bugs Identifiés

### 6.1 Bug: Modification de Date Inline

**Fichier**: `SessionDetailView.swift`: ligne 70

**Problème**:
```swift
DatePicker("", selection: $session.date, displayedComponents: .date)
```
- Mutation directe du modèle
- Pas de validation
- Peut casser l'ordre des sessions

**Solution**:
```swift
@State private var editedDate: Date

DatePicker("", selection: $editedDate, displayedComponents: .date)
    .onChange(of: editedDate) { oldValue, newValue in
        guard newValue <= Date() else {
            editedDate = oldValue
            showAlert = true
            return
        }
        session.date = newValue
        try? modelContext.save()
    }
```

---


### 6.3 Bug: Révocation Silencieuse de Badges

**Fichier**: `BadgeService.swift`: ligne 55-66

**Problème**: Badges révoqués sans notification utilisateur.

**Solution**:
```swift
func checkAndUnlockBadges(stats: GlobalStatsData) -> (unlocked: [Badge], revoked: [Badge]) {
    // ... existing logic ...
    return (newlyUnlocked, revokedBadges)
}

// Dans les vues
let (newBadges, revokedBadges) = badgeService.checkAndUnlockBadges(stats: stats)
if !revokedBadges.isEmpty {
    showRevokedAlert = true
    revokedBadgesList = revokedBadges
}
```

---

## 7. Améliorations UI/UX (Priorité Basse)

### 7.1 Feedback Haptique

**Besoin**: Retour tactile sur actions importantes.

**Solution**:
```swift
// Helpers/HapticManager.swift
import UIKit

enum HapticManager {
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// Utiliser dans les vues
Button("Valider") {
    HapticManager.success()
    completeBloc()
}
```

---

### 7.2 States de Chargement

**Besoin**: Indicateurs pendant opérations longues.

**Solution**:
```swift
// SettingsView.swift - Import
@State private var isImporting = false

Button("Importer") {
    isImporting = true
    Task {
        await performImport()
        isImporting = false
    }
}
.disabled(isImporting)
.overlay {
    if isImporting {
        ProgressView()
    }
}
```

---

### 7.3 Pull-to-Refresh

**Besoin**: Actualisation des listes.

**Solution**:
```swift
// SessionListView.swift
List {
    ForEach(sessions) { session in
        SessionCard(session: session)
    }
}
.refreshable {
    // Recalculer stats, vérifier badges
    await refreshData()
}
```

---

### 7.4 Recherche de Sessions

**Besoin**: Trouver sessions rapidement.

**Solution**:
```swift
// SessionListView.swift
@State private var searchText = ""

var filteredSessions: [SessionModel] {
    if searchText.isEmpty {
        return sessions
    }
    return sessions.filter { session in
        let dateString = session.date.formatted(date: .long, time: .omitted)
        return dateString.localizedCaseInsensitiveContains(searchText)
    }
}

List {
    // ...
}
.searchable(text: $searchText, prompt: "Rechercher une session")
```

---

## 8. Sécurité et Confidentialité

### 8.1 Chiffrement à l'Export

**Besoin**: Protéger données personnelles.

**Solution**:
```swift
// Services/EncryptionService.swift
import CryptoKit

class EncryptionService {
    func encrypt(data: Data, password: String) throws -> Data {
        let key = SymmetricKey(data: SHA256.hash(data: password.data(using: .utf8)!))
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }

    func decrypt(data: Data, password: String) throws -> Data {
        let key = SymmetricKey(data: SHA256.hash(data: password.data(using: .utf8)!))
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }
}

// Ajouter option dans SettingsView
Toggle("Protéger export par mot de passe", isOn: $encryptExport)
```

---

## 9. Analytics et Monitoring

### 9.1 Logging

**Solution**:
```swift
// Services/LoggingService.swift
import os.log

enum LoggingService {
    private static let logger = Logger(subsystem: "com.blocktracker", category: "general")

    static func info(_ message: String) {
        logger.info("\(message)")
    }

    static func error(_ message: String, error: Error? = nil) {
        if let error = error {
            logger.error("\(message): \(error.localizedDescription)")
        } else {
            logger.error("\(message)")
        }
    }

    static func debug(_ message: String) {
        logger.debug("\(message)")
    }
}
```

---

### 9.2 Analytics Basique

**Solution**: Intégrer TelemetryDeck (privacy-first analytics).

```swift
// blockTrackerApp.swift
import TelemetryClient

init() {
    TelemetryManager.initialize(with: config)
}

// Tracker events
TelemetryManager.send("session_completed", with: ["bloc_count": blocCount])
TelemetryManager.send("badge_unlocked", with: ["badge_id": badge.id])
```

---

## 10. Roadmap Recommandée

### Phase 1: Stabilisation (2-3 semaines)
**Objectif**: Rendre l'app production-ready

1. ✅ Ajouter suite de tests complète (5j)
2. ✅ Améliorer gestion d'erreurs (3j)
3. ✅ Implémenter validation de données (2j)
4. ✅ Audit accessibilité complet (3j)
5. ✅ Corriger bugs identifiés (1j)
6. ✅ Optimiser performance (2j)

**Livrable**: Version 1.1 stable et testée

---

### Phase 2: Qualité du Code (1-2 semaines)
**Objectif**: Réduire dette technique

1. ✅ Extraire constantes et éliminer nombres magiques (2j)
2. ✅ Supprimer code dupliqué (2j)
3. ✅ Standardiser nommage (0.5j)
4. ✅ Ajouter documentation complète (2j)
5. ✅ Refactoring mineur (1j)

**Livrable**: Codebase maintenable

---

### Phase 3: Fonctionnalités Utilisateur (2-3 semaines)
**Objectif**: Enrichir l'expérience

1. ✅ Synchronisation iCloud (4j)
2. ✅ Filtrage temporel stats (2j)
3. ✅ Backup automatique (3j)
4. ✅ Session pause/resume (1j)
5. ✅ Améliorations UI/UX (3j)

**Livrable**: Version 1.5 avec features demandées

---

### Phase 4: Internationalisation (1-2 semaines)
**Objectif**: Élargir l'audience

1. ✅ Extraction strings (2j)
2. ✅ Traduction anglais (2j)
3. ✅ Support locales (1j)
4. ✅ Tests multilingues (1j)

**Livrable**: Version 2.0 internationale

---

### Phase 5: Monitoring (1 semaine)
**Objectif**: Visibilité production

1. ✅ Logging systématique (2j)
2. ✅ Analytics privacy-first (2j)
3. ✅ Crash reporting (1j)

**Livrable**: App observable

---

## 11. Checklist de Mise en Production

Avant de soumettre à l'App Store:

### Technique
- [ ] Tests unitaires: >80% coverage
- [ ] Tests UI critiques
- [ ] Gestion d'erreurs complète
- [ ] Validation de toutes les entrées
- [ ] Performance testée avec 1000+ sessions
- [ ] Profiling mémoire (Instruments)
- [ ] Profiling CPU (Instruments)
- [ ] Pas de crashes sur tests manuels

### Accessibilité
- [ ] VoiceOver fonctionnel sur toutes les vues
- [ ] Dynamic Type supporté
- [ ] Contraste couleurs WCAG AA
- [ ] Testable avec Accessibility Inspector

### Sécurité
- [ ] Données sensibles chiffrées
- [ ] Validation import/export
- [ ] Pas de logs de données personnelles
- [ ] Privacy manifest complet

### App Store
- [ ] Screenshots (6.5", 6.7", 12.9")
- [ ] Description App Store (FR + EN)
- [ ] Mots-clés optimisés
- [ ] Privacy policy URL
- [ ] Support URL
- [ ] Version numbering scheme
- [ ] Build number incrementé

### Legal
- [ ] Conditions d'utilisation
- [ ] Politique de confidentialité
- [ ] Conformité RGPD (si users EU)
- [ ] Icône app (1024x1024)

---

## 12. Métriques de Succès

Pour mesurer les améliorations:

### Qualité
- **Code Coverage**: 0% → 80%+
- **Bugs critiques**: 3 identifiés → 0
- **Warnings Xcode**: ? → 0
- **Dette technique**: Élevée → Faible

### Performance
- **Temps chargement stats**: Mesurer avant/après
- **Scroll FPS**: Maintenir 60 FPS
- **Temps badge check**: < 100ms
- **Taille app**: Monitorer

### Utilisateur
- **Crash rate**: < 0.1%
- **Temps session moyen**: Mesurer
- **Rétention J7**: Objectif >40%
- **Rating App Store**: Objectif >4.5

---

## 13. Ressources Nécessaires

### Développement
- **Xcode 15+** avec iOS 17 SDK
- **Devices de test**: iPhone SE, iPhone 15 Pro, iPad
- **Apple Developer Account**: Pour TestFlight

### Services
- **CloudKit**: iCloud sync (gratuit tier suffisant)
- **TelemetryDeck**: Analytics (~5€/mois pour starter)
- **GitHub**: Versioning + CI/CD (gratuit)

### Documentation
- Apple Human Interface Guidelines
- SwiftData Documentation
- Accessibility Guidelines WCAG 2.1

---

## 14. Notes de Migration

Si vous implémentez ces changements sur l'app en production:

### Migration de Données
```swift
// Créer ModelConfiguration avec migration
let config = ModelConfiguration(
    schema: Schema([SessionModel.self, BlocModel.self]),
    migrationPlan: BlockTrackerMigrationPlan.self
)
```

### Version Control
```
v1.0 → v1.1: Tests + Errors + Validation (breaking: non)
v1.1 → v1.5: Features (breaking: non)
v1.5 → v2.0: i18n (breaking: non)
```

### Compatibilité
- Maintenir compatibilité avec iOS 17+
- Support iPhone et iPad
- Tester sur anciens appareils (A12 minimum)

---

## Conclusion

blockTracker est une application solide avec une excellente base architecturale. Les améliorations recommandées visent à:

1. **Stabiliser** avec tests et gestion d'erreurs (critique)
2. **Optimiser** performance et accessibilité (haute priorité)
3. **Enrichir** avec fonctionnalités utilisateur (moyen terme)
4. **Étendre** via internationalisation (long terme)

**Prochaine étape recommandée**: Commencer par la Phase 1 (Stabilisation) avec les tests unitaires comme priorité absolue.

**Besoin d'aide?** Ce plan est modulaire - chaque section peut être traitée indépendamment.

---

**Document créé le**: 9 janvier 2026
**Dernière mise à jour**: 9 janvier 2026
**Auteur**: Claude Code Analysis
**Version du plan**: 1.0

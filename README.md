# FokusApp V2

Eine plattformübergreifende Produktivitäts-App für Menschen mit ADHS, entwickelt mit **Flutter** für Android, iOS, macOS und Windows.

## Ziel
Ermöglicht tägliches Aufgabenmanagement, Verzichts-Tracking und ein visuelles Dashboard mit progressiven Belohnungen in einem ruhigen, klaren Interface.

## Architekturübersicht

### 1. Technologie
- **Flutter** für echte Multiplattform-Unterstützung
- **Dart** als Programmiersprache
- **Material/Cupertino** Hybrid für nativen Look-and-feel

### 2. Projektstruktur
- `lib/main.dart` - Einstiegspunkt
- `lib/models/` - Datenmodelle für Aufgaben und Verzichts-Ziele
- `lib/screens/` - UI-Bildschirme wie das Dashboard
- `lib/widgets/` - wiederverwendbare UI-Komponenten wie Donut-Charts
- `lib/services/` - späterer Ort für Persistenz und Datenlogik

### 3. Kernfunktionen
- Aufgabenmanagement (CRUD)
- Verzichts-Tracker / Impulskontrolle
- Dashboard mit Fortschrittsvisualisierung
- Minimalistisches Design, beruhigende Animationen

### 4. Datenmodell
- `TaskModel` enthält Titel, Beschreibung, Status, Datum und Priorität
- `AbstinenceGoalModel` trackt Verzichtsziele, Tagesstatus, Erfolge und Streaks

### 5. Weiterer Fahrplan
- Persistenz: z. B. `shared_preferences`, `hive`, `sqflite`
- State-Management: `Provider`, `Riverpod` oder `Bloc`
- Lokalisierung und Accessibility
- Synchronisation / Backup (optional)

## Erste Dateien
- `pubspec.yaml` mit Flutter-Grundkonfiguration
- `lib/main.dart` mit Dashboard-Startseite
- `lib/models/task_model.dart`
- `lib/models/abstinence_goal_model.dart`
- `lib/screens/dashboard_screen.dart`
- `lib/widgets/donut_chart.dart`

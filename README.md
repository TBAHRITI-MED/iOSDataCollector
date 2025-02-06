# DataCollectorApp

Application iOS (Swift) de collecte et d'enregistrement de données des capteurs : GPS, accéléromètre, batterie, réseau, etc.

## Sommaire
- [Fonctionnalités](#fonctionnalités)
- [Structure du projet](#structure-du-projet)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Export](#export)
- [Limitations](#limitations)
- [Licence](#licence)

## Fonctionnalités

- Collecte en temps réel :
  - Position GPS (latitude, longitude, altitude)
  - Vitesse (GPS)
  - Accélération (accéléromètre)
  - Batterie (niveau, état)
  - Type de réseau (Wi-Fi, 4G/5G)
  - Activité physique (marche, course, voiture)
- Enregistrement périodique en CSV/JSON
- Export via AirDrop, Email, iCloud
- Interface simple avec contrôles start/stop

## Structure du projet

```
DataCollectorApp/
├── DataCollectorApp.swift     # Point d'entrée
├── Info.plist                 # Configuration
├── DataModels/
│   └── SensorData.swift       # Modèles de données
├── Managers/
│   ├── LocationManager.swift  # GPS
│   ├── MotionManager.swift    # Accéléromètre
│   ├── ActivityManager.swift  # Détection activité
│   ├── BatteryManager.swift   # Batterie
│   ├── ConnectivityManager.swift # Réseau
│   └── DataLogger.swift       # Stockage
└── Views/
    └── ContentView.swift      # Interface SwiftUI
```

## Installation

1. Cloner le dépôt :
```bash
git clone [https://github.com/<votre-compte>/DataCollectorApp.git](https://github.com/TBAHRITI-MED/iOSDataCollector.git)
```

2. Configuration Xcode (14+) :
   - Ouvrir le projet
   - Vérifier Info.plist :
     - NSLocationWhenInUseUsageDescription
     - NSLocationAlwaysUsageDescription
     - NSMotionUsageDescription
   - Activer Background Modes (Location updates)

## Utilisation

1. Lancer sur iPhone/simulateur
2. Autoriser les permissions
3. Start/Stop pour contrôler la collecte
4. Visualisation en temps réel des données

## Export

- Formats : CSV ou JSON
- Méthodes : AirDrop, Email, iCloud
- Stockage temporaire avant partage via UIActivityViewController

## Limitations

- Requiert iOS 14+
- Impact batterie en collecte continue
- Précision GPS variable selon conditions

## Licence

MIT License - Voir LICENSE.md

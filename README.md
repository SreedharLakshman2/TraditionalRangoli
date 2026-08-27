# Traditional Rangoli

A premium iPhone and iPad app for learning, tracing, and creating traditional Indian rangoli and Tamil kolam. Built with SwiftUI.

Open **`TraditionalRangoli.xcodeproj`** and run the **TraditionalRangoli** scheme.

## Requirements

- Xcode 16 or later
- iOS 17+
- iPhone (portrait) and iPad (portrait and landscape)

## Experience

Discover → Learn → Trace → Create → Decorate → Save → Share

- 16 original pattern geometries with Tamil names and a note on why each kolam is drawn
- Festival-aware Daily Lesson (Pongal, Deepavali, Onam, or everyday threshold kolam)
- Guided step-by-step tracing on a pulli grid with a kind stroke check
- Real drawing canvas with snap-to-dots, undo/redo, and 2/4/8-way symmetry
- Coloring and courtyard decorations (rice powder, flowers, diyas)
- On-device gallery — no account, no backend

## Ads

Debug builds use Google sample banner and interstitial units so ads always fill.

Release builds use the Traditional Rangoli AdMob app ID in `Info.plist` (`GADApplicationIdentifier`). Banner and interstitial units for bundle `com.sreedhar.TraditionalRangoli` are in `TraditionalRangoli/Services/AdConfig.swift`.

A banner sits under the tab bar on Home, Explore, Create, Saved, and Profile. An interstitial can appear after you complete a rangoli, with a short cooldown.

## App Store

Listing copy: `AppStore/LISTING.md`

| Field | URL |
| --- | --- |
| Support | https://sreedharlakshman2.github.io/traditional-rangoli/ |
| Privacy | https://sreedharlakshman2.github.io/traditional-rangoli/privacy.html |
| Marketing | https://sreedharlakshman2.github.io |

Support email: sreedharlakshmanan4@gmail.com

Bundle ID: `com.sreedhar.TraditionalRangoli`

Upload iPhone 6.9" and iPad 13" posters from `AppStore/Screenshots/iphone-6.9/` and `AppStore/Screenshots/ipad-13/`. Rebuild with `bash AppStore/Screenshots/capture_simulator_screens.sh` then `python3 AppStore/Screenshots/compose_posters.py`.

## Support

Sai Laksha Technologies — Sreedhar Lakshmanan  
sreedharlakshmanan4@gmail.com

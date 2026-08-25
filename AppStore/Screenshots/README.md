# App Store screenshots

Canva-style posters: 3D courtyard backgrounds, bold gradient titles, and live app screens inside a titanium iPhone Pro (6.9") or iPad Pro (13") frame.

Upload **only** these two slots in App Store Connect:

| Connect slot | Size | Folder |
| --- | --- | --- |
| iPhone 6.9" | 1320 × 2868 | `iphone-6.9/` |
| iPad 13" | 2064 × 2752 | `ipad-13/` |

Upload `01`–`06` from each folder, in that order. Skip 6.7" — Connect does not need it when 6.9" is present.

## Copy on the posters

1. **The courtyard is waiting** — Daily lotus, pulli, and festival floors.
2. **Trace it stroke by stroke** — Kind guided lessons on a pulli grid.
3. **One line becomes eight** — Symmetry that mirrors a powder stroke.
4. **Dot, freehand, template** — Three ways to lay rice powder.
5. **Rice, flowers, and diyas** — Color the courtyard you just drew.
6. **Keep the floor you drew** — Gallery on this iPhone or iPad. No account.

## Rebuild

```bash
bash AppStore/Screenshots/capture_simulator_screens.sh
python3 AppStore/Screenshots/compose_posters.py
```

The capture script launches Debug with `RANGOLI_SCREENSHOT` so splash, onboarding, ATT, and ads stay off. Status bar is frozen at 9:41.

3D app icon source: `icon-3d.png` (also installed as `TraditionalRangoli/Assets.xcassets/AppIcon.appiconset/AppIcon.png`).

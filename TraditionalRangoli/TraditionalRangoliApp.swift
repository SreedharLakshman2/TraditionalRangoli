import SwiftUI

@main
struct TraditionalRangoliApp: App {
    @StateObject private var settings: SettingsStore
    @StateObject private var artworks: ArtworkStore
    @StateObject private var router: AppRouter
    @StateObject private var ads: AdsManager

    init() {
        let settings = SettingsStore()
        let artworks = ArtworkStore()
        let router = AppRouter()
        if ScreenshotLaunch.isActive {
            settings.seedForScreenshots()
            artworks.seedScreenshots()
            switch ScreenshotLaunch.scene {
            case "explore": router.tab = .explore
            case "create": router.tab = .create
            case "saved": router.tab = .saved
            default: router.tab = .home
            }
        }
        _settings = StateObject(wrappedValue: settings)
        _artworks = StateObject(wrappedValue: artworks)
        _router = StateObject(wrappedValue: router)
        _ads = StateObject(wrappedValue: AdsManager.shared)
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if let scene = ScreenshotLaunch.scene {
                    ScreenshotRoot(scene: scene)
                } else {
                    TraditionalRangoliAppRoot()
                }
            }
            .environmentObject(settings)
            .environmentObject(artworks)
            .environmentObject(router)
            .environmentObject(ads)
        }
    }
}

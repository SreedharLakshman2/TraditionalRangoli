import SwiftUI

@main
struct TraditionalRangoliApp: App {
    @StateObject private var settings = SettingsStore()
    @StateObject private var artworks = ArtworkStore()
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            TraditionalRangoliAppRoot()
                .environmentObject(settings)
                .environmentObject(artworks)
                .environmentObject(router)
        }
    }
}

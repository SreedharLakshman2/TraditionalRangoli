import SwiftUI

@MainActor
final class AppRouter: ObservableObject {
    @Published var tab: AppTab = .home
    @Published var studio: StudioRoute?
    @Published var pendingExploreQuery: String?

    func openCreate() {
        tab = .create
    }

    func openExplore() {
        tab = .explore
    }
}

struct StudioRoute: Identifiable, Equatable {
    enum Kind: Equatable {
        case dots(RangoliPattern?)
        case freehand
        case template(RangoliPattern)
        case guided(RangoliPattern)
        case continueArtwork(UserArtwork)
    }

    let id = UUID()
    var kind: Kind
}

struct TraditionalRangoliAppRoot: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var ads: AdsManager
    @Environment(\.scenePhase) private var scenePhase
    @State private var showSplash = true

    var body: some View {
        ZStack {
            RootView()
            if showSplash {
                LaunchSplashView {
                    withAnimation(.easeInOut(duration: 0.55)) {
                        showSplash = false
                    }
                    ads.bootstrap()
                    ReviewPrompt.askIfAppropriate(delay: 8)
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: onboardingBinding) {
            OnboardingView()
                .interactiveDismissDisabled()
        }
        .onAppear {
            ReviewPrompt.recordFirstUseIfNeeded()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                ads.onAppBecameActive()
                ReviewPrompt.recordFirstUseIfNeeded()
            }
        }
    }

    private var onboardingBinding: Binding<Bool> {
        Binding(
            get: { !settings.hasSeenOnboarding && !showSplash },
            set: { if !$0 { settings.hasSeenOnboarding = true } }
        )
    }
}

struct RootView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        ZStack(alignment: .bottom) {
            PaperBackground()
            Group {
                switch router.tab {
                case .home:
                    NavigationStack { HomeView() }
                case .explore:
                    NavigationStack { ExploreView() }
                case .create:
                    NavigationStack { CreateView() }
                case .saved:
                    NavigationStack { SavedView() }
                case .profile:
                    NavigationStack { ProfileView() }
                }
            }
            .padding(.bottom, ScreenshotLaunch.isActive ? 72 : 72 + AdBannerSlot.height)

            VStack(spacing: 4) {
                CustomTabBar(selection: $router.tab)
                    .frame(maxWidth: 560)
                if !ScreenshotLaunch.isActive {
                    AdBannerSlot()
                }
            }
        }
        .fullScreenCover(item: $router.studio) { route in
            studio(for: route)
        }
    }

    @ViewBuilder
    private func studio(for route: StudioRoute) -> some View {
        switch route.kind {
        case .dots(let pattern):
            DrawingStudioView(session: DrawingSession(
                studio: .dots,
                pattern: pattern,
                gridSize: pattern?.gridSize ?? settings.defaultGrid,
                showGuides: settings.showGuides
            ))
        case .freehand:
            DrawingStudioView(session: DrawingSession(studio: .freehand, showGuides: false))
        case .template(let pattern):
            DrawingStudioView(session: DrawingSession(
                studio: .template,
                pattern: pattern,
                gridSize: pattern.gridSize,
                showGuides: settings.showGuides
            ))
        case .guided(let pattern):
            GuidedLearningView(pattern: pattern)
        case .continueArtwork(let artwork):
            DrawingStudioView(session: DrawingSession(
                studio: artwork.studio,
                pattern: artwork.patternId.flatMap(PatternCatalog.pattern(id:)),
                showGuides: settings.showGuides,
                artwork: artwork
            ))
        }
    }
}
